<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quên mật khẩu - Online Library Management</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }

            .forgot-password-container {
                background: white;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
                overflow: hidden;
                width: 100%;
                max-width: 450px;
                position: relative;
            }

            .forgot-password-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                padding: 40px 30px;
                text-align: center;
                color: white;
            }

            .forgot-password-header i {
                font-size: 48px;
                margin-bottom: 15px;
                opacity: 0.9;
            }

            .forgot-password-header h2 {
                font-size: 28px;
                font-weight: 600;
                margin-bottom: 8px;
            }

            .forgot-password-header p {
                font-size: 14px;
                opacity: 0.9;
            }

            .forgot-password-form {
                padding: 40px 30px;
            }

            .form-group {
                margin-bottom: 25px;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #333;
                font-size: 14px;
            }

            .form-group input {
                width: 100%;
                padding: 15px;
                border: 2px solid #e1e8ed;
                border-radius: 12px;
                font-size: 16px;
                transition: all 0.3s ease;
                background: #f8f9fa;
            }

            .form-group input:focus {
                outline: none;
                border-color: #667eea;
                background: white;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            }

            .alert {
                padding: 15px;
                border-radius: 12px;
                margin-bottom: 20px;
                font-size: 14px;
                font-weight: 500;
            }

            .alert-success {
                background: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }

            .alert-error {
                background: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            .btn-primary {
                width: 100%;
                padding: 15px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border: none;
                border-radius: 12px;
                color: white;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
            }

            .btn-primary:active {
                transform: translateY(0);
            }

            .back-to-login {
                text-align: center;
                margin-top: 25px;
                padding-top: 20px;
                border-top: 1px solid #e1e8ed;
            }

            .back-to-login a {
                color: #667eea;
                text-decoration: none;
                font-weight: 500;
                font-size: 14px;
                transition: color 0.3s ease;
            }

            .back-to-login a:hover {
                color: #764ba2;
            }

            .loading {
                display: none;
                text-align: center;
                margin-top: 15px;
            }

            .loading i {
                animation: spin 1s linear infinite;
            }

            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }

            .form-info {
                background: #e3f2fd;
                padding: 15px;
                border-radius: 12px;
                margin-bottom: 20px;
                border-left: 4px solid #2196f3;
            }

            .form-info p {
                margin: 0;
                font-size: 14px;
                color: #1976d2;
            }

            @media (max-width: 480px) {
                .forgot-password-container {
                    margin: 10px;
                    border-radius: 15px;
                }

                .forgot-password-header {
                    padding: 30px 20px;
                }

                .forgot-password-form {
                    padding: 30px 20px;
                }
            }
        </style>
    </head>
    <body>
        <div class="forgot-password-container">
            <div class="forgot-password-header">
                <i class="fas fa-key"></i>
                <h2>Quên mật khẩu?</h2>
                <p>Nhập email để nhận liên kết đặt lại mật khẩu</p>
            </div>

            <div class="forgot-password-form">
                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        ${success}
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-triangle"></i>
                        ${error}
                    </div>
                </c:if>

                <c:if test="${empty success}">
                    <div class="form-info">
                        <p><i class="fas fa-info-circle"></i> Chúng tôi sẽ gửi liên kết đặt lại mật khẩu đến email của bạn. Liên kết có hiệu lực trong 24 giờ.</p>
                    </div>

                    <form method="post" action="${pageContext.request.contextPath}/ForgotPasswordServlet" id="forgotPasswordForm">
                        <div class="form-group">
                            <label for="email">
                                <i class="fas fa-envelope"></i> Địa chỉ email
                            </label>
                            <input type="email" 
                                   id="email" 
                                   name="email" 
                                   required 
                                   placeholder="Nhập địa chỉ email của bạn"
                                   value="${param.email}"
                                   autocomplete="email">
                        </div>

                        <input type="hidden" name="action" value="send_reset_link">

                        <button type="submit" class="btn-primary">
                            <i class="fas fa-paper-plane"></i>
                            Gửi liên kết đặt lại
                        </button>

                        <div class="loading" id="loading">
                            <i class="fas fa-spinner"></i>
                            Đang xử lý...
                        </div>
                    </form>
                </c:if>

                <div class="back-to-login">
                    <a href="login.jsp">
                        <i class="fas fa-arrow-left"></i>
                        Quay lại đăng nhập
                    </a>
                </div>
            </div>
        </div>

        <script>
            document.getElementById('forgotPasswordForm').addEventListener('submit', function (e) {
                const email = document.getElementById('email').value.trim();
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

                if (!email) {
                    e.preventDefault();
                    alert('Vui lòng nhập địa chỉ email.');
                    return;
                }

                if (!emailRegex.test(email)) {
                    e.preventDefault();
                    alert('Vui lòng nhập địa chỉ email hợp lệ.');
                    return;
                }

                // Hiển thị loading
                document.querySelector('.btn-primary').style.display = 'none';
                document.getElementById('loading').style.display = 'block';
            });

            // Auto focus vào email input
            document.addEventListener('DOMContentLoaded', function () {
                document.getElementById('email').focus();
            });
        </script>
    </body>
</html>