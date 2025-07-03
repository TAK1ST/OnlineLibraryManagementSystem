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
        <title>Register Account</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user-register.css"/>
        <style>
            .alert {
                padding: 10px;
                margin-bottom: 15px;
                border-radius: 4px;
                text-align: center;
            }

            .alert-success-slogan {
                background: linear-gradient(135deg, #d4edda 0%, #e8f5e8 100%);
                color: #7F8C8D;
                border: 2px solid #4CAF50;
                border-radius: 20px;
                padding: 10px 20px;
                margin: 20px;
                font-size: 1.1rem;
                font-weight: 600;
                text-align: center;
                box-shadow:
                    0 20px 40px rgba(76, 175, 80, 0.3),
                    0 10px 20px rgba(0, 0, 0, 0.1),
                    inset 0 1px 0 rgba(255, 255, 255, 0.7);
                position: relative;
                overflow: hidden;
                max-width: 600px;
                transform: scale(1);
                transition: all 0.3s ease;
                backdrop-filter: blur(10px);
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
                <h1>Sign Up</h1>
                <!--<p>Tạo tài khoản mới để bắt đầu</p>-->
            </div>

            <!-- Hiển thị thông báo thành công -->
            <% if (request.getAttribute("message") != null) { %>
            <div class="alert alert-success">
                <%= request.getAttribute("message") %>
            </div>
            <% } %>
            
            <% if (request.getAttribute("mess") != null) { %>
            <div class="alert alert-success-slogan">
                <%= request.getAttribute("mess") %>
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
                    <label for="txtname">Your Full Name <span class="required">*</span></label>
                    <input type="text" id="txtname" name="txtname" class="form-input" required 
                           placeholder="Enter Your Full Name" value="<%= request.getParameter("txtname") != null ? request.getParameter("txtname") : "" %>">
                </div>

                <div class="form-group">
                    <label for="txtemail">Your Email<span class="required">*</span></label>
                    <input type="email" id="txtemail" name="txtemail" class="form-input" required 
                           placeholder="example@email.com" value="<%= request.getParameter("txtemail") != null ? request.getParameter("txtemail") : "" %>">
                </div>

                <div class="form-group">
                    <label for="txtpassword">Your Password<span class="required">*</span></label>
                    <div class="password-group">
                        <input type="password" id="txtpassword" name="txtpassword" class="form-input" required 
                               placeholder="Enter your password">
                        <button type="button" class="password-toggle" onclick="togglePassword('txtpassword')">😵</button>
                    </div>
                </div>

                <div class="form-group">
                    <label for="txtconfirmpassword">Confirm Your Password<span class="required">*</span></label>
                    <div class="password-group">
                        <input type="password" id="txtconfirmpassword" name="txtconfirmpassword" class="form-input" required 
                               placeholder="Enter your password again">
                        <button type="button" class="password-toggle" onclick="togglePassword('txtconfirmpassword')">😵</button>
                    </div>
                </div>

                <button type="submit" name="btn" value="submit" class="submit-btn">
                    Sign Up
                </button>
            </form>

            <div class="form-footer">
                <p>Already have an account?</p>
                <a href="LoginServlet" class="login-link">Login now</a>
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
                    alert('Confirmation password does not match!');
                    return false;
                }

                if (password.length < 6) {
                    e.preventDefault();
                    alert('Password must be at least 6 characters!');
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