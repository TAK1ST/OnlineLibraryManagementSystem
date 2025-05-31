/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import constant.ViewURL;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.implement.SystemConfigurationService;

/**
 *
 * @author asus
 */
public class AdminSystemConfig extends HttpServlet {

      @Override
      protected void doGet(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
            request.getRequestDispatcher(ViewURL.ADMIN_SYSTEM_CONFIG).forward(request, response);
      }

      @Override
      protected void doPost(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {

            SystemConfigurationService systemConfigService = new SystemConfigurationService();
            String message = "";
            boolean hasUpdate = false;

            try {
                  String overdueFineStr = request.getParameter("overdueFine");
                  String returnFineStr = request.getParameter("returnFine");
                  String borrowUnitPriceStr = request.getParameter("borrowUnitPrice");

                  if (overdueFineStr != null && !overdueFineStr.trim().isEmpty()) {
                        Float overdueFine = Float.parseFloat(overdueFineStr);
                        String result = systemConfigService.updateOverdueFine(overdueFine);
                        message += result + "<br>";
                        hasUpdate = true;
                  }

                  if (returnFineStr != null && !returnFineStr.trim().isEmpty()) {
                        Float returnFine = Float.parseFloat(returnFineStr);
                        String result = systemConfigService.updateReturnFine(returnFine);
                        message += result + "<br>";
                        hasUpdate = true;
                  }

                  if (borrowUnitPriceStr != null && !borrowUnitPriceStr.trim().isEmpty()) {
                        Float borrowUnitPrice = Float.parseFloat(borrowUnitPriceStr);
                        String result = systemConfigService.updateBorrowUnitPrice(borrowUnitPrice);
                        message += result + "<br>";
                        hasUpdate = true;
                  }

                  if (!hasUpdate) {
                        message = "No values provided for update.";
                  }

            } catch (NumberFormatException e) {
                  message = "Invalid number format. Please enter valid numbers.";
            } catch (Exception e) {
                  message = "An error occurred: " + e.getMessage();
            }

            // Set message and redirect back to form
            request.setAttribute("message", message);
            request.getRequestDispatcher(ViewURL.ADMIN_SYSTEM_CONFIG).forward(request, response);
      }

      @Override
      public String getServletInfo() {
            return "System Configuration Controller";
      }
}
