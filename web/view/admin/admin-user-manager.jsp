<%-- 
    Document   : admin-user-manager
    Created on : May 24, 2025, 7:36:38 PM
    Author     : asus
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="entity.User" %>

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
                <a href="statusrequestborrowbook" class="nav-link">
                    <i class="fas fa-exclamation-triangle me-2"></i>View Request Books
                </a>
                <a href="bookmanagement" class="nav-link">
                    <i class="fas fa-book me-2"></i>Book Management
                </a>
                <a href="updateinventory" class="nav-link">
                    <i class="fas fa-boxes me-2"></i>Update Inventory
                </a>
                <a href="overduebook" class="nav-link">
                    <i class="fas fa-boxes"></i> Overdue Book
                </a>
            </div>
            <!-- Main Content -->
            <div class="main-content">
                <!-- Header -->
                <div class="header">
                    <h1><i class="fas fa-users-cog me-3"></i>User Management</h1>
                    <a href="LogoutServlet">
                        <button class="logout-btn">
                            <i class="fas fa-sign-out-alt me-2"></i>Logout
                        </button>
                    </a>
                </div>

                <!-- Content Area -->
                <div class="content-area">
                    <!-- Search Section -->
                    <div class="search-section">
                        <h2 class="search-title">
                            <i class="fas fa-search"></i>
                            Search Users
                        </h2>
                        <form action="searchUser" method="GET">
                            <div class="search-form">
                                <div class="form-group">
                                    <label for="searchName" class="form-label">
                                        <i class="fas fa-user me-2"></i>Name
                                    </label>
                                    <input type="text" class="form-control" id="searchName" name="searchName" 
                                           value="${param.searchName}" placeholder="Enter name to search...">
                                </div>
                                <div class="form-group">
                                    <label for="searchEmail" class="form-label">
                                        <i class="fas fa-envelope me-2"></i>Email
                                    </label>
                                    <input type="email" class="form-control" id="searchEmail" name="searchEmail" 
                                           value="${param.searchEmail}" placeholder="Enter email to search...">
                                </div>
                                <div class="form-group">      
                                    <button type="submit" class="search-btn" id="searchBtn">
                                        <i class="fas fa-search me-2"></i>Search
                                    </button>
                                    <a href="usermanagement">
                                        <button type="button" class="clear-btn" id="clearBtn">
                                            <i class="fas fa-times me-2"></i>Clear
                                        </button>
                                    </a>
                                </div>
                            </div>
                        </form>

                        <div id="loading" style="display: none;">Loading...</div>

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
                                <div class="col-4">
                                    <div class="th">
                                        <i class="fas fa-envelope me-2"></i>Email
                                    </div>
                                </div>
                                <div class="col-3">
                                    <div class="th">
                                        <i class="fas fa-user-tag me-2"></i>Role
                                    </div>
                                </div>
                                <div class="col-2">
                                    <div class="th">
                                        <i class="fas fa-toggle-on me-2"></i>Status
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- User Table -->
                        <div class="table-body" id="tableBody">
                            <jsp:include page="/view/admin/user-list-fragment.jsp"/>
                        </div>
                    </div>

                    <!-- Footer -->
                    <div class="footer">
                        ©Copyright Group 7
                    </div>
                </div>
            </div>
            <!-- Include Modal -->
            <jsp:include page="/view/admin/user-modal-fragment.jsp"/>

            <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
            <script>
                      let offset = ${requestScope.offset != null ? requestScope.offset : 0};
                      let isLoading = false;
                      let hasMoreData = true;
                      let searchName = "${param.searchName != null ? param.searchName : ''}";
                      let searchEmail = "${param.searchEmail != null ? param.searchEmail : ''}";
                      let isSearchMode = false;
                      function updateSearchMode() {
                          isSearchMode = (searchName.trim() !== '' || searchEmail.trim() !== '');
                      }

                      updateSearchMode();
                      window.addEventListener('scroll', function () {
                          if (window.innerHeight + window.scrollY >= document.body.offsetHeight - 50 && !isLoading && hasMoreData) {
                              loadMoreUsers();
                          }
                      });
                      document.getElementById('searchBtn').addEventListener('click', function (e) {
                          e.preventDefault();
                          searchName = document.getElementById('searchName').value.trim();
                          searchEmail = document.getElementById('searchEmail').value.trim();
                          offset = 0;
                          hasMoreData = true;
                          updateSearchMode();
                          document.getElementById('tableBody').innerHTML = '';
                          loadMoreUsers();
                      });
                      function loadMoreUsers() {
                          if (isLoading)
                              return;
                          isLoading = true;
                          document.getElementById('loading').style.display = 'block';
                          let url = 'searchUser?ajax=true&offset=' + offset;
                          if (searchName && searchName.trim() !== '') {
                              url += '&searchName=' + encodeURIComponent(searchName);
                          }
                          if (searchEmail && searchEmail.trim() !== '') {
                              url += '&searchEmail=' + encodeURIComponent(searchEmail);
                          }

                          fetch(url)
                                  .then(response => {
                                      if (!response.ok) {
                                          throw new Error('Network response was not ok');
                                      }
                                      return response.text();
                                  })
                                  .then(html => {
                                      console.log('Received HTML length:', html.length);
                                      const trimmedHtml = html.trim();
                                      if (trimmedHtml.includes('class="empty-state"') || trimmedHtml.includes('No users found')) {
                                          if (offset === 0) {
                                              document.getElementById('tableBody').innerHTML = trimmedHtml;
                                          }
                                          hasMoreData = false;
                                      } else if (trimmedHtml === '' || trimmedHtml.length < 50) {
                                          hasMoreData = false;
                                          if (offset === 0) {
                                              document.getElementById('tableBody').innerHTML =
                                                      '<div class="empty-state"><i class="fas fa-users"></i><p>No users found</p></div>';
                                          }
                                      } else {
                                          if (offset === 0) {
                                              document.getElementById('tableBody').innerHTML = trimmedHtml;
                                          } else {
                                              document.getElementById('tableBody').insertAdjacentHTML('beforeend', trimmedHtml);
                                          }

                                          offset += ${requestScope.recordsPerPage != null ? requestScope.recordsPerPage : 10};
                                          const userRows = trimmedHtml.match(/class="user-row"/g);
                                          const recordCount = userRows ? userRows.length : 0;
                                          if (recordCount < ${requestScope.recordsPerPage != null ? requestScope.recordsPerPage : 10}) {
                                              hasMoreData = false;
                                          }
                                      }

                                      isLoading = false;
                                      document.getElementById('loading').style.display = 'none';
                                  })
                                  .catch(error => {
                                      console.error('Error loading users:', error);
                                      isLoading = false;
                                      document.getElementById('loading').style.display = 'none';
                                  });
                      }

//                               Open Motal
                      window.addEventListener('DOMContentLoaded', function () {
                <% if (request.getAttribute("selectedUser") != null) { 
                       User selectedUser = (User) request.getAttribute("selectedUser");
                       if (!"admin".equalsIgnoreCase(selectedUser.getRole())) { %>
                          var userModal = new bootstrap.Modal(document.getElementById('userModal'));
                          userModal.show();
                <% } } %>
                      });
//                      Update Motal Notification
                      window.addEventListener('DOMContentLoaded', function () {
                <% 
                String successMessage = (String) session.getAttribute("successMessage");
                if (successMessage != null) { 
                session.removeAttribute("successMessage");
                %>
                          alert("<%= successMessage %>");
                <% } %>

                <% 
                String errorMessage = (String) session.getAttribute("errorMessage");
                if (errorMessage != null) { 
                session.removeAttribute("errorMessage");
                %>
                          alert("<%= errorMessage %>");
                <% } %>
                      });
                      // Scroll to top functionality
                      window.onscroll = function () {
                          const scrollBtn = document.getElementById("scrollToTopBtn");
                          if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
                              scrollBtn.style.display = "block";
                          } else {
                              scrollBtn.style.display = "none";
                          }
                      };

                      function scrollToTop() {
                          document.body.scrollTop = 0;
                          document.documentElement.scrollTop = 0;
                      }
            </script>
    </body>

    <!-- Scroll to Top Button -->
    <button id="scrollToTopBtn" class="scroll-to-top-btn" onclick="scrollToTop()" title="Go to top">
        <i class="fas fa-chevron-up"></i>
    </button>

</html>
