package controller.auth;

import dao.implement.UserDAO;
import entity.User;
import util.SendMail;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ForgotPasswordServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO(); // Giả sử bạn có UserDAO class
    private SendMail sendMail = new SendMail();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiển thị trang forgot password
        doPost(request, response);
        request.getRequestDispatcher("view/auth/forgot-password.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "send_reset_link";
        }
        
        if ("send_reset_link".equals(action)) {
            handleSendResetLink(request, response, email);
        }
    }
    
    private void handleSendResetLink(HttpServletRequest request, HttpServletResponse response, String email) 
            throws ServletException, IOException {
        
        // Validate email
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập địa chỉ email.");
            request.getRequestDispatcher("view/auth/forgot-password.jsp").forward(request, response);
            return;
        }
        
        // Kiểm tra email có tồn tại trong database không
        User user = userDAO.getEmail(email.trim());
        
        if (user == null) {
            request.setAttribute("error", "Email không tồn tại trong hệ thống.");
            request.getRequestDispatcher("view/auth/forgot-password.jsp").forward(request, response);
            return;
        }
        
        // Kiểm tra trạng thái tài khoản
        if (!"active".equalsIgnoreCase(user.getStatus())) {
            request.setAttribute("error", "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ admin.");
            request.getRequestDispatcher("view/auth/forgot-password.jsp").forward(request, response);
            return;
        }
        
        try {
            // Tạo reset token
            String resetToken = generateResetToken();
            long expirationTime = System.currentTimeMillis() + (24 * 60 * 60 * 1000); // 24 giờ
            
            // Lưu token vào database
            if (userDAO.saveResetToken(user.getId(), resetToken, expirationTime)) {
                // Tạo reset link
                String resetLink = request.getScheme() + "://" + 
                                 request.getServerName() + ":" + 
                                 request.getServerPort() + 
                                 request.getContextPath() + 
                                 "/reset-password?token=" + resetToken;
                
                // Gửi email
                sendMail.sendPasswordResetEmail(user.getEmail(), user.getName(), resetLink);
                
                // Thông báo thành công
                request.setAttribute("success", "Đường link đặt lại mật khẩu đã được gửi đến email của bạn. Vui lòng kiểm tra hộp thư.");
                request.getRequestDispatcher("view/auth/forgot-password.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi tạo yêu cầu đặt lại mật khẩu. Vui lòng thử lại.");
                request.getRequestDispatcher("view/auth/forgot-password.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại sau.");
            request.getRequestDispatcher("view/auth/forgot-password.jsp").forward(request, response);
        }
    }
    
    private String generateResetToken() {
        return UUID.randomUUID().toString() + "-" + System.currentTimeMillis();
    }
    
    @Override
    public String getServletInfo() {
        return "Servlet xử lý forgot password";
    }
}