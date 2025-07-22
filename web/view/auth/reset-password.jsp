<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - Online Library Management</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user-reset-password.css"/>
<!--    <style>
        
    </style>-->
</head>
<body>
    <div class="reset-container">
        <div class="reset-header">
            <i class="fas fa-lock"></i>
            <h1>Reset Password</h1>
            <p>Create a new password for your account.</p>
        </div>
        
        <div class="reset-form">
            <!-- Hiển thị thông báo lỗi -->
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-triangle"></i>
                    ${error}
                </div>
            </c:if>
            
            <!-- Hiển thị thông báo thành công -->
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    ${success}
                </div>
                <div class="back-to-login">
                    <a href="${pageContext.request.contextPath}/LoginServlet">
                        <i class="fas fa-arrow-left"></i>
                        Back to Login
                    </a>
                </div>
            </c:if>
            
            <!-- Form đặt lại mật khẩu -->
            <c:if test="${empty success}">
                <c:choose>
                    <c:when test="${not empty token}">
                        <form action="${pageContext.request.contextPath}/resetpassword" method="post" id="resetForm">
                            <input type="hidden" name="token" value="${token}">
                            
                            <div class="form-group">
                                <label for="newPassword">
                                    <i class="fas fa-key"></i> New Password
                                </label>
                                <input type="password" 
                                       class="form-control" 
                                       id="newPassword" 
                                       name="newPassword" 
                                       required
                                       placeholder="Enter New Password">
                            </div>
                            
                            <div class="form-group">
                                <label for="confirmPassword">
                                    <i class="fas fa-key"></i> Confirm New Password
                                </label>
                                <input type="password" 
                                       class="form-control" 
                                       id="confirmPassword" 
                                       name="confirmPassword" 
                                       required
                                       placeholder="Confirm New Password">
                            </div>
                            
                            <div class="password-requirements">
                                <h4><i class="fas fa-info-circle"></i> Password Requirements:</h4>
                                <ul>
                                    <li><i class="fas fa-check"></i> At least 8 characters</li>
                                    <li><i class="fas fa-check"></i> Contains uppercase letters (A–Z)</li>
                                    <li><i class="fas fa-check"></i> Contains lowercase letters (a–z)</li>
                                    <li><i class="fas fa-check"></i> Contains numbers (0–9)</li>
                                    <li><i class="fas fa-check"></i> Contains special characters (,.'";:/?!@#$%^&*)</li>
                                </ul>
                            </div>
                            
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Reset Password
                            </button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-triangle"></i>
                            The link is invalid or has expired.
                        </div>
                    </c:otherwise>
                </c:choose>
                
                <div class="back-to-login">
                    <a href="${pageContext.request.contextPath}/LoginServlet">
                        <i class="fas fa-arrow-left"></i>
                        Back to login
                    </a>
                </div>
            </c:if>
        </div>
    </div>

    <script>
        // Validation form
        document.getElementById('resetForm')?.addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            // Kiểm tra mật khẩu khớp
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('The confirmation password does not match!');
                return;
            }
            
            // Kiểm tra độ mạnh mật khẩu
            const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[,.'";:/@$!%*?&])[A-Za-z\d,.'";:/@$!%*?&]{8,}$/;
            if (!passwordRegex.test(newPassword)) {
                e.preventDefault();
                alert('The password does not meet the security requirements! To enhance your account security, we recommend including the following characters in your password.');
                return;
            }
        });
        
        // Hiển thị/ẩn mật khẩu
        function togglePassword(fieldId) {
            const field = document.getElementById(fieldId);
            const type = field.getAttribute('type') === 'password' ? 'text' : 'password';
            field.setAttribute('type', type);
        }
    </script>
</body>
</html>