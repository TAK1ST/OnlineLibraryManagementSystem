<%-- 
    Document   : user-list-fragment
    Created on : Jun 7, 2025, 8:15:07 PM
    Author     : asus
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,entity.User" %>

<%
    List<User> userList = (List<User>) request.getAttribute("userList");
    if (userList != null && !userList.isEmpty()) {
        for (User u : userList) {
%>
<div class="user-row" data-id="<%=u.getId()%>">
      <div class="col-3"><div class="user-cell"><%=u.getName()%></div></div>
      <div class="col-3"><div class="user-cell"><%=u.getEmail()%></div></div>
      <div class="col-3"><div class="user-cell"><%=u.getRole()%></div></div>
      <div class="col-3"><div class="user-cell"><%=u.getStatus()%></div></div>
</div>
<%
        }
    } else {
%>
<div class="empty-state">
      <i class="fas fa-users"></i>
      <p>No users found</p>
</div>
<%
    }
%>