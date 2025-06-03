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
public interface IBaseDAO<T> {
    public List<T> getAll();
    public void save(T Obj) throws Exception;
    public void delete(int  id) throws Exception;
}
