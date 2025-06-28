package controller.cart;

import dao.implement.BookDAO;
import entity.Book;
import entity.CartItem;
import entity.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class UpdateCartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginedUser = (User) session.getAttribute("loginedUser");
        
        if (loginedUser == null) {
            sendJsonResponse(response, false, "Vui lòng đăng nhập để thực hiện chức năng này");
            return;
        }
        
        try {
            int bookId = Integer.parseInt(request.getParameter("bookId"));
            int change = Integer.parseInt(request.getParameter("change"));
            
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            if (cart == null) {
                cart = new ArrayList<>();
            }
            
            BookDAO bookDAO = new BookDAO();
            Book book = bookDAO.getBookById(bookId);
            
            if (book == null) {
                sendJsonResponse(response, false, "Không tìm thấy sách");
                return;
            }
            
            CartItem existingItem = null;
            for (CartItem item : cart) {
                if (item.getBook().getId() == bookId) {
                    existingItem = item;
                    break;
                }
            }
            
            if (existingItem == null) {
                if (change > 0) {
                    cart.add(new CartItem(book, 1));
                    session.setAttribute("cart", cart);
                    sendJsonResponse(response, true, "Đã thêm sách vào giỏ");
                } else {
                    sendJsonResponse(response, false, "Sách không có trong giỏ");
                }
            } else {
                int newQuantity = existingItem.getQuantity() + change;
                if (newQuantity <= 0) {
                    cart.remove(existingItem);
                    session.setAttribute("cart", cart);
                    sendJsonResponse(response, true, "Đã xóa sách khỏi giỏ");
                } else if (newQuantity <= book.getAvailableCopies()) {
                    existingItem.setQuantity(newQuantity);
                    session.setAttribute("cart", cart);
                    sendJsonResponse(response, true, "Đã cập nhật số lượng");
                } else {
                    sendJsonResponse(response, false, "Số lượng yêu cầu vượt quá số sách có sẵn");
                }
            }
            
        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "Dữ liệu không hợp lệ");
        } catch (Exception e) {
            sendJsonResponse(response, false, "Lỗi: " + e.getMessage());
        }
    }
    
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) 
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print("{\"success\":" + success + ",\"message\":\"" + message + "\"}");
        out.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 