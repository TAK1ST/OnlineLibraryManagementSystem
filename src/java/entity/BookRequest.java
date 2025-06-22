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
      private int userId;
      private int bookId;
      private LocalDate requestDate;
      private String requestType;
      private String status;

      public BookRequest() {
      }

      public BookRequest(int id, int userId, int bookId, LocalDate requestDate, String requestType, String status) {
            this.id = id;
            this.userId = userId;
            this.bookId = bookId;
            this.requestDate = requestDate;
            this.requestType = requestType;
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

      public LocalDate getRequestDate() {
            return requestDate;
      }

      public void setRequestDate(LocalDate requestDate) {
            this.requestDate = requestDate;
      }

      public String getRequestType() {
            return requestType;
      }

      public void setRequestType(String requestType) {
            this.requestType = requestType;
      }

      public String getStatus() {
            return status;
      }

      public void setStatus(String status) {
            this.status = status;
      }

}
