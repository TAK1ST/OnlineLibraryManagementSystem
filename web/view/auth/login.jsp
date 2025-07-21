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
        <style>
            body {
                background: var(--gradient-primary);
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                color: var(--light);
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
            }

            .login-container {
                background-color: rgba(52, 73, 94, 0.9);
                padding: var(--spacing-xl);
                border-radius: var(--border-radius-lg);
                box-shadow: var(--shadow-lg);
                width: 400px;
                backdrop-filter: blur(10px);
            }

            .login-container h1 {
                margin-bottom: var(--spacing-lg);
                text-align: center;
                color: var(--primary-accent);
                font-size: 2.2em;
            }

            .form-group {
                margin-bottom: var(--spacing-md);
            }

            .form-group label {
                display: block;
                margin-bottom: var(--spacing-sm);
                font-weight: 500;
                color: var(--light);
            }

            .form-control {
                width: 100%;
                padding: var(--spacing-md);
                border: 1px solid rgba(236, 240, 241, 0.2);
                border-radius: var(--border-radius-md);
                background-color: rgba(44, 62, 80, 0.7);
                color: var(--light);
                transition: all 0.3s ease;
            }

            .form-control:focus {
                outline: none;
                border-color: var(--primary-accent);
                box-shadow: 0 0 0 2px rgba(26, 188, 156, 0.2);
            }

            .btn-login {
                width: 100%;
                padding: var(--spacing-md);
                background: var(--gradient-accent);
                border: none;
                border-radius: var(--border-radius-md);
                color: var(--light);
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .btn-login:hover {
                transform: translateY(-2px);
                box-shadow: var(--shadow-md);
            }

            .register-link {
                text-align: center;
                margin-top: var(--spacing-lg);
            }

            .register-link a {
                color: var(--primary-accent);
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .register-link a:hover {
                color: var(--secondary-accent);
            }

            .alert {
                padding: 10px;
                margin-bottom: 15px;
                border-radius: 4px;
                text-align: center;
            }

            .alert-success {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }

            .alert-error {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            /* Styles for Remember Me checkbox */
            .remember-me-container {
                display: flex;
                align-items: center;
                margin-bottom: var(--spacing-md);
                margin-top: var(--spacing-sm);
            }

            .remember-me-container input[type="checkbox"] {
                width: 18px;
                height: 18px;
                margin-right: var(--spacing-sm);
                accent-color: var(--primary-accent);
                cursor: pointer;
            }

            .remember-me-container label {
                margin-bottom: 0;
                font-weight: 400;
                cursor: pointer;
                font-size: 0.9em;
            }

            .form-actions {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-top: var(--spacing-md);
            }

            .forgot-password {
                color: var(--primary-accent);
                text-decoration: none;
                font-size: 0.9em;
                transition: all 0.3s ease;
            }

            .forgot-password:hover {
                color: var(--secondary-accent);
                text-decoration: underline;
            }
        </style>
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