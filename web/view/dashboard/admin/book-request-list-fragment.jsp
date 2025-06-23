<%-- 
    Document   : book-request-list-fragment
    Created on : Jun 21, 2025, 12:04:00 PM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,dto.BookInforRequestStatusDTO" %>
<%! 
    // Helper method to determine request type
    private String determineRequestType(BookInforRequestStatusDTO dto) {
        return dto.getRequestType() != null ? dto.getRequestType() : "borrow";
    }

    // Helper method to get actual status
    private String getActualStatus(BookInforRequestStatusDTO dto) {
        String rawStatus = dto.getStatusAction();
        String requestType = determineRequestType(dto);
        
        if ("pending".equals(rawStatus)) {
            return "pending";
        } else if ("approved".equals(rawStatus)) {
            return "approved";
        } else if ("rejected".equals(rawStatus)) {
            return "rejected";
        } else if ("completed".equals(rawStatus)) {
            return "completed";
        }
        
        return rawStatus != null ? rawStatus : "pending";
    }

    // Helper method to get display status
    private String getDisplayStatus(BookInforRequestStatusDTO dto) {
        String status = getActualStatus(dto);
        String requestType = determineRequestType(dto);
        
        switch(status) {
            case "pending":
                return "PENDING " + requestType.toUpperCase();
            case "approved":
                return "APPROVED " + requestType.toUpperCase();
            case "rejected":
                return "REJECTED";
            case "completed":
                return "COMPLETED";
            default:
                return status.toUpperCase();
        }
    }

    // Helper method to determine status priority
    private int getStatusPriority(BookInforRequestStatusDTO dto) {
        String status = getActualStatus(dto);
        String requestType = determineRequestType(dto);
        
        if ("pending".equals(status)) {
            return "borrow".equals(requestType) ? 1 : 2;
        } else if ("approved".equals(status) && "borrow".equals(requestType)) {
            return 3;
        } else if ("approved".equals(status) && "return".equals(requestType)) {
            return 4;
        }
        return 5;
    }

    // Helper method to get badge class for status
    private String getStatusBadgeClass(BookInforRequestStatusDTO dto) {
        String status = getActualStatus(dto);
        String requestType = determineRequestType(dto);
        
        switch(status) {
            case "pending":
                return "bg-warning text-dark";
            case "approved":
                return "borrow".equals(requestType) ? "bg-primary" : "bg-info";
            case "rejected":
                return "bg-danger";
            case "completed":
                return "bg-success";
            default:
                return "bg-secondary";
        }
    }

    // Helper method to check if borrow button should be shown
    private boolean shouldShowBorrowButton(BookInforRequestStatusDTO dto) {
        String status = getActualStatus(dto);
        String requestType = determineRequestType(dto);
        return "approved".equals(status) && "borrow".equals(requestType);
    }

    // Helper method to check if approve button should be shown
    private boolean shouldShowApproveButton(BookInforRequestStatusDTO dto) {
        return "pending".equals(getActualStatus(dto));
    }

    // Helper method to check if reject button should be shown
    private boolean shouldShowRejectButton(BookInforRequestStatusDTO dto) {
        return "pending".equals(getActualStatus(dto));
    }
%>

<%-- Main processing code --%>
<%
    List<BookInforRequestStatusDTO> bookRequestList = (List<BookInforRequestStatusDTO>) request.getAttribute("bookStatusList");
    String emptyMessage = request.getAttribute("emptyMessage") != null ? (String) request.getAttribute("emptyMessage") : "No book borrowing requests found!";

    if (bookRequestList != null && !bookRequestList.isEmpty()) {
        // Sort by priority
        bookRequestList.sort((a, b) -> Integer.compare(getStatusPriority(a), getStatusPriority(b)));

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

            // Debug logging
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
                  <% if (shouldShowApproveButton(b)) { %>
                  <!-- Approve Button -->
                  <form id="approve-form-<%=id%>" action="statusrequestborrowbook" method="POST" style="display:inline;">
                        <input type="hidden" name="requestId" value="<%=id%>">
                        <input type="hidden" name="action" value="approve">
                        <button type="button" class="btn btn-sm btn-success me-1 approve-btn" 
                                onclick="handleApprove(this)"
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
                                onclick="handleReject(this)"
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
                        <button type="submit" class="btn btn-sm btn-primary borrow-btn"
                                data-request-id="<%=id%>"
                                title="Create borrow record">
                              <i class="fas fa-book"></i> Process Borrow
                        </button>
                  </form>
                  <% } %>

                  <% if ("approved".equals(actualStatus) && "return".equals(requestType)) { %>
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
                  <div class="completed-status text-center">
                        <span class="badge bg-danger">
                              <i class="fas fa-times-circle"></i> Request Rejected
                        </span>
                        <small class="text-muted d-block mt-1">
                              No further action needed
                        </small>
                  </div>
                  <% } else if ("completed".equals(actualStatus)) { %>
                  <!-- Completed Status -->
                  <div class="completed-status text-center">
                        <span class="badge bg-dark">
                              <i class="fas fa-check-double"></i> Completed
                        </span>
                        <small class="text-success d-block mt-1">
                              <i class="fas fa-thumbs-up"></i> All done
                        </small>
                  </div>
                  <% } else if (!shouldShowApproveButton(b) && !shouldShowRejectButton(b) && !shouldShowBorrowButton(b)) { %>
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