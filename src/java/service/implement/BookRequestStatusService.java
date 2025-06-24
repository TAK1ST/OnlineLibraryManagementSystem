package service.implement;

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
            return bookRequestDAO.getBookRequestStatusBySearch(title, status, offset);
      }

      public boolean createBorrowRecord(int requestId) {
            Connection cn = null;
            try {
                  cn = DBConnection.getConnection();
                  if (cn == null) {
                        throw new SQLException("Cannot establish database connection");
                  }
                  cn.setAutoCommit(false);

                  // Get the book request
                  Optional<BookRequest> requestOpt = getBookRequestById(requestId);
                  if (!requestOpt.isPresent()) {
                        throw new IllegalArgumentException("Request not found: " + requestId);
                  }
                  BookRequest request = requestOpt.get();

                  // Validate request status - must be approved
                  if (!"approved".equals(request.getStatus())) {
                        throw new IllegalStateException("Request must be approved first. Current status: " + request.getStatus());
                  }

                  // Check book availability
                  Book book = bookDAO.getBookById(request.getBookId());
                  if (book == null) {
                        System.out.println("Book not found for bookId: " + request.getBookId());
                        throw new IllegalStateException("Book not found");
                  }
                  if (book.getAvailableCopies() <= 0) {
                        throw new IllegalStateException("Book not available - no copies left");
                  }
                  if (!"active".equals(book.getStatus())) {
                        throw new IllegalStateException("Book is not active");
                  }

                  // Create borrow record
                  BorrowRecord borrowRecord = new BorrowRecord();
                  borrowRecord.setUserId(request.getUserId());
                  borrowRecord.setBookId(request.getBookId());
                  borrowRecord.setBorrowDate(LocalDate.now());
                  borrowRecord.setDueDate(LocalDate.now().plusDays(14)); // 2 weeks borrow period
                  borrowRecord.setStatus("borrowed");

                  try {
                        borrowRecordDAO.save(borrowRecord);
                  } catch (Exception e) {
                        e.printStackTrace();
                  }

                  // Update book available copies
                  book.setAvailableCopies(book.getAvailableCopies() - 1);
                  boolean bookUpdated = bookDAO.update(book);
                  if (!bookUpdated) {
                        throw new RuntimeException("Failed to update book available copies");
                  }

                  // Update request status to completed
                  boolean statusUpdated = updateBookRequestStatus(requestId, "completed");
                  if (!statusUpdated) {
                        throw new RuntimeException("Failed to update request status to completed");
                  }

                  cn.commit();
                  System.out.println("Successfully created borrow record for request: " + requestId);
                  return true;

            } catch (Exception e) {
                  if (cn != null) {
                        try {
                              cn.rollback();
                              System.out.println("Transaction rolled back due to error: " + e.getMessage());
                        } catch (SQLException ex) {
                              System.err.println("Error during rollback: " + ex.getMessage());
                        }
                  }
                  System.err.println("Error creating borrow record: " + e.getMessage());
                  e.printStackTrace();
                  return false;
            } finally {
                  if (cn != null) {
                        try {
                              cn.setAutoCommit(true);
                              cn.close();
                        } catch (SQLException e) {
                              System.err.println("Error closing connection: " + e.getMessage());
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
}
