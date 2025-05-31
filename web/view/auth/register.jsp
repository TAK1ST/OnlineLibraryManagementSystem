<%-- 
    Document   : register
    Created on : May 16, 2025, 7:36:05 PM
    Author     : asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <form accept-charset="utf-8" action="RegisterServlet" method="post" style=" padding: 5%" >
            <p>name:<input type="text" name="txtname" required="">*</p>
            <p>email<input type="text" name="txtemail" required="">*</p>
            <p>password:<input type="password" name="txtpassword" required="">*</p>
            <p>confirm password:<input type="password" name="txtconfirmpassword" required="">*</p>
            <p><input type="submit" name="btn" value="submit"></p>
        </form>
    </body>
</html>
