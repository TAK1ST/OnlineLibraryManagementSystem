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
    public boolean createBorrowRequest(int userId, int bookId, Date requestDate, String status) 
            throws SQLException, ClassNotFoundException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO book_requests "
                    + "(user_id, book_id, request_date, status) "
                    + "VALUES (?, ?, ?, ?)";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            stmt.setDate(3, requestDate);
            stmt.setString(4, status);
            
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
            String sql = "SELECT id, user_id, book_id, request_date, status "
                    + "FROM book_requests "
                    + "WHERE user_id = ? ORDER BY request_date DESC";
            
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
    public List<BorrowRequest> getApprovedRequestsByUser(int userId) 
            throws SQLException, ClassNotFoundException {
        Connection conn = null;
        List<BorrowRequest> requests = new ArrayList<>();
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT id, user_id, book_id, request_date, status "
                    + "FROM book_requests "
                    + "WHERE user_id = ? AND status = 'borrowed' "
                    + "ORDER BY request_date DESC";
            
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
    public boolean returnBook(int requestId) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            
            // Update request status to pending_return
            String updateRequestSql = "UPDATE book_requests SET status = 'pending' WHERE id = ? AND status = 'borrowed'";
            PreparedStatement updateRequestStmt = conn.prepareStatement(updateRequestSql);
            updateRequestStmt.setInt(1, requestId);
            
            int rowsAffected = updateRequestStmt.executeUpdate();
            return rowsAffected > 0;
            
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
    }
    
    private BorrowRequest extractBorrowRequestFromResultSet(ResultSet rs) throws SQLException {
        BorrowRequest request = new BorrowRequest();
        request.setId(rs.getInt("id"));
        request.setUserId(rs.getInt("user_id"));
        request.setBookId(rs.getInt("book_id"));
        request.setRequestDate(rs.getDate("request_date"));
        request.setStatus(rs.getString("status"));
        return request;
    }
} 