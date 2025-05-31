/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service.implement;

import dao.implement.SystemConfigDAO;

/**
 *
 * @author asus
 */
public class SystemConfigService {

      private final SystemConfigDAO systemConfigDAO;

      public SystemConfigService() {
            this.systemConfigDAO = new SystemConfigDAO();
      }

      public String updateOverdueFine(Float overdueFine) {
            if (overdueFine == null || overdueFine < 0) {
                  return "Invalid overdue fine value";
            }
            return systemConfigDAO.updateOverdueFine(overdueFine)
                    ? "Update Overdue Fine successfully" : "Update Overdue Fine fail";
      }

      public String updateReturnFine(Float returnFine) {
            if (returnFine == null || returnFine < 0) {
                  return "Invalid return fine value";
            }
            return systemConfigDAO.updateReturnFine(returnFine)
                    ? "Update Return Fine successfully" : "Update Return Fine fail";
      }

      public String updateBorrowUnitPrice(Float borrowUnitPrice) {
            if (borrowUnitPrice == null || borrowUnitPrice < 0) {
                  return "Invalid borrow unit price value";
            }
            return systemConfigDAO.updateBorrowUnitPrice(borrowUnitPrice)
                    ? "Update Borrow Unit Price successfully" : "Update Borrow Unit Price fail";
      }
}
