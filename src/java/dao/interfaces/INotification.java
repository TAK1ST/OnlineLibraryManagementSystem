/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dao.interfaces;

import entity.Notification;
import java.util.List;

/**
 *
 * @author Admin
 */
public interface INotification {
    List<Notification> getNotificationsByUserId(int userId);
}
