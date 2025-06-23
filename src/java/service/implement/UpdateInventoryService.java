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

    private final IBookDAO bookDAO;

    public UpdateInventoryService() throws SQLException, ClassNotFoundException {
        this.bookDAO = new BookDAO();
    }

    @Override
    public int getTotalBook() {
        return bookDAO.getTotalBooks();
    }

    @Override
    public int getTotalBookAvailable() {
        try {
            List<Book> books = bookDAO.getAllBook();
            return books.stream()
                    .mapToInt(Book::getAvailableCopies)
                    .sum();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int getBorrowBook() {
        return bookDAO.getBorrowBooks();
    }

    @Override
    public int getBorrowLowStock() {
        try {
            List<Book> books = bookDAO.getAllBook();
            return (int) books.stream()
                    .filter(book -> book.getAvailableCopies() <= 2 && book.getAvailableCopies() > 0)
                    .count();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public List<Book> getAllBooks() throws SQLException, ClassNotFoundException {
        return bookDAO.getAllBook();
    }

    public List<Book> searchBooks(String title, String author, String category) throws SQLException, ClassNotFoundException {
        return bookDAO.searchBooks(title, author, category);
    }

    public boolean updateBookQuantity(int bookId, int newQuantity) {
        try {
            return bookDAO.updateBookQuantity(bookId, newQuantity);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
