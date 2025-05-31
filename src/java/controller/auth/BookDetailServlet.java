/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.auth;

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
import util.DBConnection;

/**
 *
 * @author CAU_TU
 */
public class BookDetailServlet extends HttpServlet {
   
private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String bookId = request.getParameter("id");
        Book book = null;

        if (bookId != null) {
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "SELECT * FROM books WHERE id=?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, Integer.parseInt(bookId));
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    book = new Book(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("author"),
                        rs.getString("isbn"),
                        rs.getString("category"),
                        rs.getInt("publishedYear"),
                        rs.getInt("totalCopies"),
                        rs.getInt("availableCopies"),
                        rs.getString("status")
                    );
                }
            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
            }
        }

        // Đẩy dữ liệu lên view
        request.setAttribute("book", book);
        request.getRequestDispatcher("view/auth/bookdetail.jsp").forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
