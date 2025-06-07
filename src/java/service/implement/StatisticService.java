/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.implement;

import dao.implement.BookDAO;
import dao.implement.BookRequestDAO;
import dao.implement.BorrowRecordDAO;
import dao.implement.UserDAO;
import dto.BorrowedBookDTO;
import entity.Book;
import entity.BorrowRecord;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author asus
 */
public class StatisticService {

      private final UserDAO userDAO;
      private final BookDAO bookDAO;
      private final BorrowRecordDAO borrowRecordDAO;
      private final BookRequestDAO bookRequestDAO;
      private List<Book> bookList = new ArrayList<>();
      private List<BorrowRecord> borrowRecordList = new ArrayList<>();

      public StatisticService() {
            userDAO = new UserDAO();
            bookDAO = new BookDAO();
            borrowRecordDAO = new BorrowRecordDAO();
            bookRequestDAO = new BookRequestDAO();
      }

      public int getTotalUser() {
            return userDAO.getTotalUsers();
      }

      public int getTotalBook() {
            return bookDAO.getTotalBooks();
      }

      public int getTotalCurrentBorrowPerWeek() {
            return (int) borrowRecordDAO.countUniqueUsersBorrowedThisWeek();
      }

      public List<BorrowedBookDTO> getTop5BorrowedBooks() {
            return bookDAO.getTop5BorrowedBooks();
      }

      public int[] getMonthlyData() {
            return borrowRecordDAO.getBookBorrowMonthlyTotal();
      }

      public int calculateAverageBorrowPerDay() {
            List<BorrowRecord> borrowRecords = borrowRecordDAO.getCurrentBorrowedBooks();

            int total = borrowRecords.size();
            if (borrowRecords.isEmpty()) {
                  return 0;
            }

            LocalDate firstDate = borrowRecords.stream()
                    .map(BorrowRecord::getBorrowDate)
                    .min(LocalDate::compareTo)
                    .orElse(LocalDate.now());

            LocalDate lastDate = borrowRecords.stream()
                    .map(BorrowRecord::getBorrowDate)
                    .max(LocalDate::compareTo)
                    .orElse(LocalDate.now());

            long daysBetween = ChronoUnit.DAYS.between(firstDate, lastDate);
            int totalDays = (int) (daysBetween <= 0 ? 1 : daysBetween);

            return total / totalDays;
      }
}
