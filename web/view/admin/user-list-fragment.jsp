<%-- 
    Document   : user-list-fragment
    Created on : Jun 7, 2025, 8:15:07 PM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,entity.User" %>

<%
    List<User> userList = (List<User>) request.getAttribute("userList");
    String emptyMessage = request.getAttribute("emptyMessage") != null ? (String) request.getAttribute("emptyMessage") : "No users found";

    if (userList != null && !userList.isEmpty()) {
        for (User u : userList) {
            String statusClass = "";
            String statusIcon = "";
            String statusText = u.getStatus().toLowerCase();
            String newStatus = statusText.equals("active") ? "blocked" : "active";
            String confirmMessage = "Are you sure you want to " + (statusText.equals("active") ? "block" : "activate") + " this user?";

            switch(statusText) {
                case "active":
                    statusClass = "active";
                    statusIcon = "fas fa-check-circle";
                    break;
                case "blocked":
                    statusClass = "blocked";
                    statusIcon = "fas fa-ban";
                    statusText = "blocked";
                    break;
            }
%>

<div class="user-row" data-id="<%=u.getId()%>">
      <div class="col-3">
            <div class="user-cell">
                  <a href="${pageContext.request.contextPath}/userdetail?userId=<%=u.getId()%>" class="user-link">
                        <%=u.getName()%>
                  </a>
            </div>
      </div>
      <div class="col-4">
            <div class="user-cell">
                  <a href="${pageContext.request.contextPath}/userdetail?userId=<%=u.getId()%>" class="user-link">
                        <%=u.getEmail()%>
                  </a>
            </div>
      </div>
      <div class="col-3">
            <div class="user-cell">
                  <a href="${pageContext.request.contextPath}/userdetail?userId=<%=u.getId()%>" class="user-link">
                        <%=u.getRole()%>
                  </a>
            </div>
      </div>
      <div class="col-2">
            <div class="user-cell">
                  <% if ("admin".equalsIgnoreCase(u.getRole())) { %>
                  <span class="status-btn <%=statusClass%> disabled" title="Cannot change status of admin users">
                        <i class="<%=statusIcon%>"></i>
                        <%=statusText%>
                  </span>
                  <% } else { %>
                  <a href="${pageContext.request.contextPath}/usermanagement?userId=<%=u.getId()%>&newStatus=<%=newStatus%>" 
                     class="status-btn <%=statusClass%>"
                     onclick="return confirm('<%=confirmMessage%>')">
                        <i class="<%=statusIcon%>"></i>
                        <%=statusText%>
                  </a>
                  <% } %>
            </div>
      </div>
</div>
<%
        }
    } else {
%>
<div class="empty-state">
      <i class="fas fa-users"></i>
      <p><%=emptyMessage%></p>
</div>
<%
    }
%>