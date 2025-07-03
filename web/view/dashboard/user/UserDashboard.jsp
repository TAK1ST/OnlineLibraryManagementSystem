<%-- 
    Document   : UserDashboard
    Created on : Jun 2, 2025, 9:31:11 PM
    Author     : CAU_TU
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page  import="entity.User" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
          
           /*if(session.getAttribute("loginedUser")==null){
               response.sendRedirect("index.jsp");
           }else{
               User us=(User) session.getAttribute("loginedUser");
              
             
               out.print("<h2>welcome:"  + us.getName() + "</h2>");
               out.print("<p><a href='LogoutServlet'>Logout</a>");
               out.print("<h1>DASHBOARD</h1>");
               out.print("<p><a href='ChangeProfile'>Change profile</a></p>");
             
           }*/
        %>

        <h1>Account</h1>
        <p>Center Account</p>
        <a href="EditProfileServlet">Edit Your Profile</a><br>
        <a href="EditPasswordServlet">Edit Your Password</a><br>
    </body>
</html>
