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
public class BookRequest {
    private int id;
    private User user;
    private Book book;
    private LocalDate requestDate;
    private String status;

      public BookRequest() {
      }

      public BookRequest(int id, User user, Book book, LocalDate requestDate, String status) {
            this.id = id;
            this.user = user;
            this.book = book;
            this.requestDate = requestDate;
            this.status = status;
      }

      public int getId() {
            return id;
      }

      public void setId(int id) {
            this.id = id;
      }

      public User getUser() {
            return user;
      }

      public void setUser(User user) {
            this.user = user;
      }

      public Book getBook() {
            return book;
      }

      public void setBook(Book book) {
            this.book = book;
      }

      public LocalDate getRequestDate() {
            return requestDate;
      }

      public void setRequestDate(LocalDate requestDate) {
            this.requestDate = requestDate;
      }

      public String getStatus() {
            return status;
      }

      public void setStatus(String status) {
            this.status = status;
      }
    
}
