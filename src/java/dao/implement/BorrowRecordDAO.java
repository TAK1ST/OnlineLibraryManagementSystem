/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.implement;

import dao.interfaces.IBorrowRecordDAO;
import entity.BookRequest;
import entity.BorrowRecord;
import entity.User;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import util.DBConnection;

/**
 *
 * @author asus
 */
public class BorrowRecordDAO implements IBorrowRecordDAO {

      private Connection cn = null;

      public BorrowRecordDAO(Connection cn) {
            this.cn = cn;
      }

      @Override
      public List<BorrowRecord> getAll() {
            List<BorrowRecord> records = new ArrayList<>();
            String sql = "SELECT id, userId, bookId, borrowDate, dueDate, returnDate, status FROM [dbo].[borrow_records]";
            PreparedStatement prst = null;
            ResultSet rs = null;
            try {
                  if (cn == null) {
                        System.err.println("Cannot connect database");
                        return records;
                  }
                  // step 2: create PreparedStatement and execuse query
                  prst = cn.prepareStatement(sql);
                  rs = prst.executeQuery(); // ResultSet had result from CSDL

                  // step 3: get data from ResultSet and create object BorrowRecord
                  while (rs != null && rs.next()) {
                        //  helper method  map current row to object BorrowRecord
                        BorrowRecord record = mapRowToBorrowRecord(rs);
                        records.add(record); // Thêm đối tượng vào danh sách
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            } finally {
                  try {
                        if (cn != null) {
                              cn.close();
                        }
                  } catch (Exception e) {
                        e.printStackTrace();
                  }
            }
            return records;
      }

      @Override
      public Optional<BorrowRecord> getBorrowRecordById(int id
      ) {
            String sql = "SELECT id, userId, bookId, borrowDate, dueDate, returnDate, status FROM [dbo].[borrow_records] WHERE id = ?";
            PreparedStatement prst = null;
            ResultSet rs = null;
            try {
                  if (cn == null) {
                        System.err.println("Cannot connect database.");
                        return Optional.empty();
                  }
                  prst = cn.prepareStatement(sql);
                  prst.setInt(1, id);
                  rs = prst.executeQuery();
                  if (rs.next()) {
                        return Optional.of(mapRowToBorrowRecord(rs));
                  }
            } catch (SQLException e) {
                  System.err.println("Error: " + e.getMessage());
                  e.printStackTrace();
            } finally {
                  try {
                        if (rs != null) {
                              rs.close();
                        }
                        if (prst != null) {
                              prst.close();
                        }
                  } catch (SQLException e) {
                        e.printStackTrace();
                  }
            }
            return Optional.empty();
      }

      @Override
      public List<BorrowRecord> getBorrowRecordsByUserId(int userId
      ) {
            List<BorrowRecord> records = new ArrayList<>();
            String sql = "SELECT id, userId, bookId, borrowDate, dueDate, returnDate, status FROM [dbo].[borrow_records] WHERE userId = ?";
            PreparedStatement prst = null;
            ResultSet rs = null;
            try {
                  if (cn == null) {
                        System.err.println("Cannot connect database.");
                        return records;
                  }
                  prst = cn.prepareStatement(sql);
                  prst.setInt(1, userId);
                  rs = prst.executeQuery();
                  while (rs.next()) {
                        records.add(mapRowToBorrowRecord(rs));
                  }
            } catch (SQLException e) {
                  System.err.println("Error: " + e.getMessage());
                  e.printStackTrace();
            } finally {
                  try {
                        if (rs != null) {
                              rs.close();
                        }
                        if (prst != null) {
                              prst.close();
                        }
                  } catch (SQLException e) {
                        e.printStackTrace();
                  }
            }
            return records;
      }

      @Override
      public List<BorrowRecord> getBorrowRecordsByBookId(int bookId
      ) {
            List<BorrowRecord> records = new ArrayList<>();
            String sql = "SELECT id, userId, bookId, borrowDate, dueDate, returnDate, status FROM [dbo].[borrow_records] WHERE bookId = ?";
            PreparedStatement prst = null;
            ResultSet rs = null;
            try {
                  if (cn == null) {
                        System.err.println("Cannot connect database.");
                        return records;
                  }
                  prst = cn.prepareStatement(sql);
                  prst.setInt(1, bookId);
                  rs = prst.executeQuery();
                  while (rs.next()) {
                        records.add(mapRowToBorrowRecord(rs));
                  }
            } catch (SQLException e) {
                  System.err.println("Error: " + e.getMessage());
                  e.printStackTrace();
            } finally {
                  try {
                        if (rs != null) {
                              rs.close();
                        }
                        if (prst != null) {
                              prst.close();
                        }
                  } catch (SQLException e) {
                        e.printStackTrace();
                  }
            }
            return records;
      }

      @Override
      public boolean updateReturnStatus(int id, LocalDate returnDate,
              String status
      ) {
            String sql = "UPDATE [dbo].[borrow_records] SET returnDate = ?, status = ? WHERE id = ?";
            PreparedStatement prst = null;
            try {
                  if (cn == null) {
                        System.err.println("Lỗi BorrowRecordDAO (updateReturnStatus): Connection is null.");
                        return false;
                  }
                  prst = cn.prepareStatement(sql);
                  if (returnDate != null) {
                        prst.setDate(1, Date.valueOf(returnDate));
                  } else {
                        prst.setNull(1, Types.DATE);
                  }
                  prst.setString(2, status);
                  prst.setInt(3, id);

                  int rowsUpdated = prst.executeUpdate();
                  if (rowsUpdated > 0) {
                        System.out.println("Update book return status (ID: " + id + ") successfully.");
                        return true;
                  } else {
                        System.out.println("No book loan records found (ID: " + id + ") to update or remain unchanged.");
                        return false;
                  }
            } catch (SQLException e) {
                  System.err.println("Error: " + e.getMessage());
                  e.printStackTrace();
                  return false;
            } finally {
                  try {
                        if (prst != null) {
                              prst.close();
                        }
                  } catch (SQLException e) {
                        e.printStackTrace();
                  }
            }
      }

      @Override
      public List<BorrowRecord> getCurrentBorrowedBooks() {
            List<BorrowRecord> records = new ArrayList<>();
            String sql = "SELECT id, userId, bookId, borrowDate, dueDate, returnDate, status FROM [dbo].[borrow_records] WHERE returnDate IS NULL AND (status = 'borrowed' OR status = 'overdue')";
            PreparedStatement prst = null;
            ResultSet rs = null;
            try {
                  if (cn == null) {
                        System.err.println("Cannot connect database.");
                        return records;
                  }
                  prst = cn.prepareStatement(sql);
                  rs = prst.executeQuery();
                  while (rs.next()) {
                        records.add(mapRowToBorrowRecord(rs));
                  }
            } catch (SQLException e) {
                  System.err.println("Error: " + e.getMessage());
                  e.printStackTrace();
            } finally {
                  try {
                        if (rs != null) {
                              rs.close();
                        }
                        if (prst != null) {
                              prst.close();
                        }
                  } catch (SQLException e) {
                        e.printStackTrace();
                  }
            }
            return records;
      }

      @Override
      public List<BorrowRecord> getOverdueBooks() {
            List<BorrowRecord> records = new ArrayList<>();
            String sql = "SELECT id, userId, bookId, borrowDate, dueDate, returnDate, status FROM [dbo].[borrow_records] WHERE status = 'overdue'";
            PreparedStatement prst = null;
            ResultSet rs = null;
            try {
                  if (cn == null) {
                        System.err.println("Cannot connect database.");
                        return records;
                  }
                  prst = cn.prepareStatement(sql);
                  prst.setDate(1, Date.valueOf(LocalDate.now()));
                  rs = prst.executeQuery();
                  while (rs.next()) {
                        records.add(mapRowToBorrowRecord(rs));
                  }
            } catch (SQLException e) {
                  System.err.println("Error: " + e.getMessage());
                  e.printStackTrace();
            } finally {
                  try {
                        if (rs != null) {
                              rs.close();
                        }
                        if (prst != null) {
                              prst.close();
                        }
                  } catch (SQLException e) {
                        e.printStackTrace();
                  }
            }
            return records;
      }

      @Override
      public List<BorrowRecord> getBorrowRecordsByUserIdAndStatus(int userId, String status
      ) {
            List<BorrowRecord> records = new ArrayList<>();
            String sql = "SELECT id, userId, bookId, borrowDate, dueDate, returnDate, status FROM [dbo].[borrow_records] WHERE userId = ? AND status = ?";
            PreparedStatement prst = null;
            ResultSet rs = null;
            try {
                  if (cn == null) {
                        System.err.println("Cannot connect database.");
                        return records;
                  }
                  prst = cn.prepareStatement(sql);
                  prst.setInt(1, userId);
                  prst.setString(2, status);
                  rs = prst.executeQuery();
                  while (rs.next()) {
                        records.add(mapRowToBorrowRecord(rs));
                  }
            } catch (SQLException e) {
                  System.err.println("Error: " + e.getMessage());
                  e.printStackTrace();
            } finally {
                  try {
                        if (rs != null) {
                              rs.close();
                        }
                        if (prst != null) {
                              prst.close();
                        }
                  } catch (SQLException e) {
                        e.printStackTrace();
                  }
            }
            return records;
      }

      @Override
      public void delete(int id) throws Exception {
            PreparedStatement pst = null;
            try {
                  if (cn == null) {
                        System.err.println("Cannot connect database.");
                        return;
                  }

                  String sql = "DELETE FROM [dbo].[borrow_records] WHERE id = ?";
                  pst = cn.prepareStatement(sql);
                  pst.setInt(1, id);

                  int rowsDeleted = pst.executeUpdate();
                  if (rowsDeleted > 0) {
                        System.out.println("Request deleted successfully (ID: " + id + ")!");
                  } else {
                        System.out.println("No book request found to delete (ID: " + id + ").");
                  }
            } catch (SQLException e) {
                  System.err.println("Error delete: " + e.getMessage());
                  e.printStackTrace();
                  throw e;
            } finally {
                  try {
                        if (pst != null) {
                              pst.close();
                        }
                  } catch (SQLException e) {
                        e.printStackTrace();
                  }
            }
      }

      @Override
      public void save(BorrowRecord borrowRecord) throws SQLException { 
            PreparedStatement prst = null;
            String sql = "INSERT INTO [dbo].[borrow_records] (userId, bookId, borrowDate, dueDate, returnDate, status) VALUES (?, ?, ?, ?, ?, ?)";

            try {
                  if (cn == null) {
                        System.err.println("Cannot connect database");
                        throw new SQLException("Connection is null, cannot save borrow record.");
                  }
                  if (borrowRecord == null) {
                        throw new IllegalArgumentException("BorrowRecord cannot null.");
                  }

                  prst = cn.prepareStatement(sql);

                  prst.setInt(1, borrowRecord.getUserId());
                  prst.setInt(2, borrowRecord.getBookId());

                  // Xử lý borrowDate
                  if (borrowRecord.getBorrowDate() != null) {
                        prst.setDate(3, Date.valueOf(borrowRecord.getBorrowDate()));
                  } else {
                        
                        prst.setDate(3, Date.valueOf(LocalDate.now()));
                        System.err.println("Warning: BorrowDate not supply, using time now.");
                  }

                  if (borrowRecord.getDueDate() != null) {
                        prst.setDate(4, Date.valueOf(borrowRecord.getDueDate()));
                  } else {
                        throw new IllegalArgumentException("DueDate cannot empty.");
                  }

                  if (borrowRecord.getReturnDate() != null) {
                        prst.setDate(5, Date.valueOf(borrowRecord.getReturnDate()));
                  } else {
                        prst.setNull(5, java.sql.Types.DATE);
                  }

                  if (borrowRecord.getStatus() != null && !borrowRecord.getStatus().trim().isEmpty()) {
                        prst.setString(6, borrowRecord.getStatus());
                  } else {
                        prst.setString(6, "borrowed"); 
                        System.err.println("Warning: Status not supply, set default 'borrowed'.");
                  }

                  int rowsInserted = prst.executeUpdate();
                  if (rowsInserted > 0) {
                        System.err.println("Save successfully!");
                  } else {
                         throw new SQLException("Save fail.");
                  }
            } catch (SQLException e) {
                  System.err.println("Error: " + e.getMessage());
                  e.printStackTrace();
                  throw e; 
            } catch (IllegalArgumentException e) {
                  System.err.println("Error: " + e.getMessage());
                  e.printStackTrace();
                  throw e;
            } finally {
                  try {
                        if (prst != null) {
                              prst.close();
                        }
                  } catch (SQLException e) {
                        System.err.println("Lỗi khi đóng PreparedStatement trong BorrowRecordDAO (save): " + e.getMessage());
                        e.printStackTrace();
                  }
            }
      }

      private BorrowRecord mapRowToBorrowRecord(ResultSet rs) throws SQLException {
            BorrowRecord record = new BorrowRecord();
            record.setId(rs.getInt("id"));
            record.setUserId(rs.getInt("userId"));
            record.setBookId(rs.getInt("bookId"));
            record.setBorrowDate(rs.getDate("borrowDate").toLocalDate());
            record.setDueDate(rs.getDate("dueDate").toLocalDate());
            record.setReturnDate(rs.getDate("returnDate").toLocalDate());
            record.setStatus(rs.getString("status"));
            return record;
      }

}
