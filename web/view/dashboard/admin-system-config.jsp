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
                        <h3>Role: Adminator</h3>
                        <a href="#" class="nav-link">Dashboard</a>
                        <a href="#" class="nav-link active">System Config</a>
                        <a href="#" class="nav-link">User Management</a>
                        <a href="#" class="nav-link">Overdue Books</a>
                        <a href="#" class="nav-link">Book Management</a>
                        <a href="#" class="nav-link">Update Inventory</a>
                  </div>

                  <!-- Main Content -->
                  <div class="main-content">
                        <!-- Header -->
                        <div class="header">
                              <h1>System Configuration</h1>
                              <button class="logout-btn">Logout</button>
                        </div>

                        <!-- Configuration Form -->
                        <div class="config-content">
                              <form class="config-form" method="post" action="updateSystemConfig.jsp">
                                    <div class="form-group">
                                          <label class="form-label" for="overdueFine">Overdue Fine</label>
                                          <input type="number" class="form-control" id="overdueFine" name="overdueFine" 
                                               min="0" placeholder="Enter overdue fine amount">
                                    </div>

                                    <div class="form-group">
                                          <label class="form-label" for="returnFine">Return Fine</label>
                                          <input type="number" class="form-control" id="returnFine" name="returnFine" 
                                                 min="0" placeholder="Enter return fine amount">
                                    </div>

                                    <div class="form-group">
                                          <label class="form-label" for="borrowUnitPrice">Borrow Unit Price</label>
                                          <input type="number" class="form-control" id="borrowUnitPrice" name="borrowUnitPrice" 
                                                 min="0" placeholder="Enter borrow unit price">
                                    </div>

                                    <button type="submit" class="update-btn">Update</button>
                              </form>
                        </div>
                  </div>

                  <!-- Footer -->
                  <div class="footer">
                        ©Copyright Group 7
                  </div>
            </div>
      </body>
</html>