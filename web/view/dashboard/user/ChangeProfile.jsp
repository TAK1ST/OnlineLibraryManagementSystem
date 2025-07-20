<%-- 
    Document   : ChangeProfile
    Created on : Jun 2, 2025, 9:33:41 PM
    Author     : CAU_TU
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="entity.User" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <title>Profile Management</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                background: linear-gradient(135deg, #2C3E50 0%, #34495E 100%);
                min-height: 100vh;
                color: #333;
                line-height: 1.6;
            }

            .app-container {
                display: flex;
                min-height: 100vh;
            }

            /* Modern Sidebar */
            .sidebar {
                width: 280px;
                background: rgba(26, 188, 156, 0.1);
                backdrop-filter: blur(20px);
                border-right: 1px solid rgba(26, 188, 156, 0.2);
                padding: 2rem 0;
                position: fixed;
                height: 100vh;
                z-index: 100;
            }

            .sidebar-header {
                padding: 0 2rem 2rem;
                border-bottom: 1px solid rgba(26, 188, 156, 0.1);
                margin-bottom: 2rem;
            }

            .sidebar-title {
                font-size: 1.5rem;
                font-weight: 700;
                color: #ECFDF1;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .sidebar-nav {
                padding: 0 1rem;
            }

            .nav-item {
                margin-bottom: 0.5rem;
            }

            .nav-link {
                display: flex;
                align-items: center;
                padding: 0.75rem 1rem;
                color: rgba(236, 253, 241, 0.8);
                text-decoration: none;
                border-radius: 12px;
                transition: all 0.3s ease;
                font-weight: 500;
            }

            .nav-link:hover {
                background: rgba(26, 188, 156, 0.1);
                color: #ECFDF1;
                transform: translateX(4px);
            }

            .nav-link.active {
                background: rgba(26, 188, 156, 0.2);
                color: #ECFDF1;
            }

            .nav-link i {
                width: 20px;
                margin-right: 0.75rem;
            }

            /* Main Content Area */
            .main-content {
                flex: 1;
                margin-left: 280px;
                padding: 2rem;
                max-width: calc(100vw - 280px);
            }

            .content-header {
                background: rgba(26, 188, 156, 0.1);
                backdrop-filter: blur(20px);
                border-radius: 20px;
                padding: 2rem;
                margin-bottom: 2rem;
                border: 1px solid rgba(26, 188, 156, 0.2);
                text-align: center;
            }

            .page-title {
                font-size: 2.5rem;
                font-weight: 700;
                color: #ECFDF1;
                margin-bottom: 0.5rem;
            }

            .page-subtitle {
                font-size: 1.1rem;
                color: rgba(236, 253, 241, 0.8);
            }

            /* Alert Messages */
            .alert {
                padding: 1rem 1.5rem;
                border-radius: 12px;
                margin-bottom: 1.5rem;
                display: flex;
                align-items: center;
                gap: 0.75rem;
                animation: slideIn 0.3s ease;
            }

            .alert-success {
                background: linear-gradient(135deg, #1ABC9C, #16A085);
                color: white;
            }

            .alert-error {
                background: linear-gradient(135deg, #E74C3C, #C0392B);
                color: white;
            }

            .alert-close {
                margin-left: auto;
                background: none;
                border: none;
                color: inherit;
                font-size: 1.5rem;
                cursor: pointer;
                padding: 0;
                line-height: 1;
            }

            /* Profile Cards */
            .profile-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 2rem;
            }

            .profile-card {
                background: rgba(236, 253, 241, 0.95);
                border-radius: 20px;
                padding: 2rem;
                box-shadow: 0 20px 40px rgba(44, 62, 80, 0.1);
                border: 1px solid rgba(26, 188, 156, 0.3);
                backdrop-filter: blur(10px);
            }

            .card-header {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                margin-bottom: 1.5rem;
                padding-bottom: 1rem;
                border-bottom: 2px solid rgba(26, 188, 156, 0.1);
            }

            .card-title {
                font-size: 1.5rem;
                font-weight: 600;
                color: #2C3E50;
            }

            .card-icon {
                font-size: 1.5rem;
                color: #1ABC9C;
            }

            /* Avatar Section */
            .avatar-section {
                text-align: center;
                margin-bottom: 2rem;
            }

            .avatar-container {
                position: relative;
                display: inline-block;
                margin-bottom: 1rem;
            }

            .avatar-image {
                width: 120px;
                height: 120px;
                border-radius: 50%;
                object-fit: cover;
                border: 4px solid #1ABC9C;
                box-shadow: 0 10px 30px rgba(26, 188, 156, 0.3);
            }

            .avatar-overlay {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(44, 62, 80, 0.5);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                opacity: 0;
                transition: opacity 0.3s ease;
                cursor: pointer;
            }

            .avatar-container:hover .avatar-overlay {
                opacity: 1;
            }

            .avatar-upload-btn {
                background: none;
                border: none;
                color: white;
                font-size: 1.5rem;
                cursor: pointer;
            }

            .file-input-hidden {
                display: none;
            }

            /* Form Styling */
            .form-group {
                margin-bottom: 1.5rem;
            }

            .form-label {
                display: block;
                font-weight: 600;
                color: #2C3E50;
                margin-bottom: 0.5rem;
                font-size: 0.9rem;
            }

            .form-input {
                width: 100%;
                padding: 0.75rem 1rem;
                border: 2px solid rgba(26, 188, 156, 0.2);
                border-radius: 12px;
                font-size: 1rem;
                transition: all 0.3s ease;
                background: #fff;
            }

            .form-input:focus {
                outline: none;
                border-color: #1ABC9C;
                box-shadow: 0 0 0 3px rgba(26, 188, 156, 0.1);
            }

            .form-input:read-only {
                background: rgba(236, 253, 241, 0.5);
                cursor: not-allowed;
            }

            .password-field {
                position: relative;
            }

            .password-toggle {
                position: absolute;
                right: 0.75rem;
                top: 50%;
                transform: translateY(-50%);
                background: none;
                border: none;
                color: #34495E;
                cursor: pointer;
                font-size: 1rem;
                padding: 0.25rem;
            }

            .password-toggle:hover {
                color: #1ABC9C;
            }

            /* Status Badges */
            .status-badge {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.5rem 1rem;
                border-radius: 20px;
                font-size: 0.85rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .status-user {
                background: linear-gradient(135deg, #1ABC9C, #16A085);
                color: white;
            }

            .status-active {
                background: linear-gradient(135deg, #1ABC9C, #16A085);
                color: white;
            }

            /* Password Requirements */
            .password-requirements {
                margin-top: 0.5rem;
                padding: 0.75rem;
                background: rgba(236, 253, 241, 0.3);
                border-radius: 8px;
                border-left: 4px solid #1ABC9C;
            }

            .requirement-item {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                font-size: 0.85rem;
                color: #34495E;
            }

            .requirement-item.valid {
                color: #1ABC9C;
            }

            .requirement-item i {
                font-size: 0.75rem;
            }

            /* Password Match Indicator */
            .password-match {
                margin-top: 0.5rem;
                padding: 0.5rem;
                border-radius: 8px;
                font-size: 0.85rem;
                font-weight: 600;
                text-align: center;
            }

            .password-match.match {
                background: rgba(26, 188, 156, 0.2);
                color: #16A085;
            }

            .password-match.no-match {
                background: rgba(231, 76, 60, 0.2);
                color: #C0392B;
            }

            /* Buttons */
            .btn {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.75rem 1.5rem;
                border: none;
                border-radius: 12px;
                font-size: 1rem;
                font-weight: 600;
                text-decoration: none;
                cursor: pointer;
                transition: all 0.3s ease;
                text-align: center;
                min-width: 140px;
                justify-content: center;
            }

            .btn-primary {
                background: linear-gradient(135deg, #2C3E50, #34495E);
                color: white;
            }

            .btn-primary:hover {
                background: linear-gradient(135deg, #1A252F, #2C3E50);
                transform: translateY(-2px);
                box-shadow: 0 10px 25px rgba(44, 62, 80, 0.4);
            }

            .btn-secondary {
                background: linear-gradient(135deg, #1ABC9C, #16A085);
                color: white;
            }

            .btn-secondary:hover {
                background: linear-gradient(135deg, #17A2B8, #138496);
                transform: translateY(-2px);
                box-shadow: 0 10px 25px rgba(26, 188, 156, 0.4);
            }

            /* Responsive Design */
            @media (max-width: 1024px) {
                .profile-grid {
                    grid-template-columns: 1fr;
                }
            }

            @media (max-width: 768px) {
                .sidebar {
                    width: 100%;
                    position: relative;
                    height: auto;
                }

                .main-content {
                    margin-left: 0;
                    max-width: 100%;
                    padding: 1rem;
                }

                .app-container {
                    flex-direction: column;
                }

                .page-title {
                    font-size: 2rem;
                }

                .profile-card {
                    padding: 1.5rem;
                }
            }

            /* Animations */
            @keyframes slideIn {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .fade-in {
                animation: slideIn 0.5s ease;
            }
        </style>
    </head>
    <body>
        <%
         if (session.getAttribute("loginedUser") == null) {
             response.sendRedirect("index.jsp");
         } else {
            User us = (User) session.getAttribute("loginedUser");
            String successMessage = (String) request.getAttribute("successMessage");
            String errorMessage = (String) request.getAttribute("errorMessage");
        %>

        <div class="app-container">
            <!-- Modern Sidebar -->
            <div class="sidebar">
                <div class="sidebar-header">
                    <div class="sidebar-title">
                        <i class="fas fa-user-circle"></i>
                        Account Management
                    </div>
                </div>
                <nav class="sidebar-nav">
                    <div class="nav-item">
                        <a href="home" class="nav-link">
                            <i class="fas fa-home"></i>
                            Home
                        </a>
                    </div>
                    <div class="nav-item">
                        <a href="MyStorageServlet" class="nav-link">
                            <i class="fas fa-book"></i>
                            My Books
                        </a>
                    </div>
                    <div class="nav-item">
                        <a href="cart" class="nav-link">
                            <i class="fas fa-shopping-cart"></i>
                            Book Cart
                        </a>
                    </div>
                    <div class="nav-item">
                        <a href="ChangeProfile" class="nav-link active">
                            <i class="fas fa-user-cog"></i>
                            Profile
                        </a>
                    </div>
                    <div class="nav-item">
                        <a href="#" class="nav-link">
                            <i class="fas fa-bell"></i>
                            Notifications
                        </a>
                    </div>
                </nav>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <!-- Content Header -->
                <div class="content-header">
                    <h1 class="page-title">Profile Management</h1>
                    <p class="page-subtitle">Update personal information and change password</p>
                </div>

                <!-- Alert Messages -->
                <% if (successMessage != null) { %>
                <div class="alert alert-success fade-in">
                    <i class="fas fa-check-circle"></i>
                    <span><%= successMessage %></span>
                    <button class="alert-close" onclick="this.parentElement.style.display='none'">&times;</button>
                </div>
                <% } %>
                <% if (errorMessage != null) { %>
                <div class="alert alert-error fade-in">
                    <i class="fas fa-exclamation-circle"></i>
                    <span><%= errorMessage %></span>
                    <button class="alert-close" onclick="this.parentElement.style.display='none'">&times;</button>
                </div>
                <% } %>

                <!-- Profile Grid -->
                <div class="profile-grid">
                    <!-- Profile Information Card -->
                    <div class="profile-card fade-in">
                        <div class="card-header">
                            <i class="fas fa-user-edit card-icon"></i>
                            <h3 class="card-title">Personal Information</h3>
                        </div>

                        <form action="SaveProfileServlet" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="txtid" value="<%= us.getId() %>" />
                            <input type="hidden" name="action" value="updateProfile" />

                            <!-- Avatar Section -->
                            <div class="avatar-section">
                                <div class="avatar-container">
                                    <img src="<%= us.getAvatar() %>" alt="Avatar" class="avatar-image" id="avatarPreview" />
                                    <div class="avatar-overlay" onclick="document.getElementById('avatarInput').click()">
                                        <button type="button" class="avatar-upload-btn">
                                            <i class="fas fa-camera"></i>
                                        </button>
                                    </div>
                                </div>
                                <input type="file" name="avatar" id="avatarInput" accept="image/*" class="file-input-hidden" />
                                <p style="color: #34495E; font-size: 0.85rem;">Click on image to change</p>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Full Name</label>
                                <input type="text" name="txtname" value="<%= us.getName() %>" required class="form-input" />
                            </div>

                            <div class="form-group">
                                <label class="form-label">Email</label>
                                <input type="email" value="<%= us.getEmail() %>" readonly class="form-input" />
                            </div>

                            <div class="form-group">
                                <label class="form-label">Role</label>
                                <div>
                                    <span class="status-badge status-user">
                                        <i class="fas fa-user"></i>
                                        <%= us.getRole() %>
                                    </span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Status</label>
                                <div>
                                    <span class="status-badge status-active">
                                        <i class="fas fa-check-circle"></i>
                                        <%= us.getStatus() %>
                                    </span>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i>
                                Save Information
                            </button>
                        </form>
                    </div>

                    <!-- Change Password Card -->
                    <div class="profile-card fade-in">
                        <div class="card-header">
                            <i class="fas fa-lock card-icon"></i>
                            <h3 class="card-title">Change Password</h3>
                        </div>

                        <form action="SaveProfileServlet" method="post">
                            <input type="hidden" name="txtid" value="<%= us.getId() %>" />
                            <input type="hidden" name="action" value="changePassword" />

                            <div class="form-group">
                                <label class="form-label">Current Password</label>
                                <div class="password-field">
                                    <input type="password" name="txtcurrentpassword" id="txtcurrentpassword" required class="form-input" />
                                    <button type="button" class="password-toggle" onclick="togglePassword('txtcurrentpassword', this)">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">New Password</label>
                                <div class="password-field">
                                    <input type="password" name="txtnewpassword" id="txtnewpassword" required class="form-input" />
                                    <button type="button" class="password-toggle" onclick="togglePassword('txtnewpassword', this)">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                                <div class="password-requirements">
                                    <div class="requirement-item" id="lengthReq">
                                        <i class="fas fa-times"></i>
                                        <span>At least 8 characters</span>
                                    </div>
                                    <div class="requirement-item" id="upperReq">
                                        <i class="fas fa-times"></i>
                                        <span>Contains uppercase letter</span>
                                    </div>
                                    <div class="requirement-item" id="lowerReq">
                                        <i class="fas fa-times"></i>
                                        <span>Contains lowercase letter</span>
                                    </div>
                                    <div class="requirement-item" id="numberReq">
                                        <i class="fas fa-times"></i>
                                        <span>Contains number</span>
                                    </div>
                                    <div class="requirement-item" id="specialReq">
                                        <i class="fas fa-times"></i>
                                        <span>Contains special character</span>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Confirm New Password</label>
                                <div class="password-field">
                                    <input type="password" name="txtconfirmnewpassword" id="txtconfirmnewpassword" required class="form-input" />
                                    <button type="button" class="password-toggle" onclick="togglePassword('txtconfirmnewpassword', this)">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                                <div id="passwordMatch" class="password-match" style="display: none;"></div>
                            </div>

                            <button type="submit" class="btn btn-secondary">
                                <i class="fas fa-key"></i>
                                Change Password
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // Avatar Preview
            document.getElementById('avatarInput').addEventListener('change', function (e) {
                const file = e.target.files[0];
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        document.getElementById('avatarPreview').src = e.target.result;
                    };
                    reader.readAsDataURL(file);
                }
            });

            // Password Toggle
            function togglePassword(inputId, button) {
                const input = document.getElementById(inputId);
                const icon = button.querySelector('i');
                if (input.type === 'password') {
                    input.type = 'text';
                    icon.classList.remove('fa-eye');
                    icon.classList.add('fa-eye-slash');
                } else {
                    input.type = 'password';
                    icon.classList.remove('fa-eye-slash');
                    icon.classList.add('fa-eye');
                }
            }

            // Password Validation
            document.getElementById('txtnewpassword').addEventListener('input', function (e) {
                const pwd = e.target.value;
                
                // Check length
                const lengthReq = document.getElementById('lengthReq');
                updateRequirement(lengthReq, pwd.length >= 8);
                
                // Check uppercase
                const upperReq = document.getElementById('upperReq');
                updateRequirement(upperReq, /[A-Z]/.test(pwd));
                
                // Check lowercase
                const lowerReq = document.getElementById('lowerReq');
                updateRequirement(lowerReq, /[a-z]/.test(pwd));
                
                // Check number
                const numberReq = document.getElementById('numberReq');
                updateRequirement(numberReq, /\d/.test(pwd));
                
                // Check special character
                const specialReq = document.getElementById('specialReq');
                updateRequirement(specialReq, /[!@#$%^&*(),.?":{}|<>]/.test(pwd));
                
                // Check password match
                checkPasswordMatch();
            });

            function updateRequirement(element, isValid) {
                const icon = element.querySelector('i');
                if (isValid) {
                    element.classList.add('valid');
                    icon.classList.remove('fa-times');
                    icon.classList.add('fa-check');
                } else {
                    element.classList.remove('valid');
                    icon.classList.remove('fa-check');
                    icon.classList.add('fa-times');
                }
            }

            // Password Match Check
            function checkPasswordMatch() {
                const newPassword = document.getElementById('txtnewpassword').value;
                const confirmPassword = document.getElementById('txtconfirmnewpassword').value;
                const matchDiv = document.getElementById('passwordMatch');

                if (confirmPassword === '') {
                    matchDiv.style.display = 'none';
                    return;
                }

                matchDiv.style.display = 'block';
                if (newPassword === confirmPassword) {
                    matchDiv.textContent = '✓ Passwords match';
                    matchDiv.className = 'password-match match';
                } else {
                    matchDiv.textContent = '✗ Passwords do not match';
                    matchDiv.className = 'password-match no-match';
                }
            }

            document.getElementById('txtconfirmnewpassword').addEventListener('input', checkPasswordMatch);
            
            // Auto-hide alerts after 5 seconds
            setTimeout(() => {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(alert => {
                    alert.style.opacity = '0';
                    alert.style.transform = 'translateY(-20px)';
                    setTimeout(() => alert.remove(), 300);
                });
            }, 5000);
        </script>
        <%
         }
        %>
    </body>
</html>