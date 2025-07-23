package dao.implement;

import entity.OverdueBook;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;
import util.DBConnection;

/**
 * Updated OverdueBookDAO with fine integration
 */
public class OverdueBookDAO {

    /**
     * Get all overdue books with fine information
     */
    public List<OverdueBook> getAllOverdueBooks() {
        String sql = "SELECT \n"
                + "                br.id as borrow_id,\n"
                + "                br.user_id,\n"
                + "                br.book_id,\n"
                + "                br.borrow_date,\n"
                + "                br.due_date,\n"
                + "                br.return_date,\n"
                + "                br.status as borrow_status,\n"
                + "                DATEDIFF(day, br.due_date, COALESCE(br.return_date, GETDATE())) as overdue_days,\n"
                + "                \n"
                + "                -- User information\n"
                + "                u.name as user_name,\n"
                + "                u.email as user_email,\n"
                + "                u.role as user_role,\n"
                + "                u.status as user_status,\n"
                + "                \n"
                + "                -- Book information\n"
                + "                b.title as book_title,\n"
                + "                b.author as book_author,\n"
                + "                b.isbn as book_isbn,\n"
                + "                b.category as book_category,\n"
                + "                \n"
                + "                -- Fine information\n"
                + "                f.fine_amount,\n"
                + "                COALESCE(f.paid_status, 'unpaid') as paid_status\n"
                + "                \n"
                + "            FROM borrow_records br\n"
                + "            JOIN users u ON br.user_id = u.id\n"
                + "            JOIN books b ON br.book_id = b.id\n"
                + "            LEFT JOIN fines f ON br.id = f.borrow_id\n"
                + "            WHERE br.due_date < COALESCE(br.return_date, GETDATE())\n"
                + "                AND (br.status = 'borrowed' OR br.status = 'overdue')\n"
                + "            ORDER BY br.due_date ASC";

        List<OverdueBook> overdueBooks = new ArrayList<>();

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OverdueBook overdueBook = new OverdueBook();

                // Borrow record information
                overdueBook.setBorrowId(rs.getInt("borrow_id"));
                overdueBook.setUserId(rs.getInt("user_id"));
                overdueBook.setBookId(rs.getInt("book_id"));
                overdueBook.setBorrowDate(rs.getDate("borrow_date"));
                overdueBook.setDueDate(rs.getDate("due_date"));
                overdueBook.setReturnDate(rs.getDate("return_date"));
                overdueBook.setBorrowStatus(rs.getString("borrow_status"));
                overdueBook.setOverdueDays(rs.getInt("overdue_days"));

                // User information
                overdueBook.setUserName(rs.getString("user_name"));
                overdueBook.setUserEmail(rs.getString("user_email"));
                overdueBook.setUserRole(rs.getString("user_role"));
                overdueBook.setUserStatus(rs.getString("user_status"));

                // Book information
                overdueBook.setBookTitle(rs.getString("book_title"));
                overdueBook.setBookAuthor(rs.getString("book_author"));
                overdueBook.setBookIsbn(rs.getString("book_isbn"));
                overdueBook.setBookCategory(rs.getString("book_category"));

                // Fine information
                Long fineAmount = rs.getLong("fine_amount");
                if (rs.wasNull()) {
                    // Calculate fine if not exists
                    fineAmount = calculateFine(overdueBook.getOverdueDays());
                    // Create fine record
                    createFineRecord(overdueBook.getBorrowId(), fineAmount);
                }
                overdueBook.setFineAmount(fineAmount);
                overdueBook.setPaidStatus(rs.getString("paid_status"));

                overdueBooks.add(overdueBook);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return overdueBooks;
    }

    /**
     * Get total number of overdue books
     */
    public int getTotalOverdueBooks() {
        String sql = "SELECT COUNT(*) as total \n"
                + "            FROM borrow_records br \n"
                + "            WHERE br.due_date < COALESCE(br.return_date, GETDATE())\n"
                + "                AND (br.status = 'borrowed' OR br.status = 'overdue')";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get total fines amount
     */
    public double getTotalFines() {
        String sql = "SELECT COALESCE(SUM(f.fine_amount), 0) as total\n"
                + "            FROM fines f\n"
                + "            JOIN borrow_records br ON f.borrow_id = br.id\n"
                + "            WHERE br.due_date < COALESCE(br.return_date, GETDATE())";

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
     * Get average overdue days
     */
    public int getAverageOverdueDays() {
        String sql = "SELECT COALESCE(AVG(DATEDIFF(day, br.due_date, COALESCE(br.return_date, GETDATE()))), 0) as avg_days\n"
                + "            FROM borrow_records br\n"
                + "            WHERE br.due_date < COALESCE(br.return_date, GETDATE())\n"
                + "                AND (br.status = 'borrowed' OR br.status = 'overdue')";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("avg_days");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get overdue book by borrow ID
     */
    public OverdueBook getOverdueBookById(int borrowId) {
        String sql = "SELECT \n"
                + "                br.id as borrow_id,\n"
                + "                br.user_id,\n"
                + "                br.book_id,\n"
                + "                br.borrow_date,\n"
                + "                br.due_date,\n"
                + "                br.return_date,\n"
                + "                br.status as borrow_status,\n"
                + "                DATEDIFF(day, br.due_date, COALESCE(br.return_date, GETDATE())) as overdue_days,\n"
                + "                \n"
                + "                -- User information\n"
                + "                u.name as user_name,\n"
                + "                u.email as user_email,\n"
                + "                u.role as user_role,\n"
                + "                u.status as user_status,\n"
                + "                \n"
                + "                -- Book information\n"
                + "                b.title as book_title,\n"
                + "                b.author as book_author,\n"
                + "                b.isbn as book_isbn,\n"
                + "                b.category as book_category,\n"
                + "                \n"
                + "                -- Fine information\n"
                + "                f.fine_amount,\n"
                + "                COALESCE(f.paid_status, 'unpaid') as paid_status\n"
                + "                \n"
                + "            FROM borrow_records br\n"
                + "            JOIN users u ON br.user_id = u.id\n"
                + "            JOIN books b ON br.book_id = b.id\n"
                + "            LEFT JOIN fines f ON br.id = f.borrow_id\n"
                + "            WHERE br.id = ? AND br.due_date < COALESCE(br.return_date, GETDATE())";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, borrowId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                OverdueBook overdueBook = new OverdueBook();

                // Borrow record information
                overdueBook.setBorrowId(rs.getInt("borrow_id"));
                overdueBook.setUserId(rs.getInt("user_id"));
                overdueBook.setBookId(rs.getInt("book_id"));
                overdueBook.setBorrowDate(rs.getDate("borrow_date"));
                overdueBook.setDueDate(rs.getDate("due_date"));
                overdueBook.setReturnDate(rs.getDate("return_date"));
                overdueBook.setBorrowStatus(rs.getString("borrow_status"));
                overdueBook.setOverdueDays(rs.getInt("overdue_days"));

                // User information
                overdueBook.setUserName(rs.getString("user_name"));
                overdueBook.setUserEmail(rs.getString("user_email"));
                overdueBook.setUserRole(rs.getString("user_role"));
                overdueBook.setUserStatus(rs.getString("user_status"));

                // Book information
                overdueBook.setBookTitle(rs.getString("book_title"));
                overdueBook.setBookAuthor(rs.getString("book_author"));
                overdueBook.setBookIsbn(rs.getString("book_isbn"));
                overdueBook.setBookCategory(rs.getString("book_category"));

                // Fine information
                Long fineAmount = rs.getLong("fine_amount");
                if (rs.wasNull()) {
                    // Calculate fine if not exists
                    fineAmount = calculateFine(overdueBook.getOverdueDays());
                    // Create fine record
                    createFineRecord(overdueBook.getBorrowId(), fineAmount);
                }
                overdueBook.setFineAmount(fineAmount);
                overdueBook.setPaidStatus(rs.getString("paid_status"));

                return overdueBook;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Calculate fine based on overdue days Rule: $1 per day for first 30 days,
     * $2 per day after that
     */
    private Long calculateFine(int overdueDays) {
        if (overdueDays <= 0) {
            return 0L;
        }

        long fine;
        if (overdueDays <= 30) {
            fine = overdueDays * 1L; // $1 per day
        } else {
            fine = 30L * 1L + (overdueDays - 30L) * 2L; // $1 for first 30 days, $2 for remaining
        }

        return fine;
    }

    /**
     * Create fine record for overdue book
     */
    private boolean createFineRecord(int borrowId, double fineAmount) {
        String sql = "INSERT INTO fines (borrow_id, fine_amount, paid_status) VALUES (?, ?, 'unpaid')";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, borrowId);
            ps.setDouble(2, fineAmount);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Update overdue book status
     */
    public boolean updateOverdueBookStatus(int borrowId, String status) {
        String sql = "UPDATE borrow_records SET status = ? WHERE id = ?";

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
     * Mark book as returned
     */
    public boolean markBookAsReturned(int borrowId) {
        String sql = "UPDATE borrow_records SET status = 'returned', return_date = GETDATE() WHERE id = ?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, borrowId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Get overdue books by user ID
     */
    public List<OverdueBook> getOverdueBooksByUserId(int userId) {
        String sql = "SELECT \n"
                + "                br.id as borrow_id,\n"
                + "                br.user_id,\n"
                + "                br.book_id,\n"
                + "                br.borrow_date,\n"
                + "                br.due_date,\n"
                + "                br.return_date,\n"
                + "                br.status as borrow_status,\n"
                + "                DATEDIFF(day, br.due_date, COALESCE(br.return_date, GETDATE())) as overdue_days,\n"
                + "                \n"
                + "                -- User information\n"
                + "                u.name as user_name,\n"
                + "                u.email as user_email,\n"
                + "                u.role as user_role,\n"
                + "                u.status as user_status,\n"
                + "                \n"
                + "                -- Book information\n"
                + "                b.title as book_title,\n"
                + "                b.author as book_author,\n"
                + "                b.isbn as book_isbn,\n"
                + "                b.category as book_category,\n"
                + "                \n"
                + "                -- Fine information\n"
                + "                f.fine_amount,\n"
                + "                COALESCE(f.paid_status, 'unpaid') as paid_status\n"
                + "                \n"
                + "            FROM borrow_records br\n"
                + "            JOIN users u ON br.user_id = u.id\n"
                + "            JOIN books b ON br.book_id = b.id\n"
                + "            LEFT JOIN fines f ON br.id = f.borrow_id\n"
                + "            WHERE br.user_id = ? \n"
                + "                AND br.due_date < COALESCE(br.return_date, GETDATE())\n"
                + "                AND (br.status = 'borrowed' OR br.status = 'overdue')\n"
                + "            ORDER BY br.due_date ASC";

        List<OverdueBook> overdueBooks = new ArrayList<>();

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OverdueBook overdueBook = new OverdueBook();

                // Set all properties similar to getAllOverdueBooks method
                overdueBook.setBorrowId(rs.getInt("borrow_id"));
                overdueBook.setUserId(rs.getInt("user_id"));
                overdueBook.setBookId(rs.getInt("book_id"));
                overdueBook.setBorrowDate(rs.getDate("borrow_date"));
                overdueBook.setDueDate(rs.getDate("due_date"));
                overdueBook.setReturnDate(rs.getDate("return_date"));
                overdueBook.setBorrowStatus(rs.getString("borrow_status"));
                overdueBook.setOverdueDays(rs.getInt("overdue_days"));

                overdueBook.setUserName(rs.getString("user_name"));
                overdueBook.setUserEmail(rs.getString("user_email"));
                overdueBook.setUserRole(rs.getString("user_role"));
                overdueBook.setUserStatus(rs.getString("user_status"));

                overdueBook.setBookTitle(rs.getString("book_title"));
                overdueBook.setBookAuthor(rs.getString("book_author"));
                overdueBook.setBookIsbn(rs.getString("book_isbn"));
                overdueBook.setBookCategory(rs.getString("book_category"));

                Long fineAmount = rs.getLong("fine_amount");
                if (rs.wasNull()) {
                    fineAmount = calculateFine(overdueBook.getOverdueDays());
                    createFineRecord(overdueBook.getBorrowId(), fineAmount);
                }
                overdueBook.setFineAmount(fineAmount);
                overdueBook.setPaidStatus(rs.getString("paid_status"));

                overdueBooks.add(overdueBook);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return overdueBooks;
    }

    /**
     * Get overdue books statistics for dashboard
     */
    public OverdueBookStats getOverdueBookStats() {
        String sql = "SELECT \n"
                + "                COUNT(*) as total_overdue,\n"
                + "                COALESCE(SUM(f.fine_amount), 0) as total_fines,\n"
                + "                COALESCE(AVG(DATEDIFF(day, br.due_date, COALESCE(br.return_date, GETDATE()))), 0) as avg_days,\n"
                + "                COUNT(CASE WHEN f.paid_status = 'unpaid' THEN 1 END) as unpaid_count,\n"
                + "                COALESCE(SUM(CASE WHEN f.paid_status = 'unpaid' THEN f.fine_amount ELSE 0 END), 0) as unpaid_amount,\n"
                + "                COALESCE(SUM(CASE WHEN f.paid_status = 'paid' THEN f.fine_amount ELSE 0 END), 0) as paid_amount\n"
                + "            FROM borrow_records br\n"
                + "            LEFT JOIN fines f ON br.id = f.borrow_id\n"
                + "            WHERE br.due_date < COALESCE(br.return_date, GETDATE())\n"
                + "                AND (br.status = 'borrowed' OR br.status = 'overdue')";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new OverdueBookStats(
                        rs.getInt("total_overdue"),
                        rs.getDouble("total_fines"),
                        rs.getInt("avg_days"),
                        rs.getInt("unpaid_count"),
                        rs.getDouble("unpaid_amount"),
                        rs.getDouble("paid_amount")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new OverdueBookStats(0, 0.0, 0, 0, 0.0, 0.0);
    }

    /**
     * Search overdue books by criteria
     */
    public List<OverdueBook> searchOverdueBooks(String searchTerm, String status, String paymentStatus) {
        StringBuilder sql = new StringBuilder("SELECT \n"
                + "                br.id as borrow_id,\n"
                + "                br.user_id,\n"
                + "                br.book_id,\n"
                + "                br.borrow_date,\n"
                + "                br.due_date,\n"
                + "                br.return_date,\n"
                + "                br.status as borrow_status,\n"
                + "                DATEDIFF(day, br.due_date, COALESCE(br.return_date, GETDATE())) as overdue_days,\n"
                + "                \n"
                + "                -- User information\n"
                + "                u.name as user_name,\n"
                + "                u.email as user_email,\n"
                + "                u.role as user_role,\n"
                + "                u.status as user_status,\n"
                + "                \n"
                + "                -- Book information\n"
                + "                b.title as book_title,\n"
                + "                b.author as book_author,\n"
                + "                b.isbn as book_isbn,\n"
                + "                b.category as book_category,\n"
                + "                \n"
                + "                -- Fine information\n"
                + "                f.fine_amount,\n"
                + "                COALESCE(f.paid_status, 'unpaid') as paid_status\n"
                + "                \n"
                + "            FROM borrow_records br\n"
                + "            JOIN users u ON br.user_id = u.id\n"
                + "            JOIN books b ON br.book_id = b.id\n"
                + "            LEFT JOIN fines f ON br.id = f.borrow_id\n"
                + "            WHERE br.due_date < COALESCE(br.return_date, GETDATE())\n"
                + "                AND (br.status = 'borrowed' OR br.status = 'overdue')");

        List<Object> parameters = new ArrayList<>();

        // Add search criteria
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (b.title LIKE ? OR b.author LIKE ? OR u.name LIKE ? OR u.email LIKE ?)");
            String searchPattern = "%" + searchTerm.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }

        if (status != null && !status.trim().isEmpty() && !"all".equals(status)) {
            sql.append(" AND br.status = ?");
            parameters.add(status);
        }

        if (paymentStatus != null && !paymentStatus.trim().isEmpty() && !"all".equals(paymentStatus)) {
            sql.append(" AND f.paid_status = ?");
            parameters.add(paymentStatus);
        }

        sql.append(" ORDER BY br.due_date ASC");

        List<OverdueBook> overdueBooks = new ArrayList<>();

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OverdueBook overdueBook = new OverdueBook();

                // Set all properties
                overdueBook.setBorrowId(rs.getInt("borrow_id"));
                overdueBook.setUserId(rs.getInt("user_id"));
                overdueBook.setBookId(rs.getInt("book_id"));
                overdueBook.setBorrowDate(rs.getDate("borrow_date"));
                overdueBook.setDueDate(rs.getDate("due_date"));
                overdueBook.setReturnDate(rs.getDate("return_date"));
                overdueBook.setBorrowStatus(rs.getString("borrow_status"));
                overdueBook.setOverdueDays(rs.getInt("overdue_days"));

                overdueBook.setUserName(rs.getString("user_name"));
                overdueBook.setUserEmail(rs.getString("user_email"));
                overdueBook.setUserRole(rs.getString("user_role"));
                overdueBook.setUserStatus(rs.getString("user_status"));

                overdueBook.setBookTitle(rs.getString("book_title"));
                overdueBook.setBookAuthor(rs.getString("book_author"));
                overdueBook.setBookIsbn(rs.getString("book_isbn"));
                overdueBook.setBookCategory(rs.getString("book_category"));

                Long fineAmount = rs.getLong("fine_amount");
                if (rs.wasNull()) {
                    fineAmount = calculateFine(overdueBook.getOverdueDays());
                    createFineRecord(overdueBook.getBorrowId(), fineAmount);
                }
                overdueBook.setFineAmount(fineAmount);
                overdueBook.setPaidStatus(rs.getString("paid_status"));

                overdueBooks.add(overdueBook);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return overdueBooks;
    }

    /**
     * Inner class for overdue book statistics
     */
    public static class OverdueBookStats {

        private int totalOverdue;
        private double totalFines;
        private int averageDays;
        private int unpaidCount;
        private double unpaidAmount;
        private double paidAmount;

        public OverdueBookStats(int totalOverdue, double totalFines, int averageDays,
                int unpaidCount, double unpaidAmount, double paidAmount) {
            this.totalOverdue = totalOverdue;
            this.totalFines = totalFines;
            this.averageDays = averageDays;
            this.unpaidCount = unpaidCount;
            this.unpaidAmount = unpaidAmount;
            this.paidAmount = paidAmount;
        }

        // Getters
        public int getTotalOverdue() {
            return totalOverdue;
        }

        public double getTotalFines() {
            return totalFines;
        }

        public int getAverageDays() {
            return averageDays;
        }

        public int getUnpaidCount() {
            return unpaidCount;
        }

        public double getUnpaidAmount() {
            return unpaidAmount;
        }

        public double getPaidAmount() {
            return paidAmount;
        }
    }
}
