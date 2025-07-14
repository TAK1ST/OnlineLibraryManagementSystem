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

            // Chỉ lấy những sách đang được mượn (status = 'borrowed') 
            // và chưa có yêu cầu trả sách (không có record nào với request_type = 'return' và status = 'pending')
            String sql = "SELECT id, user_id, book_id, request_date, request_type, status "
                    + "FROM book_requests "
                    + "WHERE user_id = ? AND status = 'borrowed' "
                    + "AND book_id NOT IN ("
                    + "    SELECT book_id FROM book_requests "
                    + "    WHERE user_id = ? AND request_type = 'return' AND status = 'pending'"
                    + ") "
                    + "ORDER BY request_date DESC";

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);

            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                requests.add(extractBorrowRequestFromResultSet(rs));

            }
      }

      @Override
      public List<BorrowRequest> getBorrowRequestsByUserId(int userId)
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
        }
        return requests;
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

      @Override
      public boolean returnBook(int requestId) throws SQLException, ClassNotFoundException {
            Connection conn = null;
            try {
                  conn = DBConnection.getConnection();
                  String query = "SELECT user_id, book_id FROM book_requests WHERE id = ?";
                  PreparedStatement ps = conn.prepareStatement(query);
                  ps.setInt(1, requestId);
                  ResultSet rs = ps.executeQuery();

                  if (rs.next()) {
                        int userId = rs.getInt("user_id");
                        int bookId = rs.getInt("book_id");

                        // Tạo một record mới với request_type = 'return' và status = 'pending'
                        String insertSql = "INSERT INTO book_requests (user_id, book_id, request_date, request_type, status) "
                                + "VALUES (?, ?, GETDATE(), 'return', 'pending')";
                        PreparedStatement stmt = conn.prepareStatement(insertSql);
                        stmt.setInt(1, userId);
                        stmt.setInt(2, bookId);

                        int rowsAffected = stmt.executeUpdate();

                        // In log để debug
                        System.out.println("Return book request created - User: " + userId + ", Book: " + bookId + ", Rows affected: " + rowsAffected);

                        return rowsAffected > 0;
                  } else {
                        System.out.println("Request ID not found: " + requestId);
                        return false; // requestId không tồn tại
                  }

            } finally {
                  if (conn != null) {
                        conn.close();
                  }
            }
      }

    // Thêm phương thức để lấy thông tin BorrowRequest theo ID (nếu cần)
    public BorrowRequest getBorrowRequestById(int requestId) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT id, user_id, book_id, request_date, request_type, status "
                    + "FROM book_requests WHERE id = ?";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, requestId);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractBorrowRequestFromResultSet(rs);
            }
            return null;
        } finally {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        }
    }
}
