/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.implement;

import dao.interfaces.IBookRequestDAO;
import entity.BookRequest;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 *
 * @author asus
 */
public class BookRequestDAO implements IBookRequestDAO {

      private final Connection cn;

      public BookRequestDAO(Connection cn) {
            this.cn = cn;
      }

      @Override
      public List<BookRequest> getAll() {
            List<BookRequest> requests = new ArrayList<>();
            String sql = "SELECT id, userId, bookId, requestDate, status FROM [dbo].[book_requests]";
            PreparedStatement prst = null;
            ResultSet rs = null;
            try {
                  if (cn == null) {
                        System.err.println("Error: cannot connect database.");
                        return requests;
                  }
                  prst = cn.prepareStatement(sql);
                  rs = prst.executeQuery();
                  while (rs.next()) {
                        requests.add(mapRowToBookRequest(rs));
                  }
            } catch (SQLException e) {
                  System.err.println("Lỗi BookRequestDAO (getAll): " + e.getMessage());
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
            return requests;
      }

      @Override
      public void save(BookRequest bookRequest) throws Exception {
            PreparedStatement prst = null;

            try {
                  if (cn == null) {
                        System.out.println("Cannot connect to database");
                        return;
                  }

                  String sql = "INSERT INTO [dbo].[book_requests] (userId, bookId, requestDate, status) VALUE (?, ?, ?, 'pending')";
                  prst = cn.prepareStatement(sql);
                  prst.setInt(1, bookRequest.getUserId());
                  prst.setInt(2, bookRequest.getBookId());
                  prst.setDate(3, Date.valueOf(bookRequest.getRequestDate()));
                  prst.setString(4, bookRequest.getStatus());

                  int rowsInserted = prst.executeUpdate();
                  if (rowsInserted > 0) {
                        System.out.println("User saved successfully!");
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            } finally {
                  try {
                        if (prst != null) {
                              prst.close();
                        }
                        if (cn != null) {
                              cn.close();
                        }
                  } catch (Exception e) {
                        e.printStackTrace();
                  }
            }

      }

      @Override
      public void delete(int id) throws Exception {
            PreparedStatement pst = null;
            try {
                  if (cn == null) {
                        System.err.println("Cannot connect database.");
                        return;
                  }

                  String sql = "DELETE FROM [dbo].[book_requests] WHERE id = ?";
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
      public Optional<BookRequest> getBookRequestById(int id) {
            String sql = "SELECT id, userId, bookId, requestDate, status FROM [dbo].[book_requests] WHERE id = ?";
            PreparedStatement prst = null;
            ResultSet rs = null;
            try {
                  if (cn == null) {
                        System.err.println("Cannot connect  database.");
                        return Optional.empty();
                  }
                  prst = cn.prepareStatement(sql);
                  prst.setInt(1, id);
                  rs = prst.executeQuery();
                  if (rs.next()) {
                        return Optional.of(mapRowToBookRequest(rs));
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
      public List<BookRequest> getBookRequestsByUserId(int userId) {
            List<BookRequest> requests = new ArrayList<>();
            String sql = "SELECT id, userId, bookId, requestDate, status FROM [dbo].[book_requests] WHERE userId = ?";
            PreparedStatement prst = null;
            ResultSet rs = null;
            try {
                  if (cn == null) {
                        System.err.println("Cannot connect database.");
                        return requests;
                  }
                  prst = cn.prepareStatement(sql);
                  prst.setInt(1, userId);
                  rs = prst.executeQuery();
                  while (rs.next()) {
                        requests.add(mapRowToBookRequest(rs));
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
            return requests;
      }

      @Override
      public boolean updateBookRequestStatus(int id, String newStatus) {
            String sql = "UPDATE [dbo].[book_requests] SET status = ? WHERE id = ?";
            PreparedStatement prst = null;
            try {
                  if (cn == null) {
                        System.err.println("Cannot connect database.");
                        return false;
                  }
                  prst = cn.prepareStatement(sql);
                  prst.setString(1, newStatus);
                  prst.setInt(2, id);
                  int rowsUpdated = prst.executeUpdate();
                  if (rowsUpdated > 0) {
                        System.out.println("Update book request status (ID: " + id + ") sucessfully.");
                        return true;
                  } else {
                        System.out.println("Book request not found (ID: " + id + ") to update or unchanged status.");
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
      public List<BookRequest> getAllPendingRequests() {
            List<BookRequest> requests = new ArrayList<>();
            String sql = "SELECT id, userId, bookId, requestDate, status FROM [dbo].[book_requests] WHERE status = 'pending'";
            PreparedStatement prst = null;
            ResultSet rs = null;
            try {
                  if (cn == null) {
                        System.err.println("Cannot connect database.");
                        return requests;
                  }
                  prst = cn.prepareStatement(sql);
                  rs = prst.executeQuery();
                  while (rs.next()) {
                        requests.add(mapRowToBookRequest(rs));
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
            return requests;
      }

      @Override
      public List<BookRequest> getBookRequestsByBookId(int bookId) {
            List<BookRequest> requests = new ArrayList<>();
            String sql = "SELECT id, userId, bookId, requestDate, status FROM [dbo].[book_requests] WHERE bookId = ?";
            PreparedStatement prst = null;
            ResultSet rs = null;
            try {
                  if (cn == null) {
                        System.err.println("Cannot connect database.");
                        return requests;
                  }
                  prst = cn.prepareStatement(sql);
                  prst.setInt(1, bookId);
                  rs = prst.executeQuery();
                  while (rs.next()) {
                        requests.add(mapRowToBookRequest(rs));
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
            return requests;
      }

// Helper
      private BookRequest mapRowToBookRequest(ResultSet rs) throws SQLException {
            BookRequest request = new BookRequest();
            request.setId(rs.getInt("id"));
            request.setUserId(rs.getInt("userId"));
            request.setBookId(rs.getInt("bookId"));
            request.setRequestDate(rs.getDate("requestDate").toLocalDate());
            return request;
      }
}
