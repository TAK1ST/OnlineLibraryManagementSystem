/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.implement;

import dao.interfaces.IBookDAO;
import dto.BorrowedBookDTO;
import entity.Book;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import util.DBConnection;

/**
 * @author Admin
 */
public class BookDAO implements IBookDAO {
      // Lấy sách theo tiêu đề

      @Override
      public ArrayList<Book> getBookByTitle(String title) {
            ArrayList<Book> result = new ArrayList<>();
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
                  String sql = "select [id],[title],[isbn],[author],[category],[published_year],"
                          + "[total_copies],[available_copies],[status], [image_url] "
                          + "from [dbo].[books] "
                          + "where title like ?";
                  PreparedStatement st = cn.prepareStatement(sql);
                  st.setString(1, "%" + title + "%");
                  ResultSet table = st.executeQuery();
                  while (table.next()) {
                        int id = table.getInt("id");
                        String t = table.getString("title");
                        String isbn = table.getString("isbn");
                        String author = table.getString("author");
                        String category = table.getString("category");
                        int year = table.getInt("published_year");
                        int total = table.getInt("total_copies");
                        int avaCopies = table.getInt("available_copies");
                        String status = table.getString("status");
                        String imageUrl = table.getString("image_url");
                        Book book = new Book(id, t, isbn, author, category, year, total, avaCopies, status, imageUrl);
                        result.add(book);
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            } finally {
                  if (cn != null) {
                        try {
                              cn.close();
                        } catch (SQLException e) {
                              e.printStackTrace();
                        }
                  }
            }
            return result;
      }

      // Lấy tất cả sách
      @Override
      public List<Book> getAllBook() {
            List<Book> books = new ArrayList<>();
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
                  String sql = "SELECT [id],[title],[isbn],[author],[category],[published_year],"
                          + "[total_copies],[available_copies],[status] "
                          + "FROM [dbo].[books]";
                  PreparedStatement st = cn.prepareStatement(sql);
                  ResultSet rs = st.executeQuery();
                  while (rs.next()) {
                        Book book = new Book();
                        book.setId(rs.getInt("id"));
                        book.setTitle(rs.getString("title"));
                        book.setIsbn(rs.getString("isbn"));
                        book.setAuthor(rs.getString("author"));
                        book.setCategory(rs.getString("category"));
                        book.setPublishedYear(rs.getInt("published_year"));
                        book.setTotalCopies(rs.getInt("total_copies"));
                        book.setAvailableCopies(rs.getInt("available_copies"));
                        book.setStatus(rs.getString("status"));
                        books.add(book);
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            } finally {
                  if (cn != null) {
                        try {
                              cn.close();
                        } catch (Exception e) {
                              e.printStackTrace();
                        }
                  }
            }
            return books;
      }

      public List<Book> getNewBooks(int limit) throws SQLException, ClassNotFoundException {
            List<Book> newBooks = new ArrayList<>();
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
                  String sql = "SELECT TOP ? [id],[title],[isbn],[author],[category],[published_year],"
                          + "[total_copies],[available_copies],[status]\n"
                          + "FROM [dbo].[books]\n"
                          + "ORDER BY [published_year] DESC, [id] DESC";

                  PreparedStatement st = cn.prepareStatement(sql);
                  st.setInt(1, limit);
                  ResultSet rs = st.executeQuery();

                  while (rs.next()) {
                        Book book = new Book();
                        book.setId(rs.getInt("id"));
                        book.setTitle(rs.getString("title"));
                        book.setIsbn(rs.getString("isbn"));
                        book.setAuthor(rs.getString("author"));
                        book.setCategory(rs.getString("category"));
                        book.setPublishedYear(rs.getInt("published_year"));
                        book.setTotalCopies(rs.getInt("total_copies"));
                        book.setAvailableCopies(rs.getInt("available_copies"));
                        book.setStatus(rs.getString("status"));
                        newBooks.add(book);
                  }
            } finally {
                  if (cn != null) {
                        cn.close();
                  }
            }
            return newBooks;
      }

      @Override
      public List<Book> getNewBooks() throws SQLException, ClassNotFoundException {
            List<Book> newBooks = new ArrayList<>();
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
                  String sql = "SELECT TOP 4 [id],[title],[isbn],[author],[category],[published_year],"
                          + "[total_copies],[available_copies],[status] "
                          + "FROM [dbo].[books] "
                          + "ORDER BY [published_year] DESC, [id] DESC";
                  PreparedStatement st = cn.prepareStatement(sql);
                  ResultSet rs = st.executeQuery();
                  while (rs.next()) {
                        Book book = new Book();
                        book.setId(rs.getInt("id"));
                        book.setTitle(rs.getString("title"));
                        book.setIsbn(rs.getString("isbn"));
                        book.setAuthor(rs.getString("author"));
                        book.setCategory(rs.getString("category"));
                        book.setPublishedYear(rs.getInt("published_year"));
                        book.setTotalCopies(rs.getInt("total_copies"));
                        book.setAvailableCopies(rs.getInt("available_copies"));
                        book.setStatus(rs.getString("status"));
                        newBooks.add(book);
                  }
            } finally {
                  if (cn != null) {
                        cn.close();
                  }
            }
            return newBooks;
      }

      // Tìm kiếm sách động
      @Override
    public ArrayList<Book> searchBooks(String title, String author, String category) throws ClassNotFoundException, SQLException {
        ArrayList<Book> result = new ArrayList<>();
        Connection cn = null;
        PreparedStatement st = null;
        ResultSet table = null;

        try {
            cn = DBConnection.getConnection();
            StringBuilder sql = new StringBuilder(
                    "SELECT [id],[title],[isbn],[author],[category],[published_year],"
                    + "[total_copies],[available_copies],[status],[image_url] " 
                    + "FROM [dbo].[books] "
                    + "WHERE 1=1"
            );

            ArrayList<String> params = new ArrayList<>();

            System.out.println("=== SEARCH DEBUG ===");
            System.out.println("Title: '" + title + "'");
            System.out.println("Author: '" + author + "'");
            System.out.println("Category: '" + category + "'");

            if (title != null && !title.trim().isEmpty()) {
                sql.append(" AND title LIKE ?");
                params.add("%" + title.trim() + "%");
                System.out.println("Added title filter: %" + title.trim() + "%");
            }

            if (author != null && !author.trim().isEmpty()) {
                sql.append(" AND author LIKE ?");
                params.add("%" + author.trim() + "%");
                System.out.println("Added author filter: %" + author.trim() + "%");
            }

            if (category != null && !category.trim().isEmpty()) {
                sql.append(" AND category LIKE ?");
                params.add("%" + category.trim() + "%");
                System.out.println("Added category filter: %" + category.trim() + "%");
            }

            // Debug: In ra SQL query
            System.out.println("Final SQL: " + sql.toString());
            System.out.println("Parameters: " + params);

            st = cn.prepareStatement(sql.toString());

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                st.setString(i + 1, params.get(i));
            }

            table = st.executeQuery();

            // Debug: Đếm số kết quả
            int count = 0;
            while (table.next()) {
                count++;
                int id = table.getInt("id");
                String bookTitle = table.getString("title");
                String isbn = table.getString("isbn");
                String bookAuthor = table.getString("author");
                String bookCategory = table.getString("category");
                int year = table.getInt("published_year");
                int total = table.getInt("total_copies");
                int avaCopies = table.getInt("available_copies");
                String status = table.getString("status");
                String imageUrl = table.getString("image_url");

                Book book = new Book(id, bookTitle, isbn, bookAuthor, bookCategory, year, total, avaCopies, status, imageUrl);
                result.add(book);

                // Debug: In ra thông tin sách tìm được
                System.out.println("Found book: " + bookTitle + " by " + bookAuthor);
            }

            System.out.println("Total books found: " + count);
            System.out.println("=== END DEBUG ===");

        } catch (SQLException e) {
            System.err.println("SQL Error in searchBooks: " + e.getMessage());
            e.printStackTrace();
            throw e;
        } finally {
            // Đóng resources theo thứ tự ngược lại
            if (table != null) {
                try {
                    table.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (st != null) {
                try {
                    st.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (cn != null) {
                try {
                    cn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        return result;
    }

      // Lấy sách theo id
      @Override
      public Book getBookById(int id) {
            Book book = null;
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
                  String sql = "SELECT [id], [title], [isbn], [author], [category], [published_year],"
                          + "[total_copies], [available_copies], [status], [image_url] "
                          + "FROM [dbo].[books] "
                          + "WHERE id = ?";
                  PreparedStatement st = cn.prepareStatement(sql);
                  st.setInt(1, id);
                  ResultSet rs = st.executeQuery();
                  if (rs != null && rs.next()) {
                        String title = rs.getString("title");
                        String isbn = rs.getString("isbn");
                        String author = rs.getString("author");
                        String category = rs.getString("category");
                        int year = rs.getInt("published_year");
                        int total = rs.getInt("total_copies");
                        int available = rs.getInt("available_copies");
                        String status = rs.getString("status");
                        String imageUrl = rs.getString("image_url");
                        book = new Book(id, title, isbn, author, category, year, total, available, status, imageUrl);
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            } finally {
                  if (cn != null) {
                        try {
                              cn.close();
                        } catch (SQLException e) {
                              e.printStackTrace();
                        }
                  }
            }
            return book;
      }

      // Cập nhật tổng số lượng và số lượng còn lại (an toàn)
      public boolean updateTotalCopiesAlternative(int bookId, int totalCopies) {
            Connection conn = null;
            try {
                  conn = DBConnection.getConnection();
                  conn.setAutoCommit(false); // Bắt đầu transaction
                  String countQuery = "SELECT COUNT(*) FROM borrow_records WHERE book_id = ? AND status = 'borrowed'";
                  int borrowedCount = 0;
                  try ( PreparedStatement countStmt = conn.prepareStatement(countQuery)) {
                        countStmt.setInt(1, bookId);
                        ResultSet rs = countStmt.executeQuery();
                        if (rs.next()) {
                              borrowedCount = rs.getInt(1);
                        }
                  }
                  int availableCopies = totalCopies - borrowedCount;
                  if (availableCopies < 0) {
                        conn.rollback();
                        System.out.println("Error: Total copies (" + totalCopies + ") is less than borrowed books (" + borrowedCount + ")");
                        return false;
                  }
                  String updateQuery = "UPDATE books SET total_copies = ?, available_copies = ? WHERE id = ? AND status = 'active'";
                  try ( PreparedStatement updateStmt = conn.prepareStatement(updateQuery)) {
                        updateStmt.setInt(1, totalCopies);
                        updateStmt.setInt(2, availableCopies);
                        updateStmt.setInt(3, bookId);
                        int rowsAffected = updateStmt.executeUpdate();
                        if (rowsAffected > 0) {
                              conn.commit();
                              return true;
                        } else {
                              conn.rollback();
                              return false;
                        }
                  }
            } catch (SQLException | ClassNotFoundException e) {
                  try {
                        if (conn != null) {
                              conn.rollback();
                        }
                  } catch (SQLException rollbackEx) {
                        rollbackEx.printStackTrace();
                  }
                  e.printStackTrace();
                  return false;
            } finally {
                  try {
                        if (conn != null) {
                              conn.setAutoCommit(true);
                              conn.close();
                        }
                  } catch (SQLException e) {
                        e.printStackTrace();
                  }
            }
      }

      // Lấy tổng số sách
      @Override
      public int getTotalBooks() {
            Connection cn = null;
            int count = 0;
            try {
                  cn = DBConnection.getConnection();
                  if (cn != null) {
                        String sql = "select SUM([total_copies]) from [dbo].[books];";
                        Statement st = cn.createStatement();
                        ResultSet table = st.executeQuery(sql);
                        if (table.next()) {
                              count = table.getInt(1);
                        }
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
            return count;
      }
      
      // Tìm kiếm sách theo isbn
      public List<Book> searchByIsbn(String searchTerm) {
            List<Book> books = new ArrayList<>();
            String query = "SELECT * FROM books WHERE isbn LIKE ? AND status = 'active'";
            try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(query)) {
                  stmt.setString(1, "%" + searchTerm + "%");
                  ResultSet rs = stmt.executeQuery();
                  while (rs.next()) {
                        books.add(createBookFromResultSet(rs));
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            }
            return books;
      }

      // Tìm kiếm sách theo category
      public List<Book> searchByCategory(String searchTerm) {
            List<Book> books = new ArrayList<>();
            String query = "SELECT * FROM books WHERE category LIKE ? AND status = 'active'";
            try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(query)) {
                  stmt.setString(1, "%" + searchTerm + "%");
                  ResultSet rs = stmt.executeQuery();
                  while (rs.next()) {
                        books.add(createBookFromResultSet(rs));
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            }
            return books;
      }

      // Tìm kiếm sách theo author
      public List<Book> searchByAuthor(String searchTerm) {
            List<Book> books = new ArrayList<>();
            String query = "SELECT * FROM books WHERE author LIKE ? AND status = 'active'";
            try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(query)) {
                  stmt.setString(1, "%" + searchTerm + "%");
                  ResultSet rs = stmt.executeQuery();
                  while (rs.next()) {
                        books.add(createBookFromResultSet(rs));
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            }
            return books;
      }

      // Tìm kiếm sách theo title
      public List<Book> searchByTitle(String searchTerm) {
            List<Book> books = new ArrayList<>();
            String query = "SELECT * FROM books WHERE title LIKE ? AND status = 'active'";
            try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(query)) {
                  stmt.setString(1, "%" + searchTerm + "%");
                  ResultSet rs = stmt.executeQuery();
                  while (rs.next()) {
                        books.add(createBookFromResultSet(rs));
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            }
            return books;
      }

      // Cập nhật tổng số lượng và số lượng còn lại
      public boolean updateTotalCopies(int bookId, int totalCopies) {
            String query = "UPDATE books SET total_copies = ?, available_copies = ? - (SELECT COUNT(*) FROM borrow_records WHERE book_id = ? AND status = 'borrowed') WHERE id = ? AND status = 'active'";
            try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(query)) {
                  stmt.setInt(1, totalCopies);
                  stmt.setInt(2, totalCopies);
                  stmt.setInt(3, bookId);
                  stmt.setInt(4, bookId);
                  int rowsAffected = stmt.executeUpdate();
                  return rowsAffected > 0;
            } catch (Exception e) {
                  e.printStackTrace();
                  return false;
            }
      }

      // Cập nhật thông tin sách
      @Override
      public boolean update(Book book) {
            Connection cn = null;
            PreparedStatement pr = null;
            try {
                  cn = DBConnection.getConnection();
                  String sql = "UPDATE [dbo].[books] SET title = ?, isbn = ?, author = ?, category = ?, "
                          + "published_year = ?, total_copies = ?, available_copies = ?, status = ?, image_url = ? "
                          + "WHERE id = ?";
                  pr = cn.prepareStatement(sql);
                  pr.setString(1, book.getTitle());
                  pr.setString(2, book.getIsbn());
                  pr.setString(3, book.getAuthor());
                  pr.setString(4, book.getCategory());
                  pr.setInt(5, book.getPublishedYear());
                  pr.setInt(6, book.getTotalCopies());
                  pr.setInt(7, book.getAvailableCopies());
                  pr.setString(8, book.getStatus());
                  pr.setString(9, book.getImageUrl());
                  pr.setInt(10, book.getId());
                  int rowsAffected = pr.executeUpdate();
                  return rowsAffected > 0;
            } catch (Exception e) {
                  e.printStackTrace();
                  return false;
            } finally {
                  try {
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
      }

      // Tìm kiếm sách động theo searchTerm và searchBy
      @Override
      public List<Book> searchBooks(String searchTerm, String searchBy) throws SQLException, ClassNotFoundException {
            List<Book> books = new ArrayList<>();
            String sql = "SELECT * FROM books WHERE status = 'active' AND " + searchBy + " LIKE ?";
            try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
                  ps.setString(1, "%" + searchTerm + "%");
                  try ( ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                              books.add(createBookFromResultSet(rs));
                        }
                  }
            }
            return books;
      }

      // Cập nhật số lượng sách còn lại
      @Override
      public boolean updateBookQuantity(int bookId, int newQuantity) {
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
                  String sql = "UPDATE [dbo].[books] SET [available_copies] = ? WHERE [id] = ?";
                  PreparedStatement st = cn.prepareStatement(sql);
                  st.setInt(1, newQuantity);
                  st.setInt(2, bookId);
                  int rowsAffected = st.executeUpdate();
                  return rowsAffected > 0;
            } catch (Exception e) {
                  e.printStackTrace();
                  return false;
            } finally {
                  try {
                        if (cn != null) {
                              cn.close();
                        }
                  } catch (SQLException e) {
                        e.printStackTrace();
                  }
            }
      }

      // Lấy tổng số lượt mượn sách
      @Override
      public int getBorrowBooks() {
            Connection cn = null;
            int count = 0;
            try {
                  cn = DBConnection.getConnection();
                  if (cn != null) {
                        String sql = "SELECT COUNT([id]) FROM [dbo].[borrow_records]";
                        Statement st = cn.createStatement();
                        ResultSet table = st.executeQuery(sql);
                        if (table.next()) {
                              count = table.getInt(1);
                        }
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
            return count;
      }

      // Lấy tất cả sách kèm số lượng còn lại, sắp xếp theo available_copies giảm dần
      public List<Book> getAllBooksWithAvailability() throws SQLException {
            List<Book> books = new ArrayList<>();
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
                  String sql = "SELECT [id], [title], [isbn], [author], [category], [published_year], "
                          + "[total_copies], [available_copies], [status], [image_url] FROM [dbo].[books] "
                          + "ORDER BY available_copies DESC";
                  PreparedStatement st = cn.prepareStatement(sql);
                  ResultSet rs = st.executeQuery();
                  while (rs.next()) {
                        books.add(createBookFromResultSet(rs));
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            } finally {
                  if (cn != null) {
                        cn.close();
                  }
            }
            return books;
      }

      // Lấy tất cả category duy nhất
      public ArrayList<String> getAllCategories() throws SQLException {
            ArrayList<String> categories = new ArrayList<>();
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
                  String sql = "SELECT DISTINCT category FROM books ORDER BY category";
                  PreparedStatement st = cn.prepareStatement(sql);
                  ResultSet table = st.executeQuery();
                  while (table.next()) {
                        categories.add(table.getString("category"));
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            } finally {
                  if (cn != null) {
                        cn.close();
                  }
            }
            return categories;
      }

      // Helper tạo Book từ ResultSet
      private Book createBookFromResultSet(ResultSet rs) throws SQLException {
            Book book = new Book();
            book.setId(rs.getInt("id"));
            book.setTitle(rs.getString("title"));
            book.setAuthor(rs.getString("author"));
            book.setIsbn(rs.getString("isbn"));
            book.setCategory(rs.getString("category"));
            book.setPublishedYear(rs.getInt("published_year"));
            book.setTotalCopies(rs.getInt("total_copies"));
            book.setAvailableCopies(rs.getInt("available_copies"));
            book.setStatus(rs.getString("status"));
            book.setImageUrl(rs.getString("image_url"));
            return book;
      }

      // Lấy top 5 sách được mượn nhiều nhất
      public List<BorrowedBookDTO> getTop5BorrowedBooks() {
            List<BorrowedBookDTO> bookList = new ArrayList<>();
            String sql = "SELECT TOP 5 "
                    + "b.id, b.title AS book_name, b.author, "
                    + "COUNT(br.book_id) AS borrow_count "
                    + "FROM [dbo].[books] AS b "
                    + "LEFT JOIN [dbo].[borrow_records] AS br ON b.id = br.book_id "
                    + "GROUP BY b.id, b.title, b.author "
                    + "ORDER BY borrow_count DESC, b.title";
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
                  PreparedStatement pr = cn.prepareStatement(sql);
                  ResultSet rs = pr.executeQuery();
                  while (rs.next()) {
                        BorrowedBookDTO book = new BorrowedBookDTO();
                        book.setId(rs.getInt("id"));
                        book.setBookName(rs.getString("book_name"));
                        book.setAuthor(rs.getString("author"));
                        book.setBorrowCount(rs.getInt("borrow_count"));
                        bookList.add(book);
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            } finally {
                  if (cn != null) try {
                        cn.close();
                  } catch (Exception e) {
                        e.printStackTrace();
                  }
            }
            return bookList;
      }

      @Override
      public boolean updateBook(Book book) throws SQLException, ClassNotFoundException {
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
                  String sql = "UPDATE [dbo].[books] SET "
                          + "[title] = ?, "
                          + "[isbn] = ?, "
                          + "[author] = ?, "
                          + "[category] = ?, "
                          + "[published_year] = ?, "
                          + "[total_copies] = ?, "
                          + "[available_copies] = ?, "
                          + "[status] = ? "
                          + "WHERE [id] = ?";

                  PreparedStatement st = cn.prepareStatement(sql);
                  st.setString(1, book.getTitle());
                  st.setString(2, book.getIsbn());
                  st.setString(3, book.getAuthor());
                  st.setString(4, book.getCategory());
                  st.setInt(5, book.getPublishedYear());
                  st.setInt(6, book.getTotalCopies());
                  st.setInt(7, book.getAvailableCopies());
                  st.setString(8, book.getStatus());
                  st.setInt(9, book.getId());

                  int rowsAffected = st.executeUpdate();
                  return rowsAffected > 0;
            } finally {
                  if (cn != null && !cn.isClosed()) {
                        cn.close();
                  }
            }
      }
    public ArrayList<Book> search(String title, String author, String category) throws SQLException, ClassNotFoundException {
        ArrayList<Book> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();

        String sql = "SELECT * FROM books WHERE 1=1";

        if (title != null && !title.trim().isEmpty()) {
            sql += " AND title LIKE ?";
        }
        if (author != null && !author.trim().isEmpty()) {
            sql += " AND author LIKE ?";
        }
        if (category != null && !category.trim().isEmpty()) {
            sql += " AND category LIKE ?";
        }

        PreparedStatement stmt = conn.prepareStatement(sql);

        int index = 1;
        if (title != null && !title.trim().isEmpty()) {
            stmt.setString(index++, "%" + title + "%");
        }
        if (author != null && !author.trim().isEmpty()) {
            stmt.setString(index++, "%" + author + "%");
        }
        if (category != null && !category.trim().isEmpty()) {
            stmt.setString(index++, "%" + category + "%");
        }

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            Book b = new Book();
            b.setId(rs.getInt("id"));
            b.setTitle(rs.getString("title"));
            b.setAuthor(rs.getString("author"));
            b.setCategory(rs.getString("category"));
            list.add(b);
        }

        rs.close();
        stmt.close();
        conn.close();

        return list;
    }
    
    

}
