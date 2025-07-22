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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user-change-profile.css"/>
        <title>Profile Management</title>
<!--        <style>
            
        </style>-->
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