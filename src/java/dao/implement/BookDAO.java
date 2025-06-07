/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.implement;

import dao.interfaces.IBookDAO;
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

    //ham nay De lay tat ca quyen sach 
    @Override
    public ArrayList<Book> getBookByTitle(String title) {
        ArrayList<Book> result = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBConnection.getConnection();
            if (cn != null) {
                System.out.println("connect successfully");
            }

            String sql = "select [id],[title],[isbn],[author],[category],[published_year],"
                    + "[total_copies],[available_copies],[status]\n"
                    + "from [dbo].[books]\n"
                    + "where title like ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setString(1, "%" + title + "%");
            ResultSet table = st.executeQuery();
            if (table != null) {
                while (table.next()) {
                    int id = table.getInt("id");
                    title = table.getString("title");
                    String isbn = table.getString("isbn");
                    String author = table.getString("author");
                    String category = table.getString("category");
                    int year = table.getInt("published_year");
                    int total = table.getInt("total_copies");
                    int avaCopies = table.getInt("available_copies");
                    String status = table.getString("status");
                    Book book = new Book(id, title, isbn, author, category, year, total, avaCopies, status);
                    result.add(book);
                }
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
    
    public Book getBookById(int id) {
    Book book = null;
    Connection cn = null;
    try {
        cn = DBConnection.getConnection();
        if (cn != null) {
            System.out.println("Connect successfully");
        }

        String sql = "SELECT [id], [title], [isbn], [author], [category], [published_year],"
                   + "[total_copies], [available_copies], [status] "
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

            book = new Book(id, title, isbn, author, category, year, total, available, status);
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


    @Override
    public List<Book> getNewBooks() throws SQLException, ClassNotFoundException {
        List<Book> newBooks = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBConnection.getConnection();
            String sql = "SELECT TOP 4 [id],[title],[isbn],[author],[category],[published_year],"
                    + "[total_copies],[available_copies],[status]\n"
                    + "FROM [dbo].[books]\n"
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
        } catch (Exception ex) {
            Logger.getLogger(BookDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (cn != null) {
                cn.close();
            }
        }
        return newBooks;
    }

    public ArrayList<Book> getNewBooks(int limit) throws ClassNotFoundException, SQLException, Exception {
        ArrayList<Book> result = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBConnection.getConnection();
            String sql = "SELECT TOP (?) [id],[title],[isbn],[author],[category],[published_year],"
                    + "[total_copies],[available_copies],[status]\n"
                    + "FROM [dbo].[books]\n"
                    + "WHERE [status] = 'active'\n"
                    + "ORDER BY [id] DESC";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, limit);
            ResultSet table = st.executeQuery();
            if (table != null) {
                while (table.next()) {
                    int id = table.getInt("id");
                    String title = table.getString("title");
                    String isbn = table.getString("isbn");
                    String author = table.getString("author");
                    String category = table.getString("category");
                    int year = table.getInt("published_year");
                    int total = table.getInt("total_copies");
                    int avaCopies = table.getInt("available_copies");
                    String status = table.getString("status");
                    Book book = new Book(id, title, isbn, author, category, year, total, avaCopies, status);
                    result.add(book);
                }
            }
        } finally {
            if (cn != null) {
                cn.close();
            }
        }
        return result;
    }

    @Override
    public List<Book> getAllBook() throws SQLException, ClassNotFoundException {
        List<Book> books = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBConnection.getConnection();
            String sql = "SELECT [id],[title],[isbn],[author],[category],[published_year],"
                    + "[total_copies],[available_copies],[status]\n"
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
        } catch (Exception ex) {
            Logger.getLogger(BookDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (cn != null) {
                cn.close();
            }
        }
        return books;
    }

    @Override
    public List<Book> searchBooks(String searchTerm, String searchBy) throws SQLException, ClassNotFoundException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE status = 'active' AND " + searchBy + " LIKE ?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + searchTerm + "%");

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(extractBookFromResultSet(rs));
                }
            }
        } catch (Exception ex) {
            Logger.getLogger(BookDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return books;
    }

    public List<Book> getAllBooksWithAvailability() throws SQLException, Exception {
        List<Book> books = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBConnection.getConnection();
            if (cn != null) {
                String sql = "SELECT [id], [title], [isbn], [author], [category], [published_year], "
                        + "[total_copies], [available_copies], [status] FROM [dbo].[books] "
                        + "ORDER BY available_copies DESC";

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
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (cn != null && !cn.isClosed()) {
                cn.close();
            }
        }
        return books;
    }

    public ArrayList<Book> getBooksByCategory(String category) throws ClassNotFoundException, Exception {
        ArrayList<Book> result = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBConnection.getConnection();
            String sql = "select [id],[title],[isbn],[author],[category],[published_year],[total_copies],"
                    + "[available_copies],[status]\n"
                    + "from [dbo].[books]\n"
                    + "where category like ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setString(1, "%" + category + "%");
            ResultSet table = st.executeQuery();
            if (table != null) {
                while (table.next()) {
                    int id = table.getInt("id");
                    String title = table.getString("title");
                    String isbn = table.getString("isbn");
                    String author = table.getString("author");
                    category = table.getString("category");
                    int year = table.getInt("published_year");
                    int total = table.getInt("total_copies");
                    int avaCopies = table.getInt("available_copies");
                    String status = table.getString("status");
                    Book book = new Book(id, title, isbn, author, category, year, total, avaCopies, status);
                    result.add(book);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return result;
    }

    public ArrayList<Book> getBooksByAuthor(String author) throws ClassNotFoundException, Exception {
        ArrayList<Book> result = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBConnection.getConnection();
            String sql = "select [id],[title],[isbn],[author],[category],[published_year],[total_copies],"
                    + "[available_copies],[status]\n"
                    + "from [dbo].[books]\n"
                    + "where author like ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setString(1, "%" + author + "%");
            ResultSet table = st.executeQuery();
            if (table != null) {
                while (table.next()) {
                    int id = table.getInt("id");
                    String title = table.getString("title");
                    String isbn = table.getString("isbn");
                    author = table.getString("author");
                    String category = table.getString("category");
                    int year = table.getInt("published_year");
                    int total = table.getInt("total_copies");
                    int avaCopies = table.getInt("available_copies");
                    String status = table.getString("status");
                    Book book = new Book(id, title, isbn, author, category, year, total, avaCopies, status);
                    result.add(book);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return result;
    }

    public ArrayList<String> getAllCategories() throws ClassNotFoundException, Exception {
        ArrayList<String> categories = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBConnection.getConnection();
            String sql = "SELECT DISTINCT category FROM books ORDER BY category";
            PreparedStatement st = cn.prepareStatement(sql);
            ResultSet table = st.executeQuery();
            if (table != null) {
                while (table.next()) {
                    categories.add(table.getString("category"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return categories;
    }

    public ArrayList<Book> searchBooks(String title, String author, String category) throws ClassNotFoundException, SQLException, Exception {
        ArrayList<Book> result = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBConnection.getConnection();
            StringBuilder sql = new StringBuilder(
                    "SELECT [id],[title],[isbn],[author],[category],[published_year],"
                    + "[total_copies],[available_copies],[status]\n"
                    + "FROM [dbo].[books]\n"
                    + "WHERE 1=1"
            );

            ArrayList<String> params = new ArrayList<>();

            if (title != null && !title.trim().isEmpty()) {
                sql.append(" AND title LIKE ?");
                params.add("%" + title + "%");
            }

            if (author != null && !author.trim().isEmpty()) {
                sql.append(" AND author LIKE ?");
                params.add("%" + author + "%");
            }

            if (category != null && !category.trim().isEmpty()) {
                sql.append(" AND category LIKE ?");
                params.add("%" + category + "%");
            }

            PreparedStatement st = cn.prepareStatement(sql.toString());

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                st.setString(i + 1, params.get(i));
            }

            ResultSet table = st.executeQuery();
            if (table != null) {
                while (table.next()) {
                    int id = table.getInt("id");
                    String bookTitle = table.getString("title");
                    String isbn = table.getString("isbn");
                    String bookAuthor = table.getString("author");
                    String bookCategory = table.getString("category");
                    int year = table.getInt("published_year");
                    int total = table.getInt("total_copies");
                    int avaCopies = table.getInt("available_copies");
                    String status = table.getString("status");
                    Book book = new Book(id, bookTitle, isbn, bookAuthor, bookCategory, year, total, avaCopies, status);
                    result.add(book);
                }
            }
        } finally {
            if (cn != null) {
                cn.close();
            }
        }
        return result;
    }

    private Book extractBookFromResultSet(ResultSet rs) throws SQLException {
        return new Book(
                rs.getInt("id"),
                rs.getString("title"),
                rs.getString("isbn"),
                rs.getString("author"),
                rs.getString("category"),
                rs.getInt("published_year"),
                rs.getInt("total_copies"),
                rs.getInt("available_copies"),
                rs.getString("status")
        );
    }

    public int getTotalBooks() {
        Connection cn = null;
        int count = 0;
        try {
            cn = DBConnection.getConnection();
            if (cn != null) {
                // step 2: query and execute
                String sql = "select COUNT([id]) from [dbo].[books];";
                Statement st = cn.createStatement();
                //ResultSet in OOP = table in Database
                ResultSet table = st.executeQuery(sql);
                // step 3: get data from table 
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

}
