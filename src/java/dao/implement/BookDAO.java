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
import java.util.ArrayList;
import java.util.List;
import util.DBConnection;

/**
 * @author Admin
 */
public class BookDAO implements IBookDAO {
    
    // Hàm này để lấy sách theo title
    @Override
    public ArrayList<Book> getBookByTitle(String title) {
        ArrayList<Book> result = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBConnection.getConnection();
            if (cn != null) {
                System.out.println("connect successfully");
            }
            
            String sql = "SELECT [id],[title],[author],[isbn],[category],[published_year],[total_copies],[available_copies],[status] " +
                        "FROM [dbo].[books] " +
                        "WHERE title LIKE ?";
            
            PreparedStatement st = cn.prepareStatement(sql);
            st.setString(1, "%" + title + "%");
            ResultSet table = st.executeQuery();
            
            if (table != null) {
                while (table.next()) {
                    int id = table.getInt("id");
                    String bookTitle = table.getString("title"); 
                    String author = table.getString("author");
                    String isbn = table.getString("isbn");
                    String category = table.getString("category");
                    int year = table.getInt("published_year"); 
                    int total = table.getInt("total_copies"); 
                    int avaCopies = table.getInt("available_copies"); 
                    String status = table.getString("status");
                    
                    Book b = new Book(id, bookTitle, author, isbn, category, year, total, avaCopies, status);
                    result.add(b);
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
        return result;
    }

    @Override
    public List<Book> getAllBook() throws SQLException, ClassNotFoundException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE status = 'active'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                books.add(extractBookFromResultSet(rs));
            }
        }
        return books;
    }
    
    @Override
    public List<Book> getNewBooks() throws SQLException, ClassNotFoundException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT TOP 10 * FROM books WHERE status = 'active' ORDER BY published_year DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                books.add(extractBookFromResultSet(rs));
            }
        }
        return books;
    }
    
    @Override
    public List<Book> searchBooks(String searchTerm, String searchBy) throws SQLException, ClassNotFoundException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE status = 'active' AND " + searchBy + " LIKE ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, "%" + searchTerm + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(extractBookFromResultSet(rs));
                }
            }
        }
        return books;
    }
    
    private Book extractBookFromResultSet(ResultSet rs) throws SQLException {
        return new Book(
            rs.getInt("id"),
            rs.getString("title"),
            rs.getString("author"),
            rs.getString("isbn"),
            rs.getString("category"),
            rs.getInt("published_year"),      
            rs.getInt("total_copies"),       
            rs.getInt("available_copies"),   
            rs.getString("status")
        );
    }
}
