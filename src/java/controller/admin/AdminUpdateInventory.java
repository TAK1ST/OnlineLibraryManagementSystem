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
import java.util.List;

/**
 *
 * @author asus
 */
public class AdminUpdateInventory extends HttpServlet {

      private final IUpdateInventoryService inventoryService = new UpdateInventoryService();

      @Override
      protected void doGet(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {

            List<Inventory> inventories = inventoryService.getAllInventory();
            request.setAttribute("inventories", inventories);
            request.getRequestDispatcher(ViewURL.ADMIN_UPDATE_INVENTORY).forward(request, response);
      }

      @Override
      protected void doPost(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {

            try {
                  int bookId = Integer.parseInt(request.getParameter("bookId"));
                  int newQuantity = Integer.parseInt(request.getParameter("quantity"));

                  if (inventoryService.updateStock(bookId, newQuantity)) {
                        request.setAttribute("success", "Cập nhật tồn kho thành công!");
                  } else {
                        request.setAttribute("error", "Cập nhật thất bại!");
                  }
            } catch (NumberFormatException e) {
                  request.setAttribute("error", "Dữ liệu không hợp lệ");
            } catch (IllegalArgumentException e) {
                  request.setAttribute("error", e.getMessage());
            }

            doGet(request, response);
      }
}
