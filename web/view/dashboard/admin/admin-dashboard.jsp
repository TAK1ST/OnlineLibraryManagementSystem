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
            <title>Library Statistics Dashboard</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
            <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css"/>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css"/>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css"/>
      </head>
      <body>
            <div class="container-fluid">
                  <!-- Sidebar -->
                  <div class="sidebar">
                        <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" alt="Avatar">
                        <h3>Role: Administrator</h3>
                        <a href="admindashboard" class="nav-link active">
                              <i class="fas fa-chart-bar"></i> Dashboard
                        </a>
                        <a href="systemconfig" class="nav-link">
                              <i class="fas fa-cog"></i> System Config
                        </a>
                        <a href="usermanagement" class="nav-link">
                              <i class="fas fa-users"></i> User Management
                        </a>
                        <a href="overduebook" class="nav-link">
                              <i class="fas fa-clock"></i> Overdue Books
                        </a>
                        <a href="bookmanagement" class="nav-link">
                              <i class="fas fa-book"></i> Book Management
                        </a>
                        <a href="updateinventory" class="nav-link">
                              <i class="fas fa-boxes"></i> Update Inventory
                        </a>
                  </div>

                  <!-- Main Content -->
                  <div class="main-content">
                        <!-- Header Section -->
                        <div class="header-section">
                            <button class="logout-btn">
                                    <i class="fas fa-sign-out-alt"></i> Logout
                              </button>
                              <h1 class="stat-title">Library Statistics Dashboard</h1>
                              <p class="stat-subtitle">Comprehensive overview of library system</p>
                        </div>

                        <!-- Statistics Container -->
                        <div class="stats-container">
                              <!-- Key Statistics Cards -->
                              <div class="stats-grid">
                                    <!-- Total Books -->
                                    <div class="stat-card">
                                          <div class="stat-icon">
                                                <i class="fas fa-book"></i>
                                          </div>
                                          <div class="stat-label">Total Books</div>
                                          <div class="stat-value" id="totalBooks">${totalBooksCount}</div>
                                          <div class="stat-change">+12 this month</div>
                                    </div>

                                    <!-- Total Users -->
                                    <div class="stat-card">
                                          <div class="stat-icon">
                                                <i class="fas fa-users"></i>
                                          </div>
                                          <div class="stat-label">Total Users</div>
                                          <div class="stat-value" id="totalUsers">${totalUsersCount}</div>
                                          <div class="stat-change">+23 new users</div>
                                    </div>      

                                    <!-- Currently Borrowed Books -->
                                    <div class="stat-card">
                                          <div class="stat-icon">
                                                <i class="fas fa-book-reader"></i>
                                          </div>
                                          <div class="stat-label">Currently Borrowed</div>
                                          <div class="stat-value" id="currentlyBorrowed">${currentlyBorrowed}</div>
                                          <div class="stat-change">72% utilization</div>
                                    </div>

                                    <!-- Average Borrow Duration -->
                                    <div class="stat-card">
                                          <div class="stat-icon">
                                                <i class="fas fa-hourglass-half"></i>
                                          </div>
                                          <div class="stat-label">Avg. Borrow Duration</div>
                                          <div class="stat-value" id="avgDuration">${avgDuration}</div>
                                          <div class="stat-change">days per book</div>
                                    </div>
                              </div>

                              <!-- Charts Section -->
                              <div class="charts-section">
                                    <!-- Monthly Borrowing Stats -->
                                    <div class="chart-card">
                                          <div class="chart-title">
                                                <i class="fas fa-chart-bar"></i>
                                                Monthly Borrowing Statistics
                                          </div>
                                          <div class="chart-container">
                                                <canvas id="monthlyChart"></canvas>
                                          </div>
                                    </div>

                                    <!-- Most Borrowed Books -->
                                    <div class="chart-card">
                                          <div class="chart-title">
                                                <i class="fas fa-trophy"></i>
                                                Top 5 Most Borrowed Books
                                          </div>
                                          <div class="books-list" id="mostBorrowedBooks">
                                                <div class="book-item">
                                                      <div class="book-rank">1</div>
                                                      <div class="book-info">
                                                            <div class="book-title">The Great Gatsby</div>
                                                            <div class="book-count">156 times borrowed</div>
                                                      </div>
                                                </div>
                                                <div class="book-item">
                                                      <div class="book-rank">2</div>
                                                      <div class="book-info">
                                                            <div class="book-title">To Kill a Mockingbird</div>
                                                            <div class="book-count">142 times borrowed</div>
                                                      </div>
                                                </div>
                                                <div class="book-item">
                                                      <div class="book-rank">3</div>
                                                      <div class="book-info">
                                                            <div class="book-title">1984</div>
                                                            <div class="book-count">138 times borrowed</div>
                                                      </div>
                                                </div>
                                                <div class="book-item">
                                                      <div class="book-rank">4</div>
                                                      <div class="book-info">
                                                            <div class="book-title">Pride and Prejudice</div>
                                                            <div class="book-count">127 times borrowed</div>
                                                      </div>
                                                </div>
                                                <div class="book-item">
                                                      <div class="book-rank">5</div>
                                                      <div class="book-info">
                                                            <div class="book-title">The Catcher in the Rye</div>
                                                            <div class="book-count">119 times borrowed</div>
                                                      </div>
                                                </div>
                                          </div>
                                    </div>
                              </div>
                        </div>
                  </div>

                  <!-- Footer -->
                  <div class="footer">
                        ©Copyright Group 7 - Library Management System
                  </div>
            </div>

            <script>
                  const ctx = document.getElementById('monthlyChart').getContext('2d');
                  const monthlyChart = new Chart(ctx, {
                        type: 'bar',
                        data: {
                              labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                              datasets: [{
                                          label: 'Books Borrowed',
                                          data: [245, 189, 276, 312, 298, 334, 356, 342, 287, 298, 276, 189],
                                          backgroundColor: 'rgba(102, 126, 234, 0.8)',
                                          borderColor: 'rgba(102, 126, 234, 1)',
                                          borderWidth: 2,
                                          borderRadius: 8,
                                          borderSkipped: false,
                                    }]
                        },
                        options: {
                              responsive: true,
                              maintainAspectRatio: false,
                              plugins: {
                                    legend: {
                                          display: false
                                    }
                              },
                              scales: {
                                    y: {
                                          beginAtZero: true,
                                          grid: {
                                                color: 'rgba(0,0,0,0.1)'
                                          }
                                    },
                                    x: {
                                          grid: {
                                                display: false
                                          }
                                    }
                              }
                        }
                  });

                  // Add some interactive animations
                  document.addEventListener('DOMContentLoaded', function () {
                        // Animate stat values on load
                        const statValues = document.querySelectorAll('.stat-value');
                        statValues.forEach(value => {
                              const finalValue = parseInt(value.textContent);
                              let currentValue = 0;
                              const increment = finalValue / 50;

                              const updateValue = () => {
                                    if (currentValue < finalValue) {
                                          currentValue += increment;
                                          value.textContent = Math.floor(currentValue);
                                          requestAnimationFrame(updateValue);
                                    } else {
                                          value.textContent = finalValue;
                                    }
                              };

                              setTimeout(updateValue, Math.random() * 500);
                        });

                        // Add hover effects to stat cards
                        const statCards = document.querySelectorAll('.stat-card');
                        statCards.forEach(card => {
                              card.addEventListener('mouseenter', function () {
                                    this.style.background = 'linear-gradient(135deg, #fff 0%, #f8f9fa 100%)';
                              });

                              card.addEventListener('mouseleave', function () {
                                    this.style.background = 'white';
                              });
                        });
                  });
            </script>
      </body>
</html>