package service.implement;

import constant.constance;
import dao.implement.BookDAO;
import dao.implement.BookRequestDAO;
import dao.implement.BorrowRecordDAO;
import dao.interfaces.IBookDAO;
import dao.interfaces.IBookRequestDAO;
import dao.interfaces.IBorrowRecordDAO;
import dto.BookInforRequestStatusDTO;
import entity.Book;
import entity.BookRequest;
import entity.BorrowRecord;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import util.DBConnection;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author asus
 */
public class BookRequestStatusService {

      private final IBookRequestDAO bookRequestDAO;
      private final IBorrowRecordDAO borrowRecordDAO;
      private final IBookDAO bookDAO;
      constance cs = new constance();
      public BookRequestStatusService(IBookRequestDAO bookRequestDAO, IBorrowRecordDAO borrowRecordDAO, IBookDAO bookDAO) {
            this.bookRequestDAO = bookRequestDAO;
            this.borrowRecordDAO = borrowRecordDAO;
            this.bookDAO = bookDAO;
      }

      public BookRequestStatusService() {
            this(new BookRequestDAO(), new BorrowRecordDAO(), new BookDAO());
      }

      public Optional<BookRequest> getBookRequestById(int id) {
            return bookRequestDAO.getBookRequestById(id);
      }

      public boolean updateBookRequestStatus(int requestId, String newStatus) {
            try {
                  boolean result = bookRequestDAO.updateBookRequestStatus(requestId, newStatus);
                  System.out.println("Service: Updated request " + requestId + " to status " + newStatus + ", result: " + result);
                  return result;
            } catch (Exception e) {
                  System.err.println("Service error updating request status: " + e.getMessage());
                  e.printStackTrace();
                  return false;
            }
      }

      public List<BookInforRequestStatusDTO> getAllBookRequestStatusLazyLoading(String title, String status, int offset) {
            if (offset < 0) {
                  offset = 0;
            }
            
            List<BookInforRequestStatusDTO> result = bookRequestDAO.getBookRequestStatusBySearch(title, status, offset);
            
            System.out.println("Service - Retrieved " + (result != null ? result.size() : 0) + " records");
            
            return result != null ? result : new ArrayList<>();
      }

      public boolean createBorrowRecord(int requestId) {
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
                  if (cn == null) {
                        throw new SQLException("Cannot connect database");
                  }
                  cn.setAutoCommit(false);

                  //get request 
                  Optional<BookRequest> requestOpt = getBookRequestById(requestId);
                  if (!requestOpt.isPresent()) {
                        throw new IllegalArgumentException("Request not found with ID: " + requestId);
                  }
                  BookRequest request
                          = requestOpt.get();

                  // Kiểm tra trạng thái yêu cầu
                  if (!"approved-borrow".equalsIgnoreCase(request.getStatus())) {
                        throw new IllegalStateException("Yêu cầu phải ở trạng thái approved-borrow. Trạng thái hiện tại: " + request.getStatus());
                  }

                  // Kiểm tra sách
                  Book book = bookDAO.getBookById(request.getBookId());
                  if (book == null) {
                        throw new IllegalStateException("Không tìm thấy sách với ID: " + request.getBookId());
                  }
                  if (book.getAvailableCopies() <= 0) {
                        throw new IllegalStateException("Sách không còn bản sao nào khả dụng (ID: " + book.getId() + ")");
                  }
                  if (!"active".equalsIgnoreCase(book.getStatus())) {
                        throw new IllegalStateException("Sách không ở trạng thái active (ID: " + book.getId() + ")");
                  }

                  // Tạo bản ghi mượn
                  BorrowRecord borrowRecord = new BorrowRecord();
                  borrowRecord.setUserId(request.getUserId());
                  borrowRecord.setBookId(request.getBookId());
                  borrowRecord.setBorrowDate(LocalDate.now());
                  borrowRecord.setDueDate(LocalDate.now().plusDays(cs.DEFAULT_BORROW_DURATION));
                  borrowRecord.setStatus("borrowed");

                  borrowRecordDAO.save(borrowRecord);

                  // Cập nhật số lượng sách
                  book.setAvailableCopies(book.getAvailableCopies() - 1);
                  boolean bookUpdated = bookDAO.update(book);
                  if (!bookUpdated) {
                        throw new RuntimeException("Không thể cập nhật số lượng sách (ID: " + book.getId() + ")");
                  }

                  cn.commit();
                  System.out.println("Tạo bản ghi mượn thành công cho yêu cầu: " + requestId);
                  return true;

            } catch (Exception e) {
                  if (cn != null) {
                        try {
                              cn.rollback();
                              System.out.println("Giao dịch được hoàn tác do lỗi: " + e.getMessage());
                        } catch (SQLException ex) {
                              System.err.println("Lỗi khi hoàn tác giao dịch: " + ex.getMessage());
                        }
                  }
                  System.err.println("Lỗi khi tạo bản ghi mượn: " + e.getMessage());
                  e.printStackTrace();
                  return false;
            } finally {
                  if (cn != null) {
                        try {
                              cn.setAutoCommit(true);
                              cn.close();
                        } catch (SQLException e) {
                              System.err.println("Lỗi khi đóng kết nối: " + e.getMessage());
                        }
                  }
            }
      }

      public List<BorrowRecord> getBorrowRecordsByUserIdAndBookId(int userId, int bookId) {
            return borrowRecordDAO.getBorrowRecordsByUserIdAndBookId(userId, bookId);
      }

      public boolean processReturnRequest(int requestId) {
            BookRequestDAO dao = (BookRequestDAO) bookRequestDAO;
            return dao.processReturnRequest(requestId);
      }
      
      public Book getBookDAO(int id)
      { 
            BookRequest br = bookRequestDAO.getBookRequestById(id).get();
            return bookDAO.getBookById(br.getBookId());
      }
      
      public boolean CheckBookAvailability(int id)
      {
            int availableCopies = bookDAO.getBookById(id).getAvailableCopies();
            return availableCopies > 1;
      }
}
