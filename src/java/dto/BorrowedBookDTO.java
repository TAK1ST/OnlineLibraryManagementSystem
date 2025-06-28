/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

/**
 *
 * @author asus
 */
public class BorrowedBookDTO {

      private int id;
      private String bookName;
      private String author;
      private int borrowCount;

      public BorrowedBookDTO() {
      }

      public BorrowedBookDTO(int id, String bookName, String author, int borrowCount) {
            this.id = id;
            this.bookName = bookName;
            this.author = author;
            this.borrowCount = borrowCount;
      }
      
      public int getId() {
            return id;
      }

      public void setId(int id) {
            this.id = id;
      }

      public String getBookName() {
            return bookName;
      }

      public void setBookName(String bookName) {
            this.bookName = bookName;
      }

      public String getAuthor() {
            return author;
      }

      public void setAuthor(String author) {
            this.author = author;
      }

      public int getBorrowCount() {
            return borrowCount;
      }

      public void setBorrowCount(int borrowCount) {
            this.borrowCount = borrowCount;
      }
}
