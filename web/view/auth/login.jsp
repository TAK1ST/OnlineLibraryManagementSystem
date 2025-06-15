<%-- 
    Document   : login
    Created on : May 16, 2025, 7:35:54 PM
    Author     : asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login Page</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user-login.css"/>
    </head>
    <body>
        <div class="login-container">
            <h1>Login</h1>
            <form action="LoginServlet" method="post">
                <label for="username">Username</label>
                <input type="text" id="email" name="txtemail" required>

                <label for="password">Password</label>
                <input type="password" id="password" name="txtpassword" required>

                <input type="submit" value="Login">
            </form>
            <!--<p>Don't have an account? <a href="${pageContext.request.contextPath}/view/auth/register.jsp">Register</a></p>-->
            <p>Don't have an account? <a href="RegisterServlet">Register</a></p>
        </div>
        <%
           if(request.getAttribute("ERROR")!=null){
               out.print(request.getAttribute("ERROR"));
            }
        %>
    </body>
</html>
