/*
 * Click nbfs://SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import constant.ViewURL;
import static constant.constance.RECORDS_PER_LOAD;
import dto.BookInforRequestStatusDTO;
import entity.Book;
import entity.BookRequest;
import entity.User;
import java.io.IOException;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import service.implement.BookRequestStatusService;

/**
 *
 * @author asus
 */
public class AdminStatusRequestBorrowBook extends BaseAdminController {

      @Override
      public void doGet(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {

            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            User adminUser = checkAdminAuthentication(request, response);
            if (adminUser == null) {
                  return;
            }

            BookRequestStatusService service = new BookRequestStatusService();
            String ajax = request.getParameter("ajax");
            String searchTitle = request.getParameter("searchTitle");
            String searchStatus = request.getParameter("searchStatus");
            int offset = request.getParameter("offset") != null ? Integer.parseInt(request.getParameter("offset")) : 0;

            // Normalize search parameters
            if (searchTitle != null && searchTitle.trim().isEmpty()) {
                  searchTitle = null;
            }
            if (searchStatus != null && searchStatus.trim().isEmpty()) {
                  searchStatus = null;
            }

            if (searchStatus != null) {
                  searchStatus = mapFrontendStatusToBackend(searchStatus);
            }

            List<BookInforRequestStatusDTO> bookStatusList = service.getAllBookRequestStatusLazyLoading(searchTitle, searchStatus, offset);
            if (bookStatusList == null) {
                  bookStatusList = new ArrayList<>();
            }

            request.setAttribute("bookStatusList", bookStatusList);

            if (bookStatusList.isEmpty()) {
                  request.setAttribute("emptyMessage", "No matching book borrowing requests found!");
            }

            request.setAttribute("recordsPerPage", RECORDS_PER_LOAD);
            request.setAttribute("offset", offset);
            request.setAttribute("searchTitle", searchTitle);
            request.setAttribute("searchStatus", request.getParameter("searchStatus"));

            // Handle session messages
            HttpSession session = request.getSession();
            String successMessage = (String) session.getAttribute("successMessage");
            String errorMessage = (String) session.getAttribute("errorMessage");

            if (successMessage != null) {
                  request.setAttribute("successMessage", successMessage);
                  session.removeAttribute("successMessage");
            }

            if (errorMessage != null) {
                  request.setAttribute("errorMessage", errorMessage);
                  session.removeAttribute("errorMessage");
            }

            if ("true".equals(ajax)) {
                  response.setContentType("text/html; charset=UTF-8");
                  request.getRequestDispatcher(ViewURL.BOOK_REQUEST_LIST_FRAGMENT).include(request, response);
            } else {
                  System.out.println("come to status request borrow book");
                  request.getRequestDispatcher(ViewURL.ADMIN_STATUS_REQUEST_BORROW_BOOK).forward(request, response);
            }
      }

      @Override
      public void doPost(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
            BookRequestStatusService service = new BookRequestStatusService();
            String requestId = request.getParameter("requestId");
            String action = request.getParameter("action");
            HttpSession session = request.getSession();

            try {
                  // Validate request ID
                  if (requestId == null || requestId.trim().isEmpty() || !requestId.matches("\\d+")) {
                        throw new IllegalArgumentException("Invalid request ID");
                  }

                  // Validate action
                  if (action == null || action.trim().isEmpty()) {
                        throw new IllegalArgumentException("Invalid action");
                  }

                  int id = Integer.parseInt(requestId);

                  // Process different actions
                  switch (action.toLowerCase()) {
                        case "approve":
                              processApprove(service, id, session);
                              break;
                        case "reject":
                              processReject(service, id, session);
                              break;
                        case "borrow":
                              processBorrow(service, id, session);
                              break;
                        case "return":
                              processReturn(service, id, session);
                              break;
                        default:
                              throw new IllegalArgumentException("Invalid action: " + action);
                  }

                  response.sendRedirect(request.getContextPath() + "/statusrequestborrowbook");

            } catch (NumberFormatException e) {
                  System.err.println("Number format error: " + e.getMessage());
                  session.setAttribute("errorMessage", "Invalid request ID format");
                  response.sendRedirect(request.getContextPath() + "/statusrequestborrowbook");
            } catch (Exception e) {
                  System.err.println("Error processing request: " + e.getMessage());
                  e.printStackTrace();
                  session.setAttribute("errorMessage", "Error: " + e.getMessage());
                  response.sendRedirect(request.getContextPath() + "/statusrequestborrowbook");
            }
      }

      /**
       * Map frontend status values to backend status values
       */
      private String mapFrontendStatusToBackend(String frontendStatus) {
            if (frontendStatus == null || frontendStatus.trim().isEmpty()) {
                  return null;
            }

            String status = frontendStatus.toLowerCase().trim();
            System.err.println(status);

            switch (status) {
                  case "pending_borrow":
                        return "pending";
                  case "pending_return":
                        return "pending";
                  case "approved_borrow":
                  case "approved-borrow":
                        return "approved-borrow";
                  case "approved_return":
                  case "approved-return":
                        return "approved-return";
                  case "borrowed":
                        return "borrowed";
                  case "completed":
                        return "completed";
                  case "rejected":
                        return "rejected";
                  default:
                        return frontendStatus;
            }
      }

      private void processApprove(BookRequestStatusService service, int requestId, HttpSession session) throws Exception {
            try {
                  BookRequest bookRequest = service.getBookRequestById(requestId)
                          .orElseThrow(() -> new Exception("Request not found with ID: " + requestId));

                  String requestType = bookRequest.getRequestType() != null ? bookRequest.getRequestType().toLowerCase() : "borrow";
                  String currentStatus = bookRequest.getStatus() != null ? bookRequest.getStatus().toLowerCase() : "pending";

                  // Validate current status - only accept pending requests
                  if (!"pending".equals(currentStatus)) {
                        throw new IllegalStateException("Request must be in pending state, current state: " + currentStatus);
                  }

                  String newStatus;
                  String actionType;

                  if ("borrow".equalsIgnoreCase(requestType)) {
                        // Validate book availability for borrow requests
                        Book book = service.getBookDAO(requestId);
                        if (book == null) {
                              throw new IllegalStateException("Book not found with ID: " + bookRequest.getBookId());
                        }
                        if (book.getAvailableCopies() <= 0) {
                              throw new IllegalStateException("No available copies of this book");
                        }
                        if (!"active".equalsIgnoreCase(book.getStatus())) {
                              throw new IllegalStateException("Book is not in active status");
                        }
                        newStatus = "approved-borrow";
                        actionType = "borrow";
                  } else if ("return".equalsIgnoreCase(requestType)) {
                        // For return requests, no additional validation needed
                        newStatus = "approved-return";
                        actionType = "return";
                  } else {
                        throw new IllegalStateException("Invalid request type: " + requestType);
                  }

                  // Update status
                  boolean success = service.updateBookRequestStatus(requestId, newStatus);
                  if (!success) {
                        throw new Exception("Failed to update request status");
                  }

                  session.setAttribute("successMessage", "Request #" + requestId + " has been approved for " + actionType + " successfully!");
                  System.out.println("Approved request ID: " + requestId + ", Type: " + requestType + ", New status: " + newStatus);

            } catch (Exception e) {
                  System.err.println("Error in processApprove: " + e.getMessage());
                  throw e;
            }
      }

      private void processReject(BookRequestStatusService service, int requestId, HttpSession session) throws Exception {
            try {
                  boolean success = service.updateBookRequestStatus(requestId, "rejected");
                  if (!success) {
                        throw new Exception("Failed to reject request");
                  }
                  session.setAttribute("successMessage", "Request #" + requestId + " has been rejected successfully!");
                  System.out.println("Rejected request ID: " + requestId);
            } catch (Exception e) {
                  System.err.println("Error in processReject: " + e.getMessage());
                  throw e;
            }
      }

      private void processBorrow(BookRequestStatusService service, int requestId, HttpSession session) throws Exception {
            try {
                  BookRequest req = service.getBookRequestById(requestId)
                          .orElseThrow(() -> new Exception("Request not found with ID: " + requestId));

                  // Validate request type and status
                  if (!"borrow".equalsIgnoreCase(req.getRequestType())) {
                        throw new IllegalStateException("Request type must be 'borrow', current: " + req.getRequestType());
                  }

                  if (!"approved-borrow".equalsIgnoreCase(req.getStatus())) {
                        throw new IllegalStateException("Request must be in 'approved-borrow' status, current: " + req.getStatus());
                  }

                  // Create borrow record
                  boolean success = service.createBorrowRecord(requestId);
                  if (!success) {
                        throw new Exception("Failed to create borrow record");
                  }

                  // Update status to borrowed
                  boolean statusUpdated = service.updateBookRequestStatus(requestId, "borrowed");
                  if (!statusUpdated) {
                        throw new Exception("Failed to update status to borrowed");
                  }

                  session.setAttribute("successMessage", "Borrow record created successfully for request #" + requestId + "!");
                  System.out.println("Created borrow record for request ID: " + requestId + ", new status: borrowed");
            } catch (Exception e) {
                  System.err.println("Error in processBorrow: " + e.getMessage());
                  throw e;
            }
      }

      private void processReturn(BookRequestStatusService service, int requestId, HttpSession session) throws Exception {
            try {
                  BookRequest req = service.getBookRequestById(requestId)
                          .orElseThrow(() -> new Exception("Request not found with ID: " + requestId));

                  // Validate request type and status
                  if (!"return".equalsIgnoreCase(req.getRequestType())) {
                        throw new IllegalStateException("Request type must be 'return', current: " + req.getRequestType());
                  }

                  if (!"approved-return".equalsIgnoreCase(req.getStatus())) {
                        throw new IllegalStateException("Request must be in 'approved-return' status, current: " + req.getStatus());
                  }

                  // Process return (update book copies, close borrow record, etc.)
                  boolean success = service.processReturnRequest(requestId);
                  if (!success) {
                        throw new Exception("Failed to process book return");
                  }

                  // Update status to completed (thay vì returned)
                  boolean statusUpdated = service.updateBookRequestStatus(requestId, "completed");
                  if (!statusUpdated) {
                        throw new Exception("Failed to update status to completed");
                  }

                  session.setAttribute("successMessage", "Book return processed successfully for request #" + requestId + "!");
                  System.out.println("Processed return for request ID: " + requestId + ", new status: completed");
            } catch (Exception e) {
                  System.err.println("Error in processReturn: " + e.getMessage());
                  throw e;
            }
      }
}
