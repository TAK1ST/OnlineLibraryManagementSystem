/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.implement;

import dao.implement.BookDAO;
import dao.interfaces.IBookDAO;
import entity.Book;
import java.sql.SQLException;
import java.util.List;
import service.interfaces.IUpdateInventoryService;

/**
 *
 * @author asus
 */
public class UpdateInventoryService implements IUpdateInventoryService {

      private final IBookDAO bookDAO = new BookDAO();
      private final List<Book> bookList;

      public UpdateInventoryService() throws SQLException, ClassNotFoundException {
            bookList = bookDAO.getAllBook();
      }

      @Override
      public int getTotalBook() {
            int count = 0;
            for (Book book : bookList) {
                  count++;
            }
            return count;
      }

      @Override
      public int getTotalBookAvailable() {
            int count = 0;
            for (Book book : bookList) {
                  count++;
            }
            return count;
      }

      @Override
      public int getBorrowBook() {
            return 0;
      }

      @Override
      public int getBorrowLowStock() {
            return 0;
      }
}
