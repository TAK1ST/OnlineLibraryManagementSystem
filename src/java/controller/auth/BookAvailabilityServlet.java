package controller.auth;

import dao.implement.BookDAO;
import entity.Book;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "BookAvailabilityServlet", urlPatterns = {"/availability"})
public class BookAvailabilityServlet extends HttpServlet {

    private BookDAO bookDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        bookDAO = new BookDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Book> books = bookDAO.getAllBooksWithAvailability();
            request.setAttribute("books", books);
            request.getRequestDispatcher("/availability.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
