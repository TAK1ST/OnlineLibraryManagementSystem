/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import constant.ViewURL;
import dao.implement.BookDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;
import entity.Book;
import java.util.ArrayList;
import service.implement.UpdateInventoryService;
import service.interfaces.IUpdateInventoryService;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import util.DBConnection;

/**
 *
 * @author asus
 */

public class AdminUpdateInventory extends HttpServlet {

    private final IUpdateInventoryService inventoryService;
    private BookDAO bookDAO = new BookDAO();

    public AdminUpdateInventory() throws SQLException, ClassNotFoundException {
        this.inventoryService = new UpdateInventoryService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get statistics
            int totalBooks = inventoryService.getTotalBook();
            int availableBooks = inventoryService.getTotalBookAvailable();
            int borrowedBooks = inventoryService.getBorrowBook();
            int lowStockBooks = inventoryService.getBorrowLowStock();

            // Set statistics attributes
            request.setAttribute("totalBooks", totalBooks);
            request.setAttribute("availableBooks", availableBooks);
            request.setAttribute("borrowedBooks", borrowedBooks);
            request.setAttribute("lowStockBooks", lowStockBooks);

            // Get search parameters
            String searchTitle = request.getParameter("searchTitle");
            String searchAuthor = request.getParameter("searchAuthor");
            String searchCategory = request.getParameter("searchCategory");
            String searchTerm = request.getParameter("searchTerm");
            String searchType = request.getParameter("searchType");

//            List<Book> books;
            List<Book> books = new ArrayList<>();

            // Check if it's a search request
            if ((searchTitle != null && !searchTitle.trim().isEmpty())
                    || (searchAuthor != null && !searchAuthor.trim().isEmpty())
                    || (searchCategory != null && !searchCategory.trim().isEmpty())) {

                books = ((UpdateInventoryService) inventoryService).searchBooks(searchTitle, searchAuthor, searchCategory);
            } else {
                books = ((UpdateInventoryService) inventoryService).getAllBooks();
            }

            //Search
            if (searchTerm != null && !searchTerm.trim().isEmpty() && searchType != null) {
                switch (searchType) {
                    case "title":
                        books = bookDAO.searchByTitle(searchTerm);
                        break;
                    case "author":
                        books = bookDAO.searchByAuthor(searchTerm);
                        break;
                    case "category":
                        books = bookDAO.searchByCategory(searchTerm);
                        break;
                    case "isbn":
                        // Note: ISBN search not implemented in DAO as per request
                        break;
                }
            }

            request.setAttribute("books", books);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading inventory data: " + e.getMessage());
        }

        request.getRequestDispatcher(ViewURL.ADMIN_UPDATE_INVENTORY).forward(request, response);
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("update".equals(action)) {
            try {
                int bookId = Integer.parseInt(request.getParameter("bookId"));
                int totalCopies = Integer.parseInt(request.getParameter("totalCopies"));

                if (totalCopies >= 0) {
                    // Kiểm tra số sách đang được mượn trước khi cập nhật
                    int borrowedCount = getBorrowedCount(bookId);

                    if (totalCopies >= borrowedCount) {
                        boolean success = bookDAO.updateTotalCopies(bookId, totalCopies);
                        if (success) {
                            request.setAttribute("message", "Update successful! Total: " + totalCopies
                                    + ", Available: " + (totalCopies - borrowedCount)
                                    + ", Borrowed: " + borrowedCount);
                        } else {
                            request.setAttribute("message", "Update failed!");
                        }
                    } else {
                        request.setAttribute("message", "Error: Total copies (" + totalCopies
                                + ") cannot be less than borrowed books (" + borrowedCount + ")!");
                    }
                } else {
                    request.setAttribute("message", "Total copies cannot be negative!");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("message", "Invalid input! Please enter valid numbers.");
            } catch (Exception e) {
                request.setAttribute("message", "Error occurred: " + e.getMessage());
            }
        }

        doGet(request, response);
    }

// Thêm method helper để đếm số sách đang được mượn
    private int getBorrowedCount(int bookId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            String query = "SELECT COUNT(*) FROM borrow_records WHERE book_id = ? AND status = 'borrowed'";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, bookId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return 0;
    }

    @Override
    public String getServletInfo() {
        return "Admin Update Inventory Servlet";
    }
}
