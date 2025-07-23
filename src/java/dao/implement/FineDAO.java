package dao.implement;

import entity.BorrowRecord;
import entity.Fine;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import util.DBConnection;

/**
 * Data Access Object for Fine entity Handles all database operations related to
 * fines
 */
public class FineDAO {

    /**
     * Get fine by borrow ID
     */
    public Fine getFineByBorrowId(int borrowId) {
        String sql = "SELECT * FROM fines WHERE borrow_id = ?";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, borrowId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Fine fine = new Fine();
                fine.setId(rs.getInt("id"));
                fine.setBorrowId(rs.getInt("borrow_id"));
                fine.setFineAmount(rs.getLong("fine_amount"));
                fine.setPaidStatus(rs.getString("paid_status"));

                return fine;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Create a new fine record
     */
    public boolean createFine(int borrowId, Long fineAmount) {
        String sql = "INSERT INTO fines (borrow_id, fine_amount, paid_status) VALUES (?, ?, 'unpaid')";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, borrowId);
            ps.setLong(2, fineAmount);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update fine status (paid/unpaid)
     */
    public boolean updateFineStatus(int borrowId, String status) {
        String sql = "UPDATE fines SET paid_status = ? WHERE borrow_id = ?";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, borrowId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update fine amount
     */
    public boolean updateFineAmount(int borrowId, Long newAmount) {
        String sql = "UPDATE fines SET fine_amount = ? WHERE borrow_id = ?";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, newAmount);
            ps.setInt(2, borrowId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get total unpaid fines amount
     */
    public double getTotalUnpaidFines() {
        String sql = "SELECT COALESCE(SUM(fine_amount), 0) as total FROM fines WHERE paid_status = 'unpaid'";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    /**
     * Get total paid fines amount
     */
    public double getTotalPaidFines() {
        String sql = "SELECT COALESCE(SUM(fine_amount), 0) as total FROM fines WHERE paid_status = 'paid'";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    /**
     * Get count of unpaid fines
     */
    public int getUnpaidFinesCount() {
        String sql = "SELECT COUNT(*) as count FROM fines WHERE paid_status = 'unpaid'";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get count of paid fines
     */
    public int getPaidFinesCount() {
        String sql = "SELECT COUNT(*) as count FROM fines WHERE paid_status = 'paid'";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get all fines with detailed information
     */
    public List<Fine> getAllFinesWithDetails() {
        String sql = "SELECT f.*, br.user_id, br.book_id, br.borrow_date, br.due_date, br.return_date,\n"
                + "                   u.name as user_name, u.email as user_email,\n"
                + "                   b.title as book_title, b.author as book_author\n"
                + "            FROM fines f\n"
                + "            JOIN borrow_records br ON f.borrow_id = br.id\n"
                + "            JOIN users u ON br.user_id = u.id\n"
                + "            JOIN books b ON br.book_id = b.id\n"
                + "            ORDER BY f.id DESC";

        List<Fine> fines = new ArrayList<>();
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Fine fine = new Fine();
                fine.setId(rs.getInt("id"));
                fine.setBorrowId(rs.getInt("borrow_id"));
                fine.setFineAmount(rs.getLong("fine_amount"));
                fine.setPaidStatus(rs.getString("paid_status"));
                

                // Additional details can be set here if needed
                fines.add(fine);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return fines;
    }

    /**
     * Delete fine by borrow ID
     */
    public boolean deleteFineByBorrowId(int borrowId) {
        String sql = "DELETE FROM fines WHERE borrow_id = ?";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, borrowId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Check if fine exists for borrow record
     */
    public boolean fineExists(int borrowId) {
        String sql = "SELECT 1 FROM fines WHERE borrow_id = ?";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, borrowId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get fines by status
     */
    public List<Fine> getFinesByStatus(String status) {
        String sql = "SELECT * FROM fines WHERE paid_status = ? ORDER BY id DESC";
        List<Fine> fines = new ArrayList<>();

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Fine fine = new Fine();
                fine.setId(rs.getInt("id"));
                fine.setBorrowId(rs.getInt("borrow_id"));
                fine.setFineAmount(rs.getLong("fine_amount"));
                fine.setPaidStatus(rs.getString("paid_status"));
                fines.add(fine);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return fines;
    }
}
