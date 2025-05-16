/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author asus
 */
public class DBConnection {
    private static final String DB_NAME = "YOUR_DB_NAME";
    private static final String DB_USER_NAME = "YOUR_USERNAME";
    private static final String DB_PASSWORD = "YORUR_PASSWORD";
    
    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Connection conn = null;
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/" + DB_NAME + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
        conn = DriverManager.getConnection(url, DB_USER_NAME, DB_PASSWORD);
        return conn;
    }

}
