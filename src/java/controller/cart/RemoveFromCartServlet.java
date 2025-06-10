package controller.cart;

import entity.CartItem;
import entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

@WebServlet(name = "RemoveFromCartServlet", urlPatterns = {"/RemoveFromCart"})
public class RemoveFromCartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginedUser = (User) session.getAttribute("loginedUser");
        
        if (loginedUser == null) {
            response.sendRedirect("LoginServlet");
            return;
        }
        
        try {
            int bookId = Integer.parseInt(request.getParameter("bookId"));
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            
            if (cart != null) {
                // 从购物车中移除指定 ID 的图书
                cart.removeIf(item -> item.getBook().getId() == bookId);
                session.setAttribute("cart", cart);
                request.setAttribute("message", "Book removed from cart successfully!");
                request.setAttribute("messageType", "success");
            }
            
            response.sendRedirect("cart.jsp");
            
        } catch (Exception e) {
            request.setAttribute("message", "Error removing book from cart: " + e.getMessage());
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 