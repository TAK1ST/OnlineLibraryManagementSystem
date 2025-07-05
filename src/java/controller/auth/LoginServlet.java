/*
     * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
     * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import dao.implement.UserDAO;
import entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
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
 * @author asus
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    private static final int MAX_LOGIN_ATTEMPTS = 3;
    private static final String COOKIE_NAME_EMAIL = "rememberEmail";
    private static final String COOKIE_NAME_TOKEN = "rememberToken";
    private static final int COOKIE_MAX_AGE = 7 * 24 * 60 * 60; // 7 ngày
    private static final String SECRET_KEY = "LibraryManagementSystem2024"; // Nên được lưu trong config

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra cookie để tự động đăng nhập
        if (checkRememberMeCookie(request, response)) {
            return; // Đã redirect sau khi đăng nhập thành công
        }
        
        // Nếu không có cookie hợp lệ, hiển thị trang đăng nhập
        request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("txtemail");
        String password = request.getParameter("txtpassword");
        String rememberMe = request.getParameter("rememberMe");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required");
            request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        Integer loginAttempts = (Integer) session.getAttribute("loginAttempts");
        if (loginAttempts == null) {
            loginAttempts = 0;
        }

        if (loginAttempts >= MAX_LOGIN_ATTEMPTS) {
            request.setAttribute("error", "Account locked due to too many failed attempts.");
            request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
            return;
        }
        
        //logic login : khi đăng nhập mật khẩu sai > 3 lần thì dù cho có nhập đúng 
        //thì vẫn phải đổi mật khẩu để đảm bảo an toàn cho người dùng sử dụng trong tương lại

        UserDAO d = new UserDAO();
        User us = d.getUser(email.trim(), password);

        if (us == null || !us.getStatus().equalsIgnoreCase("active")) {
            loginAttempts++;
            session.setAttribute("loginAttempts", loginAttempts);

            int attemptsLeft = MAX_LOGIN_ATTEMPTS - loginAttempts;
            if (attemptsLeft > 0) {
                request.setAttribute("error", "Email or password is invalid. Attempts left: " + attemptsLeft + "/3.");
            } else {
                request.setAttribute("error", "Account locked due to too many failed attempts.");
            }

            request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
        } else {
            // Đăng nhập thành công
            session.setAttribute("loginedUser", us);
            session.setAttribute("loginAttempts", 0);

            // Xử lý Remember Me
            if ("on".equals(rememberMe)) {
                createRememberMeCookie(response, us);
            } else {
                // Xóa cookie nếu không chọn Remember Me
                clearRememberMeCookie(response);
            }

            try {
                String redirectUrl = (String) session.getAttribute("redirectUrl");
                if (redirectUrl != null && !redirectUrl.isEmpty()) {
                    session.removeAttribute("redirectUrl");
                    response.sendRedirect(redirectUrl);
                    return;
                }

                if (us.getRole().equalsIgnoreCase("admin")) {
                    response.sendRedirect(request.getContextPath() + "/admindashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }
            } catch (Exception ex) {
                Logger.getLogger(LoginServlet.class.getName()).log(Level.SEVERE, null, ex);
                request.setAttribute("error", "Error loading application data: " + ex.getMessage());
                request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
            }
        }
    }

    /**
     * Kiểm tra cookie Remember Me và tự động đăng nhập nếu hợp lệ
     */
    private boolean checkRememberMeCookie(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
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

            // Redirect đến trang phù hợp
            String redirectUrl = (String) session.getAttribute("redirectUrl");
            if (redirectUrl != null && !redirectUrl.isEmpty()) {
                session.removeAttribute("redirectUrl");
                response.sendRedirect(redirectUrl);
            } else if (user.getRole().equalsIgnoreCase("admin")) {
                response.sendRedirect(request.getContextPath() + "/admindashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
            
            return true;

        } catch (Exception e) {
            Logger.getLogger(LoginServlet.class.getName()).log(Level.WARNING, 
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
            Logger.getLogger(LoginServlet.class.getName()).log(Level.WARNING, 
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
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Login Servlet with Remember Me functionality";
    }
}