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
            try ( Connection cn = DBConnection.getConnection();  PreparedStatement prst = cn.prepareStatement(sql)) {
                  if (cn == null) {
                        System.err.println("Cannot connect database.");
                        return Optional.empty();
                  }
                  prst.setInt(1, id);
                  try ( ResultSet rs = prst.executeQuery()) {
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
      public boolean updateBookRequestStatus(int requestId, String status) {
            String query = "UPDATE book_requests SET status = ? WHERE id = ?";
            try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(query)) {
                  stmt.setString(1, status);
                  stmt.setInt(2, requestId);
                  int rowsAffected = stmt.executeUpdate();
                  return rowsAffected > 0;
            } catch (Exception e) {
                  e.printStackTrace();
                  System.err.println("Error updating book request status: " + e.getMessage());
                  return false;
            }
      }

      @Override
      public List<BookInforRequestStatusDTO> getBookRequestStatusBySearch(String title, String status, int offset) {
            List<BookInforRequestStatusDTO> result = new ArrayList<>();
            StringBuilder query = new StringBuilder(
                    "SELECT br.id, b.title, b.isbn, b.available_copies, br.status, br.request_type, u.name as username, "
                    + "br.user_id, br.book_id, brr.due_date, COALESCE(f.fine_amount, 0) as fine_amount "
                    + "FROM book_requests br "
                    + "LEFT JOIN books b ON br.book_id = b.id "
                    + "INNER JOIN users u ON br.user_id = u.id "
                    + "LEFT JOIN borrow_records brr ON br.user_id = brr.user_id AND br.book_id = brr.book_id AND brr.status IN ('borrowed', 'overdue') "
                    + "LEFT JOIN fines f ON brr.id = f.borrow_id "
                    + "WHERE 1=1 "
            );

            List<Object> parameters = new ArrayList<>();

            // Filter by title
            if (title != null && !title.trim().isEmpty()) {
                  query.append("AND LOWER(b.title) LIKE LOWER(?) ");
                  parameters.add("%" + title.trim() + "%");
            }

            if (status != null && !status.trim().isEmpty()) {
                  switch (status.trim().toLowerCase()) {
                        case "pending_borrow":
                              query.append("AND br.status = 'pending' AND br.request_type = 'borrow' ");
                              break;
                        case "pending_return":
                              query.append("AND br.status = 'pending' AND br.request_type = 'return' ");
                              break;
                        case "approved-borrow":
                              query.append("AND br.status = 'approved-borrow' ");
                              break;
                        case "approved-return":
                              query.append("AND br.status = 'approved-return' ");
                              break;
                        default:
                              query.append("AND LOWER(br.status) = LOWER(?) ");
                              parameters.add(status.trim());
                  }
            }

            // Order + Pagination
            query.append(
                    "ORDER BY "
                    + "CASE "
                    + "WHEN br.status = 'pending' AND br.request_type = 'borrow' THEN 1 "
                    + "WHEN br.status = 'pending' AND br.request_type = 'return' THEN 2 "
                    + "WHEN br.status = 'approved-borrow' THEN 3 "
                    + "WHEN br.status = 'approved-return' THEN 4 "
                    + "ELSE 5 "
                    + "END, "
                    + "br.request_date DESC, br.id DESC "
                    + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"
            );

            parameters.add(offset);
            parameters.add(RECORDS_PER_LOAD);

            // Execute query
            try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(query.toString())) {

                  for (int i = 0; i < parameters.size(); i++) {
                        stmt.setObject(i + 1, parameters.get(i));
                  }

                  ResultSet rs = stmt.executeQuery();
                  while (rs.next()) {
                        BookInforRequestStatusDTO dto = new BookInforRequestStatusDTO();
                        dto.setId(rs.getInt("id"));
                        dto.setTitle(rs.getString("title") != null ? rs.getString("title") : "Unknown");
                        dto.setIsbn(rs.getString("isbn") != null ? rs.getString("isbn") : "N/A");
                        dto.setAvailableCopies(rs.getInt("available_copies"));
                        dto.setStatusAction(rs.getString("status"));
                        dto.setRequestType(rs.getString("request_type"));
                        dto.setUsername(rs.getString("username"));
                        dto.setUserId(rs.getInt("user_id"));
                        dto.setBookId(rs.getInt("book_id"));
                        if (rs.getDate("due_date") != null) {
                              dto.setDueDate(rs.getDate("due_date").toLocalDate());
                        }
                        dto.setOverdueFine(rs.getDouble("fine_amount"));
                        result.add(dto);
                  }

            } catch (Exception e) {
                  e.printStackTrace();
                  System.err.println("Error fetching book requests: " + e.getMessage());
            }

            return result;
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
                        try ( PreparedStatement fineStmt = cn.prepareStatement(insertFineSQL)) {
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
            try ( PreparedStatement prst = cn.prepareStatement(sql)) {
                  prst.setString(1, newStatus);
                  prst.setInt(2, requestId);
                  int rows = prst.executeUpdate();
                  return rows > 0;
            }
      }
}
