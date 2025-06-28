/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

/**
 *
 * @author asus
 */
public class Book {

      private int id;
      private String title;
      private String isbn;
      private String author;
      private String category;
      private int publishedYear;
      private int totalCopies;
      private int availableCopies;
      private String status;
      private String imageUrl;

      public Book(int id, String title, String isbn, String author, String category, int publishedYear, int totalCopies, int availableCopies, String status, String imageUrl) {
            this.id = id;
            this.title = title;
            this.isbn = isbn;
            this.author = author;
            this.category = category;
            this.publishedYear = publishedYear;
            this.totalCopies = totalCopies;
            this.availableCopies = availableCopies;
            this.status = status;
            this.imageUrl = imageUrl;
      }

      public Book() {
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

      public String getAuthor() {
            return author;
      }

      public void setAuthor(String author) {
            this.author = author;
      }

      public String getCategory() {
            return category;
      }

      public void setCategory(String category) {
            this.category = category;
      }

      public int getPublishedYear() {
            return publishedYear;
      }

      public void setPublishedYear(int publishedYear) {
            this.publishedYear = publishedYear;
      }

      public int getTotalCopies() {
            return totalCopies;
      }

      public void setTotalCopies(int totalCopies) {
            this.totalCopies = totalCopies;
      }

      public int getAvailableCopies() {
            return availableCopies;
      }

      public void setAvailableCopies(int availableCopies) {
            this.availableCopies = availableCopies;
      }

      public String getStatus() {
            return status;
      }

      public void setStatus(String status) {
            this.status = status;
      }

      public String getImageUrl() {
            return imageUrl;
      }

      public void setImageUrl(String imageUrl) {
            this.imageUrl = imageUrl;
      }

}
