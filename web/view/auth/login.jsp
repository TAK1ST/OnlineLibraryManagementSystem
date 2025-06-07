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
    </head>

    <style>
        body {
            background-color: #2C3E50;
            font-family: Arial, sans-serif;
            color: #ECF0F1;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .login-container {
            background-color: #34495E;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.3);
            width: 350px;
        }

        .login-container h1 {
            margin-bottom: 30px;
            text-align: center;
            color: #1ABC9C;
        }

        .login-container label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        .login-container input[type="text"],
        .login-container input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: none;
            border-radius: 5px;
            background-color: #2C3E50;
            color: #ECF0F1;
        }

        .login-container input[type="submit"] {
            background-color: #1ABC9C;
            border: none;
            color: #ECF0F1;
            padding: 12px;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }

        .login-container input[type="submit"]:hover {
            background-color: #16A085;
        }

        .login-container p {
            text-align: center;
            margin-top: 15px;
        }

        .login-container a {
            color: #1ABC9C;
            text-decoration: none;
        }

        .login-container a:hover {
            text-decoration: underline;
        }
    </style>

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
