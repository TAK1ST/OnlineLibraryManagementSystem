/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.implement;

import dao.interfaces.IBorrowRecordDAO;
import entity.BorrowRecord;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import util.DBConnection;

/**
 *
 * @author asus
 */
public class BorrowRecordDAO implements IBorrowRecordDAO {

      @Override
      public List<BorrowRecord> getAll() {
            List<BorrowRecord> records = new ArrayList<>();
            String sql = "select [id],[user_id],[book_id],[borrow_date], [due_date],[return_date],[status] from [dbo].[borrow_records]";
            PreparedStatement prst = null;
            ResultSet rs = null;
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();

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
      public List<BorrowRecord> getBorrowRecordsByUserId(int userId) {
            List<BorrowRecord> records = new ArrayList<>();
            String sql = "select [id],[user_id],[book_id],[borrow_date], [due_date],[return_date],[status] from [dbo].[borrow_records] WHERE user_id = ?";
            PreparedStatement prst = null;
            ResultSet rs = null;
            Connection cn = null;

            try {
                  cn = DBConnection.getConnection();
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
            } catch (Exception e) {
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
      public List<BorrowRecord> getBorrowRecordsByBookId(int bookId) {
            List<BorrowRecord> records = new ArrayList<>();
            String sql = "select [id],[user_id],[book_id],[borrow_date], [due_date],[return_date],[status] from [dbo].[borrow_records] WHERE book_id = ?";
            PreparedStatement prst = null;
            ResultSet rs = null;
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
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
            } catch (Exception e) {
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
      public boolean updateReturnStatus(int id, LocalDate returnDate, String status) {
            String sql = "UPDATE [dbo].[borrow_records] "
                    + "SET return_date = ?, status = ? "
                    + "WHERE id = ?";
            PreparedStatement prst = null;
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
                  if (cn == null) {
                        System.err.println("Cannot connect database.");
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
            } catch (Exception e) {
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
            String sql = "select [id],[user_id],[book_id],[borrow_date], [due_date],[return_date],[status] from [dbo].[borrow_records] "
                    + "WHERE return_date IS NULL AND (status = 'borrowed' OR status = 'overdue')";

            PreparedStatement prst = null;
            ResultSet rs = null;
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();

                  if (cn == null) {
                        System.err.println("Cannot connect database.");
                        return records;
                  }
                  prst = cn.prepareStatement(sql);
                  rs = prst.executeQuery();
                  while (rs.next()) {
                        records.add(mapRowToBorrowRecord(rs));
                  }
            } catch (Exception e) {
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
            String sql = "select [id],[user_id],[book_id],[borrow_date], [due_date],[return_date],[status] from [dbo].[borrow_records] "
                    + "WHERE status = 'overdue'";
            PreparedStatement prst = null;
            ResultSet rs = null;
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
                  if (cn == null) {
                        System.err.println("Cannot connect database.");
                        return records;
                  }
                  prst = cn.prepareStatement(sql);
                  
                  rs = prst.executeQuery();
                  while (rs.next()) {
                        records.add(mapRowToBorrowRecord(rs));
                  }
            } catch (Exception e) {
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

      public int[] getBookBorrowMonthlyTotal() {
            Connection cn = null;
            String sql = "SELECT MONTH(borrow_date) AS month, COUNT(*) AS total "
                    + "FROM borrow_records "
                    + "GROUP BY MONTH(borrow_date)";

            int[] ls = new int[12];
            try {
                  cn = DBConnection.getConnection();
                  PreparedStatement pr = cn.prepareStatement(sql);
                  ResultSet rs = pr.executeQuery();
                  while (rs.next()) {
                        int month = rs.getInt("month");
                        int total = rs.getInt("total");
                        ls[month - 1] = total;
                  }
            } catch (Exception e) {
            } finally {
                  try {
                        if (cn != null) {
                              cn.close();
                        }
                  } catch (Exception e) {
                        e.printStackTrace();
                  }
            }
            return ls;
      }

      @Override
      public void delete(int id) throws Exception {
            PreparedStatement pst = null;
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
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
            } catch (Exception e) {
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

      public int countUniqueUsersBorrowedThisWeek() {
            int uniqueUserCount = 0;

            LocalDate today = LocalDate.now();


            LocalDate startOfWeek = today.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));

            String sql = "SELECT COUNT(DISTINCT user_id) FROM [dbo].[borrow_records] WHERE borrow_date BETWEEN ? AND ?";

            Connection cn = null;
            PreparedStatement prst = null;
            ResultSet rs = null;

            try {
                  cn = DBConnection.getConnection();
                  if (cn == null) {
                        System.err.println("Cannot connect database.");
                        return 0;
                  }

                  prst = cn.prepareStatement(sql);
                  prst.setDate(1, Date.valueOf(startOfWeek));
                  prst.setDate(2, Date.valueOf(today));
                  rs = prst.executeQuery();
                  if (rs.next()) {
                        uniqueUserCount = rs.getInt(1);
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            } finally {
                  try {
                        if (rs != null) {
                              rs.close();
                        }
                  } catch (Exception e) {
                        e.printStackTrace();
                  }
                  try {
                        if (prst != null) {
                              prst.close();
                        }
                  } catch (Exception e) {
                        e.printStackTrace();
                  }
                  try {
                        if (cn != null) {
                              cn.close();
                        }
                  } catch (Exception e) {
                        e.printStackTrace();
                  }
            }
            return uniqueUserCount;
      }

      @Override
      public void save(BorrowRecord borrowRecord) throws SQLException {
            PreparedStatement prst = null;
            String sql = "INSERT INTO [dbo].[borrow_records] ([user_id],[book_id],[borrow_date], [due_date],[return_date],[status]) VALUES (?, ?, ?, ?, ?, ?)";

            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
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
            } catch (Exception e) {
                  System.err.println("Error: " + e.getMessage());
                  e.printStackTrace();
            } finally {
                  try {
                        if (prst != null) {
                              prst.close();
                        }
                  } catch (SQLException e) {
                        System.err.println("Error: " + e.getMessage());
                        e.printStackTrace();
                  }
            }
      }

      private BorrowRecord mapRowToBorrowRecord(ResultSet rs) throws SQLException {
            BorrowRecord record = new BorrowRecord();
            record.setId(rs.getInt("id"));
            record.setUserId(rs.getInt("user_id"));
            record.setBookId(rs.getInt("book_id"));
            record.setBorrowDate(rs.getDate("borrow_date").toLocalDate());
            record.setDueDate(rs.getDate("due_date").toLocalDate());
            Date returnDate = rs.getDate("return_date");
            if (returnDate != null) {
                  record.setReturnDate(returnDate.toLocalDate());
            } else {
                  record.setReturnDate(null);
            }

            record.setStatus(rs.getString("status"));
            return record;
      }

      @Override
      public Optional<BorrowRecord> getBorrowRecordByRequestId(int requestId) {
            String sql = "SELECT * FROM borrow_records WHERE request_id = ?";
            Connection cn = null;
            PreparedStatement pr = null;
            try {
                  cn = DBConnection.getConnection();
                  pr = cn.prepareStatement(sql);
                  pr.setInt(1, requestId);
                  ResultSet rs = pr.executeQuery();
                  if (rs.next()) {
                        return Optional.of(mapRowToBorrowRecord(rs));
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            }
            return Optional.empty();
      }

      @Override
      public List<BorrowRecord> getBorrowRecordsByUserIdAndBookId(int userId, int bookId) {
            List<BorrowRecord> records = new ArrayList<>();
            Connection cn = null;
            PreparedStatement pr = null;
            String sql = "SELECT [id],[user_id],[book_id],[borrow_date],[due_date],[return_date],[status] FROM [dbo].[borrow_records] WHERE user_id = ? AND book_id = ?";
            try {
                  cn = DBConnection.getConnection();
                  pr = cn.prepareStatement(sql);
                  if (cn == null) {
                        System.err.println("Cannot connect database.");
                        return records;
                  }
                  pr.setInt(1, userId);
                  pr.setInt(2, bookId);
                  try ( ResultSet rs = pr.executeQuery()) {
                        while (rs.next()) {
                              records.add(mapRowToBorrowRecord(rs));
                        }
                  }
            } catch (Exception e) {
                  System.err.println("Error: " + e.getMessage());
                  e.printStackTrace();
            }
            return records;
      }
}
