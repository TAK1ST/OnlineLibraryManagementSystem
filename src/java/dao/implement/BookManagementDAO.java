/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.implement;

import entity.Book;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import util.DBConnection;

/**
 *
 * @author asus
 */
public class BookManagementDAO {

      public List<Book> getBooks(int page, int size, String titleFilter,
              String authorFilter, String categoryFilter, String statusFilter)
              throws SQLException {
            List<Book> books = new ArrayList<>();
            StringBuilder sql = new StringBuilder(
                    "SELECT id, title, author, isbn, category, published_year, "
                    + "total_copies, available_copies, image_url, status FROM books WHERE 1=1"
            );

            // Add filters
            if (titleFilter != null && !titleFilter.trim().isEmpty()) {
                  sql.append(" AND title LIKE ?");
            }
            if (authorFilter != null && !authorFilter.trim().isEmpty()) {
                  sql.append(" AND author LIKE ?");
            }
            if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
                  sql.append(" AND category = ?");
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                  sql.append(" AND status = ?");
            }

            sql.append(" ORDER BY title ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

            try ( Connection cn = DBConnection.getConnection();  PreparedStatement stmt = cn.prepareStatement(sql.toString())) {

                  int paramIndex = 1;

                  if (titleFilter != null && !titleFilter.trim().isEmpty()) {
                        stmt.setString(paramIndex++, "%" + titleFilter + "%");
                  }
                  if (authorFilter != null && !authorFilter.trim().isEmpty()) {
                        stmt.setString(paramIndex++, "%" + authorFilter + "%");
                  }
                  if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
                        stmt.setString(paramIndex++, categoryFilter);
                  }
                  if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                        stmt.setString(paramIndex++, statusFilter);
                  }

                  stmt.setInt(paramIndex++, (page - 1) * size);
                  stmt.setInt(paramIndex, size);

                  ResultSet rs = stmt.executeQuery();
                  while (rs.next()) {
                        books.add(mapResultSetToBook(rs));
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            }

            return books;
      }

      public int getTotalBooksCount(String titleFilter, String authorFilter,
              String categoryFilter, String statusFilter) throws SQLException {
            StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM books WHERE 1=1");

            // Add filters
            if (titleFilter != null && !titleFilter.trim().isEmpty()) {
                  sql.append(" AND title LIKE ?");
            }
            if (authorFilter != null && !authorFilter.trim().isEmpty()) {
                  sql.append(" AND author LIKE ?");
            }
            if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
                  sql.append(" AND category = ?");
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                  sql.append(" AND status = ?");
            }

            try ( Connection cn = DBConnection.getConnection();  PreparedStatement stmt = cn.prepareStatement(sql.toString())) {

                  int paramIndex = 1;

                  if (titleFilter != null && !titleFilter.trim().isEmpty()) {
                        stmt.setString(paramIndex++, "%" + titleFilter + "%");
                  }
                  if (authorFilter != null && !authorFilter.trim().isEmpty()) {
                        stmt.setString(paramIndex++, "%" + authorFilter + "%");
                  }
                  if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
                        stmt.setString(paramIndex++, categoryFilter);
                  }
                  if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                        stmt.setString(paramIndex, statusFilter);
                  }

                  ResultSet rs = stmt.executeQuery();
                  if (rs.next()) {
                        return rs.getInt(1);
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            }

            return 0;
      }

      public Book getBookById(int bookId) throws SQLException {
            String sql = "SELECT id, title, author, isbn, category, published_year, "
                    + "total_copies, available_copies, image_url, status FROM books WHERE id = ?";

            try ( Connection cn = DBConnection.getConnection();  PreparedStatement stmt = cn.prepareStatement(sql)) {

                  stmt.setInt(1, bookId);
                  ResultSet rs = stmt.executeQuery();

                  if (rs.next()) {
                        return mapResultSetToBook(rs);
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            }

            return null;
      }

      public boolean softDeleteBook(int bookId) throws SQLException {
            String sql = "UPDATE books SET status = 'inactive' WHERE id = ?";
            boolean isSuccess = false;
            try ( Connection cn = DBConnection.getConnection();  PreparedStatement stmt = cn.prepareStatement(sql)) {

                  stmt.setInt(1, bookId);
                  if (stmt.executeUpdate() > 0) {
                        isSuccess = true;
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            }
            return isSuccess;
      }

      public boolean isBookCurrentlyBorrowed(int bookId) throws SQLException {
            String sql = "SELECT COUNT(*) FROM borrow_records WHERE book_id = ? AND status = 'borrowed'";

            try ( Connection cn = DBConnection.getConnection();  PreparedStatement stmt = cn.prepareStatement(sql)) {

                  stmt.setInt(1, bookId);
                  ResultSet rs = stmt.executeQuery();

                  if (rs.next()) {
                        return rs.getInt(1) > 0;
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            }

            return false;
      }

      public boolean updateBook(Book book) throws SQLException {
            String sql = "UPDATE books SET title = ?, author = ?, isbn = ?, category = ?, "
                    + "published_year = ?, total_copies = ?, available_copies = ?, "
                    + "image_url = ?, status = ? WHERE id = ?";
            boolean isSuccess = false;
            try ( Connection cn = DBConnection.getConnection();  PreparedStatement stmt = cn.prepareStatement(sql)) {

                  stmt.setString(1, book.getTitle());
                  stmt.setString(2, book.getAuthor());
                  stmt.setString(3, book.getIsbn());
                  stmt.setString(4, book.getCategory());
                  stmt.setInt(5, book.getPublishedYear());
                  stmt.setInt(6, book.getTotalCopies());
                  stmt.setInt(7, book.getAvailableCopies());
                  stmt.setString(8, book.getImageUrl());
                  stmt.setString(9, book.getStatus());
                  stmt.setInt(10, book.getId());

                  if (stmt.executeUpdate() > 0) {
                        isSuccess = true;
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            }
            return isSuccess;
      }

      public boolean addBook(Book book) throws SQLException {
            String sql = "INSERT INTO books (title, author, isbn, category, published_year, "
                    + "total_copies, available_copies, image_url, status) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            boolean isSuccess = false;
            try ( Connection cn = DBConnection.getConnection();  PreparedStatement stmt = cn.prepareStatement(sql)) {

                  stmt.setString(1, book.getTitle());
                  stmt.setString(2, book.getAuthor());
                  stmt.setString(3, book.getIsbn());
                  stmt.setString(4, book.getCategory());
                  stmt.setInt(5, book.getPublishedYear());
                  stmt.setInt(6, book.getTotalCopies());
                  stmt.setInt(7, book.getAvailableCopies());
                  stmt.setString(8, book.getImageUrl());
                  stmt.setString(9, book.getStatus());

                  if (stmt.executeUpdate() > 0) {
                        isSuccess = true;
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            }
            return isSuccess;
      }

      public List<String> getAvailableCategories() throws SQLException {
            List<String> categories = new ArrayList<>();
            String sql = "SELECT DISTINCT category FROM books WHERE category IS NOT NULL ORDER BY category";

            try ( Connection cn = DBConnection.getConnection();  PreparedStatement stmt = cn.prepareStatement(sql);  ResultSet rs = stmt.executeQuery()) {

                  while (rs.next()) {
                        categories.add(rs.getString("category"));
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            }

            return categories;
      }

      public List<String> getAvailableStatuses() throws SQLException {
            List<String> statuses = new ArrayList<>();
            String sql = "SELECT DISTINCT status FROM books WHERE status IS NOT NULL ORDER BY status";

            try ( Connection cn = DBConnection.getConnection();  PreparedStatement stmt = cn.prepareStatement(sql);  ResultSet rs = stmt.executeQuery()) {

                  while (rs.next()) {
                        statuses.add(rs.getString("status"));
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            }

            return statuses;
      }

      public boolean isIsbnExists(String isbn) throws SQLException {
            return isIsbnExists(isbn, -1);
      }

      public boolean isIsbnExists(String isbn, int excludeBookId) throws SQLException {
            String sql = "SELECT COUNT(*) FROM books WHERE isbn = ?";
            if (excludeBookId > 0) {
                  sql += " AND id != ?";
            }

            try ( Connection cn = DBConnection.getConnection();  PreparedStatement stmt = cn.prepareStatement(sql)) {

                  stmt.setString(1, isbn);
                  if (excludeBookId > 0) {
                        stmt.setInt(2, excludeBookId);
                  }

                  ResultSet rs = stmt.executeQuery();
                  if (rs.next()) {
                        return rs.getInt(1) > 0;
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            }
            return false;
      }

      public List<Book> getBooksByStatus(String status) throws SQLException {
            List<Book> books = new ArrayList<>();
            String sql = "SELECT id, title, author, isbn, category, published_year, "
                    + "total_copies, available_copies, image_url, status FROM books WHERE status = ?";

            try ( Connection cn = DBConnection.getConnection();  PreparedStatement stmt = cn.prepareStatement(sql)) {

                  stmt.setString(1, status);
                  ResultSet rs = stmt.executeQuery();

                  while (rs.next()) {
                        books.add(mapResultSetToBook(rs));
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            }

            return books;
      }

      public boolean restoreBook(int bookId) throws SQLException {
            String sql = "UPDATE books SET status = 'active' WHERE id = ?";
            boolean isSuccess = false;
            try ( Connection cn = DBConnection.getConnection();  PreparedStatement stmt = cn.prepareStatement(sql)) {
                  stmt.setInt(1, bookId);
                  if (stmt.executeUpdate() > 0) {
                        isSuccess = true;
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            }
            return isSuccess;
      }

      private Book mapResultSetToBook(ResultSet rs) throws SQLException {
            Book book = new Book();
            book.setId(rs.getInt("id"));
            book.setTitle(rs.getString("title"));
            book.setAuthor(rs.getString("author"));
            book.setIsbn(rs.getString("isbn"));
            book.setCategory(rs.getString("category"));
            book.setPublishedYear(rs.getInt("published_year"));
            book.setTotalCopies(rs.getInt("total_copies"));
            book.setAvailableCopies(rs.getInt("available_copies"));
            book.setImageUrl(rs.getString("image_url"));
            book.setStatus(rs.getString("status"));
            return book;
      }
}
