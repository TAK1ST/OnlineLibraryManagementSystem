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
            request.setAttribute("error", "Token không hợp lệ.");
            request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
            return;
        }
        
        try {
            // Kiểm tra token có hợp lệ không
            if (userDAO.isValidToken(token)) {
                request.setAttribute("token", token);
                request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.");
                request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi kết nối database.");
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
            request.setAttribute("error", "Token không hợp lệ.");
            request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
            return;
        }
        
        if (newPassword == null || newPassword.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập mật khẩu mới.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
            return;
        }
        
        if (confirmPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
            return;
        }
        
        // Validate password strength
        if (!isValidPassword(newPassword)) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
            return;
        }
        
        try {
            // Kiểm tra token và lấy user
            User user = userDAO.getUserByToken(token);
            
            if (user == null) {
                request.setAttribute("error", "Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.");
                request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
                return;
            }
            
            // Cập nhật mật khẩu trong database (UserDAO đã tự hash bằng BCrypt)
            if (userDAO.updatePassword(user.getId(), newPassword) > 0) {
                // Xóa token đã sử dụng
                userDAO.deleteToken(token);
                
                request.setAttribute("success", "Mật khẩu đã được đặt lại thành công. Bạn có thể đăng nhập bằng mật khẩu mới.");
                request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi đặt lại mật khẩu. Vui lòng thử lại.");
                request.setAttribute("token", token);
                request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
            }
            
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi kết nối database.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("view/auth/reset-password.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại sau.");
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