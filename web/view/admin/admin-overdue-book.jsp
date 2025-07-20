<%-- 
    Document   : admin-overdue-book
    Created on : Jun 9, 2025, 9:19:28 PM
    Author     : CAU_TU
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Overdue Books Management</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-overdue-book.css"/>
    </head>
    <body>
        <div class="container-fluid p-0">
            <div class="row g-0">
                <!-- Sidebar -->
                <div class="sidebar">
                    <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" alt="Avatar">
                    <h3>Role: Administrator</h3>
                    <a href="admindashboard" class="nav-link">
                        <i class="fas fa-chart-bar"></i> Dashboard
                    </a>
                    <a href="systemconfig" class="nav-link">
                        <i class="fas fa-cog"></i> System Config
                    </a>
                    <a href="usermanagement" class="nav-link">
                        <i class="fas fa-users"></i> User Management
                    </a>
                    <a href="statusrequestborrowbook" class="nav-link">
                        <i class="fas fa-clock"></i> View Request Books
                    </a>
                    <a href="bookmanagement" class="nav-link">
                        <i class="fas fa-book"></i> Book Management
                    </a>
                    <a href="updateinventory" class="nav-link">
                        <i class="fas fa-boxes"></i> Update Inventory
                    </a>
                    <a href="overduebook" class="nav-link active">
                        <i class="fas fa-exclamation-triangle"></i> Overdue Book
                    </a>
                </div>

                <!-- Main content -->
                <main class="main-content">
                    <!-- Header -->
                    <div class="page-header">
                        <div class="d-flex justify-content-between align-items-center flex-wrap">
                            <div>
                                <h1>
                                    <i class="fas fa-exclamation-triangle me-3"></i>
                                    Overdue Books Management
                                </h1>
                                <p class="mb-0 opacity-90">Monitor and manage overdue library books with ease</p>
                            </div>
                            <button class="refresh-btn" onclick="window.location.reload()">
                                <i class="fas fa-sync-alt me-2"></i>
                                <span>Refresh</span>
                            </button>
                        </div>
                    </div>

                    <!-- Alert Messages -->
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success-custom alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>
                            <span>${successMessage}</span>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger-custom alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            <span>${errorMessage}</span>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger-custom alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            <span>${error}</span>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty message}">
                        <div class="alert alert-info alert-dismissible fade show" role="alert">
                            <i class="fas fa-info-circle me-2"></i>
                            <span>${message}</span>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Summary Cards -->
                    <div class="row mb-4">
                        <div class="col-lg-4 col-md-6 mb-3">
                            <div class="card stats-card card-danger">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-8">
                                            <h5 class="card-title">Total Overdue</h5>
                                            <h2 class="card-text mb-0">${totalOverdueBooks}</h2>
                                            <small class="text-muted">Books past due date</small>
                                        </div>
                                        <div class="col-4 text-end">
                                            <i class="fas fa-exclamation-triangle fa-3x text-danger opacity-25"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 col-md-6 mb-3">
                            <div class="card stats-card card-warning">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-8">
                                            <h5 class="card-title">Total Fines</h5>
                                            <h2 class="card-text mb-0">
                                                $<fmt:formatNumber value="${totalFines}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                            </h2>
                                            <small class="text-muted">Outstanding penalties</small>
                                        </div>
                                        <div class="col-4 text-end">
                                            <i class="fas fa-dollar-sign fa-3x text-warning opacity-25"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 col-md-6 mb-3">
                            <div class="card stats-card card-info">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-8">
                                            <h5 class="card-title">Avg. Days Overdue</h5>
                                            <h2 class="card-text mb-0">${averageOverdueDays}</h2>
                                            <small class="text-muted">Average delay period</small>
                                        </div>
                                        <div class="col-4 text-end">
                                            <i class="fas fa-calendar-times fa-3x text-info opacity-25"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Overdue Books Table -->
                    <div class="overdue-table">
                        <div class="table-header">
                            <h5 class="mb-0">
                                <i class="fas fa-list me-2"></i>
                                <span>Overdue Books List</span>
                            </h5>
                        </div>
                        <div class="p-0">
                            <c:choose>
                                <c:when test="${empty overdueBooks}">
                                    <div class="no-data-container">
                                        <i class="fas fa-check-circle fa-4x"></i>
                                        <h4>No Overdue Books</h4>
                                        <p>All books are returned on time! Great job managing the library.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th><i class="fas fa-hashtag me-2"></i>ID</th>
                                                    <th><i class="fas fa-book me-2"></i>Book Title</th>
                                                    <th><i class="fas fa-calendar-plus me-2"></i>Borrow Date</th>
                                                    <th><i class="fas fa-calendar-times me-2"></i>Due Date</th>
                                                    <th><i class="fas fa-clock me-2"></i>Days Overdue</th>
                                                    <th><i class="fas fa-flag me-2"></i>Status</th>
                                                    <th><i class="fas fa-cogs me-2"></i>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="overdueBook" items="${overdueBooks}" varStatus="status">
                                                    <!-- Main row -->
                                                    <tr class="overdue-row" onclick="toggleDetails('${status.index}')">
                                                        <td>
                                                            <div class="fw-bold text-primary">#${overdueBook.borrowId}</div>
                                                            <i class="fas fa-chevron-down toggle-icon" id="icon-${status.index}"></i>
                                                        </td>
                                                        <td>
                                                            <div class="fw-bold text-dark">${overdueBook.bookTitle}</div>
                                                            <small class="text-muted d-block">by ${overdueBook.bookAuthor}</small>
                                                        </td>
                                                        <td>
                                                            <i class="fas fa-calendar me-2 text-muted"></i>
                                                            <fmt:formatDate value="${overdueBook.borrowDate}" pattern="dd-MM-yyyy"/>
                                                        </td>
                                                        <td class="text-danger fw-bold">
                                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                                            <fmt:formatDate value="${overdueBook.dueDate}" pattern="dd-MM-yyyy"/>
                                                        </td>
                                                        <td>
                                                            <span class="overdue-days">
                                                                <i class="fas fa-clock me-1"></i>
                                                                ${overdueBook.overdueDays} days
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <span class="badge status-overdue">
                                                                <i class="fas fa-exclamation-circle me-1"></i>
                                                                ${overdueBook.borrowStatus}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <!-- Action buttons -->
                                                            <div class="btn-group" role="group" onclick="event.stopPropagation()">
                                                                <button type="button" class="btn btn-warning btn-sm" 
                                                                        title="Send Reminder"
                                                                        onclick="sendReminder(${overdueBook.borrowId})">
                                                                    <i class="fas fa-bell"></i>
                                                                </button>
                                                                <button type="button" class="btn btn-primary btn-sm" 
                                                                        title="View Details"
                                                                        onclick="viewDetails(${overdueBook.borrowId})">
                                                                    <i class="fas fa-eye"></i>
                                                                </button>
                                                                <c:if test="${overdueBook.borrowStatus != 'returned'}">
                                                                    <button type="button" class="btn btn-success btn-sm" 
                                                                            title="Mark as Returned"
                                                                            onclick="markAsReturned(${overdueBook.borrowId})">
                                                                        <i class="fas fa-check"></i>
                                                                    </button>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                    </tr>

                                                    <!-- Details row (hidden by default) -->
                                                    <tr class="details-row" id="details-${status.index}" style="display: none;">
                                                        <td colspan="7">
                                                            <div class="details-content">
                                                                <div class="row">
                                                                    <!-- Book Details -->
                                                                    <div class="col-md-4">
                                                                        <h6 class="text-primary mb-3">
                                                                            <i class="fas fa-book me-2"></i>Book Details
                                                                        </h6>
                                                                        <div class="mb-2">
                                                                            <strong>ISBN:</strong> 
                                                                            <span class="text-muted">${overdueBook.bookIsbn}</span>
                                                                        </div>
                                                                        <div class="mb-2">
                                                                            <strong>Category:</strong> 
                                                                            <span class="badge bg-secondary">${overdueBook.bookCategory}</span>
                                                                        </div>
                                                                        <div class="mb-2">
                                                                            <strong>Author:</strong> 
                                                                            <span class="text-muted">${overdueBook.bookAuthor}</span>
                                                                        </div>
                                                                    </div>

                                                                    <!-- User Details -->
                                                                    <div class="col-md-4">
                                                                        <h6 class="text-success mb-3">
                                                                            <i class="fas fa-user me-2"></i>Borrower Details
                                                                        </h6>
                                                                        <div class="mb-2">
                                                                            <strong>Name:</strong> 
                                                                            <span class="text-muted">${overdueBook.userName}</span>
                                                                        </div>
                                                                        <div class="mb-2">
                                                                            <strong>Email:</strong> 
                                                                            <a href="mailto:${overdueBook.userEmail}" class="text-decoration-none">
                                                                                ${overdueBook.userEmail}
                                                                            </a>
                                                                        </div>
                                                                        <div class="mb-2">
                                                                            <strong>Role:</strong> 
                                                                            <span class="badge bg-secondary">${overdueBook.userRole}</span>
                                                                        </div>
                                                                        <div class="mb-2">
                                                                            <strong>User Status:</strong> 
                                                                            <span class="badge bg-info">${overdueBook.userStatus}</span>
                                                                        </div>
                                                                    </div>

                                                                    <!-- Fine Details -->
                                                                    <div class="col-md-4">
                                                                        <h6 class="text-warning mb-3">
                                                                            <i class="fas fa-dollar-sign me-2"></i>Fine Details
                                                                        </h6>
                                                                        <div class="mb-2">
                                                                            <strong>Fine Amount:</strong> 
                                                                            <span class="text-danger fw-bold fs-5">
                                                                                $<fmt:formatNumber value="${overdueBook.fineAmount}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                                                            </span>
                                                                        </div>
                                                                        <div class="mb-2">
                                                                            <strong>Payment Status:</strong>
                                                                            <c:choose>
                                                                                <c:when test="${overdueBook.paidStatus == 'paid'}">
                                                                                    <span class="badge bg-success">
                                                                                        <i class="fas fa-check-circle me-1"></i>
                                                                                        Paid
                                                                                    </span>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <span class="badge bg-danger">
                                                                                        <i class="fas fa-times-circle me-1"></i>
                                                                                        Unpaid
                                                                                    </span>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </div>
                                                                        <div class="mb-2">
                                                                            <strong>Return Date:</strong> 
                                                                            <c:choose>
                                                                                <c:when test="${not empty overdueBook.returnDate}">
                                                                                    <span class="text-success">
                                                                                        <fmt:formatDate value="${overdueBook.returnDate}" pattern="dd-MM-yyyy"/>
                                                                                    </span>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <span class="text-danger">Not returned yet</span>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
        <script>
            // Toggle details function with smooth animation
            function toggleDetails(index) {
                const detailsRow = document.getElementById('details-' + index);
                const icon = document.getElementById('icon-' + index);

                if (detailsRow.style.display === 'none' || detailsRow.style.display === '') {
                    detailsRow.style.display = 'table-row';
                    icon.classList.remove('fa-chevron-down');
                    icon.classList.add('fa-chevron-up');
                    icon.style.transform = 'rotate(180deg)';
                } else {
                    detailsRow.style.display = 'none';
                    icon.classList.remove('fa-chevron-up');
                    icon.classList.add('fa-chevron-down');
                    icon.style.transform = 'rotate(0deg)';
                }
            }
            
            // Action functions
            function sendReminder(borrowId) {
                if (confirm('Send reminder email to the borrower?')) {
                    // Implement send reminder logic
                    alert('Reminder sent successfully!');
                    // You can add AJAX call here to send reminder
                }
            }
            
            function viewDetails(borrowId) {
                // Implement view details logic
                alert('Viewing details for Borrow ID: ' + borrowId);
                // You can redirect to a detail page or show modal
            }
            
            function markAsReturned(borrowId) {
                if (confirm('Mark this book as returned?')) {
                    // Implement mark as returned logic
                    window.location.href = 'markAsReturned?borrowId=' + borrowId;
                }
            }
            
            // Auto-dismiss alerts after 5 seconds
            document.addEventListener('DOMContentLoaded', function() {
                const alerts = document.querySelectorAll('.alert:not(.alert-dismissible)');
                alerts.forEach(function(alert) {
                    setTimeout(function() {
                        alert.style.opacity = '0';
                        setTimeout(function() {
                            alert.remove();
                        }, 300);
                    }, 5000);
                });
            });
            
            // Add loading state to refresh button
            function handleRefresh() {
                const refreshBtn = document.querySelector('.refresh-btn');
                refreshBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Loading...';
                refreshBtn.disabled = true;
                window.location.reload();
            }
            
            // Update refresh button onclick
            document.querySelector('.refresh-btn').onclick = handleRefresh;
        </script>
    </body>
</html>