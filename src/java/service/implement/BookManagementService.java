/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.implement;

import dao.implement.BookManagementDAO;
import entity.Book;
import java.util.List;
import util.GenerateISBN;

/**
 *
 * @author asus
 */
public class BookManagementService {

      private final BookManagementDAO bookManagementDAO;
      private final GenerateISBN generateISBN = new GenerateISBN();

      public BookManagementService() {
            this.bookManagementDAO = new BookManagementDAO();
      }

      public List<Book> getBooks(int page, int size, String titleFilter,
              String authorFilter, String categoryFilter, String statusFilter) {
            try {
                  return bookManagementDAO.getBooks(page, size, titleFilter, authorFilter, categoryFilter, statusFilter);
            } catch (Exception e) {
                  throw new RuntimeException("Error retrieving books: " + e.getMessage(), e);
            }
      }

      public int getTotalBooksCount(String titleFilter, String authorFilter,
              String categoryFilter, String statusFilter) {
            try {
                  return bookManagementDAO.getTotalBooksCount(titleFilter, authorFilter, categoryFilter, statusFilter);
            } catch (Exception e) {
                  throw new RuntimeException("Error counting books: " + e.getMessage(), e);
            }
      }

      public int getTotalPages(int totalBooks, int pageSize) {
            return (int) Math.ceil((double) totalBooks / pageSize);
      }

      public Book getBookById(int bookId) {
            try {
                  return bookManagementDAO.getBookById(bookId);
            } catch (Exception e) {
                  throw new RuntimeException("Error retrieving book: " + e.getMessage(), e);
            }
      }

      public boolean softDeleteBook(int bookId) {
            try {
                  return bookManagementDAO.softDeleteBook(bookId);
            } catch (Exception e) {
                  throw new RuntimeException("Error soft deleting book: " + e.getMessage(), e);
            }
      }

      public boolean isBookCurrentlyBorrowed(int bookId) {
            try {
                  return bookManagementDAO.isBookCurrentlyBorrowed(bookId);
            } catch (Exception e) {
                  throw new RuntimeException("Error checking book borrow status: " + e.getMessage(), e);
            }
      }

      public boolean updateBook(Book book) {
            try {
                  // Validate book data
                  if (book == null) {
                        throw new IllegalArgumentException("Book cannot be null");
                  }
                  if (book.getTitle() == null || book.getTitle().trim().isEmpty()) {
                        throw new IllegalArgumentException("Book title is required");
                  }
                  if (book.getAuthor() == null || book.getAuthor().trim().isEmpty()) {
                        throw new IllegalArgumentException("Book author is required");
                  }
                  if (book.getIsbn() == null || book.getIsbn().trim().isEmpty()) {
                        throw new IllegalArgumentException("Book ISBN is required");
                  }

                  return bookManagementDAO.updateBook(book);
            } catch (Exception e) {
                  throw new RuntimeException("Error updating book: " + e.getMessage(), e);
            }
      }

      public boolean addBook(Book book) {
            try {
                  // Validate book data
                  if (book == null) {
                        throw new IllegalArgumentException("Book cannot be null");
                  }
                  if (book.getTitle() == null || book.getTitle().trim().isEmpty()) {
                        throw new IllegalArgumentException("Book title is required");
                  }
                  if (book.getAuthor() == null || book.getAuthor().trim().isEmpty()) {
                        throw new IllegalArgumentException("Book author is required");
                  }
                  if (book.getIsbn() == null || book.getIsbn().trim().isEmpty()) {
                        throw new IllegalArgumentException("Book ISBN is required");
                  }

                  // Check if ISBN already exists
                  if (bookManagementDAO.isIsbnExists(book.getIsbn())) {
                        throw new IllegalArgumentException("ISBN already exists");
                  }

                  return bookManagementDAO.addBook(book);
            } catch (Exception e) {
                  throw new RuntimeException("Error adding book: " + e.getMessage(), e);
            }
      }
      
      public boolean editBook(Book  book) {
            try {
                  Book currentBook = getBookById(book.getId());
                  // Validate book data
                  if (book == null) {
                        throw new IllegalArgumentException("Book cannot be null");
                  }
                  if (book.getTitle() == null || book.getTitle().trim().isEmpty()) {
                        throw new IllegalArgumentException("Book title is required");
                  }
                  if (book.getAuthor() == null || book.getAuthor().trim().isEmpty()) {
                        throw new IllegalArgumentException("Book author is required");
                  }

                  return bookManagementDAO.updateBook(book);
            } catch (Exception e) {
                  throw new RuntimeException("Error edit book: " + e.getMessage(), e);
            }
      }

      public List<String> getAvailableCategories() {
            try {
                  return bookManagementDAO.getAvailableCategories();
            } catch (Exception e) {
                  throw new RuntimeException("Error retrieving categories: " + e.getMessage(), e);
            }
      }

      public List<String> getAvailableStatuses() {
            try {
                  return bookManagementDAO.getAvailableStatuses();
            } catch (Exception e) {
                  throw new RuntimeException("Error retrieving statuses: " + e.getMessage(), e);
            }
      }

      public boolean isIsbnExists(String isbn, int excludeBookId) {
            try {
                  return bookManagementDAO.isIsbnExists(isbn, excludeBookId);
            } catch (Exception e) {
                  throw new RuntimeException("Error checking ISBN existence: " + e.getMessage(), e);
            }
      }

      public List<Book> getBooksByStatus(String status) {
            try {
                  return bookManagementDAO.getBooksByStatus(status);
            } catch (Exception e) {
                  throw new RuntimeException("Error retrieving books by status: " + e.getMessage(), e);
            }
      }

      public boolean restoreBook(int bookId) {
            try {
                  return bookManagementDAO.restoreBook(bookId);
            } catch (Exception e) {
                  throw new RuntimeException("Error restoring book: " + e.getMessage(), e);
            }
      }

      public String generateUniqueISBN() {
            return generateISBN.generateUniqueISBN();
      }
}
