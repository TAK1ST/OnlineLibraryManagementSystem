/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import constant.ViewURL;
import static constant.constance.RECORDS_PER_LOAD;
import entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import service.implement.UserManagerService;

/**
 *
 * @author asus
 */
public class AdminUserManagement extends HttpServlet {

      @Override
      protected void doGet(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            UserManagerService userService = new UserManagerService();
            List<User> userList = userService.getAllUserLazyLoading(null, null, 0); 

            request.setAttribute("recordsPerPage", RECORDS_PER_LOAD);
            request.setAttribute("userList", userList);
            request.setAttribute("offset", 0);

            request.getRequestDispatcher(ViewURL.ADMIN_USER_MANAGEMENT).forward(request, response);
      }

      @Override
      protected void doPost(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
      }

      @Override
      public String getServletInfo() {
            return "Short description";
      }

}
