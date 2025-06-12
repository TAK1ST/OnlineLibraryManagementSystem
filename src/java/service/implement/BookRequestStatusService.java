package service.implement;

import dao.implement.BookDAO;
import dao.implement.BookRequestDAO;
import dao.implement.BorrowRecordDAO;
import dao.implement.UserDAO;
import dto.BookInforRequestStatusDTO;
import entity.Book;
import entity.BorrowRecord;
import entity.User;
import java.util.ArrayList;
import java.util.List;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author asus
 */
public class BookRequestStatusService {

      private final BookRequestDAO bookRequestDAO = new BookRequestDAO();

      public BookRequestStatusService() {
      }

      public List<BookInforRequestStatusDTO> getAllBookRequest() {
            return bookRequestDAO.getAllBookRequest();
      }

      public boolean updateBookRequestStatus(int id, String newStatus) 
      {
            return bookRequestDAO.updateBookRequestStatus(id, newStatus);
      }

      public List<BookInforRequestStatusDTO> getAllBookRequestStatusLazyLoading(String isbn, String status, int offset) {
            List<BookInforRequestStatusDTO> userList;
            if ((isbn != null && !isbn.trim().isEmpty())
                    || (status != null && !status.trim().isEmpty())) {
                  userList = bookRequestDAO.getBookRequestStatusBySearch(isbn, status, offset);
            } else {
                  userList = bookRequestDAO.getBookRequestStatusLazyPageLoading(offset);
            }
            return userList;
      }
      
}
