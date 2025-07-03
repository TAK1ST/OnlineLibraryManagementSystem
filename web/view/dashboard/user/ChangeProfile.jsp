<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Profile</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #ECF0F1 0%, #1ABC9C 100%);
            min-height: 100vh;
            display: flex;
        }

        .sidebar {
            width: 250px;
            background: #2C3E50;
            padding: 20px 0;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }

        .menu-toggle {
            position: absolute;
            top: 20px;
            left: 20px;
            background: rgba(255, 255, 255, 0.2);
            border: none;
            color: white;
            padding: 12px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 18px;
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
        }

        .menu-toggle:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: scale(1.05);
        }

        .sidebar-menu {
            margin-top: 80px;
            list-style: none;
            padding: 0 10px;
        }

        .sidebar-menu li {
            margin: 8px 0;
        }

        .sidebar-menu a {
            display: block;
            color: #ECF0F1;
            text-decoration: none;
            padding: 16px 20px;
            transition: all 0.3s ease;
            border-radius: 10px;
            font-weight: 500;
            position: relative;
            overflow: hidden;
        }

        .sidebar-menu a:hover {
            background: #34495E;
            color: white;
            transform: translateX(5px);
        }

        .sidebar-menu a.active {
            background: linear-gradient(135deg, #1ABC9C, #16A085);
            color: white;
            box-shadow: 0 4px 15px rgba(26, 188, 156, 0.3);
        }

        .main-content {
            flex: 1;
            margin-left: 250px;
            padding: 30px;
            min-height: 100vh;
        }

        .profile-container {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(44, 62, 80, 0.1);
            overflow: hidden;
            backdrop-filter: blur(20px);
        }

        .profile-header {
            background: linear-gradient(135deg, #1ABC9C, #16A085);
            color: white;
            padding: 40px;
            text-align: center;
            position: relative;
        }

        .back-btn {
            position: absolute;
            left: 40px;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(255, 255, 255, 0.2);
            border: none;
            color: white;
            padding: 12px;
            border-radius: 50%;
            cursor: pointer;
            font-size: 20px;
            transition: all 0.3s ease;
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            backdrop-filter: blur(10px);
        }

        .back-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-50%) scale(1.1);
        }

        .profile-title {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 10px;
            letter-spacing: 1px;
        }

        .profile-form {
            padding: 50px;
        }

        .avatar-section {
            text-align: center;
            margin-bottom: 50px;
        }

        .avatar-container {
            position: relative;
            display: inline-block;
            margin-bottom: 20px;
        }

        .avatar-preview {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            background: linear-gradient(135deg, #2C3E50, #34495E);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            border: 4px solid #1ABC9C;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }

        .avatar-preview:hover {
            transform: scale(1.05);
            border-color: #16A085;
            box-shadow: 0 15px 40px rgba(26, 188, 156, 0.3);
        }

        .avatar-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
        }

        .change-avatar-text {
            margin-top: 15px;
            color: #2C3E50;
            font-size: 14px;
            font-weight: 500;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-label {
            color: #2C3E50;
            font-weight: 600;
            font-size: 14px;
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-input {
            padding: 16px 20px;
            border: 2px solid #ECF0F1;
            border-radius: 12px;
            font-size: 16px;
            color: #2C3E50;
            background: #FAFBFC;
            transition: all 0.3s ease;
            outline: none;
            font-weight: 500;
        }

        .form-input:focus {
            border-color: #1ABC9C;
            background: white;
            box-shadow: 0 0 0 4px rgba(26, 188, 156, 0.1);
            transform: translateY(-2px);
        }

        .form-input[readonly] {
            background: #f8f9fa;
            color: #6c757d;
            cursor: not-allowed;
        }

        .role-badge {
            display: inline-block;
            padding: 12px 24px;
            background: linear-gradient(135deg, #34495E, #2C3E50);
            color: white;
            border-radius: 25px;
            font-size: 14px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            box-shadow: 0 4px 15px rgba(44, 62, 80, 0.3);
        }

        .intro-textarea {
            min-height: 120px;
            resize: vertical;
            font-family: inherit;
        }

        .password-input-wrapper {
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
            font-size: 20px;
            padding: 8px;
            border-radius: 50%;
            transition: all 0.3s ease;
        }

        .password-toggle:hover {
            color: #1ABC9C;
            background: rgba(26, 188, 156, 0.1);
        }

        .button-group {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin-top: 50px;
        }

        .btn {
            padding: 16px 40px;
            border: none;
            border-radius: 30px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            min-width: 150px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-reset {
            background: linear-gradient(135deg, #34495E, #2C3E50);
            color: white;
            box-shadow: 0 4px 15px rgba(52, 73, 94, 0.3);
        }

        .btn-reset:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(52, 73, 94, 0.4);
        }

        .btn-save {
            background: linear-gradient(135deg, #1ABC9C, #16A085);
            color: white;
            box-shadow: 0 4px 15px rgba(26, 188, 156, 0.3);
        }

        .btn-save:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(26, 188, 156, 0.4);
        }

        .file-input {
            display: none;
        }

        .alert {
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            font-weight: 600;
            border-left: 4px solid;
            backdrop-filter: blur(10px);
        }

        .alert-success {
            background: rgba(212, 237, 218, 0.9);
            color: #155724;
            border-left-color: #1ABC9C;
        }

        .alert-error {
            background: rgba(248, 215, 218, 0.9);
            color: #721c24;
            border-left-color: #dc3545;
        }

        /* Mobile responsive */
        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
                display: none;
            }

            .sidebar.active {
                display: block;
            }

            .main-content {
                margin-left: 0;
                padding: 20px;
            }

            .menu-toggle {
                position: fixed;
                top: 20px;
                left: 20px;
                z-index: 1000;
                background: #2C3E50;
            }

            .form-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .button-group {
                flex-direction: column;
            }

            .profile-form {
                padding: 30px;
            }
        }

        /* Smooth animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .profile-container {
            animation: fadeIn 0.6s ease-out;
        }

        .form-group {
            animation: fadeIn 0.6s ease-out;
            animation-fill-mode: both;
        }

        .form-group:nth-child(1) { animation-delay: 0.1s; }
        .form-group:nth-child(2) { animation-delay: 0.2s; }
        .form-group:nth-child(3) { animation-delay: 0.3s; }
        .form-group:nth-child(4) { animation-delay: 0.4s; }
        .form-group:nth-child(5) { animation-delay: 0.5s; }
        .form-group:nth-child(6) { animation-delay: 0.6s; }
        .form-group:nth-child(7) { animation-delay: 0.7s; }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar" id="sidebar">
        <button class="menu-toggle" onclick="toggleSidebar()">☰</button>
        <ul class="sidebar-menu">
            <li><a href="#" onclick="showAlert('Chuyển đến trang Home', 'success')">Home</a></li>
            <li><a href="#" onclick="showAlert('Chuyển đến Your book', 'success')">Your book</a></li>
            <li><a href="#" onclick="showAlert('Chuyển đến Your cart', 'success')">Your cart</a></li>
            <li><a href="#" class="active">Your profile</a></li>
            <li><a href="#" onclick="showAlert('Chuyển đến Your notice', 'success')">Your notice</a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="profile-container">
            <div class="profile-header">
                <button class="back-btn" onclick="goHome()" title="Back to Home">
                    ←
                </button>
                <h1 class="profile-title">CHANGE PROFILE</h1>
            </div>

            <div class="profile-form">
                <!-- Alert messages -->
                <div id="alertContainer"></div>

                <form id="profileForm">
                    <!-- Avatar Section -->
                    <div class="avatar-section">
                        <div class="avatar-container">
                            <div class="avatar-preview" onclick="document.getElementById('avatarInput').click()">
                                <span id="avatarText">Change avatar</span>
                                <input type="file" id="avatarInput" class="file-input" accept="image/*" onchange="previewAvatar(this)">
                            </div>
                            <div class="change-avatar-text">Click để thay đổi ảnh đại diện</div>
                        </div>
                    </div>

                    <!-- Form Fields -->
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label">Full name</label>
                            <input type="text" class="form-input" id="fullName" placeholder="Enter your full name" value="Nguyễn Văn A">
                        </div>

                        <div class="form-group">
                            <label class="form-label">Email</label>
                            <input type="email" class="form-input" id="email" placeholder="example@gmail.com" value="example@gmail.com" readonly>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Your old password</label>
                            <div class="password-input-wrapper">
                                <input type="password" class="form-input" id="oldPassword" placeholder="Enter your old password">
                                <button type="button" class="password-toggle" onclick="togglePassword('oldPassword')">👁️</button>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Your new password</label>
                            <div class="password-input-wrapper">
                                <input type="password" class="form-input" id="newPassword" placeholder="Enter your new password (6 digits)" maxlength="6" pattern="[0-9]{6}">
                                <button type="button" class="password-toggle" onclick="togglePassword('newPassword')">👁️</button>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Confirm password</label>
                            <div class="password-input-wrapper">
                                <input type="password" class="form-input" id="confirmPassword" placeholder="Confirm your new password" maxlength="6" pattern="[0-9]{6}">
                                <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword')">👁️</button>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Your role</label>
                            <span class="role-badge">User</span>
                        </div>

                        <div class="form-group full-width">
                            <label class="form-label">Introduction about yourself</label>
                            <textarea class="form-input intro-textarea" id="introduction" placeholder="Enter here..."></textarea>
                        </div>
                    </div>

                    <!-- Buttons -->
                    <div class="button-group">
                        <button type="button" class="btn btn-reset" onclick="resetForm()">Reset</button>
                        <button type="button" class="btn btn-save" onclick="saveProfile()">Save change</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function goHome() {
            if (confirm('Bạn có chắc chắn muốn quay về trang Home? Các thay đổi chưa lưu sẽ bị mất.')) {
                showAlert('Đang chuyển về trang Home...', 'success');
                setTimeout(() => {
                    showAlert('Đã chuyển về trang Home!', 'success');
                }, 1000);
            }
        }

        function toggleSidebar() {
            const sidebar = document.getElementById('sidebar');
            sidebar.classList.toggle('active');
        }

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

        function previewAvatar(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    const avatarPreview = document.querySelector('.avatar-preview');
                    avatarPreview.innerHTML = `<img src="${e.target.result}" alt="Avatar">`;
                };
                reader.readAsDataURL(input.files[0]);
            }
        }

        function showAlert(message, type = 'success') {
            const alertContainer = document.getElementById('alertContainer');
            const alertDiv = document.createElement('div');
            alertDiv.className = `alert alert-${type}`;
            alertDiv.innerHTML = `
                ${message}
                <button style="float: right; background: none; border: none; font-size: 18px; cursor: pointer; color: inherit;" onclick="this.parentElement.remove()">×</button>
            `;
            alertContainer.appendChild(alertDiv);

            // Auto remove after 5 seconds
            setTimeout(() => {
                if (alertDiv.parentElement) {
                    alertDiv.remove();
                }
            }, 5000);
        }

        function validatePassword() {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            // Check if password is 6 digits
            if (newPassword && !/^\d{6}$/.test(newPassword)) {
                showAlert('Mật khẩu mới phải là 6 chữ số!', 'error');
                return false;
            }

            // Check if passwords match
            if (newPassword && confirmPassword && newPassword !== confirmPassword) {
                showAlert('Mật khẩu xác nhận không khớp!', 'error');
                return false;
            }

            return true;
        }

        function saveProfile() {
            const fullName = document.getElementById('fullName').value;
            const oldPassword = document.getElementById('oldPassword').value;
            const newPassword = document.getElementById('newPassword').value;

            // Validate required fields
            if (!fullName.trim()) {
                showAlert('Vui lòng nhập họ tên!', 'error');
                return;
            }

            // If changing password, validate
            if (newPassword) {
                if (!oldPassword) {
                    showAlert('Vui lòng nhập mật khẩu cũ!', 'error');
                    return;
                }

                if (!validatePassword()) {
                    return;
                }
            }

            // Simulate saving
            showAlert('Cập nhật thông tin thành công!', 'success');
        }

        function resetForm() {
            if (confirm('Bạn có chắc chắn muốn reset form?')) {
                document.getElementById('profileForm').reset();
                document.getElementById('fullName').value = 'Nguyễn Văn A';
                document.getElementById('email').value = 'example@gmail.com';
                document.querySelector('.avatar-preview').innerHTML = '<span id="avatarText">Change avatar</span>';
                showAlert('Đã reset form thành công!', 'success');
            }
        }

        // Add input validation for password fields
        document.getElementById('newPassword').addEventListener('input', function (e) {
            const value = e.target.value;
            // Only allow numbers
            e.target.value = value.replace(/[^0-9]/g, '');

            if (e.target.value.length === 6) {
                validatePassword();
            }
        });

        document.getElementById('confirmPassword').addEventListener('input', function (e) {
            const value = e.target.value;
            // Only allow numbers
            e.target.value = value.replace(/[^0-9]/g, '');

            if (e.target.value.length === 6) {
                validatePassword();
            }
        });

        // Initialize with user data
        window.addEventListener('DOMContentLoaded', function() {
            // Simulate loading user data
            const userName = 'Nguyễn Văn A'; // This would come from your backend
            document.getElementById('fullName').value = userName;
        });
    </script>
</body>
</html>