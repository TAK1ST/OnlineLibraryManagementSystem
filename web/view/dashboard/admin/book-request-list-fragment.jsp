<%-- 
    Document   : book-request-list-fragment
    Created on : Jun 21, 2025, 12:04:00 PM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,dto.BookInforRequestStatusDTO,dao.implement.BookDAO" %>
<%! 
    private String determineRequestType(BookInforRequestStatusDTO dto) {
        return dto.getRequestType() != null ? dto.getRequestType().trim().toLowerCase() : "borrow";
    }

    private String getActualStatus(BookInforRequestStatusDTO dto) {
        String rawStatus = dto.getStatusAction() != null ? dto.getStatusAction().trim().toLowerCase() : "pending";
        System.out.println("getActualStatus - ID: " + dto.getId() + ", Raw Status: " + dto.getStatusAction() + ", Normalized: " + rawStatus);
        if ("pending".equals(rawStatus) || "approved-borrow".equals(rawStatus) || "rejected".equals(rawStatus) || "borrowed".equals(rawStatus)) {
            return rawStatus;
        }
        return "pending";
    }

    private String getDisplayStatus(BookInforRequestStatusDTO dto) {
        String status = getActualStatus(dto);
        String requestType = determineRequestType(dto);
        
        switch(status) {
            case "pending":
                return "PENDING " + requestType.toUpperCase();
            case "approved-borrow":
                return "APPROVED BORROW";
            case "rejected":
                return "REJECTED";
            case "borrowed":
                return "BORROWED";
            default:
                return status.toUpperCase();
        }
    }

    private int getStatusPriority(BookInforRequestStatusDTO dto) {
        String status = getActualStatus(dto);
        String requestType = determineRequestType(dto);
        
        if ("pending".equals(status)) {
            return "borrow".equals(requestType) ? 1 : 2;
        } else if ("approved-borrow".equals(status)) {
            return 3;
        } else if ("approved-return".equals(status)) {
            return 4;
        }
        return 5;
    }

    private String getStatusBadgeClass(BookInforRequestStatusDTO dto) {
        String status = getActualStatus(dto);
        String requestType = determineRequestType(dto);
        
        switch(status) {
            case "pending":
                return "bg-warning text-dark";
            case "approved-borrow":
                return "bg-primary";
            case "approved-return":
                return "bg-info";
            case "rejected":
                return "bg-danger";
            case "borrowed":
                return "bg-success";
            default:
                return "bg-secondary";
        }
    }

    private boolean shouldShowBorrowButton(BookInforRequestStatusDTO dto) {
        String status = getActualStatus(dto);
        String requestType = determineRequestType(dto);
        boolean shouldShow = "approved-borrow".equals(status) && "borrow".equals(requestType);
        System.out.println("shouldShowBorrowButton - ID: " + dto.getId() + ", Status: " + status + ", Type: " + requestType + ", Show: " + shouldShow);
        return shouldShow;
    }

    private boolean shouldShowApproveButton(BookInforRequestStatusDTO dto, HttpServletRequest request) {
        String status = getActualStatus(dto);
        String requestType = determineRequestType(dto);
        if (!"pending".equals(status) || !"borrow".equals(requestType)) {
            return false;
        }

        // Kiểm tra số lượng bản sao sách
        BookDAO bookDAO = new BookDAO();
        entity.Book book = bookDAO.getBookById(dto.getBookId());
        boolean shouldShow = book != null && book.getAvailableCopies() > 0 && "active".equalsIgnoreCase(book.getStatus());
        System.out.println("shouldShowApproveButton - ID: " + dto.getId() + ", Book Available: " + (book != null ? book.getAvailableCopies() : "null") + ", Show: " + shouldShow);
        return shouldShow;
    }

    private boolean shouldShowRejectButton(BookInforRequestStatusDTO dto) {
        boolean shouldShow = "pending".equals(getActualStatus(dto));
        System.out.println("shouldShowRejectButton - ID: " + dto.getId() + ", Show: " + shouldShow);
        return shouldShow;
    }
%>

<%
    List<BookInforRequestStatusDTO> bookRequestList = (List<BookInforRequestStatusDTO>) request.getAttribute("bookStatusList");
    String emptyMessage = request.getAttribute("emptyMessage") != null ? (String) request.getAttribute("emptyMessage") : "No book borrowing requests found!";

    if (bookRequestList != null && !bookRequestList.isEmpty()) {
        for (BookInforRequestStatusDTO b : bookRequestList) {
            String id = String.valueOf(b.getId());
            String isbn = b.getIsbn() != null ? b.getIsbn() : "N/A";
            String title = b.getTitle() != null ? b.getTitle() : "N/A";
            String username = b.getUsername() != null ? b.getUsername() : "N/A";
            double overdueFine = b.getOverdueFine();

            String requestType = determineRequestType(b);
            String actualStatus = getActualStatus(b);
            String displayStatus = getDisplayStatus(b);
            String badgeClass = getStatusBadgeClass(b);
            int priority = getStatusPriority(b);

            System.out.println("Request ID: " + id + ", Status: " + actualStatus + 
                             ", Type: " + requestType + ", Display: " + displayStatus + 
                             ", Fine: " + overdueFine + ", Priority: " + priority);
%>

<tr class="book-request-row priority-<%=priority%>" 
    data-id="<%=id%>" 
    data-status="<%=actualStatus%>_<%=requestType%>" 
    data-type="<%=requestType%>"
    data-raw-status="<%=actualStatus%>"
    data-fine="<%=overdueFine%>">

      <td class="isbn-cell">
            <span class="fw-bold"><%=isbn%></span>
      </td>

      <td class="title-cell">
            <div class="book-title"><%=title%></div>
            <% if (requestType.equals("return") && overdueFine > 0) { %>
            <small class="text-danger">
                  <i class="fas fa-exclamation-triangle"></i>
                  Return with fine: $<%=String.format("%.2f", overdueFine)%>
            </small>
            <% } %>
      </td>

      <td class="username-cell">
            <span class="user-name"><%=username%></span>
            <small class="text-muted d-block"><%=requestType.substring(0,1).toUpperCase() + requestType.substring(1)%> Request</small>
      </td>

      <td class="status-cell">
            <div class="status-container">
                  <span class="badge <%=badgeClass%> status-badge">
                        <%=displayStatus%>
                  </span>
                  <% if (overdueFine > 0) { %>
                  <div class="fine-info mt-1">
                        <small class="text-danger fw-bold">
                              <i class="fas fa-dollar-sign"></i>
                              Fine: $<%=String.format("%.2f", overdueFine)%>
                        </small>
                  </div>
                  <% } %>
                  <% if (priority <= 3) { %>
                  <div class="priority-indicator mt-1">
                        <small class="badge bg-warning text-dark">
                              <i class="fas fa-exclamation"></i> Action Required
                        </small>
                  </div>
                  <% } %>
            </div>
      </td>

      <td class="action-cell">
            <div class="action-buttons d-flex flex-wrap gap-1">
                  <% if (shouldShowApproveButton(b, request)) { %>
                  <!-- Approve Button -->
                  <form id="approve-form-<%=id%>" action="statusrequestborrowbook" method="POST" style="display:inline;">
                        <input type="hidden" name="requestId" value="<%=id%>">
                        <input type="hidden" name="action" value="approve">
                        <button type="button" class="btn btn-sm btn-success me-1 approve-btn" 
                                onclick="document.getElementById('approve-form-<%=id%>').submit()"
                                data-request-id="<%=id%>" 
                                data-status="<%=actualStatus%>_<%=requestType%>" 
                                data-type="<%=requestType%>"
                                data-fine="<%=overdueFine%>"
                                title="Approve <%=requestType%> request">
                              <i class="fas fa-check"></i> Approve
                        </button>
                  </form>
                  <% } %>

                  <% if (shouldShowRejectButton(b)) { %>
                  <!-- Reject Button -->
                  <form id="reject-form-<%=id%>" action="statusrequestborrowbook" method="POST" style="display:inline;">
                        <input type="hidden" name="requestId" value="<%=id%>">
                        <input type="hidden" name="action" value="reject">
                        <button type="button" class="btn btn-sm btn-danger me-1 reject-btn"
                                onclick="document.getElementById('reject-form-<%=id%>').submit()"
                                data-request-id="<%=id%>"
                                title="Reject request">
                              <i class="fas fa-times"></i> Reject
                        </button>
                  </form>
                  <% } %>

                  <% if (shouldShowBorrowButton(b)) { %>
                  <!-- Process Borrow Button -->
                  <form id="borrow-form-<%=id%>" action="statusrequestborrowbook" method="POST" style="display:inline;">
                        <input type="hidden" name="requestId" value="<%=id%>">
                        <input type="hidden" name="action" value="borrow">
                        <button type="button" class="btn btn-sm btn-primary borrow-btn"
                                onclick="document.getElementById('borrow-form-<%=id%>').submit()"
                                data-request-id="<%=id%>"
                                title="Create borrow record">
                              <i class="fas fa-book"></i> Process Borrow
                        </button>
                  </form>
                  <% } %>

                  <% if ("approved-return".equals(actualStatus)) { %>
                  <!-- Approved Return Status -->
                  <div class="completed-status text-center">
                        <span class="badge bg-primary">
                              <i class="fas fa-check-circle"></i> Return Approved
                        </span>
                        <small class="text-muted d-block mt-1">
                              Ready for book collection
                        </small>
                        <% if (overdueFine > 0) { %>
                        <small class="text-danger d-block">
                              <i class="fas fa-exclamation-triangle"></i>
                              Fine paid: $<%=String.format("%.2f", overdueFine)%>
                        </small>
                        <% } %>
                  </div>
                  <% } else if ("rejected".equals(actualStatus)) { %>
                  <!-- Rejected Status -->
                  <div class=" personally-status text-center">
                        <span class="badge bg-danger">
                              <i class="fas fa-times-circle"></i> Request Rejected
                        </span>
                        <small class="text-muted d-block mt-1">
                              No further action needed
                        </small>
                  </div>
                  <% } else if ("borrowed".equals(actualStatus)) { %>
                  <!-- Borrowed Status -->
                  <div class="completed-status text-center">
                        <span class="badge bg-success">
                              <i class="fas fa-check-double"></i> Borrowed
                        </span>
                        <small class="text-success d-block mt-1">
                              <i class="fas fa-thumbs-up"></i> Book borrowed
                        </small>
                  </div>
                  <% } else if (!shouldShowApproveButton(b, request) && !shouldShowRejectButton(b) && !shouldShowBorrowButton(b)) { %>
                  <!-- Unknown Status -->
                  <div class="unknown-status text-center">
                        <span class="badge bg-secondary">
                              <i class="fas fa-question"></i> <%=actualStatus%>
                        </span>
                        <small class="text-muted d-block mt-1">Contact administrator</small>
                  </div>
                  <% } %>
            </div>
      </td>
</tr>
<%
        }
    } else {
%>
<tr>
      <td colspan="5" class="empty-state text-center py-5">
            <div class="d-flex flex-column align-items-center">
                  <div class="empty-icon mb-3">
                        <i class="fas fa-book-open fa-4x text-muted"></i>
                  </div>
                  <h5 class="text-muted mb-2">No Book Requests Found</h5>
                  <p class="text-muted mb-0"><%=emptyMessage%></p>
                  <small class="text-muted mt-2">
                        Try adjusting your search filters or check back later
                  </small>
            </div>
      </td>
</tr>
<%
    }
%>