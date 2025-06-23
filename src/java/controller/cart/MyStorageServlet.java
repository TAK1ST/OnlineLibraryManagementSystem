package controller.cart;

import dao.implement.BorrowRequestDAO;
import entity.BorrowRequest;
import entity.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/MyStorageServlet")
public class MyStorageServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginedUser = (User) session.getAttribute("loginedUser");
        
        if (loginedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            BorrowRequestDAO borrowRequestDAO = new BorrowRequestDAO();
            List<BorrowRequest> approvedRequests = borrowRequestDAO.getApprovedRequestsByUser(loginedUser.getId());
            request.setAttribute("approvedRequests", approvedRequests);
            request.getRequestDispatcher("/myStorage.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("message", "Error loading My Storage: " + e.getMessage());
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher("/myStorage.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 