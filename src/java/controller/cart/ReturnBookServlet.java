package controller.cart;

import dao.implement.BorrowRequestDAO;
import entity.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ReturnBookServlet")
public class ReturnBookServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession();
        User loginedUser = (User) session.getAttribute("loginedUser");
        
        if (loginedUser == null) {
            out.print("{\"success\": false, \"message\": \"Please login to return books\"}");
            return;
        }
        
        try {
            int requestId = Integer.parseInt(request.getParameter("requestId"));
            BorrowRequestDAO borrowRequestDAO = new BorrowRequestDAO();
            
            boolean success = borrowRequestDAO.returnBook(requestId);
            
            if (success) {
                out.print("{\"success\": true, \"message\": \"Yêu cầu trả sách đã được gửi. Vui lòng chờ admin duyệt.\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Không thể gửi yêu cầu trả sách. Vui lòng thử lại.\"}");
            }
            
        } catch (Exception e) {
            out.print("{\"success\": false, \"message\": \"Lỗi khi gửi yêu cầu trả sách: " + e.getMessage() + "\"}");
        }
    }
} 