/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Filter.java to edit this template
 */
package filter;

import constant.Regex;
import dao.implement.UserDAO;
import entity.User;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author CAU_TU
 */
public class LoginValidateFilter implements Filter {

    private static final boolean debug = false; // Tắt debug để tránh spam log
    private FilterConfig filterConfig = null;
    
    // Constants cho Remember Me
    private static final int MAX_LOGIN_ATTEMPTS = 3;
    private static final String COOKIE_NAME_EMAIL = "rememberEmail";
    private static final String COOKIE_NAME_TOKEN = "rememberToken";
    private static final int COOKIE_MAX_AGE = 7 * 24 * 60 * 60; // 7 ngày
    private static final String SECRET_KEY = "LibraryManagementSystem2024"; // Nên được lưu trong config

    public LoginValidateFilter() {
    }

    /**
     * Xử lý trước khi filter chạy
     */
    private void doBeforeProcessing(ServletRequest request, ServletResponse response)
            throws IOException, ServletException {
        if (debug) {
            log("LoginValidateFilter:DoBeforeProcessing");
        }
    }

    /**
     * Xử lý sau khi filter chạy
     */
    private void doAfterProcessing(ServletRequest request, ServletResponse response)
            throws IOException, ServletException {
        if (debug) {
            log("LoginValidateFilter:DoAfterProcessing");
        }
    }

    /**
     * Filter chính - xử lý toàn bộ logic đăng nhập
     */
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        if (debug) {
            log("LoginValidateFilter:doFilter()");
        }

        doBeforeProcessing(request, response);

        Throwable problem = null;
        try {
            HttpServletRequest httpRequest = (HttpServletRequest) request;
            HttpServletResponse httpResponse = (HttpServletResponse) response;

            // Xử lý GET request - kiểm tra cookie và hiển thị trang login
            if ("GET".equalsIgnoreCase(httpRequest.getMethod())) {
                // Kiểm tra cookie để tự động đăng nhập
                if (checkRememberMeCookie(httpRequest, httpResponse)) {
                    return; // Đã redirect sau khi đăng nhập thành công
                }
                
                // Nếu không có cookie hợp lệ, cho phép hiển thị trang đăng nhập
                chain.doFilter(request, response);
                return;
            }

            // Xử lý POST request - validate và xử lý đăng nhập
            if ("POST".equalsIgnoreCase(httpRequest.getMethod())) {
                String email = request.getParameter("txtemail");
                String password = request.getParameter("txtpassword");
                String rememberMe = request.getParameter("rememberMe");

                // Validate dữ liệu đầu vào
                String validationError = validateLoginData(email, password);
                if (validationError != null) {
                    request.setAttribute("error", validationError);
                    request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
                    return;
                }

                // Xử lý logic đăng nhập
                processLogin(httpRequest, httpResponse, email.trim(), password, rememberMe);
                return;
            }

            // Các method khác
            chain.doFilter(request, response);

        } catch (Throwable t) {
            problem = t;
            if (debug) {
                t.printStackTrace();
            }
        }

        doAfterProcessing(request, response);

        // Xử lý lỗi nếu có
        if (problem != null) {
            if (problem instanceof ServletException) {
                throw (ServletException) problem;
            }
            if (problem instanceof IOException) {
                throw (IOException) problem;
            }
            sendProcessingError(problem, response);
        }
    }

    /**
     * Validate dữ liệu đăng nhập
     */
    private String validateLoginData(String email, String password) {
        // Validate email
        if (email == null || email.trim().isEmpty()) {
            return "Email and password are required";
        }

        // Validate email format
        if (!email.trim().matches(Regex.EMAIL_REGEX)) {
            return "You must enter your email format correctly! (Ex: abc@gmail.com)";
        }

        // Validate password
        if (password == null || password.trim().isEmpty()) {
            return "Email and password are required";
        }

        return null; // Không có lỗi
    }

    /**
     * Xử lý quá trình đăng nhập
     */
    private void processLogin(HttpServletRequest request, HttpServletResponse response, 
                            String email, String password, String rememberMe) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer loginAttempts = (Integer) session.getAttribute("loginAttempts");
        if (loginAttempts == null) {
            loginAttempts = 0;
        }

        if (loginAttempts >= MAX_LOGIN_ATTEMPTS) {
            request.setAttribute("error", "It seems you've forgotten your account password.");
            request.getRequestDispatcher("view/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        UserDAO d = new UserDAO();
        User us = d.getUser(email, password);

        if (us == null || !us.getStatus().equalsIgnoreCase("active")) {
            // Đăng nhập thất bại
            loginAttempts++;
            session.setAttribute("loginAttempts", loginAttempts);

            int attemptsLeft = MAX_LOGIN_ATTEMPTS - loginAttempts;
            String errorMessage;
            if (attemptsLeft > 0) {
                errorMessage = "Email or password is invalid. Attempts left: " + attemptsLeft + "/3.";
            } else {
                errorMessage = "It seems you've forgotten your account password. I recommend resetting it by clicking the 'Forgot Password' button below.";
            }

            request.setAttribute("error", errorMessage);
            request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
        } else {
            // Đăng nhập thành công
            session.setAttribute("loginedUser", us);
            session.setAttribute("loginAttempts", 0);

            // Xử lý Remember Me
            if ("on".equals(rememberMe)) {
                createRememberMeCookie(response, us);
            } else {
                clearRememberMeCookie(response);
            }

            // Set attribute để LoginServlet biết đã xử lý xong
            request.setAttribute("loginSuccess", true);
            request.setAttribute("loggedUser", us);
            
            // Tiếp tục chain để LoginServlet xử lý điều hướng
            try {
                request.getRequestDispatcher("/LoginServlet").forward(request, response);
            } catch (Exception ex) {
                Logger.getLogger(LoginValidateFilter.class.getName()).log(Level.SEVERE, null, ex);
                request.setAttribute("error", "Error loading application data: " + ex.getMessage());
                request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
            }
        }
    }

    /**
     * Kiểm tra cookie Remember Me và tự động đăng nhập nếu hợp lệ
     */
    private boolean checkRememberMeCookie(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            return false;
        }

        String rememberedEmail = null;
        String rememberedToken = null;

        // Tìm cookie
        for (Cookie cookie : cookies) {
            if (COOKIE_NAME_EMAIL.equals(cookie.getName())) {
                rememberedEmail = cookie.getValue();
            } else if (COOKIE_NAME_TOKEN.equals(cookie.getName())) {
                rememberedToken = cookie.getValue();
            }
        }

        // Kiểm tra xem có đủ thông tin cookie không
        if (rememberedEmail == null || rememberedToken == null) {
            return false;
        }

        try {
            // Giải mã email
            String decodedEmail = new String(Base64.getDecoder().decode(rememberedEmail));
            
            // Lấy thông tin user từ database
            UserDAO userDAO = new UserDAO();
            User user = userDAO.getEmail(decodedEmail);
            
            if (user == null || !user.getStatus().equalsIgnoreCase("active")) {
                clearRememberMeCookie(response);
                return false;
            }

            // Tạo token mong đợi và so sánh
            String expectedToken = generateRememberToken(user);
            if (!expectedToken.equals(rememberedToken)) {
                clearRememberMeCookie(response);
                return false;
            }

            // Token hợp lệ, tự động đăng nhập
            HttpSession session = request.getSession(true);
            session.setAttribute("loginedUser", user);
            session.setAttribute("loginAttempts", 0);

            // Set attributes cho LoginServlet xử lý điều hướng
            request.setAttribute("loginSuccess", true);
            request.setAttribute("loggedUser", user);
            request.setAttribute("autoLogin", true);
            
            // Forward đến LoginServlet để xử lý điều hướng
            request.getRequestDispatcher("/LoginServlet").forward(request, response);
            return true;

        } catch (Exception e) {
            Logger.getLogger(LoginValidateFilter.class.getName()).log(Level.WARNING, 
                "Error processing remember me cookie", e);
            clearRememberMeCookie(response);
            return false;
        }
    }

    /**
     * Tạo cookie Remember Me
     */
    private void createRememberMeCookie(HttpServletResponse response, User user) {
        try {
            // Mã hóa email
            String encodedEmail = Base64.getEncoder().encodeToString(user.getEmail().getBytes());
            
            // Tạo token bảo mật
            String token = generateRememberToken(user);

            // Tạo cookie cho email
            Cookie emailCookie = new Cookie(COOKIE_NAME_EMAIL, encodedEmail);
            emailCookie.setMaxAge(COOKIE_MAX_AGE);
            emailCookie.setHttpOnly(true);
            emailCookie.setSecure(false); // Đặt true nếu sử dụng HTTPS
            emailCookie.setPath("/");

            // Tạo cookie cho token
            Cookie tokenCookie = new Cookie(COOKIE_NAME_TOKEN, token);
            tokenCookie.setMaxAge(COOKIE_MAX_AGE);
            tokenCookie.setHttpOnly(true);
            tokenCookie.setSecure(false); // Đặt true nếu sử dụng HTTPS
            tokenCookie.setPath("/");

            response.addCookie(emailCookie);
            response.addCookie(tokenCookie);

        } catch (Exception e) {
            Logger.getLogger(LoginValidateFilter.class.getName()).log(Level.WARNING, 
                "Error creating remember me cookie", e);
        }
    }

    /**
     * Xóa cookie Remember Me
     */
    private void clearRememberMeCookie(HttpServletResponse response) {
        Cookie emailCookie = new Cookie(COOKIE_NAME_EMAIL, "");
        emailCookie.setMaxAge(0);
        emailCookie.setPath("/");

        Cookie tokenCookie = new Cookie(COOKIE_NAME_TOKEN, "");
        tokenCookie.setMaxAge(0);
        tokenCookie.setPath("/");

        response.addCookie(emailCookie);
        response.addCookie(tokenCookie);
    }

    /**
     * Tạo token bảo mật cho Remember Me
     */
    private String generateRememberToken(User user) throws NoSuchAlgorithmException {
        String data = user.getEmail() + ":" + user.getId() + ":" + SECRET_KEY;
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(data.getBytes());
        return Base64.getEncoder().encodeToString(hash);
    }

    /**
     * Getter cho FilterConfig
     */
    public FilterConfig getFilterConfig() {
        return (this.filterConfig);
    }

    /**
     * Setter cho FilterConfig
     */
    public void setFilterConfig(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
    }

    /**
     * Destroy method
     */
    public void destroy() {
        // Cleanup resources if needed
    }

    /**
     * Init method
     */
    public void init(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
        if (filterConfig != null) {
            if (debug) {
                log("LoginValidateFilter: Initializing filter");
            }
        }
    }

    /**
     * ToString method
     */
    @Override
    public String toString() {
        if (filterConfig == null) {
            return ("LoginValidateFilter()");
        }
        StringBuffer sb = new StringBuffer("LoginValidateFilter(");
        sb.append(filterConfig);
        sb.append(")");
        return (sb.toString());
    }

    /**
     * Xử lý lỗi và hiển thị stack trace
     */
    private void sendProcessingError(Throwable t, ServletResponse response) {
        String stackTrace = getStackTrace(t);

        if (stackTrace != null && !stackTrace.equals("")) {
            try {
                response.setContentType("text/html");
                PrintStream ps = new PrintStream(response.getOutputStream());
                PrintWriter pw = new PrintWriter(ps);
                pw.print("<html>\n<head>\n<title>Error</title>\n</head>\n<body>\n");
                pw.print("<h1>The resource did not process correctly</h1>\n<pre>\n");
                pw.print(stackTrace);
                pw.print("</pre></body>\n</html>");
                pw.close();
                ps.close();
                response.getOutputStream().close();
            } catch (Exception ex) {
                // Log exception nếu cần
            }
        } else {
            try {
                PrintStream ps = new PrintStream(response.getOutputStream());
                t.printStackTrace(ps);
                ps.close();
                response.getOutputStream().close();
            } catch (Exception ex) {
                // Log exception nếu cần
            }
        }
    }

    /**
     * Lấy stack trace dưới dạng String
     */
    public static String getStackTrace(Throwable t) {
        String stackTrace = null;
        try {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            t.printStackTrace(pw);
            pw.close();
            sw.close();
            stackTrace = sw.getBuffer().toString();
        } catch (Exception ex) {
            // Ignore
        }
        return stackTrace;
    }

    /**
     * Log message
     */
    public void log(String msg) {
        if (filterConfig != null) {
            filterConfig.getServletContext().log(msg);
        }
    }
}