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
public class AdminSearchUser extends HttpServlet {

      @Override
      protected void doGet(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            UserManagerService userManagerService = new UserManagerService();
            int offset = 0;

            try {
                  String offsetParam = request.getParameter("offset");
                  if (offsetParam != null) {
                        offset = Math.max(0, Integer.parseInt(offsetParam));
                  }
            } catch (NumberFormatException e) {
                  System.err.println("Error parsing offset: " + e.getMessage());
                  offset = 0;
            }

            String searchEmail = request.getParameter("searchEmail");
            String searchName = request.getParameter("searchName");
            String action = request.getParameter("action");
            String ajax = request.getParameter("ajax");

            // Xử lý hành động "clear"
            if ("clear".equalsIgnoreCase(action)) {
                  searchName = null;
                  searchEmail = null;
            }

            // Chuẩn hóa input - chuyển chuỗi rỗng thành null
            searchName = (searchName != null && !searchName.trim().isEmpty()) ? searchName.trim() : null;
            searchEmail = (searchEmail != null && !searchEmail.trim().isEmpty()) ? searchEmail.trim() : null;

            // Debug log
            System.out.println("Search params - Name: " + searchName + ", Email: " + searchEmail + ", Offset: " + offset);

            // Lấy danh sách người dùng
            List<User> userList = userManagerService.getAllUserLazyLoading(searchEmail, searchName, offset);

            // Debug log
            System.out.println("Found " + (userList != null ? userList.size() : 0) + " users");

            request.setAttribute("userList", userList);
            request.setAttribute("offset", offset);
            request.setAttribute("recordsPerPage", RECORDS_PER_LOAD);

            // Xử lý yêu cầu AJAX
            if ("true".equalsIgnoreCase(ajax)) {
                  response.setContentType("text/html; charset=UTF-8");
                  response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
                  response.setHeader("Pragma", "no-cache");
                  response.setDateHeader("Expires", 0);

                  request.getRequestDispatcher("/view/dashboard/admin/user-list-fragment.jsp").include(request, response);
            } else {
                  request.getRequestDispatcher(ViewURL.ADMIN_USER_MANAGEMENT).forward(request, response);
            }
      }

      /**
       * Handles the HTTP <code>POST</code> method.
       *
       * @param request servlet request
       * @param response servlet response
       * @throws ServletException if a servlet-specific error occurs
       * @throws IOException if an I/O error occurs
       */
      @Override
      protected void doPost(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
            doGet(request, response);
      }

      /**
       * Returns a short description of the servlet.
       *
       * @return a String containing servlet description
       */
      @Override
      public String getServletInfo() {
            return "Short description";
      }// </editor-fold>

}
