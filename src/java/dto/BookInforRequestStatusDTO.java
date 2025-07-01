/*
 * Click nbfs://SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

import java.time.LocalDate;

/**
 *
 * @author asus
 */
public class BookInforRequestStatusDTO {

      private int id;
      private String title;
      private String isbn;
      private int availableCopies;
      private String statusAction;
      private String requestType;
      private String username;
      private double overdueFine;
      private int userId;
      private int bookId;
      private LocalDate dueDate;

      public BookInforRequestStatusDTO() {
      }

      public int getId() {
            return id;
      }

      public void setId(int id) {
            this.id = id;
      }

      public String getTitle() {
            return title;
      }

      public void setTitle(String title) {
            this.title = title;
      }

      public String getIsbn() {
            return isbn;
      }

      public void setIsbn(String isbn) {
            this.isbn = isbn;
      }

      public int getAvailableCopies() {
            return availableCopies;
      }

      public void setAvailableCopies(int availableCopies) {
            this.availableCopies = availableCopies;
      }

      public String getStatusAction() {
            return statusAction;
      }

      public void setStatusAction(String statusAction) {
            this.statusAction = statusAction != null ? statusAction.toLowerCase().trim() : "pending";
      }

      public String getRequestType() {
            return requestType;
      }

      public void setRequestType(String requestType) {
            this.requestType = requestType != null ? requestType.toLowerCase().trim() : "borrow";
      }

      public String getUsername() {
            return username;
      }

      public void setUsername(String username) {
            this.username = username;
      }

      public double getOverdueFine() {
            return overdueFine;
      }

      public void setOverdueFine(double overdueFine) {
            this.overdueFine = overdueFine;
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

      public LocalDate getDueDate() {
            return dueDate;
      }

      public void setDueDate(LocalDate dueDate) {
            this.dueDate = dueDate;
      }
}
