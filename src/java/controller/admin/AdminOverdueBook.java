/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import constant.ViewURL;
import dao.implement.OverdueBookDAO;
import dao.implement.FineDAO;
import entity.OverdueBook;
import entity.User;
import entity.Fine;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author asus
 */
public class AdminOverdueBook extends BaseAdminController {

      private final OverdueBookDAO overdueBookDAO = new OverdueBookDAO();
      private final FineDAO fineDAO = new FineDAO();

      @Override
      protected void doGet(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
            
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            User adminUser = checkAdminAuthentication(request, response);
            if (adminUser == null) {
                  return;
            }
            
            try {
                  // Get all overdue books
                  List<OverdueBook> overdueBooks = overdueBookDAO.getAllOverdueBooks();

                  // Get statistics
                  int totalOverdueBooks = overdueBookDAO.getTotalOverdueBooks();
                  double totalFines = overdueBookDAO.getTotalFines();
                  int averageOverdueDays = overdueBookDAO.getAverageOverdueDays();
                  
                  // Get fine statistics
                  double totalUnpaidFines = fineDAO.getTotalUnpaidFines();
                  double totalPaidFines = fineDAO.getTotalPaidFines();
                  int totalUnpaidCount = fineDAO.getUnpaidFinesCount();

                  // Set attributes for JSP
                  request.setAttribute("overdueBooks", overdueBooks);
                  request.setAttribute("totalOverdueBooks", totalOverdueBooks);
                  request.setAttribute("totalFines", totalFines);
                  request.setAttribute("averageOverdueDays", averageOverdueDays);
                  request.setAttribute("totalUnpaidFines", totalUnpaidFines);
                  request.setAttribute("totalPaidFines", totalPaidFines);
                  request.setAttribute("totalUnpaidCount", totalUnpaidCount);

                  // Check if there are any overdue books
                  if (overdueBooks == null || overdueBooks.isEmpty()) {
                        request.setAttribute("message", "No overdue books found.");
                  }

                  // Forward to JSP view
                  request.getRequestDispatcher(ViewURL.ADMIN_OVER_BOOK).forward(request, response);

            } catch (Exception e) {
                  // Log the error
                  e.printStackTrace();

                  // Set error message
                  request.setAttribute("error", "An error occurred while retrieving overdue books: " + e.getMessage());
                  request.getRequestDispatcher(ViewURL.ADMIN_OVER_BOOK).forward(request, response);
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
            
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");
            
            User adminUser = checkAdminAuthentication(request, response);
            if (adminUser == null) {
                  return;
            }
            
            String action = request.getParameter("action");

            if (action == null) {
                  doGet(request, response);
                  return;
            }

            try {
                  switch (action) {
                        case "refresh":
                              // Simply redirect to GET to refresh the data
                              response.sendRedirect(request.getContextPath() + "/admin/overdue-books");
                              break;

                        case "markPaid":
                              handleMarkFineAsPaid(request, response);
                              break;
                              
                        case "markUnpaid":
                              handleMarkFineAsUnpaid(request, response);
                              break;
                              
                        case "updateFineAmount":
                              handleUpdateFineAmount(request, response);
                              break;

                        case "export":
                              // Future implementation for exporting overdue books data
                              // For now, just redirect back
                              response.sendRedirect(request.getContextPath() + "/admin/overdue-books");
                              break;
                        case "delete":
                            
                            break;
                        default:
                              doGet(request, response);
                              break;
                  }
            } catch (Exception e) {
                  e.printStackTrace();
                  request.setAttribute("error", "An error occurred while processing your request: " + e.getMessage());
                  doGet(request, response);
            }
      }
      
      /**
       * Handle marking fine as paid
       */
      private void handleMarkFineAsPaid(HttpServletRequest request, HttpServletResponse response) 
              throws ServletException, IOException {
            try {
                  int borrowId = Integer.parseInt(request.getParameter("borrowId"));
                  
                  boolean success = fineDAO.updateFineStatus(borrowId, "paid");
                  
                  if (success) {
                        request.setAttribute("successMessage", "Fine has been marked as paid successfully!");
                  } else {
                        request.setAttribute("errorMessage", "Failed to update fine status. Please try again.");
                  }
                  
            } catch (NumberFormatException e) {
                  request.setAttribute("errorMessage", "Invalid borrow ID format.");
            } catch (Exception e) {
                  request.setAttribute("errorMessage", "An error occurred while updating fine status: " + e.getMessage());
            }
            
            doGet(request, response);
      }
      
      /**
       * Handle marking fine as unpaid
       */
      private void handleMarkFineAsUnpaid(HttpServletRequest request, HttpServletResponse response) 
              throws ServletException, IOException {
            try {
                  int borrowId = Integer.parseInt(request.getParameter("borrowId"));
                  
                  boolean success = fineDAO.updateFineStatus(borrowId, "unpaid");
                  
                  if (success) {
                        request.setAttribute("successMessage", "Fine has been marked as unpaid successfully!");
                  } else {
                        request.setAttribute("errorMessage", "Failed to update fine status. Please try again.");
                  }
                  
            } catch (NumberFormatException e) {
                  request.setAttribute("errorMessage", "Invalid borrow ID format.");
            } catch (Exception e) {
                  request.setAttribute("errorMessage", "An error occurred while updating fine status: " + e.getMessage());
            }
            
            doGet(request, response);
      }
      
      /**
       * Handle updating fine amount
       */
      private void handleUpdateFineAmount(HttpServletRequest request, HttpServletResponse response) 
              throws ServletException, IOException {
            try {
                  int borrowId = Integer.parseInt(request.getParameter("borrowId"));
                  Long newAmount = new Long(request.getParameter("fineAmount"));
                  
                  if (newAmount < 0) {
                        request.setAttribute("errorMessage", "Fine amount cannot be negative.");
                        doGet(request, response);
                        return;
                  }
                  
                  boolean success = fineDAO.updateFineAmount(borrowId, newAmount);
                  
                  if (success) {
                        request.setAttribute("successMessage", "Fine amount has been updated successfully!");
                  } else {
                        request.setAttribute("errorMessage", "Failed to update fine amount. Please try again.");
                  }
                  
            } catch (NumberFormatException e) {
                  request.setAttribute("errorMessage", "Invalid number format for borrow ID or fine amount.");
            } catch (Exception e) {
                  request.setAttribute("errorMessage", "An error occurred while updating fine amount: " + e.getMessage());
            }
            
            doGet(request, response);
      }

      
      private void handleDelete(HttpServletRequest request, HttpServletResponse response) 
              throws ServletException, IOException {
            try {
                  int borrowId = Integer.parseInt(request.getParameter("borrowId"));
//                  Long newAmount = new Long(request.getParameter("fineAmount"));
//                  
//                  if (newAmount < 0) {
//                        request.setAttribute("errorMessage", "Fine amount cannot be negative.");
//                        doGet(request, response);
//                        return;
//                  }
                  
                  boolean success = fineDAO.deleteFineByBorrowId(borrowId);
                  
                  if (success) {
                        request.setAttribute("successMessage", "Fine amount has been updated successfully!");
                  } else {
                        request.setAttribute("errorMessage", "Failed to update fine amount. Please try again.");
                  }
                  
            } catch (NumberFormatException e) {
                  request.setAttribute("errorMessage", "Invalid number format for borrow ID or fine amount.");
            } catch (Exception e) {
                  request.setAttribute("errorMessage", "An error occurred while updating fine amount: " + e.getMessage());
            }
            
            doGet(request, response);
      }
      /**
       * Returns a short description of the servlet.
       *
       * @return a String containing servlet description
       */
      @Override
      public String getServletInfo() {
            return "Admin Overdue Book Management Servlet";
      }
}