<%-- 
    Document   : admin-update-inventory
    Created on : May 30, 2025, 6:50:54 PM
    Author     : asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
      <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Update Inventory</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-update-inventory.css"/>
      </head>
      <body>
            <!-- Header -->
            <div class="header">
                  <div class="header-left">
                        <button class="back-btn" onclick="goBack()">←</button>
                        <h1 class="page-title">Update Inventory</h1>
                  </div>
                  <button class="logout-btn" onclick="logout()">Logout</button>
            </div>

            <!-- Main Content -->
            <div class="main-container">
                  <div class="content-card">
                        <!-- Stats Overview -->
                        <div class="stats-container">
                              <div class="stat-card">
                                    <div class="stat-number">1,247</div>
                                    <div class="stat-label">Total Books</div>
                              </div>
                              <div class="stat-card">
                                    <div class="stat-number">892</div>
                                    <div class="stat-label">Available</div>
                              </div>
                              <div class="stat-card">
                                    <div class="stat-number">355</div>
                                    <div class="stat-label">Borrowed</div>
                              </div>
                              <div class="stat-card">
                                    <div class="stat-number">23</div>
                                    <div class="stat-label">Low Stock</div>
                              </div>
                        </div>

                        <!-- Search and Filter -->
                        <div class="search-section">
                              <div class="search-row">
                                    <div class="form-group">
                                          <label for="searchTitle">Search by Title</label>
                                          <input type="text" id="searchTitle" class="form-input" placeholder="Enter book title...">
                                    </div>
                                    <div class="form-group">
                                          <label for="searchAuthor">Search by Author</label>
                                          <input type="text" id="searchAuthor" class="form-input" placeholder="Enter author name...">
                                    </div>
                                    <button class="search-btn" onclick="searchBooks()">
                                          <span id="searchText">Search</span>
                                          <span id="searchLoading" class="loading" style="display: none;"></span>
                                    </button>
                                    <button class="reset-btn" onclick="resetSearch()">Reset</button>
                              </div>
                        </div>

                        <!-- Books Table -->
                        <div class="table-container">
                              <table class="books-table">
                                    <thead>
                                          <tr>
                                                <th>Book ID</th>
                                                <th>Title</th>
                                                <th>Author</th>
                                                <th>Category</th>
                                                <th>Status</th>
                                                <th>Current Stock</th>
                                                <th>Update Quantity</th>
                                                <th>Actions</th>
                                          </tr>
                                    </thead>
                                    <tbody id="booksTableBody">
                                          <tr>
                                                <td>BK001</td>
                                                <td>The Great Gatsby</td>
                                                <td>F. Scott Fitzgerald</td>
                                                <td>Classic Literature</td>
                                                <td><span class="status-badge status-available">Available</span></td>
                                                <td>5</td>
                                                <td>
                                                      <div class="quantity-control">
                                                            <button class="qty-btn" onclick="updateQuantity('BK001', -1)">−</button>
                                                            <input type="number" class="qty-input" value="5" min="0" id="qty-BK001">
                                                            <button class="qty-btn" onclick="updateQuantity('BK001', 1)">+</button>
                                                      </div>
                                                </td>
                                                <td>
                                                      <div class="action-buttons">
                                                            <button class="action-btn btn-update" onclick="saveQuantity('BK001')">Update</button>
                                                            <button class="action-btn btn-details" onclick="viewDetails('BK001')">Details</button>
                                                      </div>
                                                </td>
                                          </tr>
                                          <tr>
                                                <td>BK002</td>
                                                <td>To Kill a Mockingbird</td>
                                                <td>Harper Lee</td>
                                                <td>Classic Literature</td>
                                                <td><span class="status-badge status-borrowed">Borrowed</span></td>
                                                <td>2</td>
                                                <td>
                                                      <div class="quantity-control">
                                                            <button class="qty-btn" onclick="updateQuantity('BK002', -1)">−</button>
                                                            <input type="number" class="qty-input" value="2" min="0" id="qty-BK002">
                                                            <button class="qty-btn" onclick="updateQuantity('BK002', 1)">+</button>
                                                      </div>
                                                </td>
                                                <td>
                                                      <div class="action-buttons">
                                                            <button class="action-btn btn-update" onclick="saveQuantity('BK002')">Update</button>
                                                            <button class="action-btn btn-details" onclick="viewDetails('BK002')">Details</button>
                                                      </div>
                                                </td>
                                          </tr>
                                          <tr>
                                                <td>BK003</td>
                                                <td>1984</td>
                                                <td>George Orwell</td>
                                                <td>Dystopian Fiction</td>
                                                <td><span class="status-badge status-available">Available</span></td>
                                                <td>1</td>
                                                <td>
                                                      <div class="quantity-control">
                                                            <button class="qty-btn" onclick="updateQuantity('BK003', -1)">−</button>
                                                            <input type="number" class="qty-input" value="1" min="0" id="qty-BK003">
                                                            <button class="qty-btn" onclick="updateQuantity('BK003', 1)">+</button>
                                                      </div>
                                                </td>
                                                <td>
                                                      <div class="action-buttons">
                                                            <button class="action-btn btn-update" onclick="saveQuantity('BK003')">Update</button>
                                                            <button class="action-btn btn-details" onclick="viewDetails('BK003')">Details</button>
                                                      </div>
                                                </td>
                                          </tr>
                                          <tr>
                                                <td>BK004</td>
                                                <td>Pride and Prejudice</td>
                                                <td>Jane Austen</td>
                                                <td>Romance</td>
                                                <td><span class="status-badge status-maintenance">Maintenance</span></td>
                                                <td>0</td>
                                                <td>
                                                      <div class="quantity-control">
                                                            <button class="qty-btn" onclick="updateQuantity('BK004', -1)" disabled>−</button>
                                                            <input type="number" class="qty-input" value="0" min="0" id="qty-BK004">
                                                            <button class="qty-btn" onclick="updateQuantity('BK004', 1)">+</button>
                                                      </div>
                                                </td>
                                                <td>
                                                      <div class="action-buttons">
                                                            <button class="action-btn btn-update" onclick="saveQuantity('BK004')">Update</button>
                                                            <button class="action-btn btn-details" onclick="viewDetails('BK004')">Details</button>
                                                      </div>
                                                </td>
                                          </tr>
                                          <tr>
                                                <td>BK005</td>
                                                <td>The Catcher in the Rye</td>
                                                <td>J.D. Salinger</td>
                                                <td>Coming-of-age</td>
                                                <td><span class="status-badge status-available">Available</span></td>
                                                <td>3</td>
                                                <td>
                                                      <div class="quantity-control">
                                                            <button class="qty-btn" onclick="updateQuantity('BK005', -1)">−</button>
                                                            <input type="number" class="qty-input" value="3" min="0" id="qty-BK005">
                                                            <button class="qty-btn" onclick="updateQuantity('BK005', 1)">+</button>
                                                      </div>
                                                </td>
                                                <td>
                                                      <div class="action-buttons">
                                                            <button class="action-btn btn-update" onclick="saveQuantity('BK005')">Update</button>
                                                            <button class="action-btn btn-details" onclick="viewDetails('BK005')">Details</button>
                                                      </div>
                                                </td>
                                          </tr>
                                    </tbody>
                              </table>
                        </div>
                  </div>
            </div>

            <script>
                  // Quantity update functions
                  function updateQuantity(bookId, change) {
                        const input = document.getElementById(`qty-${bookId}`);
                        const currentValue = parseInt(input.value) || 0;
                        const newValue = Math.max(0, currentValue + change);
                        input.value = newValue;

                        // Update minus button state
                        const minusBtn = input.previousElementSibling;
                        minusBtn.disabled = newValue === 0;
                  }

                  // Save quantity changes
                  function saveQuantity(bookId) {
                        const input = document.getElementById(`qty-${bookId}`);
                        const newQuantity = input.value;

                        // Show loading state
                        const updateBtn = event.target;
                        const originalText = updateBtn.textContent;
                        updateBtn.innerHTML = '<span class="loading"></span>';
                        updateBtn.disabled = true;

                        // Simulate API call
                        setTimeout(() => {
                              updateBtn.textContent = originalText;
                              updateBtn.disabled = false;

                              // Show success feedback
                              updateBtn.style.background = '#27ae60';
                              updateBtn.textContent = 'Saved!';

                              setTimeout(() => {
                                    updateBtn.style.background = '#1ABC9C';
                                    updateBtn.textContent = originalText;
                              }, 1500);

                              // Update stats (simple simulation)
                              updateStats();
                        }, 1000);
                  }

                  // View book details
                  function viewDetails(bookId) {
                        alert(`View details for book: ${bookId}`);
                  }

                  // Search functionality
                  function searchBooks() {
                        const searchBtn = document.querySelector('.search-btn');
                        const searchText = document.getElementById('searchText');
                        const searchLoading = document.getElementById('searchLoading');

                        searchText.style.display = 'none';
                        searchLoading.style.display = 'inline-block';
                        searchBtn.disabled = true;

                        // Simulate search
                        setTimeout(() => {
                              searchText.style.display = 'inline-block';
                              searchLoading.style.display = 'none';
                              searchBtn.disabled = false;
                        }, 1500);
                  }

                  // Reset search
                  function resetSearch() {
                        document.getElementById('searchTitle').value = '';
                        document.getElementById('searchAuthor').value = '';
                  }

                  // Update stats
                  function updateStats() {
                        // This would normally fetch real data from the server
                        const stats = document.querySelectorAll('.stat-number');
                        stats.forEach(stat => {
                              stat.style.color = '#27ae60';
                              setTimeout(() => {
                                    stat.style.color = '#1ABC9C';
                              }, 1000);
                        });
                  }

                  // Navigation functions
                  function goBack() {
                        history.back();
                  }

                  function logout() {
                        if (confirm('Are you sure you want to logout?')) {
                              // Redirect to login page
                              window.location.href = 'login.jsp';
                        }
                  }

                  // Initialize page
                  document.addEventListener('DOMContentLoaded', function () {
                        // Set initial state for quantity controls
                        const qtyInputs = document.querySelectorAll('.qty-input');
                        qtyInputs.forEach(input => {
                              const bookId = input.id.replace('qty-', '');
                              const minusBtn = input.previousElementSibling;
                              minusBtn.disabled = parseInt(input.value) === 0;
                        });
                  });
            </script>
      </body>
</html>