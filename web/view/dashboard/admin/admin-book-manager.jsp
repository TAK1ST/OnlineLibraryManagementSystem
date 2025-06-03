<!DOCTYPE html>
<html lang="en">
      <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Book Management System</title>
            <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/add-book-manager.css"/>

      </head>
      <body>
            <!-- Header -->
            <div class="header">
                  <div class="container">
                        <div class="row align-items-center">
                              <div class="col-auto">
                                    <button class="btn back-btn" onclick="goBack()">
                                          <i class="fas fa-arrow-left me-1"></i>
                                    </button>
                              </div>
                              <div class="col text-center">
                                    <h1 class="main-title mb-0">Book Management</h1>
                              </div>
                              <div class="col-auto">
                                    <button class="btn logout-btn">
                                          <i class="fas fa-sign-out-alt me-2"></i>
                                          Logout
                                    </button>
                              </div>
                        </div>
                  </div>
            </div>

            <!-- Main Content -->
            <div class="container fade-in">
                  <!-- Filter Section -->
                  <div class="filter-section">
                        <div class="row g-3 align-items-end">
                              <div class="col-md-3">
                                    <label class="form-label fw-semibold text-muted">Title</label>
                                    <input type="text" class="form-control" placeholder="Search by title...">
                              </div>
                              <div class="col-md-3">
                                    <label class="form-label fw-semibold text-muted">Category</label>
                                    <select class="form-control">
                                          <option value="">All Categories</option>
                                          <option value="fiction">Fiction</option>
                                          <option value="non-fiction">Non-Fiction</option>
                                          <option value="science">Science</option>
                                          <option value="technology">Technology</option>
                                    </select>
                              </div>
                              <div class="col-md-3">
                                    <label class="form-label fw-semibold text-muted">Author</label>
                                    <input type="text" class="form-control" placeholder="Search by author...">
                              </div>
                              <div class="col-md-2">
                                    <label class="form-label fw-semibold text-muted">Status</label>
                                    <select class="form-control">
                                          <option value="">All Status</option>
                                          <option value="available">Available</option>
                                          <option value="borrowed">Borrowed</option>
                                          <option value="reserved">Reserved</option>
                                    </select>
                              </div>
                              <div class="col-md-1">
                                    <button class="btn filter-btn w-100">
                                          <i class="fas fa-filter"></i>
                                    </button>
                              </div>
                        </div>
                  </div>

                  <!-- Add Book Button -->
                  <div class="mb-4">
                        <button class="btn add-book-btn">
                              <i class="fas fa-plus me-2"></i>
                              Add New Book
                        </button>
                  </div>

                  <!-- Books Table -->
                  <div class="table-container">
                        <div class="table-responsive">
                              <table class="table table-hover mb-0">
                                    <thead>
                                          <tr>
                                                <th>ISBN</th>
                                                <th>Title</th>
                                                <th>Author</th>
                                                <th>Category</th>
                                                <th>Status</th>
                                                <th class="text-center">Actions</th>
                                          </tr>
                                    </thead>
                                    <tbody>
                                          <!-- Sample Data -->
                                          <tr>
                                                <td><span class="badge bg-light text-dark">978-0-123456-78-9</span></td>
                                                <td><strong>The Great Gatsby</strong></td>
                                                <td>F. Scott Fitzgerald</td>
                                                <td><span class="badge" style="background-color: var(--secondary-color);">Fiction</span></td>
                                                <td><span class="badge bg-success">Available</span></td>
                                                <td class="text-center">
                                                      <button class="btn btn-edit btn-sm">
                                                            <i class="fas fa-edit me-1"></i>Edit
                                                      </button>
                                                      <button class="btn btn-delete btn-sm">
                                                            <i class="fas fa-trash me-1"></i>Delete
                                                      </button>
                                                </td>
                                          </tr>
                                          <tr>
                                                <td><span class="badge bg-light text-dark">978-0-987654-32-1</span></td>
                                                <td><strong>Clean Code</strong></td>
                                                <td>Robert C. Martin</td>
                                                <td><span class="badge" style="background-color: var(--primary-color);">Technology</span></td>
                                                <td><span class="badge bg-warning">Borrowed</span></td>
                                                <td class="text-center">
                                                      <button class="btn btn-edit btn-sm">
                                                            <i class="fas fa-edit me-1"></i>Edit
                                                      </button>
                                                      <button class="btn btn-delete btn-sm">
                                                            <i class="fas fa-trash me-1"></i>Delete
                                                      </button>
                                                </td>
                                          </tr>
                                          <tr>
                                                <td><span class="badge bg-light text-dark">978-0-456789-01-2</span></td>
                                                <td><strong>Sapiens</strong></td>
                                                <td>Yuval Noah Harari</td>
                                                <td><span class="badge" style="background-color: var(--dark-primary);">History</span></td>
                                                <td><span class="badge bg-info">Reserved</span></td>
                                                <td class="text-center">
                                                      <button class="btn btn-edit btn-sm">
                                                            <i class="fas fa-edit me-1"></i>Edit
                                                      </button>
                                                      <button class="btn btn-delete btn-sm">
                                                            <i class="fas fa-trash me-1"></i>Delete
                                                      </button>
                                                </td>
                                          </tr>
                                          <!-- Empty state can be shown when no books -->
                                          <!-- <tr>
                                              <td colspan="6">
                                                  <div class="empty-state">
                                                      <i class="fas fa-book-open"></i>
                                                      <h4>No books found</h4>
                                                      <p class="text-muted">Add your first book to get started</p>
                                                  </div>
                                              </td>
                                          </tr> -->
                                    </tbody>
                              </table>
                        </div>
                  </div>

                  <!-- Pagination -->
                  <div class="d-flex justify-content-center mt-4">
                        <nav>
                              <ul class="pagination">
                                    <li class="page-item disabled">
                                          <span class="page-link" style="color: var(--dark-secondary);">Previous</span>
                                    </li>
                                    <li class="page-item active">
                                          <span class="page-link" style="background-color: var(--secondary-color); border-color: var(--secondary-color);">1</span>
                                    </li>
                                    <li class="page-item">
                                          <a class="page-link" href="#" style="color: var(--dark-primary);">2</a>
                                    </li>
                                    <li class="page-item">
                                          <a class="page-link" href="#" style="color: var(--dark-primary);">3</a>
                                    </li>
                                    <li class="page-item">
                                          <a class="page-link" href="#" style="color: var(--dark-primary);">Next</a>
                                    </li>
                              </ul>
                        </nav>
                  </div>
            </div>

            <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
            <script>
                                  function goBack()
                                  {
                                        history.back();
                                  }
                                  // Add some interactive functionality
                                  document.addEventListener('DOMContentLoaded', function () {
                                        // Filter functionality
                                        const filterBtn = document.querySelector('.filter-btn');
                                        const inputs = document.querySelectorAll('.form-control');

                                        filterBtn.addEventListener('click', function () {
                                              // Add loading animation
                                              this.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
                                              setTimeout(() => {
                                                    this.innerHTML = '<i class="fas fa-filter"></i>';
                                              }, 1000);
                                        });

                                        // Add hover effects to table rows
                                        const tableRows = document.querySelectorAll('tbody tr');
                                        tableRows.forEach(row => {
                                              row.addEventListener('mouseenter', function () {
                                                    this.style.boxShadow = '0 4px 15px rgba(0,0,0,0.1)';
                                              });
                                              row.addEventListener('mouseleave', function () {
                                                    this.style.boxShadow = 'none';
                                              });
                                        });

                                        // Button click animations
                                        const buttons = document.querySelectorAll('.btn');
                                        buttons.forEach(btn => {
                                              btn.addEventListener('click', function (e) {
                                                    // Create ripple effect
                                                    const ripple = document.createElement('span');
                                                    const rect = this.getBoundingClientRect();
                                                    const size = Math.max(rect.width, rect.height);
                                                    const x = e.clientX - rect.left - size / 2;
                                                    const y = e.clientY - rect.top - size / 2;

                                                    ripple.style.width = ripple.style.height = size + 'px';
                                                    ripple.style.left = x + 'px';
                                                    ripple.style.top = y + 'px';
                                                    ripple.classList.add('ripple');

                                                    this.appendChild(ripple);

                                                    setTimeout(() => {
                                                          ripple.remove();
                                                    }, 600);
                                              });
                                        });
                                  });
            </script>

            <style>
                  .fa-arrow-left
                  {
                        size: 20px;
                  }
                  .ripple {
                        position: absolute;
                        border-radius: 50%;
                        background: rgba(255, 255, 255, 0.6);
                        transform: scale(0);
                        animation: ripple 0.6s linear;
                        pointer-events: none;
                  }

                  @keyframes ripple {
                        to {
                              transform: scale(4);
                              opacity: 0;
                        }
                  }

                  .btn {
                        position: relative;
                        overflow: hidden;
                  }
            </style>
      </body>
</html>