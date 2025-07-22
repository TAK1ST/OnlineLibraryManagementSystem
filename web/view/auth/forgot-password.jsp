<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Forgot Password - Online Library Management</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user-forgot-password.css"/>
<!--        <style>
            
        </style>-->
    </head>
    <body>
        <div class="forgot-password-container">
            <div class="forgot-password-header">
                <i class="fas fa-key"></i>
                <h2>Forgot Password?</h2>
                <p>Enter your email to receive the password reset link.</p>
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
                        <p><i class="fas fa-info-circle"></i> We will send a password reset link to your email. The link will be valid for 24 hours.</p>
                    </div>

                    <form method="post" action="${pageContext.request.contextPath}/ForgotPasswordServlet" id="forgotPasswordForm">
                        <div class="form-group">
                            <label for="email">
                                <i class="fas fa-envelope"></i> Email Address
                            </label>
                            <input type="email" 
                                   id="email" 
                                   name="email" 
                                   required 
                                   placeholder="Enter your email address."
                                   value="${param.email}"
                                   autocomplete="email">
                        </div>

                        <input type="hidden" name="action" value="send_reset_link">

                        <button type="submit" class="btn-primary">
                            <i class="fas fa-paper-plane"></i>
                            Send Reset Link
                        </button>

                        <div class="loading" id="loading">
                            <i class="fas fa-spinner"></i>
                            Processing…
                        </div>
                    </form>
                </c:if>

                <div class="back-to-login">
                    <a href="${pageContext.request.contextPath}/LoginServlet">
                        <i class="fas fa-arrow-left"></i>
                        Back to Login
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
                    alert('Please enter your email address.');
                    return;
                }

                if (!emailRegex.test(email)) {
                    e.preventDefault();
                    alert('Please enter a valid email address.');
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