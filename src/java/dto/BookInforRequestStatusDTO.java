/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

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

      public BookInforRequestStatusDTO() {
      }

      public BookInforRequestStatusDTO(int id, String title, String isbn, int availableCopies, String statusAction) {
            this.id = id;
            this.title = title;
            this.isbn = isbn;
            this.availableCopies = availableCopies;
            this.statusAction = statusAction;
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
            this.statusAction = statusAction;
      }

      
}
