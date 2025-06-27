package controller.cart;

import entity.CartItem;
import entity.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class RemoveFromCartServlet extends HttpServlet {

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
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            
            if (cart == null) {
                sendJsonResponse(response, false, "Giỏ sách trống");
                return;
            }
            
            CartItem itemToRemove = null;
            for (CartItem item : cart) {
                if (item.getBook().getId() == bookId) {
                    itemToRemove = item;
                    break;
                }
            }
            
            if (itemToRemove != null) {
                cart.remove(itemToRemove);
                session.setAttribute("cart", cart);
                sendJsonResponse(response, true, "Đã xóa sách khỏi giỏ");
            } else {
                sendJsonResponse(response, false, "Không tìm thấy sách trong giỏ");
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
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 