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
        <title>Đăng nhập - Thư viện trực tuyến</title>
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
        </style>
    </head>
    <body>
        <div class="login-container">
            <h1>Đăng nhập</h1>
            <form action="${pageContext.request.contextPath}/LoginServlet" method="POST">
                <div class="form-group">
                    <label for="username">Tên đăng nhập</label>
                    <input type="text" class="form-control" id="username" name="txtemail" required>
                </div>
                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <input type="password" class="form-control" id="password" name="txtpassword" required>
                </div>
                <button type="submit" class="btn-login">Đăng nhập</button>
            </form>
            <div class="register-link">
                <p>Chưa có tài khoản? <a href="${pageContext.request.contextPath}/RegisterServlet">Đăng ký ngay</a></p>
            </div>
        </div>
    </body>
</html>
