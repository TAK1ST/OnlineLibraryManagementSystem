/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.implement;

import static constant.constance.RECORDS_PER_LOAD;
import dao.interfaces.IBookRequestDAO;
import dto.BookInforRequestStatusDTO;
import entity.BookRequest;
import entity.User;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;
import util.DBConnection;

/**
 *
 * @author asus
 */
public class BookRequestDAO implements IBookRequestDAO {

      public BookRequestDAO() {
      }

      @Override
      public List<BookRequest> getAll() {
            List<BookRequest> requests = new ArrayList<>();
            String sql = "SELECT id, userId, bookId, requestDate, status FROM [dbo].[book_requests]";
            PreparedStatement prst = null;
            ResultSet rs = null;
            try {
                  Connection cn = DBConnection.getConnection();
                  if (cn == null) {
                        System.err.println("Error: cannot connect database.");
                        return requests;
                  }
                  prst = cn.prepareStatement(sql);
                  rs = prst.executeQuery();
                  while (rs.next()) {
                        requests.add(mapRowToBookRequest(rs));
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
            return requests;
      }

      @Override
      public void save(BookRequest bookRequest) throws Exception {
            PreparedStatement prst = null;
            Connection cn = DBConnection.getConnection();
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
                        System.out.println("Book saved successfully!");
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
            Connection cn = DBConnection.getConnection();
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
                  Connection cn = DBConnection.getConnection();
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
            return Optional.empty();
      }

      @Override
      public List<BookRequest> getBookRequestsByUserId(int userId) {
            List<BookRequest> requests = new ArrayList<>();
            String sql = "SELECT id, userId, bookId, requestDate, status FROM [dbo].[book_requests] WHERE userId = ?";
            PreparedStatement prst = null;
            ResultSet rs = null;

            try {
                  Connection cn = DBConnection.getConnection();
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
            return requests;
      }

      public List<BookInforRequestStatusDTO> getAllBookRequest() {
            List<BookInforRequestStatusDTO> ls = new ArrayList<>();
            Connection cn = null;
            ResultSet result = null;
            PreparedStatement prst = null;

            try {
                  cn = DBConnection.getConnection();
                  if (cn == null) {
                        System.err.println("Cannot connect to the database");
                        return ls; // return empty list
                  }

                  String sql = "SELECT b.id, b.title, b.isbn, b.available_copies, br.status "
                          + "FROM [dbo].[book_requests] br "
                          + "JOIN [dbo].[books] b ON br.book_id = b.id "
                          + "WHERE br.status IN ('approved', 'pending')";

                  prst = cn.prepareStatement(sql);
                  result = prst.executeQuery();

                  while (result.next()) {
                        BookInforRequestStatusDTO book = new BookInforRequestStatusDTO();
                        book.setId(result.getInt("id"));
                        book.setTitle(result.getString("title"));
                        book.setIsbn(result.getString("isbn"));
                        book.setAvailableCopies(result.getInt("available_copies"));
                        book.setStatusAction(result.getString("status"));
                        ls.add(book);
                  }

            } catch (Exception e) {
                  e.printStackTrace();
            } finally {
                  try {
                        if (result != null) {
                              result.close();
                        }
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
            return ls;
      }

      @Override
      public boolean updateBookRequestStatus(int id, String newStatus) {
            String sql = "UPDATE [dbo].[book_requests] SET status = ? WHERE id = ?";
            Connection cn = null;
            PreparedStatement prst = null;
            try {
                  cn = DBConnection.getConnection();
                  if (cn == null) {
                        System.err.println("Cannot connect database.");
                        return false;
                  }
                  prst = cn.prepareStatement(sql);
                  prst.setString(1, newStatus);
                  prst.setInt(2, id);
                  int rowsUpdated = prst.executeUpdate();
                  if (rowsUpdated > 0) {
                        System.err.println("Update book request status (ID: " + id + ") sucessfully.");
                        return true;
                  } else {
                        System.err.println("Book request not found (ID: " + id + ") to update or unchanged status.");
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
                  } catch (Exception e) {
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
                  Connection cn = DBConnection.getConnection();
                  if (cn == null) {
                        System.err.println("Cannot connect database.");
                        return requests;
                  }
                  prst = cn.prepareStatement(sql);
                  rs = prst.executeQuery();
                  while (rs.next()) {
                        requests.add(mapRowToBookRequest(rs));
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
            return requests;
      }

      @Override
      public List<BookRequest> getBookRequestsByBookId(int bookId) {
            List<BookRequest> requests = new ArrayList<>();
            String sql = "SELECT id, userId, bookId, requestDate, status FROM [dbo].[book_requests] WHERE bookId = ?";
            PreparedStatement prst = null;
            ResultSet rs = null;
            try {
                  Connection cn = DBConnection.getConnection();
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
            return requests;
      }

      public List<BookInforRequestStatusDTO> getBookRequestStatusBySearch(String isbn, String status, int offset) {
            List<BookInforRequestStatusDTO> list = new ArrayList<>();
            PreparedStatement pr = null;
            ResultSet rs = null;
            Connection cn = null;

            String sql = "SELECT b.id, b.title, b.isbn, b.available_copies, br.status "
                    + "FROM book_requests br "
                    + "JOIN books b ON br.book_id = b.id "
                    + "WHERE 1=1 "
                    + "AND (? IS NULL OR b.isbn LIKE ?) "
                    + "AND (? IS NULL OR br.status = ?) "
                    + "ORDER BY b.id "
                    + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

            try {
                  cn = DBConnection.getConnection();
                  if (cn != null) {
                        pr = cn.prepareStatement(sql);
                        int paramIndex = 1;

                        pr.setString(paramIndex++, (isbn == null || isbn.trim().isEmpty()) ? null : isbn);
                        pr.setString(paramIndex++, (isbn == null || isbn.trim().isEmpty()) ? null : "%" + isbn + "%");

                        pr.setString(paramIndex++, (status == null || status.trim().isEmpty()) ? null : status);
                        pr.setString(paramIndex++, (status == null || status.trim().isEmpty()) ? null : status);

                        pr.setInt(paramIndex++, offset);
                        pr.setInt(paramIndex, RECORDS_PER_LOAD);

                        rs = pr.executeQuery();

                        while (rs.next()) {
                              BookInforRequestStatusDTO book = new BookInforRequestStatusDTO();
                              book.setId(rs.getInt("id"));
                              book.setTitle(rs.getString("title"));
                              book.setIsbn(rs.getString("isbn"));
                              book.setAvailableCopies(rs.getInt("available_copies"));
                              book.setStatusAction(rs.getString("status"));
                              list.add(book);
                        }
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            } finally {
                  try {
                        if (rs != null) {
                              rs.close();
                        }
                        if (pr != null) {
                              pr.close();
                        }
                        if (cn != null) {
                              cn.close();
                        }
                  } catch (Exception e) {
                        e.printStackTrace();
                  }
            }

            return list;
      }

      public List<BookInforRequestStatusDTO> getBookRequestStatusLazyPageLoading(int offset) {
            List<BookInforRequestStatusDTO> list = new ArrayList<>();
            Connection cn = null;
            PreparedStatement pr = null;
            ResultSet rs = null;

            try {
                  cn = DBConnection.getConnection();
                  if (cn != null) {
                        String sql = "SELECT b.id, b.title, b.isbn, b.available_copies, br.status "
                                + "FROM book_requests br "
                                + "JOIN books b ON br.book_id = b.id "
                                + "ORDER BY b.id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
                        pr = cn.prepareStatement(sql);
                        pr.setInt(1, offset);
                        pr.setInt(2, RECORDS_PER_LOAD);

                        rs = pr.executeQuery();

                        while (rs.next()) {
                              BookInforRequestStatusDTO dto = new BookInforRequestStatusDTO();
                              dto.setId(rs.getInt("id"));
                              dto.setTitle(rs.getString("title"));
                              dto.setIsbn(rs.getString("isbn"));
                              dto.setAvailableCopies(rs.getInt("available_copies"));
                              dto.setStatusAction(rs.getString("status"));
                              list.add(dto);
                        }
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            } finally {
                  try {
                        if (rs != null) {
                              rs.close();
                        }
                        if (pr != null) {
                              pr.close();
                        }
                        if (cn != null) {
                              cn.close();
                        }
                  } catch (Exception e) {
                        e.printStackTrace();
                  }
            }
            return list;
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
