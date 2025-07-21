package controller.auth;

import dao.implement.UserDAO;
import entity.User;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.BCrypt;

public class ResetPasswordServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String token = request.getParameter("token");
        
        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("error", "Invalid token.");
            request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
            return;
        }
        
        try {
            // Kiểm tra token có hợp lệ không
            if (userDAO.isValidToken(token)) {
                request.setAttribute("token", token);
                request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "The password reset link is invalid or has expired.");
                request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while connecting to the database.");
            request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate inputs
        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("error", "Invalid token.");
            request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
            return;
        }
        
        if (newPassword == null || newPassword.trim().isEmpty()) {
            request.setAttribute("error", "Please enter a new password.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
            return;
        }
        
        if (confirmPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "The confirmation password does not match.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
            return;
        }
        
        // Validate password strength
        if (!isValidPassword(newPassword)) {
            request.setAttribute("error", "The password must be at least 8 characters long and include uppercase letters, lowercase letters, numbers, and special characters.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
            return;
        }
        
        try {
            // Kiểm tra token và lấy user
            User user = userDAO.getUserByToken(token);
            
            if (user == null) {
                request.setAttribute("error", "The password reset link is invalid or has expired.");
                request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
                return;
            }
            
            // Cập nhật mật khẩu trong database (UserDAO đã tự hash bằng BCrypt)
            if (userDAO.updatePassword(user.getId(), newPassword) > 0) {
                // Xóa token đã sử dụng
                userDAO.deleteToken(token);
                
                request.setAttribute("success", "Your password has been successfully reset. You can now log in with your new password.");
                request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "An error occurred while resetting your password. Please try again.");
                request.setAttribute("token", token);
                request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
            }
            
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while connecting to the database.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred. Please try again later.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
        }
    }
    
    /**
     * Validate password strength
     */
    private boolean isValidPassword(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }
        
        boolean hasUppercase = false;
        boolean hasLowercase = false;
        boolean hasDigit = false;
        boolean hasSpecialChar = false;
        
        for (char c : password.toCharArray()) {
            if (Character.isUpperCase(c)) {
                hasUppercase = true;
            } else if (Character.isLowerCase(c)) {
                hasLowercase = true;
            } else if (Character.isDigit(c)) {
                hasDigit = true;
            } else if (!Character.isLetterOrDigit(c)) {
                hasSpecialChar = true;
            }
        }
        
        return hasUppercase && hasLowercase && hasDigit && hasSpecialChar;
    }
    
    @Override
    public String getServletInfo() {
        return "Servlet xử lý reset password";
    }
}