/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.interfaces;

import entity.Book;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author asus
 */

public interface IBookDAO {
      public ArrayList<Book> getBookByTitle(String title);
      public List<Book> getAllBook() throws SQLException, ClassNotFoundException;
      public List<Book> getNewBooks() throws SQLException, ClassNotFoundException;
      public List<Book> searchBooks(String searchTerm, String searchBy) throws SQLException, ClassNotFoundException;
      public ArrayList<Book> searchBooks(String title, String author, String category) throws ClassNotFoundException, SQLException;
      public boolean updateBookQuantity(int bookId, int newQuantity);
      public int getTotalBooks();
      public int getBorrowBooks();
}
