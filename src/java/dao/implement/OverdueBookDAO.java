/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.implement;

import entity.OverdueBook;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import util.DBConnection;

/**
 *
 * @author CAU_TU
 */
public class OverdueBookDAO {

    public List<OverdueBook> getAllOverdueBooks() {
        List<OverdueBook> list = new ArrayList<>();
        String sql = "SELECT br.id AS borrow_id, " +
                    "u.id AS user_id, u.name AS user_name, u.email AS user_email, u.role AS user_role, u.status AS user_status, " +
                    "b.id AS book_id, b.title AS book_title, b.author AS book_author, b.isbn AS book_isbn, b.category AS book_category, " +
                    "br.borrow_date, br.due_date, br.return_date, br.status AS borrow_status, " +
                    "DATEDIFF(DAY, br.due_date, GETDATE()) AS overdue_days, " +
                    "ISNULL(f.fine_amount, 0) AS fine_amount, " +
                    "ISNULL(f.paid_status, 'unpaid') AS paid_status " +
                    "FROM borrow_records br " +
                    "JOIN users u ON br.user_id = u.id " +
                    "JOIN books b ON br.book_id = b.id " +
                    "LEFT JOIN fines f ON f.borrow_id = br.id " +
                    "WHERE br.status = 'overdue' AND br.return_date IS NULL " +
                    "ORDER BY br.due_date ASC";

        try (Connection conn = DBConnection.getConnection();  
             PreparedStatement ps = conn.prepareStatement(sql);  
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                OverdueBook ob = new OverdueBook();
                
                // Borrow record info
                ob.setBorrowId(rs.getInt("borrow_id"));
                ob.setBorrowDate(rs.getDate("borrow_date"));
                ob.setDueDate(rs.getDate("due_date"));
                ob.setReturnDate(rs.getDate("return_date"));
                ob.setBorrowStatus(rs.getString("borrow_status"));
                
                // User info
                ob.setUserId(rs.getInt("user_id"));
                ob.setUserName(rs.getString("user_name"));
                ob.setUserEmail(rs.getString("user_email"));
                ob.setUserRole(rs.getString("user_role"));
                ob.setUserStatus(rs.getString("user_status"));
                
                // Book info
                ob.setBookId(rs.getInt("book_id"));
                ob.setBookTitle(rs.getString("book_title"));
                ob.setBookAuthor(rs.getString("book_author"));
                ob.setBookIsbn(rs.getString("book_isbn"));
                ob.setBookCategory(rs.getString("book_category"));
                
                // Overdue and fine info
                ob.setOverdueDays(rs.getInt("overdue_days"));
                ob.setFineAmount(rs.getBigDecimal("fine_amount"));
                ob.setPaidStatus(rs.getString("paid_status"));
                
                list.add(ob);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Get total overdue books count
    public int getTotalOverdueBooks() {
        int count = 0;
        String sql = "SELECT COUNT(*) as total FROM borrow_records WHERE status = 'overdue' AND return_date IS NULL";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                count = rs.getInt("total");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return count;
    }
    
    // Get total fines amount
    public double getTotalFines() {
        double total = 0.0;
        String sql = "SELECT SUM(ISNULL(f.fine_amount, 0)) as total_fines " +
                    "FROM borrow_records br " +
                    "LEFT JOIN fines f ON f.borrow_id = br.id " +
                    "WHERE br.status = 'overdue' AND br.return_date IS NULL";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                total = rs.getDouble("total_fines");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return total;
    }
    
    // Get average overdue days
    public int getAverageOverdueDays() {
        int avg = 0;
        String sql = "SELECT AVG(DATEDIFF(DAY, br.due_date, GETDATE())) as avg_days " +
                    "FROM borrow_records br " +
                    "WHERE br.status = 'overdue' AND br.return_date IS NULL";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                avg = rs.getInt("avg_days");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return avg;
    }
}