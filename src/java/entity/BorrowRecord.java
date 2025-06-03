/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import java.time.LocalDate;

/**
 *
 * @author asus
 */
public class BorrowRecord {
    private int id;
    private int userId;
    private int bookId;
    private LocalDate borrowDate;
    private LocalDate dueDate;
    private LocalDate returnDate;
    private String status;

      public BorrowRecord() {
      }

    
      public BorrowRecord(int id, int userId, int bookId, LocalDate borrowDate, LocalDate dueDate, LocalDate returnDate, String status) {
            this.id = id;
            this.userId = userId;
            this.bookId = bookId;
            this.borrowDate = borrowDate;
            this.dueDate = dueDate;
            this.returnDate = returnDate;
            this.status = status;
      }

      public int getId() {
            return id;
      }

      public void setId(int id) {
            this.id = id;
      }

      public int getUserId() {
            return userId;
      }

      public void setUserId(int userId) {
            this.userId = userId;
      }

      public int getBookId() {
            return bookId;
      }

      public void setBookId(int bookId) {
            this.bookId = bookId;
      }

      public LocalDate getBorrowDate() {
            return borrowDate;
      }

      public void setBorrowDate(LocalDate borrowDate) {
            this.borrowDate = borrowDate;
      }

      public LocalDate getDueDate() {
            return dueDate;
      }

      public void setDueDate(LocalDate dueDate) {
            this.dueDate = dueDate;
      }

      public LocalDate getReturnDate() {
            return returnDate;
      }

      public void setReturnDate(LocalDate returnDate) {
            this.returnDate = returnDate;
      }

      public String getStatus() {
            return status;
      }

      public void setStatus(String status) {
            this.status = status;
      }
    
      
}

