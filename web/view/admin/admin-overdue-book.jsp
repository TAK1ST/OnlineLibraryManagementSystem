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
                <nav class="col-md-2 sidebar">
                    <div class="sidebar-sticky">
                        <div class="sidebar-header">
                            <h4>
                                <div class="brand-icon">
                                    <i class="fas fa-book-reader"></i>
                                </div>
                                Library Admin
                            </h4>
                        </div>
                        <div class="p-3">
                            <ul class="nav flex-column">
                                <li class="nav-item">
                                    <a class="nav-link" href="admindashboard">
                                        <i class="fas fa-tachometer-alt"></i>
                                        <span>Dashboard</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link active" href="overduebook">
                                        <i class="fas fa-exclamation-triangle"></i>
                                        <span>Overdue Books</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="bookmanagement">
                                        <i class="fas fa-book"></i>
                                        <span>Books</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="usermanagement">
                                        <i class="fas fa-users"></i>
                                        <span>Users</span>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </nav>

                <!-- Main content -->
                <main class="col-md-10">
                    <div class="main-content">
                        <!-- Header -->
                        <div class="page-header">
                            <div class="d-flex justify-content-between align-items-center flex-wrap">
                                <div>
                                    <h1>
                                        <i class="fas fa-exclamation-triangle"></i>
                                        Overdue Books Management
                                    </h1>
                                    <p class="mb-0">Monitor and manage overdue library books with ease</p>
                                </div>
                                <button class="refresh-btn" onclick="window.location.reload()">
                                    <i class="fas fa-sync-alt"></i>
                                    <span>Refresh</span>
                                </button>
                            </div>
                        </div>

                        <!-- Alert Messages -->
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success-custom alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle"></i>
                                <span>${successMessage}</span>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger-custom alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle"></i>
                                <span>${errorMessage}</span>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger-custom alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle"></i>
                                <span>${error}</span>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <c:if test="${not empty message}">
                            <div class="alert alert-info alert-dismissible fade show" role="alert">
                                <i class="fas fa-info-circle"></i>
                                <span>${message}</span>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Summary Cards -->
                        <div class="row mb-4">
                            <div class="col-md-4">
                                <div class="card stats-card card-danger">
                                    <div class="card-body">
                                        <div class="row align-items-center">
                                            <div class="col-8">
                                                <h5 class="card-title">Total Overdue</h5>
                                                <h2 class="card-text mb-0">${totalOverdueBooks}</h2>
                                                <small class="opacity-75">Books past due date</small>
                                            </div>
                                            <div class="col-4 text-end">
                                                <i class="fas fa-exclamation-triangle fa-3x opacity-25"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card stats-card card-warning">
                                    <div class="card-body">
                                        <div class="row align-items-center">
                                            <div class="col-8">
                                                <h5 class="card-title">Total Fines</h5>
                                                <h2 class="card-text mb-0">
                                                    $<fmt:formatNumber value="${totalFines}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                                </h2>
                                                <small class="opacity-75">Outstanding penalties</small>
                                            </div>
                                            <div class="col-4 text-end">
                                                <i class="fas fa-dollar-sign fa-3x opacity-25"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card stats-card card-info">
                                    <div class="card-body">
                                        <div class="row align-items-center">
                                            <div class="col-8">
                                                <h5 class="card-title">Avg. Days Overdue</h5>
                                                <h2 class="card-text mb-0">${averageOverdueDays}</h2>
                                                <small class="opacity-75">Average delay period</small>
                                            </div>
                                            <div class="col-4 text-end">
                                                <i class="fas fa-calendar-times fa-3x opacity-25"></i>
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
                                    <i class="fas fa-list"></i>
                                    <span>Overdue Books List</span>
                                </h5>
                            </div>
                            <div class="p-3">
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
                                                        <tr class="overdue-row clickable-row" onclick="toggleDetails('${status.index}')" style="cursor: pointer;">
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
                                                                            title="Send Reminder">
                                                                        <i class="fas fa-bell"></i>
                                                                    </button>
<!--                                                                    <button type="button" class="btn btn-primary btn-sm" 
                                                                            title="View Details">
                                                                        <i class="fas fa-eye"></i>
                                                                    </button>
                                                                    <button type="button" class="btn btn-success btn-sm" 
                                                                            title="Mark as Returned">
                                                                        <i class="fas fa-check"></i>
                                                                    </button>-->
                                                                </div>
                                                            </td>
                                                        </tr>

                                                        <!-- Details row (hidden by default) -->
                                                        <tr class="details-row" id="details-${status.index}" style="display: none;">
                                                            <td colspan="7">
                                                                <div class="details-content p-3 bg-light">
                                                                    <div class="row">
                                                                        <!-- Book Details -->
                                                                        <div class="col-md-4">
                                                                            <h6 class="fw-bold text-primary mb-2">
                                                                                <i class="fas fa-book me-2"></i>Book Details
                                                                            </h6>
                                                                            <div class="mb-2">
                                                                                <strong>ISBN:</strong> ${overdueBook.bookIsbn}
                                                                            </div>
                                                                            <div class="mb-2">
                                                                                <strong>Category:</strong> ${overdueBook.bookCategory}
                                                                            </div>
                                                                            <div class="mb-2">
                                                                                <strong>Author:</strong> ${overdueBook.bookAuthor}
                                                                            </div>
                                                                        </div>

                                                                        <!-- User Details -->
                                                                        <div class="col-md-4">
                                                                            <h6 class="fw-bold text-success mb-2">
                                                                                <i class="fas fa-user me-2"></i>Borrower Details
                                                                            </h6>
                                                                            <div class="mb-2">
                                                                                <strong>Name:</strong> ${overdueBook.userName}
                                                                            </div>
                                                                            <div class="mb-2">
                                                                                <strong>Email:</strong> ${overdueBook.userEmail}
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
                                                                            <h6 class="fw-bold text-warning mb-2">
                                                                                <i class="fas fa-dollar-sign me-2"></i>Fine Details
                                                                            </h6>
                                                                            <div class="mb-2">
                                                                                <strong>Fine Amount:</strong> 
                                                                                <span class="text-danger fw-bold">
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
                                                                                        <fmt:formatDate value="${overdueBook.returnDate}" pattern="dd-MM-yyyy"/>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <span class="text-muted">Not returned</span>
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
                    </div>
                </main>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                                                    function toggleDetails(index) {
                                                                        const detailsRow = document.getElementById('details-' + index);
                                                                        const icon = document.getElementById('icon-' + index);

                                                                        if (detailsRow.style.display === 'none' || detailsRow.style.display === '') {
                                                                            detailsRow.style.display = 'table-row';
                                                                            icon.classList.remove('fa-chevron-down');
                                                                            icon.classList.add('fa-chevron-up');
                                                                        } else {
                                                                            detailsRow.style.display = 'none';
                                                                            icon.classList.remove('fa-chevron-up');
                                                                            icon.classList.add('fa-chevron-down');
                                                                        }
                                                                    }
        </script>

        <style>
            .clickable-row:hover {
                background-color: #f8f9fa !important;
            }

            .toggle-icon {
                font-size: 0.8em;
                margin-left: 0.5rem;
                color: #6c757d;
            }

            .details-content {
                border-left: 4px solid #007bff;
                border-radius: 0.375rem;
                margin: 0.5rem 0;
            }

            .details-content h6 {
                border-bottom: 1px solid #dee2e6;
                padding-bottom: 0.5rem;
                margin-bottom: 1rem;
            }

            .details-row td {
                padding: 0 !important;
                border-top: none !important;
            }

            .overdue-row.clickable-row {
                transition: background-color 0.2s ease;
            }
        </style>
    </body>
</html>