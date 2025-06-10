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

@WebServlet(name = "ViewCartServlet", urlPatterns = {"/ViewCartServlet"})
public class ViewCartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("loginedUser") == null) {
            session = request.getSession();
            session.setAttribute("redirectUrl", request.getRequestURI());
            response.sendRedirect("login.jsp");
            return;
        }
        
        User loginedUser = (User) session.getAttribute("loginedUser");
        
        // Lấy giỏ hàng từ session
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        request.setAttribute("cart", cart);
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 