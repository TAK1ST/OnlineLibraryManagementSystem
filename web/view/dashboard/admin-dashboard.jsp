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
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css"/>
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
                        <!-- Logout Button -->
                        <button class="logout-btn">Logout</button>

                        <!-- Title -->
                        <h1 class="stat-title">Statistic Application</h1>

                        <!-- Statistics Container -->
                        <div class="stats-container">
                              <div class="stat-row">
                                    <!-- Total User -->
                                    <div class="stat-section">
                                          <div class="stat-label">Total User</div>
                                          <input type="text" class="stat-input" id="totalUser" readonly placeholder="Loading...">
                                    </div>

                                    <!-- Total Overdue Books -->
                                    <div class="stat-section">
                                          <div class="stat-label">Total Overdue Books</div>
                                          <input type="text" class="stat-input" id="totalOverdue" readonly placeholder="Loading...">
                                    </div>

                                    <!-- Books Section -->
                                    <div class="books-section">
                                          <!-- Most Borrowed Books -->
                                          <div class="book-card">
                                                <div class="book-title">Most Borrowed Books</div>
                                                <div class="book-content" id="mostBorrowedBooks">
                                                      <div class="no-data">Loading book statistics...</div>
                                                </div>
                                          </div>

                                          <!-- Most The Best Book -->
                                          <div class="book-card">
                                                <div class="book-title">Most The Best Book</div>
                                                <div class="book-content" id="bestBooks">
                                                      <div class="no-data">Loading book ratings...</div>
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
            </div>
      </body>
</html>
