/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.implement;

import dao.implement.UserDAO;
import entity.User;
import java.util.List;
import service.interfaces.IUserService;

/**
 *
 * @author asus
 */

public class StatisticService implements IUserService {

      private final UserDAO userDAO = new UserDAO();

      @Override
      public List<User> getAllUser() {
            return userDAO.getAll();
      }

      @Override
      public User getUserById(int id) {
            return userDAO.getId(id);
      }

      @Override
      public User getUserEmail(String email) {
            return userDAO.getEmail(email);
      }

      @Override
      public User getUserName(String name) {
            return userDAO.getName(name);
      }
}
