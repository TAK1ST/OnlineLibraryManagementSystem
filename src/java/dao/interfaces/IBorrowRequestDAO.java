package dao.interfaces;

import java.sql.Date;
import java.sql.SQLException;
import java.util.List;
import entity.BorrowRequest;

public interface IBorrowRequestDAO {
    boolean createBorrowRequest(int userId, int bookId, Date requestDate, String status) throws SQLException, ClassNotFoundException;
    List<BorrowRequest> getBorrowRequestsByUser(int userId) throws SQLException, ClassNotFoundException;
    List<BorrowRequest> getApprovedRequestsByUser(int userId) throws SQLException, ClassNotFoundException;
    boolean returnBook(int requestId) throws SQLException, ClassNotFoundException;
} 