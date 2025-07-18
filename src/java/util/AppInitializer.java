/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author asus
 */
@WebListener
public class AppInitializer implements ServletContextListener {

      public void contextInitialized(ServletContextListener sce) {
            try ( Connection cn = DBConnection.getConnection();) {
                  String checkSql = "SELECT COUNT(*) FROM users WHERE email = ?";
                  PreparedStatement checkStmt = cn.prepareStatement(checkSql);
                  checkStmt.setString(1, "admin@example.com");

                  ResultSet rs = checkStmt.executeQuery();
                  rs.next();
                  int count = rs.getInt(1);
                  String pw_hash = BCrypt.hashpw("adminpassword", BCrypt.gensalt());
                  
                  if (count == 0) {
                        String insertSql = "INSERT INTO users (username, password, role, status, avatar) VALUES (?, ?, ?, ?,)";
                        PreparedStatement insertStmt = cn.prepareStatement(insertSql);
                        insertStmt.setString(1, "admin@example.com");
                        insertStmt.setString(2, pw_hash);
                        insertStmt.setString(3, "admin");
                        insertStmt.setString(4, "active");

                        int inserted = insertStmt.executeUpdate();
                        System.out.println("Admin account created! Rows inserted: " + inserted);
                  } else {
                        System.out.println("Admin already exists. Skipping insert.");
                  }

            } catch (Exception e) {
                  System.err.println("Error during admin account check/insert:");
                  e.printStackTrace();
            }
      }
}
