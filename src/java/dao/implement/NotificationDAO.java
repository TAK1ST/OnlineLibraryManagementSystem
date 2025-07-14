/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.implement;

import dao.interfaces.INotification;
import entity.Notification;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import util.DBConnection;

/**
 *
 * @author Admin
 */
public class NotificationDAO {

    public List<Notification> getNotificationsByUserId(int userId) {
        List<Notification> list = new ArrayList<>();
        Connection conn;
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Notification n = new Notification();
                n.setId(rs.getInt("id"));
                n.setUserId(userId);
                n.setMessage(rs.getString("message"));
                n.setRead(rs.getBoolean("is_read"));
                n.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(n);
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(NotificationDAO.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(NotificationDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return list;
    }

    public boolean createNotification(Notification notification) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO notifications (user_id, message, is_read, created_at) VALUES (?, ?, ?, NOW())";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, notification.getUserId());
            ps.setString(2, notification.getMessage());
            ps.setBoolean(3, notification.isIsRead());

            int result = ps.executeUpdate();
            return result > 0;
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(NotificationDAO.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        } catch (SQLException ex) {
            Logger.getLogger(NotificationDAO.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        } finally {
            try {
                if (ps != null) {
                    ps.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(NotificationDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }


public boolean markAsRead(int notificationId, int userId) {
    Connection conn = null;
    PreparedStatement ps = null;
    try {
        conn = DBConnection.getConnection();
        String sql = "UPDATE notifications SET is_read = true WHERE id = ? AND user_id = ?";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, notificationId);
        ps.setInt(2, userId);
        
        int result = ps.executeUpdate();
        return result > 0;
    } catch (ClassNotFoundException ex) {
        Logger.getLogger(NotificationDAO.class.getName()).log(Level.SEVERE, null, ex);
        return false;
    } catch (SQLException ex) {
        Logger.getLogger(NotificationDAO.class.getName()).log(Level.SEVERE, null, ex);
        return false;
    } finally {
        try {
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException ex) {
            Logger.getLogger(NotificationDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}

    public int getUnreadCount(int userId) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = false";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(NotificationDAO.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(NotificationDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                Logger.getLogger(NotificationDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return 0;
    }
}
