/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package constant;

import dao.implement.SystemConfigDAO;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 *
 * @author asus
 */
public class constance {
      
      // Set System config
      SystemConfigDAO scd = new SystemConfigDAO();
      public float OVERDUE_FINE_UNIT = scd.getOverdueFineUnit();
      public float BORROW_UNIT_PRICE = scd.getBorrowUnitPrice();
      public int DEFAULT_BORROW_DURATION = scd.getDefaultBorrowDuration();
      
      // Valid statuses that can be processed
      public static final List<String> VALID_STATUSES = new ArrayList<>(
              Arrays.asList(
                      "pending_borrow", "pending_return", "approved_borrow", "approved_return",
                      "rejected", "completed", "pending", "approved"
              ));

      // Valid actions
      public static final List<String> VALID_ACTIONS = new ArrayList<>(
              Arrays.asList("approve", "reject", "borrow"));

      // Lazy loading
      public static int RECORDS_PER_LOAD = 10;
}
