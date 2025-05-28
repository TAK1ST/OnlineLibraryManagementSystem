/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dto;

/**
 *
 * @author asus
 */
public class UserResponse {
      private String name;
      private String email;
      private String role;
      private String status;

      public UserResponse() {
      }

      public UserResponse(String name, String email, String role, String status) {
            this.name = name;
            this.email = email;
            this.role = role;
            this.status = status;
      }

      
      
      public String getName() {
            return name;
      }

      public String getEmail() {
            return email;
      }

      public String getRole() {
            return role;
      }

      public String getStatus() {
            return status;
      }
}
