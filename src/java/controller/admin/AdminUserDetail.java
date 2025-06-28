/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import constant.ViewURL;
import static constant.constance.RECORDS_PER_LOAD;
import entity.User;
import java.io.IOException;
import java.io.PrintWriter;
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
public class AdminUserDetail extends BaseAdminController {

      @Override
      protected void doGet(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {

            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            User adminUser = checkAdminAuthentication(request, response);
            if (adminUser == null) {
                  return;
            }

            UserManagerService userService = new UserManagerService();
            try {
                  int userId = Integer.parseInt(request.getParameter("userId"));
                  User user = userService.getUserById(userId);

                  if (user != null) {
                        request.setAttribute("selectedUser", user);
                  } else {
                        request.setAttribute("ERROR", "User not found");
                  }
            } catch (NumberFormatException e) {
                  request.setAttribute("ERROR", "Invalid user ID");
            }

            List<User> userList = userService.getAllUserLazyLoading(null, null, 0);
            request.setAttribute("userList", userList);
            request.setAttribute("offset", 0);
            request.setAttribute("recordsPerPage", RECORDS_PER_LOAD);

            // Chuyển tiếp đến admin-user-manager.jsp
            request.getRequestDispatcher(ViewURL.ADMIN_USER_MANAGEMENT).forward(request, response);
      }

      @Override
      protected void doPost(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
      }

      /**
       * Returns a short description of the servlet.
       *
       * @return a String containing servlet description
       */
      @Override
      public String getServletInfo() {
            return "Short description";
      }

}
