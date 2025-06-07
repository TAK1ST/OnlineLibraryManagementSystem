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
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #2C3E50 0%, #34495E 35%, #1ABC9C 65%, #16A085 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .register-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 40px;
            width: 100%;
            max-width: 480px;
            transform: translateY(0);
            transition: all 0.3s ease;
        }

        .register-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
        }

        .register-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .register-header h1 {
            color: #2C3E50;
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
            background: linear-gradient(135deg, #2C3E50, #1ABC9C);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .register-header p {
            color: #7F8C8D;
            font-size: 1.1rem;
        }

        .form-group {
            margin-bottom: 25px;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #2C3E50;
            font-weight: 600;
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .required {
            color: #E74C3C;
            margin-left: 4px;
        }

        .form-input {
            width: 100%;
            padding: 15px 20px;
            border: 2px solid #ECF0F1;
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #FAFAFA;
            outline: none;
        }

        .form-input:focus {
            border-color: #1ABC9C;
            background: white;
            box-shadow: 0 0 0 4px rgba(26, 188, 156, 0.1);
            transform: translateY(-2px);
        }

        .form-input:hover {
            border-color: #16A085;
        }

        .password-group {
            position: relative;
        }

        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #7F8C8D;
            cursor: pointer;
            font-size: 1.1rem;
            padding: 5px;
            transition: color 0.3s ease;
        }

        .password-toggle:hover {
            color: #1ABC9C;
        }

        .submit-btn {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #1ABC9C, #16A085);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
            position: relative;
            overflow: hidden;
        }

        .submit-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s ease;
        }

        .submit-btn:hover::before {
            left: 100%;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(26, 188, 156, 0.3);
        }

        .submit-btn:active {
            transform: translateY(0);
        }

        .form-footer {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #ECF0F1;
        }

        .form-footer p {
            color: #7F8C8D;
            margin-bottom: 10px;
        }

        .login-link {
            color: #1ABC9C;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .login-link:hover {
            color: #16A085;
            text-decoration: underline;
        }

        .floating-shapes {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: -1;
        }

        .shape {
            position: absolute;
            opacity: 0.1;
            animation: float 6s ease-in-out infinite;
        }

        .shape:nth-child(1) {
            top: 20%;
            left: 10%;
            width: 80px;
            height: 80px;
            background: #1ABC9C;
            border-radius: 50%;
            animation-delay: 0s;
        }

        .shape:nth-child(2) {
            top: 60%;
            right: 15%;
            width: 60px;
            height: 60px;
            background: #3498DB;
            border-radius: 50%;
            animation-delay: 2s;
        }

        .shape:nth-child(3) {
            bottom: 20%;
            left: 20%;
            width: 100px;
            height: 100px;
            background: #E74C3C;
            border-radius: 20px;
            animation-delay: 4s;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(180deg); }
        }

        /* Responsive Design */
        @media (max-width: 600px) {
            .register-container {
                padding: 30px 20px;
                margin: 10px;
            }
            
            .register-header h1 {
                font-size: 2rem;
            }
            
            .form-input {
                padding: 12px 15px;
            }
            
            .submit-btn {
                padding: 14px;
            }
        }

        /* Animation on load */
        .register-container {
            animation: slideIn 0.6s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
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

        <form accept-charset="utf-8" action="RegisterServlet" method="post">
            <div class="form-group">
                <label for="txtname">Họ và tên <span class="required">*</span></label>
                <input type="text" id="txtname" name="txtname" class="form-input" required 
                       placeholder="Nhập họ và tên của bạn">
            </div>

            <div class="form-group">
                <label for="txtemail">Email <span class="required">*</span></label>
                <input type="email" id="txtemail" name="txtemail" class="form-input" required 
                       placeholder="example@email.com">
            </div>

            <div class="form-group">
                <label for="txtpassword">Mật khẩu <span class="required">*</span></label>
                <div class="password-group">
                    <input type="password" id="txtpassword" name="txtpassword" class="form-input" required 
                           placeholder="Nhập mật khẩu">
                    <button type="button" class="password-toggle" onclick="togglePassword('txtpassword')">👁</button>
                </div>
            </div>

            <div class="form-group">
                <label for="txtconfirmpassword">Xác nhận mật khẩu <span class="required">*</span></label>
                <div class="password-group">
                    <input type="password" id="txtconfirmpassword" name="txtconfirmpassword" class="form-input" required 
                           placeholder="Nhập lại mật khẩu">
                    <button type="button" class="password-toggle" onclick="togglePassword('txtconfirmpassword')">👁</button>
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
                button.textContent = '🙈';
            } else {
                input.type = 'password';
                button.textContent = '👁️';
            }
        }

        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
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
            input.addEventListener('focus', function() {
                this.parentNode.style.transform = 'scale(1.02)';
            });
            
            input.addEventListener('blur', function() {
                this.parentNode.style.transform = 'scale(1)';
            });
        });
    </script>
</body>
</html>
