<%-- 
    Document   : admin-user-manager
    Created on : May 24, 2025, 7:36:38 PM
    Author     : asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
      <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>User Management</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-user-manager.css"/>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css"/>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/container.css"/>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css"/>
      </head>
      <body>
            <div class="container-fluid">
                  <!-- Sidebar -->
                  <div class="sidebar">
                        <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" alt="Avatar">
                        <h3>Role: Adminator</h3>
                        <a href="#" class="nav-link active">Dashboard</a>
                        <a href="#" class="nav-link">System Config</a>
                        <a href="#" class="nav-link">User Management</a>
                        <a href="#" class="nav-link">Overdue Books</a>
                        <a href="#" class="nav-link">Book Management</a>
                        <a href="#" class="nav-link">Update Inventory</a>
                  </div>
                  <!-- Main Content -->
                  <div class="main-content">
                        <!-- Header -->
                        <div class="header">
                              <h1><i class="fas fa-users-cog me-3"></i>User Management</h1>
                              <button class="logout-btn">
                                    <i class="fas fa-sign-out-alt me-2"></i>Logout
                              </button>
                        </div>

                        <!-- Content Area -->
                        <div class="content-area">
                              <!-- Search Section -->
                              <div class="search-section">
                                    <button class="search-btn" onclick="searchUsers()">
                                          <i class="fas fa-search me-2"></i>Search
                                    </button>
                              </div>

                              <!-- User Table -->
                              <div class="user-table">
                                    <div class="table-header">
                                          <div class="row g-0">
                                                <div class="col-3">
                                                      <div class="th">
                                                            <i class="fas fa-user me-2"></i>Name
                                                      </div>
                                                </div>
                                                <div class="col-3">
                                                      <div class="th">
                                                            <i class="fas fa-envelope me-2"></i>Email
                                                      </div>
                                                </div>
                                                <div class="col-3">
                                                      <div class="th">
                                                            <i class="fas fa-user-tag me-2"></i>Role
                                                      </div>
                                                </div>
                                                <div class="col-3">
                                                      <div class="th">
                                                            <i class="fas fa-toggle-on me-2"></i>Status
                                                      </div>
                                                </div>
                                          </div>
                                    </div>
                                    <div class="table-body">
                                          <div class="empty-state">
                                                <i class="fas fa-users"></i>
                                                <p>Loading user data...</p>
                                          </div>
                                    </div>
                              </div>
                        </div>
                  </div>
            </div>
                  <!-- Footer -->
                  <div class="footer">
                        ©Copyright Group 7
                  </div>                  
      </body>
</html>
