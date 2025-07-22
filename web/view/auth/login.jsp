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
        <title>Login - Online Library</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/theme.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user-login.css"/>
<!--        <style>
            
        </style>-->
    </head>
    <body>
        <div class="login-container">
            <h1>Login</h1>
            
            <!-- Hiển thị thông báo thành công -->
            <% if (request.getAttribute("message") != null) { %>
                <div class="alert alert-success">
                    <%= request.getAttribute("message") %>
                </div>
            <% } %>
            
            <!-- Hiển thị thông báo lỗi -->
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/LoginServlet" method="POST">
                <div class="form-group">
                    <label for="username">Your Email</label>
                    <input type="text" class="form-control" id="username" name="txtemail" required>
                </div>
                <div class="form-group">
                    <label for="password">Your Password</label>
                    <input type="password" class="form-control" id="password" name="txtpassword" required>
                </div>
                
                <!-- Remember Me checkbox -->
                <div class="remember-me-container">
                    <input type="checkbox" id="rememberMe" name="rememberMe">
                    <label for="rememberMe">Remember me for 7 days</label>
                </div>
                
                <button type="submit" class="btn-login">Login</button>
                
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/ForgotPasswordServlet" class="forgot-password">Forgot password?</a>
                </div>
            </form>
            
            <div class="register-link">
                <p>New to Library? | <a href="${pageContext.request.contextPath}/RegisterServlet">Sign Up</a></p>
                <p><a href="javascript: history.back()">Come Back</a></p>
            </div>
        </div>
    </body>
</html>