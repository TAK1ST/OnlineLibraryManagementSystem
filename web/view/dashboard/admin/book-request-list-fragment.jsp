<%-- 
    Document   : book-request-list-fragment
    Created on : Jun 12, 2025, 10:04:58 AM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,dto.BookInforRequestStatusDTO" %>
<%
    List<BookInforRequestStatusDTO> bookRequestList = (List<BookInforRequestStatusDTO>) request.getAttribute("bookStatusList");
    String emptyMessage = request.getAttribute("emptyMessage") != null ? (String) request.getAttribute("emptyMessage") : "No book borrowing requests found!";

    if (bookRequestList != null && !bookRequestList.isEmpty()) {
        for (BookInforRequestStatusDTO b : bookRequestList) {
%>
<tr class="book-request-row" data-id="<%=b.getId()%>">
      <td><%=b.getIsbn()%></td>
      <td><%=b.getTitle()%></td>
      <td><%=b.getStatusAction()%></td>
      <td><%=b.getAvailableCopies()%></td>
      <td><%=1%></td>
      <td>
            <div class="action-buttons">
                  <form action="statusrequestborrowbook" method="POST" style="display:inline;">
                        <input type="hidden" name="requestId" value="<%=b.getId()%>">
                        <input type="hidden" name="action" value="approve">
                        <button type="submit" class="btn-approve" onclick="return confirm('Approve this request?')">
                              <i class="fas fa-check"></i> Approve
                        </button>
                  </form>
                  <form action="statusrequestborrowbook" method="POST" style="display:inline;">
                        <input type="hidden" name="requestId" value="<%=b.getId()%>">
                        <input type="hidden" name="action" value="reject">
                        <button type="submit" class="btn-reject" onclick="return confirm('Reject this request?')">
                              <i class="fas fa-times"></i> Reject
                        </button>
                  </form>
            </div>
      </td>
</tr>
<%
        }
    } else {
%>
<tr>
      <td colspan="6" class="empty-state">
            <i class="fas fa-book"></i>
            <h3>No book borrowing requests found</h3>
            <p><%=emptyMessage%></p>
      </td>
</tr>
<%
    }
%>
