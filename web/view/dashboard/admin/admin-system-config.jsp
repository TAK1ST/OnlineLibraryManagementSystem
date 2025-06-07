<%-- 
    Document   : admin-system-config
    Created on : May 18, 2025, 10:14:39 PM
    Author     : asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
      <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>System Configuration</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/system-config.css"/>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css"/>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css"/>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/container.css"/>
      </head>
      <body>
            <div class="container-fluid">
                  <!-- Sidebar -->
                  <div class="sidebar">
                        <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" alt="Avatar">
                        <h3>Role: Administrator</h3>
                        <a href="admindashboard" class="nav-link">Dashboard</a>
                        <a href="systemconfig" class="nav-link active">System Config</a>
                        <a href="usermanagement" class="nav-link">User Management</a>
                        <a href="statusrequestborrowbook" class="nav-link">View Request Books</a>
                        <a href="bookmanagement" class="nav-link">Book Management</a>
                        <a href="updateinventory" class="nav-link">Update Inventory</a>
                  </div>

                  <!-- Main Content -->
                  <div class="main-content">
                        <!-- Header -->
                        <div class="header">
                              <h1>System Configuration</h1>
                              <button class="logout-btn" onclick="logout()">
                                  <a href="LogoutServlet" class="nav-link">Logout</a>
                              </button>
                        </div>

                        <!-- Message Display -->
                        <% if (request.getAttribute("message") != null) { %>
                        <div id="autoAlert" class="alert alert-info fade show" 
                             role="alert" style="margin:0 25% ; text-align: center">
                              <%= request.getAttribute("message") %>
                        </div>
                        <% } %>
                        <!-- Configuration Form -->
                        <div class="config-content">
                              <form class="config-form" method="POST" action="systemconfig">
                                    <div class="form-group mb-3">
                                          <label class="form-label" for="overdueFine">Overdue Fine (per day)</label>
                                          <input type="number" class="form-control" id="overdueFine" name="overdueFine" 
                                                 min="0" step="0.01" placeholder="Enter overdue fine amount">
                                          <small class="form-text text-muted">Leave empty if you don't want to update this value</small>
                                    </div>

                                    <div class="form-group mb-3">
                                          <label class="form-label" for="returnFine">Default Borrow Duration (days)</label>
                                          <input type="number" class="form-control" id="returnFine" name="returnFine" 
                                                 min="0" step="0.01" placeholder="Enter default borrow duration">
                                          <small class="form-text text-muted">Leave empty if you don't want to update this value</small>
                                    </div>

                                    <div class="form-group mb-3">
                                          <label class="form-label" for="borrowUnitPrice">Unit Price per Book</label>
                                          <input type="number" class="form-control" id="borrowUnitPrice" name="borrowUnitPrice" 
                                                 min="0" step="0.01" placeholder="Enter unit price per book">
                                          <small class="form-text text-muted">Leave empty if you don't want to update this value</small>
                                    </div>

                                    <button type="submit" class="btn btn-primary update-btn">Update Configuration</button>
                              </form>
                        </div>
                  </div>

                  <!-- Footer -->
                  <div class="footer">
                        ©Copyright Group 7
                  </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                                    function logout() {
                                          if (confirm('Are you sure you want to logout?')) {
                                                window.location.href = 'logout';
                                          }
                                    }
                                    setTimeout(function () {
                                          const alertEl = document.getElementById("autoAlert");
                                          if (alertEl) {
                                                alertEl.classList.remove("show");
                                                alertEl.classList.add("fade"); 
                                                setTimeout(() => alertEl.remove(), 300);
                                          }
                                    }, 1000);
            </script>
      </body>
</html>