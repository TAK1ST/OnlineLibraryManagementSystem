<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
      <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Book Management</title>
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-book-management.css"/>
      </head>
      <body>
            <div class="container">
                  <!-- Header -->
                  <div class="header">
                        <div class="header-left">
                              <a href="admindashboard" style="text-decoration: none">
                                    <button class="back-arrow">
                                          <i class="fas fa-arrow-left"></i>
                                    </button>
                              </a>
                              <h1>Book Management</h1>
                        </div>
                        <a href="#" class="logout-btn">
                              <i class="fas fa-sign-out-alt"></i>
                              Logout
                        </a>
                  </div>

                  <!-- Alert Messages -->
                  <c:if test="${not empty successMessage}">
                        <div class="alert alert-success">
                              <i class="fas fa-check-circle"></i>
                              ${successMessage}
                        </div>
                  </c:if>

                  <c:if test="${not empty errorMessage}">
                        <div class="alert alert-error">
                              <i class="fas fa-exclamation-circle"></i>
                              ${errorMessage}
                        </div>
                  </c:if>

                  <!-- Filter Section -->
                  <div class="filter-section">
                        <form class="filter-form" method="GET" action="bookmanagement">
                              <div class="filter-group">
                                    <label for="title">Book Title</label>
                                    <input type="text" id="title" name="title" class="filter-input" 
                                           placeholder="Search by title..." value="${titleFilter}">
                              </div>
                              <div class="filter-group">
                                    <label for="category">Category</label>
                                    <select id="category" name="category" class="filter-select">
                                          <option value="">All Categories</option>
                                          <c:forEach var="cat" items="${categories}">
                                                <option value="${cat}" ${categoryFilter eq cat ? 'selected' : ''}>${cat}</option>
                                          </c:forEach>
                                    </select>
                              </div>
                              <div class="filter-group">
                                    <label for="author">Author Name</label>
                                    <input type="text" id="author" name="author" class="filter-input" 
                                           placeholder="Search by author..." value="${authorFilter}">
                              </div>
                              <div class="filter-group">
                                    <label for="status">Status</label>
                                    <select id="status" name="status" class="filter-select">
                                          <option value="">All Status</option>
                                          <c:forEach var="stat" items="${statuses}">
                                                <option value="${stat}" ${statusFilter eq stat ? 'selected' : ''}>${stat}</option>
                                          </c:forEach>
                                    </select>
                              </div>
                              <button type="submit" class="filter-btn">
                                    <i class="fas fa-search"></i>
                                    Search
                              </button>
                        </form>
                  </div>

                  <!-- Add Book Button -->
                  <div class="add-book-section">
                        <a href="addbook" class="add-book-btn">
                              <i class="fas fa-plus"></i>
                              Add New Book
                        </a>
                  </div>

                  <!-- Book Table -->
                  <div class="table-container">
                        <c:choose>
                              <c:when test="${not empty books}">
                                    <table class="book-table">
                                          <thead class="table-header">
                                                <tr>
                                                      <th>ISBN</th>
                                                      <th>Title</th>
                                                      <th>Author</th>
                                                      <th>Category</th>
                                                      <th>Status</th>
                                                      <th>Actions</th>
                                                </tr>
                                          </thead>
                                          <tbody>
                                                <c:forEach var="book" items="${books}">
                                                      <tr class="table-row">
                                                            <td class="table-cell">${book.isbn}</td>
                                                            <td class="table-cell">${book.title}</td>
                                                            <td class="table-cell">${book.author}</td>
                                                            <td class="table-cell">${book.category}</td>
                                                            <td class="table-cell">
                                                                  <span class="status-${book.status.toLowerCase()}">${book.status}</span>
                                                            </td>
                                                            <td class="table-cell">
                                                                  <div class="action-buttons">
                                                                        <!-- Edit Button - Fixed to trigger modal -->
                                                                        <button type="button" class="edit-btn" 
                                                                                onclick="openEditModal('${book.id}', '${book.isbn}', '${book.title}', '${book.author}', '${book.category}', '${book.publishedYear}', '${book.totalCopies}', '${book.availableCopies}', '${book.status}', '${book.imageUrl}')">
                                                                              <i class="fas fa-edit"></i>
                                                                              Edit
                                                                        </button>

                                                                        <c:if test="${book.status ne 'blocked'}">
                                                                              <button class="delete-btn" onclick="confirmDelete('${book.id}', '${book.title}')">
                                                                                    <i class="fas fa-trash"></i>
                                                                                    Delete
                                                                              </button>
                                                                        </c:if>
                                                                  </div>
                                                            </td>
                                                      </tr>
                                                </c:forEach>
                                          </tbody>
                                    </table>
                              </c:when>
                              <c:otherwise>
                                    <div class="no-data" style="padding: 20px 50px;">
                                          <i class="fas fa-book">             No books found matching your criteria.</i>
                                    </div>
                              </c:otherwise>
                        </c:choose>
                  </div>

                  <!-- Pagination -->
                  <c:if test="${totalPages > 1}">
                        <div class="pagination">
                              <!-- Previous Button -->
                              <c:if test="${currentPage > 1}">
                                    <a href="bookmanagement?page=${currentPage - 1}&size=${pageSize}&title=${titleFilter}&author=${authorFilter}&category=${categoryFilter}&status=${statusFilter}" 
                                       class="page-btn">Previous</a>
                              </c:if>

                              <!-- Page Numbers -->
                              <c:forEach var="i" begin="1" end="${totalPages}">
                                    <c:choose>
                                          <c:when test="${i eq currentPage}">
                                                <span class="page-btn active">${i}</span>
                                          </c:when>
                                          <c:otherwise>
                                                <a href="bookmanagement?page=${i}&size=${pageSize}&title=${titleFilter}&author=${authorFilter}&category=${categoryFilter}&status=${statusFilter}" 
                                                   class="page-btn">${i}</a>
                                          </c:otherwise>
                                    </c:choose>
                              </c:forEach>

                              <!-- Next Button -->
                              <c:if test="${currentPage < totalPages}">
                                    <a href="bookmanagement?page=${currentPage + 1}&size=${pageSize}&title=${titleFilter}&author=${authorFilter}&category=${categoryFilter}&status=${statusFilter}" 
                                       class="page-btn">Next</a>
                              </c:if>
                        </div>

                        <!-- Pagination Info -->
                        <div class="pagination-info">
                              Showing ${((currentPage - 1) * pageSize) + 1} to ${currentPage * pageSize > totalBooks ? totalBooks : currentPage * pageSize} of ${totalBooks} books
                        </div>
                  </c:if>
            </div>
            <!-- Delete Confirmation Modal -->
            <jsp:include page="/view/admin/delete-confirm-modal.jsp"/>

            <!-- Edit Book Modal -->
            <jsp:include page="/view/admin/modal-edit-book.jsp"/>

            <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js">
            </script>
            
            <script>
                  let currentDeleteBookId = null;

                  function confirmDelete(bookId, bookTitle) {
                        currentDeleteBookId = bookId;
                        document.getElementById('bookTitle').textContent = bookTitle;
                        document.getElementById('deleteModal').style.display = 'block';
                  }

                  function closeDeleteModal() {
                        document.getElementById('deleteModal').style.display = 'none';
                        currentDeleteBookId = null;
                  }

                  function executeDelete() {
                        if (currentDeleteBookId) {
                              document.getElementById('deleteBookId').value = currentDeleteBookId;
                              document.getElementById('deleteForm').submit();
                        }
                  }

                  // Close modal when clicking outside
                  window.onclick = function (event) {
                        const modal = document.getElementById('deleteModal');
                        if (event.target === modal) {
                              closeDeleteModal();
                        }
                  }

                  // Auto-hide alert messages after 5 seconds
                  document.addEventListener('DOMContentLoaded', function () {
                        const alerts = document.querySelectorAll('.alert');
                        alerts.forEach(alert => {
                              setTimeout(() => {
                                    alert.style.opacity = '0';
                                    setTimeout(() => {
                                          alert.style.display = 'none';
                                    }, 300);
                              }, 5000);
                        });
                  });

                  // Edit modal functions
                  function openEditModal(bookId, isbn, title, author, category, publishedYear, totalCopies, availableCopies, status, imageUrl) {
                        // Populate form fields
                        document.getElementById('modalBookId').value = bookId;
                        document.getElementById('modalIsbn').value = isbn;
                        document.getElementById('modalTitle').value = title;
                        document.getElementById('modalAuthor').value = author;
                        document.getElementById('modalCategory').value = category;
                        document.getElementById('modalPublishedYear').value = publishedYear;
                        document.getElementById('modalTotalCopies').value = totalCopies;
                        document.getElementById('modalAvailableCopies').value = availableCopies;
                        document.getElementById('modalStatus').value = status;
                        document.getElementById('modalImageUrl').value = imageUrl || '';

                        // Store current filter parameters
                        document.getElementById('currentTitle').value = '${titleFilter}';
                        document.getElementById('currentAuthor').value = '${authorFilter}';
                        document.getElementById('currentCategory').value = '${categoryFilter}';
                        document.getElementById('currentStatus').value = '${statusFilter}';
                        document.getElementById('currentPage').value = '${currentPage}';
                        document.getElementById('currentSize').value = '${pageSize}';

                        // Show modal using Bootstrap
                        var editModal = new bootstrap.Modal(document.getElementById('editBookModal'));
                        editModal.show();
                  }

                  // Close modal when clicking outside
                  window.onclick = function (event) {
                        const modal = document.getElementById('deleteModal');
                        if (event.target === modal) {
                              closeDeleteModal();
                        }
                  }
                  // Smooth animations for table rows
                  document.addEventListener('DOMContentLoaded', function () {
                        const rows = document.querySelectorAll('.table-row');
                        rows.forEach((row, index) => {
                              row.style.opacity = '0';
                              row.style.transform = 'translateY(20px)';
                              setTimeout(() => {
                                    row.style.transition = 'all 0.6s cubic-bezier(0.4, 0, 0.2, 1)';
                                    row.style.opacity = '1';
                                    row.style.transform = 'translateY(0)';
                              }, index * 100);
                        });
                  });
            </script>
      </body>
</html>