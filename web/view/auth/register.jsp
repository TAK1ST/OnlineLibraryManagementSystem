<%-- 
    Document   : register
    Created on : May 16, 2025, 7:36:05 PM
    Author     : asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng Ký Tài Khoản</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user-register.css"/>
        <style>
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
        </style>
    </head>
    <body>
        <div class="floating-shapes">
            <div class="shape"></div>
            <div class="shape"></div>
            <div class="shape"></div>
        </div>

        <div class="register-container">
            <div class="register-header">
                <h1>Đăng Ký</h1>
                <p>Tạo tài khoản mới để bắt đầu</p>
            </div>

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

            <form accept-charset="utf-8" action="RegisterServlet" method="post">
                <div class="form-group">
                    <label for="txtname">Họ và tên <span class="required">*</span></label>
                    <input type="text" id="txtname" name="txtname" class="form-input" required 
                           placeholder="Nhập họ và tên của bạn" value="<%= request.getParameter("txtname") != null ? request.getParameter("txtname") : "" %>">
                </div>

                <div class="form-group">
                    <label for="txtemail">Email <span class="required">*</span></label>
                    <input type="email" id="txtemail" name="txtemail" class="form-input" required 
                           placeholder="example@email.com" value="<%= request.getParameter("txtemail") != null ? request.getParameter("txtemail") : "" %>">
                </div>

                <div class="form-group">
                    <label for="txtpassword">Mật khẩu <span class="required">*</span></label>
                    <div class="password-group">
                        <input type="password" id="txtpassword" name="txtpassword" class="form-input" required 
                               placeholder="Nhập mật khẩu">
                        <button type="button" class="password-toggle" onclick="togglePassword('txtpassword')">😵</button>
                    </div>
                </div>

                <div class="form-group">
                    <label for="txtconfirmpassword">Xác nhận mật khẩu <span class="required">*</span></label>
                    <div class="password-group">
                        <input type="password" id="txtconfirmpassword" name="txtconfirmpassword" class="form-input" required 
                               placeholder="Nhập lại mật khẩu">
                        <button type="button" class="password-toggle" onclick="togglePassword('txtconfirmpassword')">😵</button>
                    </div>
                </div>

                <button type="submit" name="btn" value="submit" class="submit-btn">
                    Đăng Ký
                </button>
            </form>

            <div class="form-footer">
                <p>Đã có tài khoản?</p>
                <a href="LoginServlet" class="login-link">Đăng nhập ngay</a>
            </div>
        </div>

        <script>
            function togglePassword(inputId) {
                const input = document.getElementById(inputId);
                const button = input.nextElementSibling;

                if (input.type === 'password') {
                    input.type = 'text';
                    button.textContent = '😮';
                } else {
                    input.type = 'password';
                    button.textContent = '😵';
                }
            }

            // Form validation
            document.querySelector('form').addEventListener('submit', function (e) {
                const password = document.getElementById('txtpassword').value;
                const confirmPassword = document.getElementById('txtconfirmpassword').value;

                if (password !== confirmPassword) {
                    e.preventDefault();
                    alert('Mật khẩu xác nhận không khớp!');
                    return false;
                }

                if (password.length < 6) {
                    e.preventDefault();
                    alert('Mật khẩu phải có ít nhất 6 ký tự!');
                    return false;
                }
            });

            // Add floating animation to form elements
            document.querySelectorAll('.form-input').forEach(input => {
                input.addEventListener('focus', function () {
                    this.parentNode.style.transform = 'scale(1.02)';
                });

                input.addEventListener('blur', function () {
                    this.parentNode.style.transform = 'scale(1)';
                });
            });
        </script>
    </body>
</html>