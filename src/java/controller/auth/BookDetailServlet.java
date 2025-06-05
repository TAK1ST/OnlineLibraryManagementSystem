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
import util.DBConnection;

/**
 *
 * @author CAU_TU
 */
public class BookDetailServlet extends HttpServlet {
   
private static final long serialVersionUID = 1L;
private BookDAO bookDAO;
    
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy tất cả sách từ database
            List<Book> books = bookDAO.getAllBook();
            
            // Đẩy dữ liệu lên view
            request.setAttribute("books", books);
            request.getRequestDispatcher("view/auth/bookdetail.jsp").forward(request, response);
            
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            // Nếu có lỗi, gửi danh sách rỗng
            request.setAttribute("books", null);
            request.setAttribute("error", "Không thể tải danh sách sách: " + e.getMessage());
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
