<%-- 
    Document   : ChangeProfile
    Created on : Jun 2, 2025, 9:33:41 PM
    Author     : CAU_TU
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page  import="entity.User" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
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
                padding: 20px;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 30px;
            }

            .card {
                background: white;
                border-radius: 20px;
                box-shadow: 0 20px 40px rgba(44, 62, 80, 0.1);
                padding: 40px;
                position: relative;
                overflow: hidden;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .card:hover {
                transform: translateY(-5px);
                box-shadow: 0 25px 50px rgba(44, 62, 80, 0.15);
            }

            .card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 5px;
                background: linear-gradient(90deg, #1ABC9C, #16A085, #2C3E50);
            }

            .card-header {
                text-align: center;
                margin-bottom: 35px;
                padding-bottom: 20px;
                border-bottom: 2px solid #ECF0F1;
            }

            .card-header h2 {
                color: #2C3E50;
                font-size: 24px;
                font-weight: 600;
                margin-bottom: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
            }

            .card-header p {
                color: #7F8C8D;
                font-size: 14px;
            }

            .icon {
                width: 30px;
                height: 30px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                border-radius: 50%;
                background: linear-gradient(135deg, #1ABC9C, #16A085);
                color: white;
                font-size: 16px;
            }

            /* Profile Picture Section */
            .avatar-section {
                text-align: center;
                margin-bottom: 30px;
            }

            .avatar-container {
                position: relative;
                display: inline-block;
                margin-bottom: 20px;
            }

            .avatar-preview {
                width: 120px;
                height: 120px;
                border-radius: 50%;
                background: linear-gradient(135deg, #1ABC9C, #16A085);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 48px;
                font-weight: bold;
                box-shadow: 0 10px 30px rgba(26, 188, 156, 0.3);
                transition: all 0.3s ease;
                cursor: pointer;
                overflow: hidden;
                position: relative;
            }

            .avatar-preview:hover {
                transform: scale(1.05);
                box-shadow: 0 15px 40px rgba(26, 188, 156, 0.4);
            }

            .avatar-preview img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                border-radius: 50%;
            }

            .avatar-upload-overlay {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.5);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                opacity: 0;
                transition: opacity 0.3s ease;
                cursor: pointer;
            }

            .avatar-container:hover .avatar-upload-overlay {
                opacity: 1;
            }

            .avatar-upload-text {
                color: white;
                font-size: 14px;
                font-weight: 500;
                text-align: center;
            }

            .file-input {
                display: none;
            }

            .upload-btn {
                background: linear-gradient(135deg, #3498DB, #2980B9);
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 25px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                margin-top: 10px;
            }

            .upload-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(52, 152, 219, 0.3);
            }

            /* Form Styles */
            .form-group {
                margin-bottom: 25px;
                position: relative;
            }

            .form-group label {
                display: block;
                color: #2C3E50;
                font-weight: 500;
                margin-bottom: 8px;
                font-size: 14px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .form-group input {
                width: 100%;
                padding: 15px 20px;
                border: 2px solid #ECF0F1;
                border-radius: 12px;
                font-size: 16px;
                color: #2C3E50;
                background: #FAFBFC;
                transition: all 0.3s ease;
                outline: none;
            }

            .form-group input:focus {
                border-color: #1ABC9C;
                background: white;
                box-shadow: 0 0 0 3px rgba(26, 188, 156, 0.1);
                transform: translateY(-2px);
            }

            .form-group input[readonly] {
                background: #f8f9fa;
                color: #6c757d;
                cursor: not-allowed;
                border-color: #e9ecef;
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
                font-size: 18px;
                padding: 5px;
            }

            .password-toggle:hover {
                color: #1ABC9C;
            }

            .status-badge, .role-badge {
                display: inline-block;
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                margin-top: 5px;
            }

            .status-badge {
                background: linear-gradient(135deg, #16A085, #1ABC9C);
                color: white;
            }

            .role-badge {
                background: linear-gradient(135deg, #34495E, #2C3E50);
                color: white;
            }

            .submit-btn {
                width: 100%;
                padding: 18px;
                background: linear-gradient(135deg, #1ABC9C, #16A085);
                color: white;
                border: none;
                border-radius: 12px;
                font-size: 16px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 1px;
                cursor: pointer;
                transition: all 0.3s ease;
                margin-top: 20px;
                box-shadow: 0 8px 20px rgba(26, 188, 156, 0.3);
            }

            .submit-btn:hover {
                transform: translateY(-3px);
                box-shadow: 0 12px 30px rgba(26, 188, 156, 0.4);
            }

            .submit-btn:active {
                transform: translateY(-1px);
            }

            .password-submit-btn {
                background: linear-gradient(135deg, #E74C3C, #C0392B);
                box-shadow: 0 8px 20px rgba(231, 76, 60, 0.3);
            }

            .password-submit-btn:hover {
                box-shadow: 0 12px 30px rgba(231, 76, 60, 0.4);
            }

            /* Password Strength Indicator */
            .password-strength {
                height: 4px;
                background: #ECF0F1;
                border-radius: 2px;
                margin-top: 8px;
                overflow: hidden;
            }

            .password-strength-bar {
                height: 100%;
                width: 0%;
                transition: all 0.3s ease;
                border-radius: 2px;
            }

            .strength-weak {
                background: #E74C3C;
                width: 25%;
            }
            .strength-fair {
                background: #F39C12;
                width: 50%;
            }
            .strength-good {
                background: #F1C40F;
                width: 75%;
            }
            .strength-strong {
                background: #27AE60;
                width: 100%;
            }

            .password-requirements {
                font-size: 12px;
                color: #7F8C8D;
                margin-top: 8px;
                list-style: none;
            }

            .password-requirements li {
                padding: 2px 0;
                position: relative;
                padding-left: 20px;
            }

            .password-requirements li::before {
                content: '✗';
                position: absolute;
                left: 0;
                color: #E74C3C;
                font-weight: bold;
            }

            .password-requirements li.valid::before {
                content: '✓';
                color: #27AE60;
            }

            /* Animations */
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .card {
                animation: fadeInUp 0.6s ease-out;
            }

            .card:nth-child(2) {
                animation-delay: 0.2s;
            }

            /* Alert Styles */
            .alert {
                margin-bottom: 30px;
                border-radius: 12px;
                padding: 0;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                animation: slideInDown 0.5s ease-out;
                grid-column: 1 / -1;
            }

            .alert-success {
                background: linear-gradient(135deg, #27AE60, #2ECC71);
            }

            .alert-error {
                background: linear-gradient(135deg, #E74C3C, #EC7063);
            }

            .alert-content {
                display: flex;
                align-items: center;
                padding: 15px 20px;
                color: white;
            }

            .alert-icon {
                font-size: 18px;
                margin-right: 12px;
            }

            .alert-text {
                flex: 1;
                font-weight: 500;
                font-size: 14px;
            }

            .alert-close {
                background: none;
                border: none;
                color: white;
                font-size: 20px;
                cursor: pointer;
                padding: 0 5px;
                opacity: 0.8;
                transition: opacity 0.3s ease;
            }

            .alert-close:hover {
                opacity: 1;
            }

            @keyframes slideInDown {
                from {
                    opacity: 0;
                    transform: translateY(-100px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            @media (max-width: 768px) {
                .container {
                    grid-template-columns: 1fr;
                    gap: 20px;
                    padding: 10px;
                }

                .card {
                    padding: 30px 25px;
                }

                .card-header h2 {
                    font-size: 20px;
                }

                .avatar-preview {
                    width: 100px;
                    height: 100px;
                    font-size: 40px;
                }

                .form-group input {
                    padding: 12px 15px;
                    font-size: 14px;
                }

                .submit-btn {
                    padding: 15px;
                    font-size: 14px;
                }
            }
        </style>
    </head>
    <body>
        <%
         if(session.getAttribute("loginedUser")==null){
             response.sendRedirect("index.jsp");
         }
         else{
            User us=(User) session.getAttribute("loginedUser");
            String successMessage = (String) request.getAttribute("successMessage");
            String errorMessage = (String) request.getAttribute("errorMessage");
        %>

        <div class="container">
            <!-- Success/Error Messages -->
            <% if (successMessage != null) { %>
            <div class="alert alert-success">
                <div class="alert-content">
                    <span class="alert-icon">✅</span>
                    <span class="alert-text"><%= successMessage %></span>
                    <button class="alert-close" onclick="this.parentElement.parentElement.style.display = 'none'">×</button>
                </div>
            </div>
            <% } %>

            <% if (errorMessage != null) { %>
            <div class="alert alert-error">
                <div class="alert-content">
                    <span class="alert-icon">❌</span>
                    <span class="alert-text"><%= errorMessage %></span>
                    <button class="alert-close" onclick="this.parentElement.parentElement.style.display = 'none'">×</button>
                </div>
            </div>
            <% } %>
            <!-- Profile Information Card -->
            <div class="card">
                <div class="card-header">
                    <a href="home" style="text-decoration: none">
                        <button class="back-btn">
                            <i class="fas fa-arrow-left"></i>
                        </button>
                    </a>
                    <h2>
                        <span class="icon">👤</span>
                        Profile Information
                    </h2>
                    <p>Update your personal details</p>
                </div>

                <!-- Avatar Section -->
                <div class="avatar-section">
                    <div class="avatar-container">
                        <div class="avatar-preview" id="avatarPreview">
                            <% if (us.getAvatar() != null && !us.getAvatar().isEmpty()) { %>
                            <img src="<%= ImageDisplayHelper.getUserAvatarUrl(us) %>" alt="Avatar">
                            <% } else { %>
                            <%= us.getName().substring(0,1).toUpperCase() %>
                            <% } %>
                            <div class="avatar-upload-overlay">
                                <div class="avatar-upload-text">
                                    📷<br><input type="file" id="avatarInput" name="avatar" class="file-input" accept="image/*">
                                    <button type="button" class="upload-btn" onclick="document.getElementById('avatarInput').click()">
                                        Change Photo
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <form action='SaveProfileServlet' method='post' enctype="multipart/form-data">
                    <input type='hidden' name='txtid' value='<%= us.getId() %>' />
                    <input type='hidden' name='action' value='updateProfile' />

                    <div class="form-group">
                        <label for="txtname">Full Name</label>
                        <input type='text' id="txtname" name='txtname' value='<%= us.getName() %>' required />
                    </div>

                    <div class="form-group">
                        <label for="txtemail">Email Address</label>
                        <input type='email' id="txtemail" name='txtemail' value='<%= us.getEmail() %>' readonly />
                    </div>

                    <div class="form-group">
                        <label for="txtrole">Role</label>
                        <input type='text' id="txtrole" name='txtrole' value='<%= us.getRole() %>' readonly style="display: none;" />
                        <span class="role-badge"><%= us.getRole() %></span>
                    </div>

                    <div class="form-group">
                        <label for="txtstatus">Account Status</label>
                        <input type='text' id="txtstatus" name='txtstatus' value='<%= us.getStatus() %>' readonly style="display: none;" />
                        <span class="status-badge"><%= us.getStatus() %></span>
                    </div>

                    <button type='submit' class="submit-btn">
                        💾 Save Profile Changes
                    </button>
                </form>
            </div>

            <!-- Password Change Card -->
            <div class="card">
                <div class="card-header">
                    <h2>
                        <span class="icon">🔒</span>
                        Change Password
                    </h2>
                    <p>Update your account security</p>
                </div>

                <form action='SaveProfileServlet' method='post'>
                    <input type='hidden' name='txtid' value='<%= us.getId() %>' />
                    <input type='hidden' name='action' value='changePassword' />

                    <div class="form-group">
                        <label for="txtcurrentpassword">Current Password</label>
                        <div class="password-group">
                            <input type='password' id="txtcurrentpassword" name='txtcurrentpassword' placeholder="Enter your current password" required />
                            <button type="button" class="password-toggle" onclick="togglePassword('txtcurrentpassword')">👁️</button>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="txtnewpassword">New Password</label>
                        <div class="password-group">
                            <input type='password' id="txtnewpassword" name='txtnewpassword' placeholder="Enter new password" required />
                            <button type="button" class="password-toggle" onclick="togglePassword('txtnewpassword')">👁️</button>
                        </div>
                        <div class="password-strength">
                            <div class="password-strength-bar" id="strengthBar"></div>
                        </div>
                        <ul class="password-requirements" id="passwordRequirements">
                            <li id="lengthReq">At least 8 characters</li>
                            <li id="upperReq">One uppercase letter</li>
                            <li id="lowerReq">One lowercase letter</li>
                            <li id="numberReq">One number</li>
                            <li id="specialReq">One special character</li>
                        </ul>
                    </div>

                    <div class="form-group">
                        <label for="txtconfirmnewpassword">Confirm New Password</label>
                        <div class="password-group">
                            <input type='password' id="txtconfirmnewpassword" name='txtconfirmnewpassword' placeholder="Confirm new password" required />
                            <button type="button" class="password-toggle" onclick="togglePassword('txtconfirmnewpassword')">👁️</button>
                        </div>
                        <div id="passwordMatch" style="font-size: 12px; margin-top: 5px;"></div>
                    </div>

                    <button type='submit' class="submit-btn password-submit-btn">
                        🔐 Change Password
                    </button>
                </form>
            </div>
        </div>

        <script>
            // Avatar Upload Preview
            document.getElementById('avatarInput').addEventListener('change', function (e) {
                const file = e.target.files[0];
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        const avatarPreview = document.getElementById('avatarPreview');
                        avatarPreview.innerHTML = `<img src="${e.target.result}" alt="Avatar">`;
                    };
                    reader.readAsDataURL(file);
                }
            });

            // Password Toggle
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

            // Password Strength Checker
            document.getElementById('txtnewpassword').addEventListener('input', function (e) {
                const password = e.target.value;
                const strengthBar = document.getElementById('strengthBar');
                const requirements = {
                    length: password.length >= 8,
                    upper: /[A-Z]/.test(password),
                    lower: /[a-z]/.test(password),
                    number: /\d/.test(password),
                    special: /[!@#$%^&*(),.?":{}|<>]/.test(password)
                };

                // Update requirement indicators
                document.getElementById('lengthReq').classList.toggle('valid', requirements.length);
                document.getElementById('upperReq').classList.toggle('valid', requirements.upper);
                document.getElementById('lowerReq').classList.toggle('valid', requirements.lower);
                document.getElementById('numberReq').classList.toggle('valid', requirements.number);
                document.getElementById('specialReq').classList.toggle('valid', requirements.special);

                // Calculate strength
                const validCount = Object.values(requirements).filter(Boolean).length;
                strengthBar.className = 'password-strength-bar';

                if (validCount >= 5)
                    strengthBar.classList.add('strength-strong');
                else if (validCount >= 4)
                    strengthBar.classList.add('strength-good');
                else if (validCount >= 3)
                    strengthBar.classList.add('strength-fair');
                else if (validCount >= 1)
                    strengthBar.classList.add('strength-weak');
            });

            // Password Match Checker
            function checkPasswordMatch() {
                const newPassword = document.getElementById('txtnewpassword').value;
                const confirmPassword = document.getElementById('txtconfirmnewpassword').value;
                const matchDiv = document.getElementById('passwordMatch');

                if (confirmPassword === '') {
                    matchDiv.textContent = '';
                    return;
                }

                if (newPassword === confirmPassword) {
                    matchDiv.textContent = '✓ Passwords match';
                    matchDiv.style.color = '#27AE60';
                } else {
                    matchDiv.textContent = '✗ Passwords do not match';
                    matchDiv.style.color = '#E74C3C';
                }
            }

            document.getElementById('txtnewpassword').addEventListener('input', checkPasswordMatch);
            document.getElementById('txtconfirmnewpassword').addEventListener('input', checkPasswordMatch);
        </script>

        <%
         }
        %>
    </body>
</html>