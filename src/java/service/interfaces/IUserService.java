/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.interfaces;

import entity.User;
import java.util.List;

/**
 *
 * @author asus
 */
public interface IUserService {
      List <User> getAllUser();
      User getUserById(int id);
      User getUserEmail(String email);
      User getUserName(String name);
}
