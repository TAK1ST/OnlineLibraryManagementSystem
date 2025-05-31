/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.implement;

import dao.implement.UserDAO;
import entity.User;
import java.util.List;

/**
 *
 * @author asus
 */
public class StatisticService {

      private final UserDAO userDAO;
//      private final BookDAO bookDAO;
//      private final List<Book> bookList;

      public StatisticService() {
            userDAO = new UserDAO();
//            bookDAO = new BookDAO();
      }

      public int getTotalUser() {
            List<User> userList = userDAO.getAll();
            int count = 0;
            for (User user : userList) {
                  count++;
            }
            return count;
      }
}
