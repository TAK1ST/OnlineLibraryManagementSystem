package controller.auth;

import dao.implement.BookDAO;
import entity.Book;
import entity.User;
import java.io.IOException;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "SearchBook", urlPatterns = {"/search"})
public class SearchBookServlet extends HttpServlet {

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String category = request.getParameter("category");
        
        BookDAO bookDAO = new BookDAO();
        ArrayList<Book> books = new ArrayList<>();
        ArrayList<Book> newBooks = new ArrayList<>();
        
        try {
            // Nếu không có tiêu chí tìm kiếm nào, hiển thị tất cả sách
            if ((title == null || title.trim().isEmpty()) && 
                (author == null || author.trim().isEmpty()) && 
                (category == null || category.trim().isEmpty())) {
                books = new ArrayList<>(bookDAO.getAllBook());
                // Get new books for the homepage
                newBooks = new ArrayList<>(bookDAO.getNewBooks()); // Get top 5 new books

            } else {
                books = bookDAO.searchBooks(title, author, category);
            }
            
            // Lấy danh sách categories cho dropdown
            ArrayList<String> categories = bookDAO.getAllCategories();
            
            request.setAttribute("categories", categories);
            request.setAttribute("books", books);
            request.setAttribute("newBooks", newBooks);
            request.setAttribute("title", title);
            request.setAttribute("author", author);
            request.setAttribute("category", category);
            
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(SearchBookServlet.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "An error occurred while processing your request.");
        } catch (Exception ex) {
            Logger.getLogger(SearchBookServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loginedUser") != null) {
            request.getRequestDispatcher("search.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("home.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
