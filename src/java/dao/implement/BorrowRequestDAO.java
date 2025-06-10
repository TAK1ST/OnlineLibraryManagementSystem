package dao.implement;

import dao.interfaces.IBorrowRequestDAO;
import entity.BorrowRequest;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import util.DBConnection;

public class BorrowRequestDAO implements IBorrowRequestDAO {
    
    @Override
    public boolean createBorrowRequest(int userId, int bookId, Date requestDate, Date dueDate, String status) 
            throws SQLException, ClassNotFoundException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO borrow_records "
                    + "(user_id, book_id, borrow_date, due_date, status) "
                    + "VALUES (?, ?, ?, ?, ?)";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            stmt.setDate(3, requestDate);
            stmt.setDate(4, dueDate);
            stmt.setString(5, status);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } finally {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        }
    }

    @Override
    public boolean updateBorrowRequestStatus(int requestId, String newStatus) 
            throws SQLException, ClassNotFoundException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE borrow_records SET status = ? WHERE id = ?";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, newStatus);
            stmt.setInt(2, requestId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } finally {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        }
    }

    @Override
    public List<BorrowRequest> getBorrowRequestsByUser(int userId) 
            throws SQLException, ClassNotFoundException {
        Connection conn = null;
        List<BorrowRequest> requests = new ArrayList<>();
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT id, user_id, book_id, borrow_date, due_date, "
                    + "return_date, status, note FROM borrow_records "
                    + "WHERE user_id = ? ORDER BY borrow_date DESC";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                requests.add(extractBorrowRequestFromResultSet(rs));
            }
        } finally {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        }
        return requests;
    }

    @Override
    public List<BorrowRequest> getAllPendingRequests() 
            throws SQLException, ClassNotFoundException {
        Connection conn = null;
        List<BorrowRequest> requests = new ArrayList<>();
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT id, user_id, book_id, borrow_date, due_date, "
                    + "return_date, status, note FROM borrow_records "
                    + "WHERE status = 'pending' ORDER BY borrow_date";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                requests.add(extractBorrowRequestFromResultSet(rs));
            }
        } finally {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        }
        return requests;
    }

    @Override
    public BorrowRequest getBorrowRequestById(int requestId) 
            throws SQLException, ClassNotFoundException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT id, user_id, book_id, borrow_date, due_date, "
                    + "return_date, status, note FROM borrow_records "
                    + "WHERE id = ?";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, requestId);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractBorrowRequestFromResultSet(rs);
            }
        } finally {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        }
        return null;
    }
    
    private BorrowRequest extractBorrowRequestFromResultSet(ResultSet rs) throws SQLException {
        BorrowRequest request = new BorrowRequest();
        request.setId(rs.getInt("id"));
        request.setUserId(rs.getInt("user_id"));
        request.setBookId(rs.getInt("book_id"));
        request.setRequestDate(rs.getDate("borrow_date"));
        request.setDueDate(rs.getDate("due_date"));
        request.setStatus(rs.getString("status"));
        request.setNote(rs.getString("note"));
        return request;
    }
} 