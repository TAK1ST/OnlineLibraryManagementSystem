/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.implement;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import util.DBConnection;

/**
 *
 * @author asus
 */
public class SystemConfigDAO {

      public boolean updateOverdueFine(float overdueFine) {
            // step 1: connection
            Connection cn = null;
            PreparedStatement prst = null; 
            boolean isUpdated = false;
            try {
                  cn = DBConnection.getConnection();
                  if (cn != null) {

                        // step 2: query and execute
                        String sql = "UPDATE [dbo].[system_config]\n"
                                + "SET [config_value] = ?\n"
                                + "WHERE [config_key] = 'overdue_fine_per_day'";

                        // init OOP, just prepare not start
                        prst = cn.prepareStatement(sql); // Gán vào biến đã khai báo ngoài try
                        // value 1 = place at the first <?>
                        prst.setFloat(1, overdueFine);
                        int rowsAffected = prst.executeUpdate();

                        if (rowsAffected > 0) {
                              System.out.println("update overdue fine successfully" + rowsAffected);
                              isUpdated = true;
                        } else {
                              System.out.println("update overdue fine fail.");
                        }
                  }
            } catch (SQLException e) { // Bắt lỗi SQL cụ thể hơn
                  System.err.println("Error: " + e.getMessage()); // Dùng System.err cho lỗi
                  e.printStackTrace(); // In stack trace để debug
            } catch (Exception e) { // Bắt các lỗi khác (ví dụ: lỗi kết nối database)
                  System.err.println("Unexpected Error: " + e.getMessage());
                  e.printStackTrace();
            } finally {
                  try {
                        if (prst != null) {
                              prst.close();
                        }
                  } catch (SQLException e) {
                        System.err.println("PreparedStatement Error: " + e.getMessage());
                        e.printStackTrace();
                  }
                  try {
                        if (cn != null) {
                              cn.close();
                        }
                  } catch (SQLException e) {
                        System.err.println("Error Connection: " + e.getMessage());
                        e.printStackTrace();
                  }
            }
            return isUpdated;
      }
     
      public boolean updateReturnFine(float returnFine) {
            // step 1: connection
            Connection cn = null;
            PreparedStatement prst = null; 
            boolean isUpdated = false;

            try {
                  cn = DBConnection.getConnection();
                  if (cn != null) {

                        // step 2: query and execute
                        String sql = "UPDATE [dbo].[system_config]\n"
                                + "SET [config_value] = ?\n"
                                + "WHERE [config_key] = 'default_borrow_duration_days'";

                        // init OOP, just prepare not start
                        prst = cn.prepareStatement(sql); // Gán vào biến đã khai báo ngoài try
                        // value 1 = place at the first <?>
                        prst.setFloat(1, returnFine);
                        int rowsAffected = prst.executeUpdate();

                        if (rowsAffected > 0) {
                              System.out.println("update return fine successfully" + rowsAffected);
                              isUpdated = true;
                        } else {
                              System.out.println("update return fine fail.");
                        }
                  }
            } catch (SQLException e) { // Bắt lỗi SQL cụ thể hơn
                  System.err.println("Error: " + e.getMessage()); // Dùng System.err cho lỗi
                  e.printStackTrace(); // In stack trace để debug
            } catch (Exception e) { // Bắt các lỗi khác (ví dụ: lỗi kết nối database)
                  System.err.println("Unexpected Error: " + e.getMessage());
                  e.printStackTrace();
            } finally {
                  try {
                        if (prst != null) {
                              prst.close();
                        }
                  } catch (SQLException e) {
                        System.err.println("PreparedStatement Error: " + e.getMessage());
                        e.printStackTrace();
                  }
                  try {
                        if (cn != null) {
                              cn.close();
                        }
                  } catch (SQLException e) {
                        System.err.println("Error Connection: " + e.getMessage());
                        e.printStackTrace();
                  }
            }
            return isUpdated;
      }
      
      public boolean updateBorrowUnitPrice(float borrowUnitPrice) {
            // step 1: connection
            Connection cn = null;
            PreparedStatement prst = null; 
            boolean isUpdated = false;

            try {
                  cn = DBConnection.getConnection();
                  if (cn != null) {

                        // step 2: query and execute
                        String sql = "UPDATE [dbo].[system_config]\n"
                                + "SET [config_value] = ?\n"
                                + "WHERE [config_key] = 'unit_price_per_book'";

                        // init OOP, just prepare not start
                        prst = cn.prepareStatement(sql); // Gán vào biến đã khai báo ngoài try
                        // value 1 = place at the first <?>
                        prst.setFloat(1, borrowUnitPrice);
                        int rowsAffected = prst.executeUpdate();

                        if (rowsAffected > 0) {
                              isUpdated = true;
                        } else {
                              System.out.println("update borrow unit price fail.");
                        }
                  }
            } catch (SQLException e) { // Bắt lỗi SQL cụ thể hơn
                  System.err.println("Error: " + e.getMessage()); // Dùng System.err cho lỗi
                  e.printStackTrace(); // In stack trace để debug
            } catch (Exception e) { // Bắt các lỗi khác (ví dụ: lỗi kết nối database)
                  System.err.println("Unexpected Error: " + e.getMessage());
                  e.printStackTrace();
            } finally {
                  try {
                        if (prst != null) {
                              prst.close();
                        }
                  } catch (SQLException e) {
                        System.err.println("PreparedStatement Error: " + e.getMessage());
                        e.printStackTrace();
                  }
                  try {
                        if (cn != null) {
                              cn.close();
                        }
                  } catch (SQLException e) {
                        System.err.println("Error Connection: " + e.getMessage());
                        e.printStackTrace();
                  }
            }
            return isUpdated;
      }
}
