<%-- 
    Document   : admin-add-book-manager
    Created on : May 29, 2025, 11:04:26 PM
    Author     : asus
--%>
<!DOCTYPE html>
<html lang="en">
      <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Book Management</title>
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-add-book-management.css"/>
      </head>
      <body>
            <div class="container">
                  <!-- Header -->
                  <div class="header">
                        <a href="admindashboard" style="text-decoration: none">
                              <button class="back-btn" >
                                    <i class="fas fa-arrow-left"></i>
                                    <span>Back</span>
                              </button>
                        </a>
                        <h1 class="page-title">Book Management</h1>
                        <button class="logout-btn" onclick="logout()">
                              <i class="fas fa-sign-out-alt"></i>
                              Logout
                        </button>
                  </div>

                  <!-- Error/Success Messages -->
                  <% if (request.getAttribute("errorMessage") != null) { %>
                  <div class="error-message">
                        <i class="fas fa-exclamation-triangle"></i>
                        <span><%= request.getAttribute("errorMessage") %></span>
                  </div>
                  <% } %>

                  <% if (request.getParameter("success") != null) { %>
                  <div class="success-message">
                        <i class="fas fa-check-circle"></i>
                        <span><%= request.getParameter("success") %></span>
                  </div>
                  <% } %>

                  <!-- Main Form Container -->
                  <div class="form-container">
                        <form id="addBookForm" action="addbook" method="post" enctype="multipart/form-data" onsubmit="return handleSubmit(event)">
                              <div class="form-content">
                                    <!-- Image Upload Section -->
                                    <div class="image-upload">
                                          <div class="upload-box" onclick="document.getElementById('bookImage').click()" id="uploadBox">
                                                <div class="upload-placeholder">
                                                      <i class="fas fa-image fa-3x"></i>
                                                      <p>Click to upload</p>
                                                      <small>book cover image</small>
                                                </div>
                                          </div>
                                          <input type="file" 
                                                 id="bookImage" 
                                                 name="bookImage" 
                                                 accept="image/jpeg,image/png,image/jpg" 
                                                 class="hidden-file-input"
                                                 onchange="previewImage(event)">
                                    </div>

                                    <!-- Form Fields -->
                                    <div class="form-fields">
                                          <div class="form-group">
                                                <label for="title" class="form-label">
                                                      <i class="fas fa-book"></i> Book Title *
                                                </label>
                                                <input type="text" 
                                                       id="title"
                                                       name="title" 
                                                       class="form-input" 
                                                       placeholder="Enter the title"
                                                       value="<%= request.getAttribute("book") != null ? ((entity.Book)request.getAttribute("book")).getTitle() : "" %>"
                                                       required>
                                                <div class="field-error" id="titleError"></div>
                                          </div>

                                          <div class="form-group">
                                                <label for="author" class="form-label">
                                                      <i class="fas fa-user-edit"></i> Author *
                                                </label>
                                                <input type="text" 
                                                       id="author"
                                                       name="author" 
                                                       class="form-input" 
                                                       placeholder="Enter the author"
                                                       value="<%= request.getAttribute("book") != null ? ((entity.Book)request.getAttribute("book")).getAuthor() : "" %>"
                                                       required>
                                                <div class="field-error" id="authorError"></div>
                                          </div>

                                          <div class="form-group isbn-group">
                                                <label for="isbn" class="form-label">
                                                      <i class="fas fa-barcode"></i> ISBN
                                                </label>
                                                <input type="text" 
                                                       id="isbn"
                                                       name="isbn" 
                                                       class="form-input isbn-input" 
                                                       placeholder="Enter ISBN number (auto-generated if empty)"
                                                       value="<%= request.getAttribute("book") != null ? ((entity.Book)request.getAttribute("book")).getIsbn() : "" %>">
                                                <small>Leave empty to auto-generate</small>
                                                <div class="field-error" id="isbnError"></div>
                                          </div>

                                          <div class="form-row">
                                                <div class="form-group">
                                                      <label for="totalCopies" class="form-label">
                                                            <i class="fas fa-copy"></i> Total Copies *
                                                      </label>
                                                      <input type="number" 
                                                             id="totalCopies"
                                                             name="totalCopies" 
                                                             class="form-input" 
                                                             placeholder="Enter total copies"
                                                             min="1" 
                                                             max="1000"
                                                             value="<%= request.getAttribute("book") != null ? ((entity.Book)request.getAttribute("book")).getTotalCopies() : "" %>"
                                                             required>
                                                      <div class="field-error" id="totalCopiesError"></div>
                                                </div>
                                                <div class="form-group">
                                                      <label for="publishedYear" class="form-label">
                                                            <i class="fas fa-calendar-alt"></i> Published Year *
                                                      </label>
                                                      <input type="number" 
                                                             id="publishedYear"
                                                             name="publishedYear" 
                                                             class="form-input" 
                                                             placeholder="published year"
                                                             min="1000" 
                                                             max="2025"
                                                             value="<%= request.getAttribute("book") != null ? ((entity.Book)request.getAttribute("book")).getPublishedYear() : new java.util.Date().getYear() + 1900 %>"
                                                             required>
                                                      <div class="field-error" id="publishedYearError"></div>
                                                </div>
                                          </div>

                                          <div class="form-row">
                                                <div class="form-group">
                                                      <label for="category" class="form-label">
                                                            <i class="fas fa-tags"></i> Category *
                                                      </label>
                                                      <select id="category" name="category" class="form-input" required>
                                                            <option value="" disabled selected>Select category</option>
                                                            <option value="fiction">Fiction</option>
                                                            <option value="non-fiction">Non-Fiction</option>
                                                            <option value="science">Science</option>
                                                            <option value="history">History</option>
                                                            <option value="biography">Biography</option>
                                                            <option value="technology">Technology</option>
                                                            <option value="literature">Literature</option>
                                                            <option value="education">Education</option>
                                                      </select>
                                                      <div class="field-error" id="categoryError"></div>
                                                </div>
                                                <div class="form-group">
                                                      <label for="status" class="form-label">
                                                            <i class="fas fa-toggle-on"></i> Status *
                                                      </label>
                                                      <select id="status" name="status" class="form-input" required>
                                                            <option value="" disabled>Select status</option>
                                                            <option value="active" selected>Active</option>
                                                            <option value="inactive">Inactive</option>
                                                      </select>
                                                      <div class="field-error" id="statusError"></div>
                                                </div>
                                          </div>

                                          <div class="form-actions">
                                                <button type="button" class="btn btn-reset" onclick="resetForm()">
                                                      <i class="fas fa-undo"></i> Reset
                                                </button>
                                                <button type="submit" class="btn btn-add" id="submitBtn">
                                                      <i class="fas fa-plus"></i> Add Book
                                                </button>
                                          </div>
                                    </div>
                              </div>
                        </form>
                  </div>
            </div>

            <script>
                  // Client-side validation
                  function validateForm() {
                        let isValid = true;

                        // Clear previous errors
                        document.querySelectorAll('.field-error').forEach(error => {
                              error.textContent = '';
                        });
                        document.querySelectorAll('.form-input').forEach(input => {
                              input.classList.remove('form-validation-error');
                        });

                        // Validate title
                        const title = document.getElementById('title').value.trim();
                        if (!title) {
                              showFieldError('title', 'Book title is required');
                              isValid = false;
                        } else if (title.length < 2) {
                              showFieldError('title', 'Title must be at least 2 characters');
                              isValid = false;
                        }

                        // Validate author
                        const author = document.getElementById('author').value.trim();
                        if (!author) {
                              showFieldError('author', 'Author is required');
                              isValid = false;
                        } else if (author.length < 2) {
                              showFieldError('author', 'Author must be at least 2 characters');
                              isValid = false;
                        }

                        // Validate total copies
                        const totalCopies = document.getElementById('totalCopies').value;
                        if (!totalCopies || parseInt(totalCopies) < 1) {
                              showFieldError('totalCopies', 'Total copies must be at least 1');
                              isValid = false;
                        } else if (parseInt(totalCopies) > 1000) {
                              showFieldError('totalCopies', 'Total copies cannot exceed 1000');
                              isValid = false;
                        }

                        // Validate published year
                        const publishedYear = document.getElementById('publishedYear').value;
                        const currentYear = new Date().getFullYear();
                        if (!publishedYear || parseInt(publishedYear) < 1000) {
                              showFieldError('publishedYear', 'Published year must be at least 1000');
                              isValid = false;
                        } else if (parseInt(publishedYear) > currentYear) {
                              showFieldError('publishedYear', 'Published year cannot be in the future');
                              isValid = false;
                        }

                        // Validate category
                        const category = document.getElementById('category').value;
                        if (!category) {
                              showFieldError('category', 'Please select a category');
                              isValid = false;
                        }

                        // Validate status
                        const status = document.getElementById('status').value;
                        if (!status) {
                              showFieldError('status', 'Please select a status');
                              isValid = false;
                        }

                        return isValid;
                  }

                  function showFieldError(fieldId, message) {
                        const field = document.getElementById(fieldId);
                        const errorDiv = document.getElementById(fieldId + 'Error');
                        field.classList.add('form-validation-error');
                        errorDiv.textContent = message;
                  }

                  // Image preview functionality
                  function previewImage(event) {
                        const file = event.target.files[0];
                        const uploadBox = document.getElementById('uploadBox');

                        if (file) {
                              // Validate file type
                              if (!file.type.match('image/(jpeg|png|jpg)')) {
                                    showAlert('Only JPEG, JPG or PNG images are allowed.', 'error');
                                    event.target.value = '';
                                    resetUploadBox();
                                    return;
                              }

                              // Validate file size (max 5MB)
                              if (file.size > 5242880) {
                                    showAlert('File size must be less than 5MB.', 'error');
                                    event.target.value = '';
                                    resetUploadBox();
                                    return;
                              }

                              const reader = new FileReader();
                              reader.onload = function (e) {
                                    uploadBox.innerHTML = `<img src="${e.target.result}" class="preview-image" alt="Book Cover Preview">`;
                              };
                              reader.readAsDataURL(file);
                        } else {
                              resetUploadBox();
                        }
                  }

                  function resetUploadBox() {
                        const uploadBox = document.getElementById('uploadBox');
                        uploadBox.innerHTML = `
                        <div class="upload-placeholder">
                            <i class="fas fa-image fa-3x"></i>
                            <p>Click to upload</p>
                            <small>book cover image</small>
                        </div>
                    `;
                  }

                  // Form submission
                  function handleSubmit(event) {
                        console.log('Form submission started');

                        // Validate form first
                        if (!validateForm()) {
                              event.preventDefault();
                              showAlert('Please fix the errors above', 'error');
                              return false;
                        }

                        const submitBtn = document.getElementById('submitBtn');

                        // Show loading state
                        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Adding Book...';
                        submitBtn.disabled = true;

                        console.log('Form is valid, submitting...');

                        // Let the form submit naturally to the server
                        return true;
                  }

                  // Reset form
                  function resetForm() {
                        if (confirm('Are you sure you want to reset the form? All data will be lost.')) {
                              document.getElementById('addBookForm').reset();
                              resetUploadBox();

                              // Clear validation errors
                              document.querySelectorAll('.field-error').forEach(error => {
                                    error.textContent = '';
                              });
                              document.querySelectorAll('.form-input').forEach(input => {
                                    input.classList.remove('form-validation-error');
                              });

                              // Reset submit button
                              const submitBtn = document.getElementById('submitBtn');
                              submitBtn.innerHTML = '<i class="fas fa-plus"></i> Add Book';
                              submitBtn.disabled = false;
                        }
                  }

                  // Logout function
                  function logout() {
                        if (confirm('Are you sure you want to logout?')) {
                              showAlert('Logging out...', 'success');
                              setTimeout(() => {
                                    window.location.href = '#';
                              }, 1500);
                        }
                  }

                  // Show alert messages
                  function showAlert(message, type) {
                        // Remove existing alerts
                        const existingAlert = document.querySelector('.alert');
                        if (existingAlert) {
                              existingAlert.remove();
                        }

                        const alert = document.createElement('div');
                        alert.className = `alert alert-${type}`;
                        alert.innerHTML = `
                        <i class="fas fa-${type == 'success' ? 'check-circle' : 'exclamation-triangle'}"></i>
                  ${message}
                    `;
                        document.body.appendChild(alert);

                        // Auto-hide after 4 seconds
                        setTimeout(() => {
                              alert.style.animation = 'slideInRight 0.3s ease-out reverse';
                              setTimeout(() => alert.remove(), 300);
                        }, 4000);
                  }

                  // Initialize form
                  document.addEventListener('DOMContentLoaded', function () {
                        console.log('Page loaded, initializing form...');

                        // Set default published year to current year if empty
                        const yearInput = document.getElementById('publishedYear');
                        if (!yearInput.value) {
                              yearInput.value = new Date().getFullYear();
                        }

                        // Auto-capitalize title and author inputs
                        const titleInput = document.getElementById('title');
                        const authorInput = document.getElementById('author');

                        [titleInput, authorInput].forEach(input => {
                              input.addEventListener('input', function () {
                                    this.value = this.value.replace(/\b\w/g, l => l.toUpperCase());
                              });
                        });

                        // Format ISBN input
                        const isbnInput = document.getElementById('isbn');
                        isbnInput.addEventListener('input', function () {
                              let value = this.value.replace(/[^\d\-]/g, '');
                              if (value.length > 17) {
                                    value = value.substring(0, 17);
                              }
                              this.value = value;
                        });

                        console.log('Form initialization complete');
                  });
            </script>
      </body>
</html>