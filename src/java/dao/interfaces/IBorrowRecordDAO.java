/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.interfaces;

import entity.BorrowRecord;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 *
 * @author asus
 */
public interface IBorrowRecordDAO extends IBaseDAO<BorrowRecord> {

      List<BorrowRecord> getBorrowRecordsByUserId(int userId);

      List<BorrowRecord> getBorrowRecordsByBookId(int bookId);

      boolean updateReturnStatus(int id, LocalDate returnDate, String status);

      List<BorrowRecord> getCurrentBorrowedBooks();

      List<BorrowRecord> getOverdueBooks();

      Optional<BorrowRecord> getBorrowRecordByRequestId(int requestId);
      
      List<BorrowRecord> getBorrowRecordsByUserIdAndBookId(int userId, int bookId);
}
