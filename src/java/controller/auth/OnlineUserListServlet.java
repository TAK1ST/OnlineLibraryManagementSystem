package controller.auth;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Set;
import service.implement.OnlineUserManager;

/**
 * Servlet để hiển thị danh sách người dùng online
 * @author CAU_TU
 */
//@WebServlet(name = "OnlineUserListServlet", urlPatterns = {"/online-users"})
public class OnlineUserListServlet extends HttpServlet {
    
    private static final String ONLINE_USERS_JSP = "view/dashboard/user/online-users.jsp";
    
    /**
     * Xử lý request và forward tới JSP
     */
    public void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy danh sách người dùng online
            Set<String> onlineUsers = OnlineUserManager.getOnlineUsers();
            int userCount = OnlineUserManager.getOnlineUserCount();
            
            // Đưa dữ liệu vào request scope
            request.setAttribute("onlineUsers", onlineUsers);
            request.setAttribute("userCount", userCount);
            
            // Forward tới JSP
            request.getRequestDispatcher(ONLINE_USERS_JSP).forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            
            // Đưa thông tin lỗi vào request
            request.setAttribute("error", "Lỗi khi tải danh sách người dùng online: " + e.getMessage());
            request.setAttribute("onlineUsers", null);
            request.setAttribute("userCount", 0);
            
            // Forward tới JSP để hiển thị lỗi
            request.getRequestDispatcher(ONLINE_USERS_JSP).forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet hiển thị danh sách người dùng đang online";
    }
}