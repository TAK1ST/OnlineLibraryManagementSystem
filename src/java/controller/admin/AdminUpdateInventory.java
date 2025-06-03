/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import service.implement.UpdateInventoryService;
import constant.ViewURL;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import service.interfaces.IUpdateInventoryService;

/**
 *
 * @author asus
 */
public class AdminUpdateInventory extends HttpServlet {

      private final IUpdateInventoryService inventoryService;

      public AdminUpdateInventory() throws SQLException, ClassNotFoundException {
            this.inventoryService = new UpdateInventoryService();
      }

      @Override
      protected void doGet(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
            request.getRequestDispatcher(ViewURL.ADMIN_UPDATE_INVENTORY).forward(request, response);
      }

      @Override
      protected void doPost(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
      }
}