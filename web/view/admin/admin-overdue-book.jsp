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
                    <a href="LogoutServlet" class="nav-link">
                            <i class="fas fa-sign-out-alt me-2"></i>Logout
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
                        <div class="col-lg-3 col-md-6 mb-3">
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
                        <div class="col-lg-3 col-md-6 mb-3">
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
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="card stats-card card-success">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-8">
                                            <h5 class="card-title">Unpaid Fines</h5>
                                            <h2 class="card-text mb-0">
                                                $<fmt:formatNumber value="${totalUnpaidFines}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                            </h2>
                                            <small class="text-muted">${totalUnpaidCount} unpaid records</small>
                                        </div>
                                        <div class="col-4 text-end">
                                            <i class="fas fa-times-circle fa-3x text-danger opacity-25"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 mb-3">
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
                                                    <th><i class="fas fa-dollar-sign me-2"></i>Fine</th>
                                                    <th><i class="fas fa-flag me-2"></i>Payment Status</th>
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
                                                            <span class="text-danger fw-bold">
                                                                $<fmt:formatNumber value="${overdueBook.fineAmount}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                                            </span>
                                                        </td>
                                                        <td>
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
                                                        </td>
                                                        <td>
                                                            <!-- Action buttons -->
                                                            <div class="btn-group" role="group" onclick="event.stopPropagation()">
                                                                <!-- Payment status buttons -->
                                                                <c:choose>
                                                                    <c:when test="${overdueBook.paidStatus == 'paid'}">
                                                                        <button type="button" class="btn btn-outline-danger btn-sm" 
                                                                                title="Mark as Unpaid"
                                                                                onclick="markAsUnpaid(${overdueBook.borrowId})">
                                                                            <i class="fas fa-times"></i>
                                                                        </button>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <button type="button" class="btn btn-outline-success btn-sm" 
                                                                                title="Mark as Paid"
                                                                                onclick="markAsPaid(${overdueBook.borrowId})">
                                                                            <i class="fas fa-check"></i>
                                                                        </button>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                                
                                                                <button type="button" class="btn btn-outline-primary btn-sm" 
                                                                        title="Edit Fine Amount"
                                                                        onclick="editFineAmount(${overdueBook.borrowId}, ${overdueBook.fineAmount})">
                                                                    <i class="fas fa-edit"></i>
                                                                </button>
                                                                
                                                                <button type="button" class="btn btn-warning btn-sm" 
                                                                        title="Send Reminder"
                                                                        onclick="sendReminder(${overdueBook.borrowId})">
                                                                    <i class="fas fa-bell"></i>
                                                                </button>
                                                                
                                                                <button type="button" class="btn btn-info btn-sm" 
                                                                        title="View Details"
                                                                        onclick="viewDetails(${overdueBook.borrowId})">
                                                                    <i class="fas fa-eye"></i>
                                                                </button>
                                                            </div>
                                                        </td>
                                                    </tr>

                                                    <!-- Details row (hidden by default) -->
                                                    <tr class="details-row" id="details-${status.index}" style="display: none;">
                                                        <td colspan="8">
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
                                                                        <div class="mb-2">
                                                                            <strong>Status:</strong> 
                                                                            <span class="badge status-overdue">
                                                                                <i class="fas fa-exclamation-circle me-1"></i>
                                                                                ${overdueBook.borrowStatus}
                                                                            </span>
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

                                                                        <!-- Quick Action Buttons in Details -->
                                                                        <div class="mt-3">
                                                                            <strong>Quick Actions:</strong>
                                                                            <div class="btn-group d-block mt-2" role="group">
                                                                                <c:choose>
                                                                                    <c:when test="${overdueBook.paidStatus == 'paid'}">
                                                                                        <button type="button" class="btn btn-sm btn-outline-danger me-1" 
                                                                                                onclick="markAsUnpaid(${overdueBook.borrowId})">
                                                                                            <i class="fas fa-times me-1"></i>Mark Unpaid
                                                                                        </button>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <button type="button" class="btn btn-sm btn-outline-success me-1" 
                                                                                                onclick="markAsPaid(${overdueBook.borrowId})">
                                                                                            <i class="fas fa-check me-1"></i>Mark Paid
                                                                                        </button>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                                <button type="button" class="btn btn-sm btn-outline-primary" 
                                                                                        onclick="editFineAmount(${overdueBook.borrowId}, ${overdueBook.fineAmount})">
                                                                                    <i class="fas fa-edit me-1"></i>Edit Fine
                                                                                </button>
                                                                            </div>
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

        <!-- Edit Fine Amount Modal -->
        <div class="modal fade" id="editFineModal" tabindex="-1" aria-labelledby="editFineModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editFineModalLabel">
                            <i class="fas fa-edit me-2"></i>Edit Fine Amount
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form id="editFineForm" method="post" action="overduebook">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="updateFineAmount">
                            <input type="hidden" name="borrowId" id="editBorrowId">
                            
                            <div class="mb-3">
                                <label for="fineAmount" class="form-label">Fine Amount ($)</label>
                                <div class="input-group">
                                    <span class="input-group-text">$</span>
                                    <input type="number" step="0.01" min="0" class="form-control" id="fineAmount" name="fineAmount" required>
                                </div>
                                <div class="form-text">Enter the new fine amount in dollars.</div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                <i class="fas fa-times me-1"></i>Cancel
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-1"></i>Update Fine
                            </button>
                        </div>
                    </form>
                </div>
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
            
            // Mark fine as paid
            function markAsPaid(borrowId) {
                if (confirm('Are you sure you want to mark this fine as PAID?')) {
                    const form = document.createElement('form');
                    form.method = 'post';
                    form.action = 'overduebook';
                    
                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = 'markPaid';
                    form.appendChild(actionInput);
                    
                    const borrowIdInput = document.createElement('input');
                    borrowIdInput.type = 'hidden';
                    borrowIdInput.name = 'borrowId';
                    borrowIdInput.value = borrowId;
                    form.appendChild(borrowIdInput);
                    
                    document.body.appendChild(form);
                    form.submit();
                }
            }
            
            // Mark fine as unpaid
            function markAsUnpaid(borrowId) {
                if (confirm('Are you sure you want to mark this fine as UNPAID?')) {
                    const form = document.createElement('form');
                    form.method = 'post';
                    form.action = 'overduebook';
                    
                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = 'markUnpaid';
                    form.appendChild(actionInput);
                    
                    const borrowIdInput = document.createElement('input');
                    borrowIdInput.type = 'hidden';
                    borrowIdInput.name = 'borrowId';
                    borrowIdInput.value = borrowId;
                    form.appendChild(borrowIdInput);
                    
                    document.body.appendChild(form);
                    form.submit();
                }
            }
            
            // Edit fine amount
            function editFineAmount(borrowId, currentAmount) {
                document.getElementById('editBorrowId').value = borrowId;
                document.getElementById('fineAmount').value = currentAmount;
                
                const modal = new bootstrap.Modal(document.getElementById('editFineModal'));
                modal.show();
            }
            
            // Other action functions
            function sendReminder(borrowId) {
                if (confirm('Send reminder email to the borrower?')) {
                    // Implement send reminder logic
                    alert('Reminder sent successfully!');
                    // You can add AJAX call here to send reminder
                }
            }
            
            function viewDetails(borrowId) {
                // Find the corresponding details row and toggle it
                const rows = document.querySelectorAll('.overdue-row');
                rows.forEach((row, index) => {
                    const idCell = row.querySelector('td:first-child .fw-bold');
                    if (idCell && idCell.textContent.includes('#' + borrowId)) {
                        toggleDetails(index);
                    }
                });
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
            
            // Form validation for edit fine modal
            document.getElementById('editFineForm').addEventListener('submit', function(e) {
                const fineAmount = document.getElementById('fineAmount').value;
                if (fineAmount < 0) {
                    e.preventDefault();
                    alert('Fine amount cannot be negative!');
                    return false;
                }
                
                if (!confirm('Are you sure you want to update this fine amount?')) {
                    e.preventDefault();
                    return false;
                }
            });
            
            // Add hover effects and loading states for action buttons
            document.addEventListener('DOMContentLoaded', function() {
                // Add loading states to action buttons
                const actionButtons = document.querySelectorAll('.btn-group button');
                actionButtons.forEach(button => {
                    button.addEventListener('click', function() {
                        if (this.getAttribute('onclick') && 
                            (this.getAttribute('onclick').includes('markAsPaid') || 
                             this.getAttribute('onclick').includes('markAsUnpaid'))) {
                            
                            setTimeout(() => {
                                this.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
                                this.disabled = true;
                            }, 100);
                        }
                    });
                });
                
                // Enhanced table row hover effects
                const tableRows = document.querySelectorAll('.overdue-row');
                tableRows.forEach(row => {
                    row.addEventListener('mouseenter', function() {
                        this.style.backgroundColor = '#f8f9fa';
                        this.style.transform = 'scale(1.01)';
                        this.style.transition = 'all 0.2s ease-in-out';
                    });
                    
                    row.addEventListener('mouseleave', function() {
                        this.style.backgroundColor = '';
                        this.style.transform = '';
                    });
                });
            });
            
            // Keyboard shortcuts
            document.addEventListener('keydown', function(e) {
                // Ctrl + R to refresh
                if (e.ctrlKey && e.key === 'r') {
                    e.preventDefault();
                    handleRefresh();
                }
                
                // Escape to close modal
                if (e.key === 'Escape') {
                    const modal = bootstrap.Modal.getInstance(document.getElementById('editFineModal'));
                    if (modal) {
                        modal.hide();
                    }
                }
            });
            
            // Real-time search functionality (if needed in future)
            function filterTable() {
                // This function can be implemented for searching through overdue books
                // Currently just a placeholder for future enhancement
            }
            
            // Export functionality placeholder
            function exportOverdueBooks() {
                if (confirm('Export overdue books data to CSV?')) {
                    // This would trigger the export action in the servlet
                    const form = document.createElement('form');
                    form.method = 'post';
                    form.action = 'overduebook';
                    
                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = 'export';
                    form.appendChild(actionInput);
                    
                    document.body.appendChild(form);
                    form.submit();
                }
            }
            
            // Status update confirmation with better UX
            function confirmStatusChange(action, borrowId) {
                const actionText = action === 'markPaid' ? 'mark as PAID' : 'mark as UNPAID';
                const iconClass = action === 'markPaid' ? 'fa-check-circle text-success' : 'fa-times-circle text-danger';
                
                // Create custom confirmation dialog
                const confirmDialog = document.createElement('div');
                confirmDialog.className = 'modal fade';
                confirmDialog.innerHTML = `
                    <div class="modal-dialog modal-sm">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">
                                    <i class="fas ${iconClass} me-2"></i>Confirm Action
                                </h5>
                            </div>
                            <div class="modal-body text-center">
                                <p>Are you sure you want to ${actionText} this fine?</p>
                                <p class="text-muted small">Borrow ID: #${borrowId}</p>
                            </div>
                            <div class="modal-footer justify-content-center">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="button" class="btn ${action == 'markPaid' ? 'btn-success' : 'btn-danger'}" onclick="executeStatusChange('${action}', ${borrowId}); bootstrap.Modal.getInstance(this.closest('.modal')).hide();">
                                    Confirm
                                </button>
                            </div>
                        </div>
                    </div>
                `;
                
                document.body.appendChild(confirmDialog);
                const modal = new bootstrap.Modal(confirmDialog);
                modal.show();
                
                // Clean up after modal is hidden
                confirmDialog.addEventListener('hidden.bs.modal', function() {
                    document.body.removeChild(confirmDialog);
                });
            }
            
            function executeStatusChange(action, borrowId) {
                const form = document.createElement('form');
                form.method = 'post';
                form.action = 'overduebook';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = action;
                form.appendChild(actionInput);
                
                const borrowIdInput = document.createElement('input');
                borrowIdInput.type = 'hidden';
                borrowIdInput.name = 'borrowId';
                borrowIdInput.value = borrowId;
                form.appendChild(borrowIdInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        </script>
        
        <style>
            /* Additional custom styles for enhanced UX */
            .overdue-row {
                cursor: pointer;
                transition: all 0.2s ease-in-out;
            }
            
            .overdue-row:hover {
                background-color: #f8f9fa !important;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            
            .toggle-icon {
                transition: transform 0.3s ease-in-out;
                margin-left: 8px;
            }
            
            .details-content {
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                border-radius: 8px;
                padding: 20px;
                margin: 10px 0;
                border-left: 4px solid #007bff;
            }
            
            .btn-group .btn {
                transition: all 0.2s ease-in-out;
            }
            
            .btn-group .btn:hover {
                transform: translateY(-1px);
                box-shadow: 0 2px 4px rgba(0,0,0,0.2);
            }
            
            .stats-card {
                transition: transform 0.2s ease-in-out;
                border: none;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            
            .stats-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            }
            
            .modal-content {
                border: none;
                box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            }
            
            .table th {
                background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
                color: white;
                border: none;
                font-weight: 600;
                text-transform: uppercase;
                font-size: 0.85rem;
                letter-spacing: 0.5px;
            }
            
            .alert-success-custom {
                background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
                border-color: #28a745;
                color: #155724;
            }
            
            .alert-danger-custom {
                background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
                border-color: #dc3545;
                color: #721c24;
            }
            
            .refresh-btn {
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                border: none;
                color: white;
                padding: 10px 20px;
                border-radius: 25px;
                font-weight: 600;
                transition: all 0.3s ease;
                box-shadow: 0 2px 10px rgba(40, 167, 69, 0.3);
            }
            
            .refresh-btn:hover {
                transform: translateY(-1px);
                box-shadow: 0 4px 15px rgba(40, 167, 69, 0.4);
                background: linear-gradient(135deg, #20c997 0%, #28a745 100%);
            }
            
            .no-data-container {
                text-align: center;
                padding: 60px 20px;
                color: #6c757d;
            }
            
            .no-data-container i {
                color: #28a745;
                margin-bottom: 20px;
            }
            
            .overdue-days {
                background: linear-gradient(135deg, #ff6b6b 0%, #ee5a52 100%);
                color: white;
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 0.85rem;
                font-weight: 600;
            }
            
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(10px); }
                to { opacity: 1; transform: translateY(0); }
            }
            
            .details-row td {
                animation: fadeIn 0.3s ease-in-out;
            }
            
            /* Responsive improvements */
            @media (max-width: 768px) {
                .btn-group {
                    flex-direction: column;
                }
                
                .btn-group .btn {
                    margin-bottom: 2px;
                }
                
                .stats-card {
                    margin-bottom: 15px;
                }
                
                .details-content .row {
                    flex-direction: column;
                }
                
                .details-content .col-md-4 {
                    margin-bottom: 20px;
                }
            }
        </style>
    </body>
</html>