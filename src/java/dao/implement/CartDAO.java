package dao.implement;

import entity.CartItem;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import util.DBConnection;

public class CartDAO {
    
    public boolean addToCart(int userId, int bookId) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            // Kiểm tra xem item đã có trong giỏ hàng chưa
            String checkSql = "SELECT id FROM cart_items WHERE user_id = ? AND book_id = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, userId);
            checkStmt.setInt(2, bookId);
            ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next()) {
                return true; // Item đã có trong giỏ
            }
            
            // Thêm item mới vào giỏ
            String sql = "INSERT INTO cart_items (user_id, book_id, added_date) "
                    + "SELECT ?, ?, GETDATE() "
                    + "FROM books b WHERE b.id = ? AND b.available_copies > 0";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            stmt.setInt(3, bookId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } finally {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        }
    }
    
    public boolean removeFromCart(int userId, int bookId) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM cart_items WHERE user_id = ? AND book_id = ?";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } finally {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        }
    }
    
    public List<CartItem> getCartItems(int userId) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        List<CartItem> items = new ArrayList<>();
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT ci.id, ci.user_id, ci.book_id, b.title as book_title, "
                    + "b.author as book_author, ci.added_date "
                    + "FROM cart_items ci "
                    + "JOIN books b ON ci.book_id = b.id "
                    + "WHERE ci.user_id = ?";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                CartItem item = new CartItem(
                    rs.getInt("id"),
                    rs.getInt("user_id"),
                    rs.getInt("book_id"),
                    rs.getString("book_title"),
                    rs.getString("book_author"),
                    rs.getString("added_date")
                );
                items.add(item);
            }
        } finally {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        }
        return items;
    }
    
    public void clearCart(int userId) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "DELETE FROM cart_items WHERE user_id = ?";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            
            stmt.executeUpdate();
        } finally {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        }
    }
    
    public boolean isBookInCart(int userId, int bookId) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) FROM cart_items WHERE user_id = ? AND book_id = ?";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        } finally {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        }
    }
} 