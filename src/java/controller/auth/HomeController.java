package controller.auth;

import dao.implement.BookDAO;
import entity.Book;
import entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            BookDAO bookDAO = new BookDAO();
            List<Book> books = bookDAO.getAllBook();
            List<Book> newBooks = bookDAO.getNewBooks();
            ArrayList<String> categories = bookDAO.getAllCategories();
            
            request.setAttribute("books", books);
            request.setAttribute("newBooks", newBooks);
            request.setAttribute("categories", categories);
            
            // Kiểm tra session và chuyển hướng dựa vào vai trò người dùng
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("loginedUser") != null) {
                User loginedUser = (User) session.getAttribute("loginedUser");
                if (loginedUser.getRole().equalsIgnoreCase("admin")) {
                    // Nếu là admin
                    request.getRequestDispatcher("admindashboard").forward(request, response);
                } else {
                    // Nếu là user thường
                    request.getRequestDispatcher("user-dashboard.jsp").forward(request, response);
                }
            } else {
                // Nếu chưa đăng nhập (guest)
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }
        } catch (SQLException | ClassNotFoundException e) {
            request.setAttribute("error", "Error loading books: " + e.getMessage());
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } catch (Exception ex) {
            Logger.getLogger(HomeController.class.getName()).log(Level.SEVERE, null, ex);
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}
