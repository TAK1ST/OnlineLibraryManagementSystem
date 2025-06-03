package controller.auth;

import dao.implement.BookDAO;
import entity.Book;
import java.io.IOException;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "SearchBookServlet", urlPatterns = {"/search"})
public class SearchBookServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String category = request.getParameter("category");
        
        BookDAO bookDAO = new BookDAO();
        ArrayList<Book> books = new ArrayList<>();
        
        try {
            // Nếu không có tiêu chí tìm kiếm nào, hiển thị tất cả sách
            if ((title == null || title.trim().isEmpty()) && 
                (author == null || author.trim().isEmpty()) && 
                (category == null || category.trim().isEmpty())) {
                books = new ArrayList<>(bookDAO.getAllBook());
            } else {
                books = bookDAO.searchBooks(title, author, category);
            }
            
            // Lấy danh sách categories cho dropdown
            ArrayList<String> categories = bookDAO.getAllCategories();
            request.setAttribute("categories", categories);
            
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(SearchBookServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(SearchBookServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        request.setAttribute("books", books);
        request.setAttribute("title", title);
        request.setAttribute("author", author);
        request.setAttribute("selectedCategory", category);
        
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
