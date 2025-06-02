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
        <title>Change Profile</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #ECFOF1 0%, #1ABC9C 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }

            .profile-container {
                background: white;
                border-radius: 15px;
                box-shadow: 0 15px 35px rgba(44, 62, 80, 0.1);
                padding: 40px;
                width: 100%;
                max-width: 500px;
                position: relative;
                overflow: hidden;
            }

            .profile-container::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 5px;
                background: linear-gradient(90deg, #1ABC9C, #16A085, #2C3E50);
            }

            .profile-header {
                text-align: center;
                margin-bottom: 35px;
            }

            .profile-header h1 {
                color: #2C3E50;
                font-size: 28px;
                font-weight: 600;
                margin-bottom: 8px;
            }

            .profile-header p {
                color: #34495E;
                font-size: 14px;
                opacity: 0.8;
            }

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
                border: 2px solid #ECFOF1;
                border-radius: 10px;
                font-size: 16px;
                color: #2C3E50;
                background: #ECFOF1;
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

            .form-group input[type="password"] {
                font-family: 'Courier New', monospace;
                letter-spacing: 2px;
            }

            .status-badge {
                display: inline-block;
                padding: 8px 15px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                background: #16A085;
                color: white;
                margin-top: 5px;
            }

            .role-badge {
                display: inline-block;
                padding: 8px 15px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                background: #34495E;
                color: white;
                margin-top: 5px;
            }

            .submit-btn {
                width: 100%;
                padding: 18px;
                background: linear-gradient(135deg, #1ABC9C, #16A085);
                color: white;
                border: none;
                border-radius: 10px;
                font-size: 16px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 1px;
                cursor: pointer;
                transition: all 0.3s ease;
                margin-top: 20px;
                box-shadow: 0 5px 15px rgba(26, 188, 156, 0.3);
            }

            .submit-btn:hover {
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(26, 188, 156, 0.4);
                background: linear-gradient(135deg, #16A085, #1ABC9C);
            }

            .submit-btn:active {
                transform: translateY(-1px);
            }

            .user-icon {
                width: 80px;
                height: 80px;
                background: linear-gradient(135deg, #1ABC9C, #16A085);
                border-radius: 50%;
                margin: 0 auto 20px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 35px;
                font-weight: bold;
                box-shadow: 0 8px 20px rgba(26, 188, 156, 0.3);
            }

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

            .profile-container {
                animation: fadeInUp 0.6s ease-out;
            }

            .form-group {
                animation: fadeInUp 0.6s ease-out;
                animation-fill-mode: both;
            }

            .form-group:nth-child(2) { animation-delay: 0.1s; }
            .form-group:nth-child(3) { animation-delay: 0.2s; }
            .form-group:nth-child(4) { animation-delay: 0.3s; }
            .form-group:nth-child(5) { animation-delay: 0.4s; }
            .form-group:nth-child(6) { animation-delay: 0.5s; }

            @media (max-width: 768px) {
                .profile-container {
                    padding: 30px 25px;
                    margin: 10px;
                }
                
                .profile-header h1 {
                    font-size: 24px;
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
       %>
       
       <div class="profile-container">
           <div class="profile-header">
               <div class="user-icon">
                   <%= us.getName().substring(0,1).toUpperCase() %>
               </div>
               <h1>Edit Profile</h1>
               <p>Update your personal information</p>
           </div>
           
           <form action='SaveProfileServlet' method='post'>
               <input type='hidden' name='txtid' value='<%= us.getId() %>' />
               
               <div class="form-group">
                   <label for="txtname">Full Name</label>
                   <input type='text' id="txtname" name='txtname' value='<%= us.getName() %>' required />
               </div>
               
               <div class="form-group">
                   <label for="txtemail">Email Address</label>
                   <input type='email' id="txtemail" name='txtemail' value='<%= us.getEmail() %>' readonly />
               </div>
               
               <div class="form-group">
                   <label for="txtpassword">Password</label>
                   <input type='password' id="txtpassword" name='txtpassword' value='<%= us.getPassword() %>' required />
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
                   Save Changes
               </button>
           </form>
       </div>
       
       <%
        }
       %>
    </body>
</html>