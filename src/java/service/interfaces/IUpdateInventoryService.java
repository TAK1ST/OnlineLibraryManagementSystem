/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.interfaces;

/**
 *
 * @author asus
 */
public interface IUpdateInventoryService {
      public int getTotalBook();
      public int getTotalBookAvailable(); 
      public int getBorrowBook();
      public int getBorrowLowStock();
}
