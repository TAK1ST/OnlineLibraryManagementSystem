<%-- 
    Document   : admin
    Created on : May 18, 2025, 2:32:43 PM
    Author     : asus
--%>
<!DOCTYPE html>
<html lang="en">
      <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>Statistic Application</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
      </head>
      <body>

            <div class="sidebar d-flex flex-column align-items-center">
                  <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" alt="Avatar" class="rounded-circle">
                  <h3 class="mb-4">Role: Adminator</h3>
                  <a href="#" class="nav-link active">Dashboard</a>
                  <a href="#" class="nav-link">System Config</a>
                  <a href="#" class="nav-link">User Management</a>
                  <a href="#" class="nav-link">Overdue Books</a>
                  <a href="#" class="nav-link">Book Management</a>
                  <a href="#" class="nav-link">Update Inventory</a>
            </div>

            <button class="logout-btn">Logout</button>

            <main class="main-content d-flex align-items-center">
                  <div class="stat-title">Statistic Application</div>
                  <div class="stat--content">
                        <div class="stat-row d-flex align-items-center justify-content-between">
                              <div class="stat-label me-4">Total User</div>
                              <input type="text" class="form-control stat-input" readonly>
                        </div>

                        <div class="stat-row d-flex align-items-center justify-content-between" >
                              <div class="stat-label me-4">Most The Best Book</div>
                              <input type="text" class="form-control stat-input" readonly>
                        </div>

                        <div class="stat-row d-flex align-items-center justify-content-between">
                              <div class="stat-label me-4">Most Borrowed Books</div>
                              <input type="text" class="form-control stat-input" readonly>
                        </div>

                        <div class="stat-row d-flex align-items-center justify-content-between">
                              <div class="stat-label me-4">Total Overdue Books</div>
                              <input type="text" class="form-control stat-input" readonly>
                        </div>
                  </div>
            </main>

            <div class="footer">
                  @Copyright Group 7
            </div>

      </body>
</html>
