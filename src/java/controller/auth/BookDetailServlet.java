/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import dao.implement.BookDAO;
import entity.Book;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import util.DBConnection;

/**
 *
 * @author CAU_TU
 */
public class BookDetailServlet extends HttpServlet {
    private BookDAO bookDAO;

    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== BookDetailServlet.doGet() called ===");

        try {
            // Kiểm tra BookDAO
            if (bookDAO == null) {
                System.err.println("ERROR: BookDAO is null!");
                request.setAttribute("error", "BookDAO không được khởi tạo");
                request.getRequestDispatcher("view/auth/bookdetail.jsp").forward(request, response);
                return;
            }

            System.out.println("BookDAO initialized successfully");

            // Lấy ID từ request (từ button View Details) 
            String bookId = request.getParameter("id");
            if (bookId == null || bookId.trim().isEmpty()) {
                request.setAttribute("error", "ID sách không hợp lệ");
                request.getRequestDispatcher("view/auth/bookdetail.jsp").forward(request, response);
                return;
            }

            System.out.println("Fetching book with ID: " + bookId);

            // Lấy thông tin sách dựa trên ID
            Book book = bookDAO.getBookById(Integer.parseInt(bookId));
            System.out.println("Book retrieved: " + (book != null ? book.getTitle() : "null"));

            // Đẩy dữ liệu lên view
            request.setAttribute("book", book);
            request.getRequestDispatcher("view/auth/bookdetail.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Unexpected error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi không xác định: " + e.getMessage());
            request.getRequestDispatcher("view/auth/bookdetail.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet for displaying all books";
    }// </editor-fold>

}
