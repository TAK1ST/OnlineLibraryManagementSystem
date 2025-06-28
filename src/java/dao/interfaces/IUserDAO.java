/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.interfaces;

import entity.User;

/**
 *
 * @author asus
 */
public interface IUserDAO extends IBaseDAO<User>{
      public User getId(int id);
      public User getName(String name);
      public User getEmail(String email);
}
