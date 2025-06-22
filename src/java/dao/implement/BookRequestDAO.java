/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.implement;

import static constant.constance.RECORDS_PER_LOAD;
import dao.interfaces.IBookRequestDAO;
import dto.BookInforRequestStatusDTO;
import entity.Book;
import entity.BookRequest;
import entity.BorrowRecord;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import util.DBConnection;

/**
 *
 * @author asus
 */
public class BookRequestDAO implements IBookRequestDAO {

    private final BorrowRecordDAO borrowRecordDAO = new BorrowRecordDAO();
    private final BookDAO bookDAO = new BookDAO();

    public BookRequestDAO() {
    }

    @Override
    public Optional<BookRequest> getBookRequestById(int id) {
        String sql = "SELECT id, user_id, book_id, request_date, request_type, status FROM [dbo].[book_requests] WHERE id = ?";
        try (Connection cn = DBConnection.getConnection(); 
             PreparedStatement prst = cn.prepareStatement(sql)) {
            if (cn == null) {
                System.err.println("Cannot connect database.");
                return Optional.empty();
            }
            prst.setInt(1, id);
            try (ResultSet rs = prst.executeQuery()) {
                if (rs.next()) {
                    BookRequest request = new BookRequest();
                    request.setId(rs.getInt("id"));
                    request.setUserId(rs.getInt("user_id"));
                    request.setBookId(rs.getInt("book_id"));
                    request.setRequestDate(rs.getDate("request_date").toLocalDate());
                    request.setRequestType(rs.getString("request_type"));
                    request.setStatus(rs.getString("status"));
                    return Optional.of(request);
                }
            }
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
        return Optional.empty();
    }

    @Override
    public boolean updateBookRequestStatus(int requestId, String newStatus) {
        String sql = "UPDATE book_requests SET status = ? WHERE id = ?";
        try (Connection cn = DBConnection.getConnection();
             PreparedStatement prst = cn.prepareStatement(sql)) {
            
            if (cn == null) {
                System.err.println("Cannot establish database connection");
                return false;
            }
            
            prst.setString(1, newStatus);
            prst.setInt(2, requestId);
            
            int rowsUpdated = prst.executeUpdate();
            System.out.println("Updated " + rowsUpdated + " rows for request ID: " + requestId + " with status: " + newStatus);
            
            return rowsUpdated > 0;
            
        } catch (SQLException e) {
            System.err.println("SQL Error updating book request status: " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            System.err.println("Error updating book request status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<BookInforRequestStatusDTO> getBookRequestStatusBySearch(String title, String status, int offset) {
        List<BookInforRequestStatusDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        
        sql.append("SELECT br.id, b.title, b.isbn, b.available_copies, br.status, br.request_type, u.name as username, ")
           .append("br.user_id, br.book_id, brr.due_date ")
           .append("FROM book_requests br ")
           .append("JOIN books b ON br.book_id = b.id ")
           .append("JOIN users u ON br.user_id = u.id ")
           .append("LEFT JOIN borrow_records brr ON br.user_id = brr.user_id AND br.book_id = brr.book_id AND brr.status = 'borrowed' ")
           .append("WHERE 1=1 ");

        if (title != null && !title.trim().isEmpty()) {
            sql.append("AND b.title LIKE ? ");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND br.status = ? ");
        }

        sql.append("ORDER BY br.id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection cn = DBConnection.getConnection();
             PreparedStatement pr = cn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (title != null && !title.trim().isEmpty()) {
                pr.setString(paramIndex++, "%" + title + "%");
            }
            if (status != null && !status.trim().isEmpty()) {
                pr.setString(paramIndex++, status);
            }
            pr.setInt(paramIndex++, offset);
            pr.setInt(paramIndex, RECORDS_PER_LOAD);

            try (ResultSet rs = pr.executeQuery()) {
                while (rs.next()) {
                    BookInforRequestStatusDTO dto = new BookInforRequestStatusDTO();
                    dto.setId(rs.getInt("id"));
                    dto.setTitle(rs.getString("title"));
                    dto.setIsbn(rs.getString("isbn"));
                    dto.setAvailableCopies(rs.getInt("available_copies"));
                    dto.setUsername(rs.getString("username"));
                    dto.setUserId(rs.getInt("user_id"));
                    dto.setBookId(rs.getInt("book_id"));
                    dto.setStatusAction(rs.getString("status"));
                    dto.setRequestType(rs.getString("request_type"));

                    // Calculate overdue fine if due date exists
                    Date dueDate = rs.getDate("due_date");
                    if (dueDate != null) {
                        dto.setDueDate(dueDate.toLocalDate());
                        dto.setOverdueFine(calculateOverdueFine(dueDate.toLocalDate()));
                    } else {
                        dto.setOverdueFine(0.0);
                    }
                    
                    list.add(dto);
                }
            }
        } catch (Exception e) {
            System.err.println("Error in getBookRequestStatusBySearch: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    private double calculateOverdueFine(LocalDate dueDate) {
        if (dueDate == null) {
            return 0.0;
        }

        LocalDate today = LocalDate.now();
        if (today.isAfter(dueDate)) {
            long daysOverdue = ChronoUnit.DAYS.between(dueDate, today);
            return daysOverdue * 1.0; // $1 per day
        }
        return 0.0;
    }

    public boolean processReturnRequest(int requestId) {
        Connection cn = null;
        try {
            cn = DBConnection.getConnection();
            if (cn == null) {
                throw new SQLException("Cannot establish database connection");
            }
            cn.setAutoCommit(false);

            // Get the book request
            Optional<BookRequest> requestOpt = getBookRequestById(requestId);
            if (!requestOpt.isPresent()) {
                throw new IllegalArgumentException("Request not found: " + requestId);
            }
            BookRequest request = requestOpt.get();

            // Find the active borrow record
            List<BorrowRecord> borrowRecords = borrowRecordDAO
                    .getBorrowRecordsByUserIdAndBookId(request.getUserId(), request.getBookId());
            
            BorrowRecord activeBorrowRecord = borrowRecords.stream()
                    .filter(b -> "borrowed".equals(b.getStatus()))
                    .findFirst()
                    .orElseThrow(() -> new IllegalStateException("No active borrow record found"));

            // Calculate and store fine if overdue
            double fine = calculateOverdueFine(activeBorrowRecord.getDueDate());
            if (fine > 0) {
                String insertFineSQL = "INSERT INTO fines (borrow_id, fine_amount, paid_status) VALUES (?, ?, 'paid')";
                try (PreparedStatement fineStmt = cn.prepareStatement(insertFineSQL)) {
                    fineStmt.setInt(1, activeBorrowRecord.getId());
                    fineStmt.setDouble(2, fine);
                    fineStmt.executeUpdate();
                }
            }

            // Update borrow record to returned
            activeBorrowRecord.setReturnDate(LocalDate.now());
            borrowRecordDAO.updateReturnStatus(activeBorrowRecord.getId(), LocalDate.now(), "returned");

            // Update book available copies
            Book book = bookDAO.getBookById(request.getBookId());
            if (book != null) {
                book.setAvailableCopies(book.getAvailableCopies() + 1);
                bookDAO.update(book);
            }

            // Update request status
            boolean updated = updateStatusInDB(cn, requestId, "completed");
            if (!updated) {
                throw new RuntimeException("Failed to update book request status");
            }

            cn.commit();
            return true;
            
        } catch (Exception e) {
            if (cn != null) {
                try {
                    cn.rollback();
                } catch (SQLException ex) {
                    System.err.println("Error during rollback: " + ex.getMessage());
                }
            }
            System.err.println("Error processing return request: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (cn != null) {
                try {
                    cn.setAutoCommit(true);
                    cn.close();
                } catch (SQLException e) {
                    System.err.println("Error closing connection: " + e.getMessage());
                }
            }
        }
    }

    private boolean updateStatusInDB(Connection cn, int requestId, String newStatus) throws SQLException {
        String sql = "UPDATE book_requests SET status = ? WHERE id = ?";
        try (PreparedStatement prst = cn.prepareStatement(sql)) {
            prst.setString(1, newStatus);
            prst.setInt(2, requestId);
            int rows = prst.executeUpdate();
            return rows > 0;
        }
    }
}