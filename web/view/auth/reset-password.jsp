<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lại mật khẩu - Online Library Management</title>
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

        .reset-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            max-width: 450px;
            width: 100%;
            animation: slideUp 0.6s ease;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .reset-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 40px 30px;
            text-align: center;
            color: white;
        }

        .reset-header i {
            font-size: 3rem;
            margin-bottom: 15px;
            opacity: 0.9;
        }

        .reset-header h1 {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .reset-header p {
            font-size: 1rem;
            opacity: 0.9;
            line-height: 1.5;
        }

        .reset-form {
            padding: 40px 30px;
        }

        .alert {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-size: 14px;
            display: flex;
            align-items: center;
            animation: fadeIn 0.5s ease;
        }

        .alert i {
            margin-right: 10px;
            font-size: 16px;
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

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
            font-size: 14px;
        }

        .form-control {
            width: 100%;
            padding: 15px;
            border: 2px solid #e1e8ed;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        .form-control:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .password-requirements {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-top: 15px;
            font-size: 13px;
            color: #666;
        }

        .password-requirements h4 {
            color: #333;
            margin-bottom: 10px;
            font-size: 14px;
        }

        .password-requirements ul {
            list-style: none;
            padding: 0;
        }

        .password-requirements li {
            margin-bottom: 5px;
            display: flex;
            align-items: center;
        }

        .password-requirements li i {
            margin-right: 8px;
            font-size: 12px;
            color: #667eea;
        }

        .btn {
            width: 100%;
            padding: 15px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
            margin-top: 15px;
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        .back-to-login {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }

        .back-to-login a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            transition: color 0.3s ease;
        }

        .back-to-login a:hover {
            color: #5a67d8;
        }

        .back-to-login a i {
            margin-right: 8px;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Responsive */
        @media (max-width: 480px) {
            .reset-container {
                margin: 10px;
            }
            
            .reset-header {
                padding: 30px 20px;
            }
            
            .reset-form {
                padding: 30px 20px;
            }
        }
    </style>
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
                                    <li><i class="fas fa-check"></i> Contains special characters (!@#$%^&*)</li>
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
            const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
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