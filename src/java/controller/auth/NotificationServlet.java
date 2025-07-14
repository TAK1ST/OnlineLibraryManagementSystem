package controller.auth;

import com.google.gson.Gson;
import dao.implement.NotificationDAO;
import entity.Notification;
import entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name="NotificationServlet", urlPatterns={"/NotificationServlet"})
public class NotificationServlet extends HttpServlet {
   
    /**
     * Handles the HTTP <code>GET</code> method - Lấy danh sách thông báo của user
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Kiểm tra user đã login chưa
            User user = (User) request.getSession().getAttribute("loginedUser");
            if (user == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\":\"User not logged in\"}");
                return;
            }
            
            // Lấy danh sách thông báo
            NotificationDAO notificationDAO = new NotificationDAO();
            List<Notification> notiList = notificationDAO.getNotificationsByUserId(user.getId());
            
            // Trả về JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            new Gson().toJson(notiList, response.getWriter());
            
        } catch (Exception e) {
            Logger.getLogger(NotificationServlet.class.getName()).log(Level.SEVERE, null, e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Server error occurred\"}");
        }
    } 
    
    /**
     * Handles the HTTP <code>POST</code> method - Đánh dấu thông báo đã đọc
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Kiểm tra user đã login chưa
            User user = (User) request.getSession().getAttribute("loginedUser");
            if (user == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\":\"User not logged in\"}");
                return;
            }
            
            // Lấy notification ID từ request
            String notificationIdStr = request.getParameter("notificationId");
            if (notificationIdStr == null || notificationIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Notification ID is required\"}");
                return;
            }
            
            int notificationId = Integer.parseInt(notificationIdStr);
            
            // Đánh dấu thông báo đã đọc
            NotificationDAO notificationDAO = new NotificationDAO();
            boolean success = notificationDAO.markAsRead(notificationId, user.getId());
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            if (success) {
                response.getWriter().write("{\"success\":true,\"message\":\"Notification marked as read\"}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"Failed to mark notification as read\"}");
            }
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Invalid notification ID\"}");
        } catch (Exception e) {
            Logger.getLogger(NotificationServlet.class.getName()).log(Level.SEVERE, null, e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Server error occurred\"}");
        }
    }
    
    @Override
    public String getServletInfo() {
        return "Notification Servlet - Handles notification retrieval and marking as read";
    }
}