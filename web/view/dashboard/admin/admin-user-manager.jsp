<%-- 
    Document   : admin-user-manager
    Created on : May 24, 2025, 7:36:38 PM
    Author     : asus
--%>
<!DOCTYPE html>
<html lang="en">
      <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>User Management</title>
            <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css"/>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-user-manager.css"/>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css"/>

      </head>
      <body>
            <div class="container-fluid p-0">
                  <!-- Sidebar -->
                  <div class="sidebar">
                        <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" alt="Avatar">
                        <h3>Role: Administrator</h3>
                        <a href="admindashboard" class="nav-link">
                              <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                        </a>
                        <a href="systemconfig" class="nav-link">
                              <i class="fas fa-cogs me-2"></i>System Config
                        </a>
                        <a href="usermanagement" class="nav-link active">
                              <i class="fas fa-users me-2"></i>User Management
                        </a>
                        <a href="overduebook" class="nav-link">
                              <i class="fas fa-exclamation-triangle me-2"></i>Overdue Books
                        </a>
                        <a href="bookmanagement" class="nav-link">
                              <i class="fas fa-book me-2"></i>Book Management
                        </a>
                        <a href="updateinventory" class="nav-link">
                              <i class="fas fa-boxes me-2"></i>Update Inventory
                        </a>
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
                                    <h2 class="search-title">
                                          <i class="fas fa-search"></i>
                                          Search Users
                                    </h2>
                                    <div class="search-form">
                                          <div class="form-group">
                                                <label for="searchName" class="form-label">
                                                      <i class="fas fa-user me-2"></i>Name
                                                </label>
                                                <input type="text" class="form-control" id="searchName" placeholder="Enter name to search...">
                                          </div>
                                          <div class="form-group">
                                                <label for="searchEmail" class="form-label">
                                                      <i class="fas fa-envelope me-2"></i>Email
                                                </label>
                                                <input type="email" class="form-control" id="searchEmail" placeholder="Enter email to search...">
                                          </div>
                                          <div class="form-group">
                                                <button class="search-btn" id="searchBtn">
                                                      <i class="fas fa-search me-2"></i>Search
                                                </button>
                                          </div>
                                          <div class="form-group">
                                                <button class="clear-btn" id="clearBtn">
                                                      <i class="fas fa-times me-2"></i>Clear
                                                </button>
                                          </div>
                                    </div>
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
                                    <div class="table-body" id="tableBody">
                                          <div class="empty-state">
                                                <i class="fas fa-users"></i>
                                                <p>Enter search criteria to find users</p>
                                          </div>
                                    </div>
                              </div>
                        </div>

                        <!-- Footer -->
                        <div class="footer">
                              ©Copyright Group 7
                        </div>
                  </div>
            </div>

            <!-- User Modal -->
            <div class="modal fade" id="userModal" tabindex="-1" aria-labelledby="userModalLabel" aria-hidden="true">
                  <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                              <div class="modal-header">
                                    <h5 class="modal-title" id="userModalLabel">
                                          <i class="fas fa-user-edit me-2"></i>Edit User Profile
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                              </div>
                              <div class="modal-body">
                                    <div class="modal-user-section">
                                          <div class="user-modal-avatar">
                                                <i class="fas fa-user"></i>
                                          </div>
                                          <form class="modal-form" id="userForm">
                                                <div class="form-row">
                                                      <label for="modalEmail" class="modal-label">Email</label>
                                                      <input type="email" class="modal-input" id="modalEmail" value="">
                                                </div>
                                                <div class="form-row">
                                                      <label for="modalName" class="modal-label">Name</label>
                                                      <input type="text" class="modal-input" id="modalName" value="">
                                                </div>
                                                <div class="form-row">
                                                      <label for="modalPassword" class="modal-label">Password</label>
                                                      <input type="password" class="modal-input" id="modalPassword" placeholder="Enter new password">
                                                </div>
                                                <div class="form-row">
                                                      <label for="modalRole" class="modal-label">Role</label>
                                                      <select class="modal-select" id="modalRole">
                                                            <option value="user">User</option>
                                                            <option value="admin">Administrator</option>
                                                            <option value="moderator">Moderator</option>
                                                      </select>
                                                </div>
                                                <div class="form-row">
                                                      <label for="modalStatus" class="modal-label">Status</label>
                                                      <select class="modal-select" id="modalStatus">
                                                            <option value="active">Active</option>
                                                            <option value="inactive">Inactive</option>
                                                            <option value="suspended">Suspended</option>
                                                      </select>
                                                </div>
                                                <div class="button-row">
                                                      <button type="button" class="btn-update" id="updateBtn">
                                                            <i class="fas fa-save me-2"></i>Update
                                                      </button>
                                                      <button type="button" class="btn-delete" id="deleteBtn">
                                                            <i class="fas fa-trash me-2"></i>Delete
                                                      </button>
                                                </div>
                                          </form>
                                    </div>
                              </div>
                        </div>
                  </div>
            </div>
      </body>
</html>
