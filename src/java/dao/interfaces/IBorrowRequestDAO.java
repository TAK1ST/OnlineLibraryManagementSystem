package dao.interfaces;

import java.sql.Date;
import java.sql.SQLException;
import java.util.List;
import entity.BorrowRequest;

public interface IBorrowRequestDAO {
    boolean createBorrowRequest(int userId, int bookId, Date requestDate, Date dueDate, String status) throws SQLException, ClassNotFoundException;
    boolean updateBorrowRequestStatus(int requestId, String newStatus) throws SQLException, ClassNotFoundException;
    List<BorrowRequest> getBorrowRequestsByUser(int userId) throws SQLException, ClassNotFoundException;
    List<BorrowRequest> getAllPendingRequests() throws SQLException, ClassNotFoundException;
    BorrowRequest getBorrowRequestById(int requestId) throws SQLException, ClassNotFoundException;
} 