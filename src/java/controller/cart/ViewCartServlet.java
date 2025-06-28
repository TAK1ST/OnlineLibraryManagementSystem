package controller.cart;

import dao.implement.BookDAO;
import entity.Book;
import entity.CartItem;
import entity.User;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ViewCartServlet extends HttpServlet {
    
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginedUser = (User) session.getAttribute("loginedUser");
        
        if (loginedUser == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }
        
        // Lấy giỏ hàng từ session
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }
        
        try {
            // Cập nhật thông tin sách cho mỗi item trong giỏ hàng
            BookDAO bookDAO = new BookDAO();
            for (CartItem item : cart) {
                Book book = bookDAO.getBookById(item.getBook().getId());
                item.setBook(book);
            }
            
            request.setAttribute("cart", cart);
            request.getRequestDispatcher("/cart.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("message", "Error loading cart: " + e.getMessage());
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/cart.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 