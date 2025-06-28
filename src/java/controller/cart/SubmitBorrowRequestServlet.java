package controller.cart;

import dao.implement.BookDAO;
import dao.implement.BorrowRequestDAO;
import entity.Book;
import entity.CartItem;
import entity.User;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class SubmitBorrowRequestServlet extends HttpServlet {

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginedUser = (User) session.getAttribute("loginedUser");
        
        if (loginedUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            
            if (cart == null || cart.isEmpty()) {
                request.setAttribute("message", "Your cart is empty!");
                request.setAttribute("messageType", "warning");
                request.getRequestDispatcher("cart.jsp").forward(request, response);
                return;
            }
            
            BorrowRequestDAO borrowRequestDAO = new BorrowRequestDAO();
            BookDAO bookDAO = new BookDAO();
            boolean success = true;
            
            // Tạo borrow request cho mỗi cuốn sách trong giỏ hàng
            for (CartItem item : cart) {
                Book currentBook = bookDAO.getBookById(item.getBook().getId());
                
                // Kiểm tra số lượng sách có sẵn
                if (currentBook.getAvailableCopies() < item.getQuantity()) {
                    request.setAttribute("message", "Not enough copies available for book: " + currentBook.getTitle());
                    request.setAttribute("messageType", "error");
                    request.getRequestDispatcher("cart.jsp").forward(request, response);
                    return;
                }
                
                LocalDate today = LocalDate.now();
                // Tạo borrow request cho mỗi bản copy
                for (int i = 0; i < item.getQuantity(); i++) {
                    success &= borrowRequestDAO.createBorrowRequest(
                        loginedUser.getId(),
                        currentBook.getId(),
                        Date.valueOf(today),
                        "pending"
                    );
                    
                    if (success) {
                        // Cập nhật số lượng sách có sẵn
                        currentBook.setAvailableCopies(currentBook.getAvailableCopies() - 1);
                        bookDAO.updateBook(currentBook);
                    } else {
                        break;
                    }
                }
                
                if (!success) break;
            }
            
            if (success) {
                // Xóa giỏ hàng sau khi đã tạo borrow request thành công
                session.removeAttribute("cart");
                request.setAttribute("message", "Borrow requests submitted successfully! Please wait for admin approval.");
                request.setAttribute("messageType", "success");
            } else {
                request.setAttribute("message", "Failed to submit some borrow requests. Please try again.");
                request.setAttribute("messageType", "error");
            }
            
        } catch (Exception e) {
            request.setAttribute("message", "Error submitting borrow requests: " + e.getMessage());
            request.setAttribute("messageType", "error");
        }
        
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }
} 