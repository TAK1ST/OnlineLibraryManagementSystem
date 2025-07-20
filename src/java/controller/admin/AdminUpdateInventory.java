/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import constant.ViewURL;
import dao.implement.BookDAO;
import dao.implement.OverdueBookDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;
import entity.Book;
import entity.OverdueBook;
import entity.User;
import java.util.ArrayList;
import service.implement.UpdateInventoryService;
import service.interfaces.IUpdateInventoryService;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;
import util.DBConnection;

/**
 *
 * @author asus
 */
public class AdminUpdateInventory extends BaseAdminController {

    private final IUpdateInventoryService inventoryService;
    private final BookDAO bookDAO = new BookDAO();
    private final OverdueBookDAO overdueBookDAO = new OverdueBookDAO();

    public AdminUpdateInventory() throws SQLException, ClassNotFoundException {
        this.inventoryService = new UpdateInventoryService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            List<OverdueBook> overdueBooks = overdueBookDAO.getAllOverdueBooks();

            // Get statistics
            int totalBooks = inventoryService.getTotalBook();
            int availableBooks = inventoryService.getTotalBookAvailable();
            int borrowedBooks = inventoryService.getBorrowBook();
            int totalOverdueBooks = overdueBookDAO.getTotalOverdueBooks();

            // Set statistics attributes
            request.setAttribute("totalBooks", totalBooks);
            request.setAttribute("availableBooks", availableBooks);
            request.setAttribute("borrowedBooks", borrowedBooks);
            request.setAttribute("totalOverdueBooks", totalOverdueBooks);

            // Get search parameters
            String searchTitle = request.getParameter("searchTitle");
            String searchAuthor = request.getParameter("searchAuthor");
            String searchCategory = request.getParameter("searchCategory");
            String searchTerm = request.getParameter("searchTerm");
            String searchType = request.getParameter("searchType");

//            List<Book> books;
            List<Book> books = new ArrayList<>();

            // Thay vì sửa Book, tạo Map để lưu borrowedCount
            Map<Integer, Integer> borrowedCountMap = new HashMap<>();
            for (Book book : books) {
                int borrowedCount = getBorrowedCount(book.getId());
                borrowedCountMap.put(book.getId(), borrowedCount);
            }

            request.setAttribute("books", books);
            request.setAttribute("borrowedCountMap", borrowedCountMap);

            User adminUser = checkAdminAuthentication(request, response);
            if (adminUser == null) {
                return;
            }

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
                        books = bookDAO.searchByIsbn(searchTerm);
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
                // FIX: Thay đổi tên parameter để phù hợp với logic cộng dồn
                int quantityToAdd = Integer.parseInt(request.getParameter("totalCopies"));

                if (quantityToAdd >= 0) {
                    // Kiểm tra số sách đang được mượn trước khi cập nhật
                    int borrowedCount = getBorrowedCount(bookId);

                    // FIX: Lấy số lượng hiện tại để kiểm tra
                    int currentQuantity = getCurrentQuantity(bookId);
                    int newTotalQuantity = currentQuantity + quantityToAdd;

                    if (newTotalQuantity >= borrowedCount) {
                        // FIX: Sử dụng method addToTotalCopies thay vì cũ
                        boolean success = bookDAO.addToTotalCopies(bookId, quantityToAdd);
                        if (success) {
                            request.setAttribute("message", "Update successful! Added: " + quantityToAdd
                                    + ", New Total: " + newTotalQuantity
                                    + ", Available: " + (newTotalQuantity - borrowedCount)
                                    + ", Borrowed: " + borrowedCount);
                        } else {
                            request.setAttribute("message", "Update failed!");
                        }
                    } else {
                        request.setAttribute("message", "Error: New total copies (" + newTotalQuantity
                                + ") cannot be less than borrowed books (" + borrowedCount + ")!");
                    }
                } else {
                    request.setAttribute("message", "Quantity to add cannot be negative!");
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
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            String query = "SELECT COUNT(*) FROM borrow_records WHERE book_id = ? AND status = 'borrowed'";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, bookId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // FIX: Đóng resource đúng cách
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            try {
                if (stmt != null) {
                    stmt.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
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

    // FIX: Thêm method để lấy số lượng hiện tại
    private int getCurrentQuantity(int bookId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            String query = "SELECT [total_copies] FROM books WHERE id = ?";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, bookId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt("quantity");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            try {
                if (stmt != null) {
                    stmt.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
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
