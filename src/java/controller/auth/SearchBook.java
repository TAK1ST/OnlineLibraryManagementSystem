/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import dao.implement.BookDAO;
import entity.Book;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

@WebServlet(name = "SearchBook", urlPatterns = {"/search"})
public class SearchBook extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchTerm = request.getParameter("txtsearch");
        String searchBy = request.getParameter("searchBy");
        
        // Default search by title if not specified
        if (searchBy == null || searchBy.trim().isEmpty()) {
            searchBy = "title";
        }
        
        try {
            BookDAO bookDAO = new BookDAO();
            List<Book> books = null;
            
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                books = bookDAO.searchBooks(searchTerm, searchBy);
            } else {
                books = bookDAO.getNewBooks(); // Show new books if no search term
            }
            
            request.setAttribute("books", books);
            request.setAttribute("searchTerm", searchTerm);
            request.setAttribute("searchBy", searchBy);
            
            // Forward to the search results page
            request.getRequestDispatcher("search.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred while searching for books: " + e.getMessage());
            request.getRequestDispatcher("search.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
