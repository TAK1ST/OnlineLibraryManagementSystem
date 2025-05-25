/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.interfaces;

import entity.User;
import java.util.List;

/**
 *
 * @author asus
 * @param <T>
 */
public abstract class BaseDAO<T> {
    public abstract List<T> getAll();
    public abstract void save(User user);
    public abstract void delete(int  userId);
}
