package controller.auth;

import dao.implement.BookDAO;
import entity.Book;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy danh sách sách mới
            BookDAO bookDAO = new BookDAO();
            List<Book> newBooks = bookDAO.getNewBooks(); 
            List<String> categories = bookDAO.getAllCategories(); 
            request.setAttribute("books", newBooks);
            request.setAttribute("categories", categories);
            
            
            request.getRequestDispatcher("home.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("message", "Error: " + e.getMessage());
            request.setAttribute("messageType", "error");
            request.getRequestDispatcher("/home.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 