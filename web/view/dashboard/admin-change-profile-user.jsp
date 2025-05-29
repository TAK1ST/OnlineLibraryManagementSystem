<%-- 
    Document   : admin-change-profile-user
    Created on : May 29, 2025, 11:44:06 PM
    Author     : asus
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
      <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>User Management</title>
            <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css"/>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/container.css"/>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css"/>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-change-profile-user.css"/>

      </head>
      <body>
            <div class="main-container">
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
                        <div class="header">
                              <h1 class="page-title">User Management</h1>
                              <button class="logout-btn">Logout</button>
                        </div>

                        <div class="content-area">
                              <div class="search-section">
                                    <h2 class="search-title">Search</h2>
                                    <form>
                                          <div class="mb-3">
                                                <label for="username" class="form-label">Username</label>
                                                <input type="text" class="form-control" id="username" placeholder="Enter username">
                                          </div>
                                          <div class="mb-3">
                                                <label for="email" class="form-label">Email</label>
                                                <input type="text" class="form-control" id="email" placeholder="Enter email">
                                          </div>
                                          <button type="button" class="search-btn" data-bs-toggle="modal" data-bs-target="#userModal">Search</button>
                                    </form>
                              </div>
                        </div>

                        <div class="footer">
                              ©Copyright Group 7
                        </div>
                  </div>
            </div>

            <!-- User Modal -->
            <div class="modal fade" id="userModal" tabindex="-1" aria-labelledby="userModalLabel" aria-hidden="true">
                  <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                              <div class="modal-body">
                                    <div class="modal-user-section">
                                          <div class="user-modal-avatar">
                                                <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                                                <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                                                </svg>
                                          </div>
                                          <form class="modal-form">
                                                <div class="form-row">
                                                      <label for="modalEmail" class="modal-label">Email</label>
                                                      <input type="email" class="modal-input" id="modalEmail" value="email default">
                                                </div>
                                                <div class="form-row">
                                                      <label for="modalName" class="modal-label">name</label>
                                                      <input type="text" class="modal-input" id="modalName" value="username default">
                                                </div>
                                                <div class="form-row">
                                                      <label for="modalPassword" class="modal-label">password</label>
                                                      <input type="text" class="modal-input" id="modalPassword" value="password hash">
                                                </div>
                                                <div class="form-row">
                                                      <label for="modalRole" class="modal-label">role</label>
                                                      <select class="modal-select" id="modalRole">
                                                            <option selected>role default</option>
                                                            <option value="admin">Administrator</option>
                                                            <option value="user">User</option>
                                                            <option value="moderator">Moderator</option>
                                                      </select>
                                                </div>
                                                <div class="form-row">
                                                      <label for="modalStatus" class="modal-label">status</label>
                                                      <select class="modal-select" id="modalStatus">
                                                            <option selected>username default</option>
                                                            <option value="active">Active</option>
                                                            <option value="inactive">Inactive</option>
                                                            <option value="suspended">Suspended</option>
                                                      </select>
                                                </div>
                                                <div class="button-row">
                                                      <button type="button" class="btn-update">Update</button>
                                                      <button type="button" class="btn-delete">Delete</button>
                                                </div>
                                          </form>
                                    </div>
                              </div>
                        </div>
                  </div>
            </div>

            <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
            <script>
                  document.addEventListener('DOMContentLoaded', function () {
                        document.querySelector('.search-btn').addEventListener('click', function () {
                              setTimeout(() => {
                                    const modal = new bootstrap.Modal(document.getElementById('userModal'));
                                    modal.show();
                              });
                        });
                  });
            </script>
      </body>
</html>