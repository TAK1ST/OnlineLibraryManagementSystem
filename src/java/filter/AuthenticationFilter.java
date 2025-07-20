/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package filter;

import dao.implement.UserDAO;
import entity.User;
import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;
import java.util.Base64;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Filter để kiểm tra authentication (đăng nhập) trước khi truy cập các trang được bảo vệ
 * @author CAU_TU
 */
@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {"/*"})
public class AuthenticationFilter implements Filter {

    private static final String COOKIE_NAME_EMAIL = "rememberEmail";
    private static final String COOKIE_NAME_TOKEN = "rememberToken";
    private static final String SECRET_KEY = "LibraryManagementSystem2024";
    private static final Logger logger = Logger.getLogger(AuthenticationFilter.class.getName());

    // Danh sách các URL không cần xác thực
    private static final List<String> PUBLIC_URLS = Arrays.asList(
        "/LoginServlet",
        "/RegisterServlet", 
        "/resetpassword",
        "/resetpassword",           // Thêm servlet URL
        "/ForgotPasswordServlet",
        "/login.jsp",
        "/register.jsp",
        "/forgot-password.jsp",
        "/reset-password.jsp",
        "/error.jsp"
    );

    // Danh sách các đường dẫn tài nguyên tĩnh không cần xác thực
    private static final List<String> STATIC_RESOURCES = Arrays.asList(
        "/css/",
        "/js/",
        "/images/",
        "/img/",
        "/assets/",
        "/fonts/",
        "/favicon.ico",
        "/view/auth/"
    );

    // Danh sách các URL chỉ dành cho admin
    private static final List<String> ADMIN_URLS = Arrays.asList(
        "/admindashboard",
        "/systemconfig",
        "/usermanagement",
        "/bookmanagement",
        "/overduebook",
        "/updateinventory",
        "/statusrequestborrowbook",
        "/searchUser",
        "/userdetail",
        "/searchbook",
        "/addbook",
        "/editbook"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo filter
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Loại bỏ context path để lấy đường dẫn thực tế
        String path = requestURI.substring(contextPath.length());
        
        // Kiểm tra nếu là tài nguyên tĩnh
        if (isStaticResource(path)) {
            chain.doFilter(request, response);
            return;
        }
        
        // Kiểm tra nếu là URL công khai
        if (isPublicUrl(path)) {
            chain.doFilter(request, response);
            return;
        }
        
        // Lấy session và kiểm tra đăng nhập
        HttpSession session = httpRequest.getSession(false);
        User loginedUser = null;
        
        if (session != null) {
            loginedUser = (User) session.getAttribute("loginedUser");
        }
        
        // Nếu chưa đăng nhập, kiểm tra cookie Remember Me
        if (loginedUser == null) {
            loginedUser = checkRememberMeCookie(httpRequest, httpResponse);
        }
        
        // Nếu vẫn chưa đăng nhập sau khi kiểm tra cookie
        if (loginedUser == null) {
            // Lưu URL hiện tại để redirect sau khi đăng nhập
            if (session == null) {
                session = httpRequest.getSession(true);
            }
            session.setAttribute("redirectUrl", requestURI);
            
            // Redirect đến trang đăng nhập
            httpResponse.sendRedirect(contextPath + "/LoginServlet");
            return;
        }
        
        // Kiểm tra quyền truy cập admin
        if (isAdminUrl(path)) {
            if (loginedUser.getRole() == null || !loginedUser.getRole().equalsIgnoreCase("admin")) {
                // Không có quyền truy cập
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Admin privileges required.");
                return;
            }
        }
        
        // Kiểm tra trạng thái tài khoản
        if (!loginedUser.getStatus().equalsIgnoreCase("active")) {
            // Tài khoản bị khóa hoặc không hoạt động
            if (session != null) {
                session.invalidate();
            }
            clearRememberMeCookie(httpResponse);
            httpResponse.sendRedirect(contextPath + "/LoginServlet?error=account_inactive");
            return;
        }
        
        // Nếu tất cả kiểm tra đều pass, tiếp tục xử lý request
        chain.doFilter(request, response);
    }

    /**
     * Kiểm tra cookie Remember Me và tự động đăng nhập nếu hợp lệ
     */
    private User checkRememberMeCookie(HttpServletRequest request, HttpServletResponse response) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            return null;
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
            return null;
        }

        try {
            // Giải mã email
            String decodedEmail = new String(Base64.getDecoder().decode(rememberedEmail));
            
            // Lấy thông tin user từ database
            UserDAO userDAO = new UserDAO();
            User user = userDAO.getEmail(decodedEmail);
            
            if (user == null || !user.getStatus().equalsIgnoreCase("active")) {
                clearRememberMeCookie(response);
                return null;
            }

            // Tạo token mong đợi và so sánh
            String expectedToken = generateRememberToken(user);
            if (!expectedToken.equals(rememberedToken)) {
                clearRememberMeCookie(response);
                return null;
            }

            // Token hợp lệ, tự động đăng nhập
            HttpSession session = request.getSession(true);
            session.setAttribute("loginedUser", user);
            session.setAttribute("loginAttempts", 0);

            logger.info("User automatically logged in via Remember Me cookie: " + user.getEmail());
            return user;

        } catch (Exception e) {
            logger.log(Level.WARNING, "Error processing remember me cookie", e);
            clearRememberMeCookie(response);
            return null;
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
     * Kiểm tra xem đường dẫn có phải là tài nguyên tĩnh không
     */
    private boolean isStaticResource(String path) {
        for (String staticResource : STATIC_RESOURCES) {
            if (path.startsWith(staticResource)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Kiểm tra xem đường dẫn có phải là URL công khai không
     */
    private boolean isPublicUrl(String path) {
        // Tách path và query parameters
        String cleanPath = path;
        if (path.contains("?")) {
            cleanPath = path.substring(0, path.indexOf("?"));
        }
        
        // Kiểm tra exact match với clean path
        if (PUBLIC_URLS.contains(cleanPath)) {
            return true;
        }
        
        // Trang chủ công khai
        if (cleanPath.equals("/") || cleanPath.equals("/home")) {
            return true;
        }
        
        return false;
    }
    
    /**
     * Kiểm tra xem đường dẫn có phải là URL dành cho admin không
     */
    private boolean isAdminUrl(String path) {
        // Tách path và query parameters cho admin URLs
        String cleanPath = path;
        if (path.contains("?")) {
            cleanPath = path.substring(0, path.indexOf("?"));
        }
        
        for (String adminUrl : ADMIN_URLS) {
            if (cleanPath.startsWith(adminUrl)) {
                return true;
            }
        }
        return false;
    }

    @Override
    public void destroy() {
        // Cleanup khi filter bị hủy
    }
}