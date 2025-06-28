/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.implement;

import dao.implement.UserDAO;
import entity.User;
import java.util.ArrayList;
import java.util.List;
import service.interfaces.IUserService;

/**
 *
 * @author asus
 */
public class UserManagerService implements IUserService {

      private final UserDAO userDAO = new UserDAO();

      @Override
      public List<User> getAllUser() {
            return userDAO.getAll();
      }

      public List<User> getUsersLazyLoading(int offset) {
            return userDAO.getUserLazyPageLoading(offset);
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

      public List<User> getAllUserLazyLoading(String searchEmail, String searchName, int offset) {
            List<User> userList;
            if ((searchName != null && !searchName.trim().isEmpty())
                    || (searchEmail != null && !searchEmail.trim().isEmpty())) {
                  userList = userDAO.getUserBySearch(searchEmail, searchName, offset);
            } else {
                  userList = userDAO.getUserLazyPageLoading(offset);
            }
            return userList;
      }
      
      public int updateUser(int userId, String username, String password, String status) 
      {
            return userDAO.updateUser(userId, username, password, status);
      }
}
