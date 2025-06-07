package controller.auth;

import dao.implement.BookDAO;
import entity.Book;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
            List<Book> allBooks = bookDAO.getAllBook();
            List<Book> newBooks = bookDAO.getNewBooks();
            ArrayList<String> categories = bookDAO.getAllCategories();
            
            request.setAttribute("allBooks", allBooks);
            request.setAttribute("newBooks", newBooks);
            request.setAttribute("categories", categories);
            
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            request.setAttribute("error", "Error loading books: " + e.getMessage());
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } catch (Exception ex) {
            Logger.getLogger(HomeController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
