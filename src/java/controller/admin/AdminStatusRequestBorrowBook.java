/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import constant.ViewURL;
import static constant.constance.RECORDS_PER_LOAD;
import dto.BookInforRequestStatusDTO;
import entity.BookRequest;
import java.io.IOException;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import service.implement.BookRequestStatusService;

/**
 *
 * @author asus
 */
public class AdminStatusRequestBorrowBook extends HttpServlet {

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BookRequestStatusService service = new BookRequestStatusService();
        String ajax = request.getParameter("ajax");
        String searchTitle = request.getParameter("searchTitle");
        String searchStatus = request.getParameter("searchStatus");
        int offset = request.getParameter("offset") != null ? Integer.parseInt(request.getParameter("offset")) : 0;

        // Handle empty string as null for proper filtering
        if (searchTitle != null && searchTitle.trim().isEmpty()) {
            searchTitle = null;
        }
        if (searchStatus != null && searchStatus.trim().isEmpty()) {
            searchStatus = null;
        }

        List<BookInforRequestStatusDTO> bookStatusList = service.getAllBookRequestStatusLazyLoading(searchTitle, searchStatus, offset);
        if (bookStatusList == null) {
            bookStatusList = new ArrayList<>();
        }
        request.setAttribute("bookStatusList", bookStatusList);
        System.out.println("bookStatusList size: " + (bookStatusList != null ? bookStatusList.size() : "null"));

        if (bookStatusList.isEmpty()) {
            request.setAttribute("emptyMessage", "No matching book borrowing requests found!");
        }

        request.setAttribute("recordsPerPage", RECORDS_PER_LOAD);
        request.setAttribute("offset", offset);

        // Hiển thị thông báo từ session (nếu có)
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
            // Validate parameters
            if (requestId == null || requestId.trim().isEmpty()) {
                throw new Exception("Request ID is required");
            }

            if (action == null || action.trim().isEmpty()) {
                throw new Exception("Action is required");
            }

            int id = Integer.parseInt(requestId);

            // Validate action
            if (!action.equals("approve") && !action.equals("reject") && !action.equals("borrow")) {
                throw new Exception("Invalid action: " + action);
            }

            // Process based on action
            switch (action) {
                case "approve":
                    processApprove(service, id, session, request); // Sửa lỗi ở đây
                    break;
                case "reject":
                    processReject(service, id, session);
                    break;
                case "borrow":
                    processBorrow(service, id, session);
                    break;
            }

            // Redirect back to the same page
            response.sendRedirect(request.getContextPath() + "/statusrequestborrowbook");

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid request ID format");
            response.sendRedirect(request.getContextPath() + "/statusrequestborrowbook");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/statusrequestborrowbook");
        }
    }

    // Sửa lỗi nghiêm trọng trong phương thức này
    private void processApprove(BookRequestStatusService service, int requestId, HttpSession session, HttpServletRequest request) throws Exception {
        try {
            // Lấy thông tin request để xác định loại
            BookRequest bookRequest = service.getBookRequestById(requestId)
                    .orElseThrow(() -> new Exception("Request not found with ID: " + requestId));
            
            // Xác định loại request từ database
            String requestType = bookRequest.getRequestType();
            if (requestType == null) {
                requestType = "borrow"; // Default value
            }
            
            String newStatus;
            if ("borrow".equalsIgnoreCase(requestType)) {
                newStatus = "approved";
            } else if ("return".equalsIgnoreCase(requestType)) {
                newStatus = "approved";
            } else {
                throw new Exception("Unknown request type: " + requestType);
            }
            
            // Cập nhật trạng thái
            boolean success = service.updateBookRequestStatus(requestId, newStatus);
            if (!success) {
                throw new Exception("Failed to update request status");
            }
            
            // Set success message
            String actionType = "borrow".equalsIgnoreCase(requestType) ? "borrow" : "return";
            session.setAttribute("successMessage", "Request #" + requestId + " has been approved for " + actionType + " successfully!");
            
            System.out.println("Approved request ID: " + requestId + " with status: " + newStatus + " for type: " + requestType);
            
        } catch (Exception e) {
            System.err.println("Error in processApprove: " + e.getMessage());
            e.printStackTrace();
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
            e.printStackTrace();
            throw e;
        }
    }

    private void processBorrow(BookRequestStatusService service, int requestId, HttpSession session) throws Exception {
        try {
            // Check if book is available before creating borrow record
            BookRequest req = service.getBookRequestById(requestId)
                    .orElseThrow(() -> new Exception("Request not found with ID: " + requestId));

            // Create borrow record
            boolean success = service.createBorrowRecord(requestId);
            if (!success) {
                throw new Exception("Failed to create borrow record");
            }
            
            session.setAttribute("successMessage", "Borrow record created successfully for request #" + requestId + "!");
            System.out.println("Created borrow record for request ID: " + requestId);
        } catch (Exception e) {
            System.err.println("Error in processBorrow: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
}
