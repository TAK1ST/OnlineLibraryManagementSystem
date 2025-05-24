<!DOCTYPE html>
<html lang="en">
      <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Book Management</title>
            <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-book-manager.css"/>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css"/>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css"/>
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
                              <div class="header-left">
                                    <button class="back-btn" onclick="goBack()">
                                          <i class="fas fa-arrow-left"></i>
                                    </button>
                                    <h1>Book Management</h1>
                              </div>
                              <button class="logout-btn">Logout</button>
                        </div>

                        <!-- Filter Section -->
                        <div class="filter-section">
                              <div class="filter-row">
                                    <div class="filter-group">
                                          <label>title</label>
                                          <input type="text" class="filter-input" id="titleFilter" placeholder="">
                                    </div>
                                    <div class="filter-group">
                                          <label>category</label>
                                          <input type="text" class="filter-input" id="categoryFilter" placeholder="">
                                    </div>
                                    <div class="filter-group">
                                          <label>author</label>
                                          <input type="text" class="filter-input" id="authorFilter" placeholder="">
                                    </div>
                                    <div class="filter-group">
                                          <label>status</label>
                                          <input type="text" class="filter-input" id="statusFilter" placeholder="">
                                    </div>
                                    <button class="filter-btn" onclick="filterBooks()">
                                          <i class="fas fa-filter me-1"></i>filter
                                    </button>
                              </div>
                              <div>
                                    <button class="add-book-btn" onclick="addNewBook()">
                                          <i class="fas fa-plus me-1"></i>Add new book
                                    </button>
                              </div>
                        </div>
                        <!-- Content Area -->
                        <div class="content-area">
                              <div class="book-table">
                                    <!-- Table Header -->
                                    <div class="table-header">
                                          <div class="row">
                                                <div class="col-2">isbn</div>
                                                <div class="col-2">title</div>
                                                <div class="col-2">author</div>
                                                <div class="col-2">category</div>
                                                <div class="col-2">status</div>
                                                <div class="col-2">action</div>
                                          </div>
                                    </div>

                                    <!-- Table Body -->
                                    <div class="table-body" id="bookTableBody">
                                          <div class="empty-state">
                                                <i class="fas fa-books"></i>
                                                <p>No books found. Click "Add new book" to add books to the library.</p>
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