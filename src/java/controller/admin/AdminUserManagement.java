package controller.admin;

import constant.ViewURL;
import static constant.constance.RECORDS_PER_LOAD;
import entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import service.implement.UserManagerService;

/**
 *
 * @author asus
 */
public class AdminUserManagement extends BaseAdminController {

      @Override
      public void doGet(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            // Check authentication and authorization
            checkAdminAuthentication(request, response);

            String userId = request.getParameter("userId");
            String currentStatus = request.getParameter("newStatus");

            UserManagerService userService = new UserManagerService();
            List<User> userList = userService.getAllUserLazyLoading(null, null, 0);

            if (userId != null && currentStatus != null) {
                  try {
                        int id = Integer.parseInt(userId);
                        User targetUser = userService.getUserById(id);
                        if (targetUser == null) {
                              request.setAttribute("errorMessage", "User not found");
                        } else if ("admin".equalsIgnoreCase(targetUser.getRole())) {
                              request.setAttribute("errorMessage", "Cannot update status of admin users");
                        } else {
                              userService.updateUser(id, null, null, currentStatus);
                        }
                  } catch (NumberFormatException e) {
                        request.setAttribute("errorMessage", "Invalid user ID format");
                  } catch (Exception e) {
                        e.printStackTrace();
                        request.setAttribute("errorMessage", "Error updating user status");
                  }
            }

            request.setAttribute("recordsPerPage", RECORDS_PER_LOAD);
            request.setAttribute("userList", userList);
            request.setAttribute("offset", 0);

            request.getRequestDispatcher(ViewURL.ADMIN_USER_MANAGEMENT).forward(request, response);
      }

      @Override
      public void doPost(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            // Check authentication and authorization
            User adminUser = checkAdminAuthentication(request, response);
            if (adminUser == null) {
                  return; // Already redirected to login
            }

            HttpSession session = request.getSession();
            UserManagerService userService = new UserManagerService();

            try {
                  int userId = Integer.parseInt(request.getParameter("userId"));
                  String name = request.getParameter("name");
                  String password = request.getParameter("password");
                  String status = request.getParameter("status");

                  User us = userService.getUserById(userId);
                  if (us == null) {
                        session.setAttribute("errorMessage", "User not found");
                  } else {
                        us.setName(name);
                        if (password != null && !password.trim().isEmpty()) {
                              if (password.length() < 6) {
                                    session.setAttribute("errorMessage", "Password must be at least 6 characters");
                              } else {
                                    us.setPassword(password);
                                    userService.updateUser(userId, name, password, status);
                                    session.setAttribute("successMessage", "User updated successfully");
                              }
                        } else {
                              userService.updateUser(userId, name, null, status);
                              session.setAttribute("successMessage", "User updated successfully");
                        }
                  }
            } catch (NumberFormatException e) {
                  session.setAttribute("errorMessage", "Invalid user ID format");
            } catch (Exception e) {
                  e.printStackTrace();
                  session.setAttribute("errorMessage", "Error updating user");
            }

            response.sendRedirect(request.getContextPath() + "/usermanagement");
      }

      @Override
      public String getServletInfo() {
            return "Admin User Management Controller";
      }
}
