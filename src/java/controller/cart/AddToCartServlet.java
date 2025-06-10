package controller.cart;

import dao.implement.BookDAO;
import entity.Book;
import entity.CartItem;
import entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AddToCartServlet", urlPatterns = {"/AddToCartServlet"})
public class AddToCartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginedUser = (User) session.getAttribute("loginedUser");
        
        if (loginedUser == null) {
            // Lưu URL hiện tại để redirect sau khi đăng nhập
            String currentUrl = request.getRequestURI();
            String queryString = request.getQueryString();
            String fullUrl = queryString != null ? currentUrl + "?" + queryString : currentUrl;
            session.setAttribute("redirectUrl", fullUrl);
            
            // Chuyển hướng đến trang đăng nhập
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }
        
        try {
            int bookId = Integer.parseInt(request.getParameter("bookId"));
            BookDAO bookDAO = new BookDAO();
            Book book = bookDAO.getBookById(bookId);
            
            if (book != null && book.getAvailableCopies() > 0) {
                // Lấy giỏ hàng từ session hoặc tạo mới nếu chưa có
                List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
                if (cart == null) {
                    cart = new ArrayList<>();
                }
                
                // Kiểm tra xem sách đã có trong giỏ hàng chưa
                CartItem existingItem = null;
                for (CartItem item : cart) {
                    if (item.getBook().getId() == book.getId()) {
                        existingItem = item;
                        break;
                    }
                }
                
                if (existingItem == null) {
                    // Thêm sách mới vào giỏ với số lượng 1
                    cart.add(new CartItem(book, 1));
                    session.setAttribute("cart", cart);
                    request.setAttribute("message", "Book added to cart successfully!");
                    request.setAttribute("messageType", "success");
                } else if (existingItem.getQuantity() < book.getAvailableCopies()) {
                    // Tăng số lượng nếu còn sách
                    existingItem.incrementQuantity();
                    session.setAttribute("cart", cart);
                    request.setAttribute("message", "Increased book quantity in cart!");
                    request.setAttribute("messageType", "success");
                } else {
                    request.setAttribute("message", "Cannot add more copies of this book!");
                    request.setAttribute("messageType", "warning");
                }
            } else {
                request.setAttribute("message", "Book is not available for borrowing.");
                request.setAttribute("messageType", "error");
            }
            
            // Chuyển về trang trước đó
            String referer = request.getHeader("Referer");
            if (referer != null && !referer.contains("login.jsp")) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
            
        } catch (Exception e) {
            request.setAttribute("message", "Error: " + e.getMessage());
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/user-dashboard.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 