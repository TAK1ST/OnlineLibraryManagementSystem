<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Book Borrowing History - Online Library</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/main.css" rel="stylesheet">
        <style>
            .history-item {
                background: white;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin-bottom: 20px;
                padding: 20px;
                transition: transform 0.2s;
            }
            .history-item:hover {
                transform: translateY(-5px);
            }
            .status-badge {
                font-size: 0.9rem;
                padding: 5px 10px;
                border-radius: 15px;
            }
            .status-pending {
                background-color: #ffd700;
                color: #000;
            }
            .status-approved {
                background-color: #28a745;
                color: white;
            }
            .status-borrowed {
                background-color: #007bff;
                color: white;
            }
            .status-returned {
                background-color: #17a2b8;
                color: white;
            }
            .status-rejected {
                background-color: #dc3545;
                color: white;
            }
            .filter-section {
                background: white;
                border-radius: 10px;
                padding: 20px;
                margin-bottom: 20px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .stats-card {
                background: white;
                border-radius: 10px;
                padding: 15px;
                text-align: center;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin-bottom: 20px;
                transition: transform 0.2s;
            }
            .stats-card:hover {
                transform: translateY(-2px);
            }
            .stats-card h3 {
                margin: 0;
                font-size: 2rem;
                font-weight: bold;
            }
            .stats-card p {
                margin: 5px 0 0 0;
                color: #6c757d;
            }
            .stats-pending {
                border-left: 4px solid #ffd700;
            }
            .stats-approved {
                border-left: 4px solid #28a745;
            }
            .stats-borrowed {
                border-left: 4px solid #007bff;
            }
            .stats-returned {
                border-left: 4px solid #17a2b8;
            }
            .stats-rejected {
                border-left: 4px solid #dc3545;
            }
        </style>
    </head>
    <body>
        <!-- Thanh điều hướng -->
        <nav class="navbar navbar-expand-lg navbar-dark">
            <div class="container">
                <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
                    <i class="fas fa-book-reader me-2"></i>Online Library
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <c:if test="${not empty sessionScope.loginedUser}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/MyStorageServlet">
                                    <i class="fas fa-book"></i> My Storage
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/cart">
                                    <i class="fas fa-shopping-cart me-1"></i>Cart
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/ChangeProfile">
                                    <i class="fas fa-user me-1"></i>Hi, ${sessionScope.loginedUser.name}!
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/LogoutServlet">Log out</a>
                            </li>
                        </c:if>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container mt-4">
            <h2 class="mb-4">Borrowed History</h2>

            <!-- Hiển thị thông báo -->
            <c:if test="${not empty message}">
                <div class="alert alert-${messageType} alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Thống kê tổng quan -->
            <div class="d-flex flex-wrap justify-content-center gap-3 mb-4">
                <div class="stats-card stats-pending flex-fill" style="min-width: 180px; max-width: 220px;">
                    <h3 class="text-warning">${pendingCount}</h3>
                    <p>Pending</p>
                </div>
                <div class="stats-card stats-approved flex-fill" style="min-width: 180px; max-width: 220px;">
                    <h3 class="text-success">${approvedCount}</h3>
                    <p>Approved</p>
                </div>
                <div class="stats-card stats-borrowed flex-fill" style="min-width: 180px; max-width: 220px;">
                    <h3 class="text-primary">${borrowedCount}</h3>
                    <p>Borrowed</p>
                </div>
                <div class="stats-card stats-returned flex-fill" style="min-width: 180px; max-width: 220px;">
                    <h3 class="text-info">${returnedCount}</h3>
                    <p>Returned</p>
                </div>
                <div class="stats-card stats-rejected flex-fill" style="min-width: 180px; max-width: 220px;">
                    <h3 class="text-danger">${rejectedCount}</h3>
                    <p>Rejected</p>
                </div>
            </div>

            <!-- Bộ lọc và sắp xếp -->
            <div class="filter-section">
                <form id="filterForm" method="GET" action="${pageContext.request.contextPath}/BorrowHistoryServlet">
                    <div class="row">
                        <div class="col-md-6">
                            <label for="statusFilter" class="form-label">Filter by Status:</label>
                            <select id="statusFilter" name="status" class="form-select">
                                <option value="all" ${currentFilter == null or currentFilter == 'all' ? 'selected' : ''}>All Status</option>
                                <option value="pending" ${currentFilter == 'pending' ? 'selected' : ''}>Pending Approval</option>
                                <option value="approved" ${currentFilter == 'approved' ? 'selected' : ''}>Approved</option>
                                <option value="borrowed" ${currentFilter == 'borrowed' ? 'selected' : ''}>Borrowed</option>
                                <option value="returned" ${currentFilter == 'returned' ? 'selected' : ''}>Returned</option>
                                <option value="rejected" ${currentFilter == 'rejected' ? 'selected' : ''}>Rejected</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="sortBy" class="form-label">Sort by:</label>
                            <select id="sortBy" name="sort" class="form-select">
                                <option value="date_desc" ${currentSort == 'date_desc' or currentSort == null ? 'selected' : ''}>Newest First</option>
                                <option value="date_asc" ${currentSort == 'date_asc' ? 'selected' : ''}>Oldest First</option>
                                <option value="status" ${currentSort == 'status' ? 'selected' : ''}>By Status</option>
                            </select>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col-md-12">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-filter me-2"></i>Apply Filter
                            </button>
                            <a href="${pageContext.request.contextPath}/BorrowHistoryServlet" class="btn btn-secondary">
                                <i class="fas fa-times me-2"></i>Clear Filter
                            </a>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Danh sách lịch sử mượn -->
            <jsp:useBean id="bookDAO" class="dao.implement.BookDAO"/>

            <c:choose>
                <c:when test="${empty borrowHistory}">
                    <div class="text-center py-5">
                        <i class="fas fa-history fa-3x text-muted mb-3"></i>
                        <h4>No history found</h4>
                        <c:choose>
                            <c:when test="${currentFilter != null and currentFilter != 'all'}">
                                <p class="text-muted">No books found with status: <strong>${currentFilter}</strong></p>
                                <a href="${pageContext.request.contextPath}/BorrowHistoryServlet" class="btn btn-primary">
                                    <i class="fas fa-eye me-2"></i>View All Records
                                </a>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted">You have not borrowed any books yet.</p>
                                <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
                                    <i class="fas fa-book me-2"></i>View Book List
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="mb-3">
                        <h5>Showing ${totalCount} record(s)
                            <c:if test="${currentFilter != null and currentFilter != 'all'}">
                                with status: <span class="badge bg-primary">${currentFilter}</span>
                            </c:if>
                        </h5>
                    </div>
                    <div class="row">
                        <c:forEach items="${borrowHistory}" var="request">
                            <div class="col-md-6">
                                <div class="history-item">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <h5 class="mb-0">
                                            <c:set var="book" value="${bookDAO.getBookById(request.bookId)}"/>
                                            ${book.title}
                                        </h5>
                                        <span class="status-badge status-${request.status.toLowerCase()}">
                                            <c:choose>
                                                <c:when test="${request.status eq 'pending'}">
                                                    <i class="fas fa-clock me-1"></i>Pending Approval
                                                </c:when>
                                                <c:when test="${request.status eq 'approved'}">
                                                    <i class="fas fa-check me-1"></i>Approved
                                                </c:when>
                                                <c:when test="${request.status eq 'borrowed'}">
                                                    <i class="fas fa-book me-1"></i>Borrowed
                                                </c:when>
                                                <c:when test="${request.status eq 'returned'}">
                                                    <i class="fas fa-undo me-1"></i>Returned
                                                </c:when>
                                                <c:when test="${request.status eq 'rejected'}">
                                                    <i class="fas fa-times me-1"></i>Rejected
                                                </c:when>
                                            </c:choose>
                                        </span>
                                    </div>

                                    <p class="mb-2">
                                        <strong>Author:</strong> ${book.author}
                                    </p>
                                    <p class="mb-2">
                                        <strong>Categories:</strong> ${book.category}
                                    </p>
                                    <p class="mb-2">
                                        <strong>Request Date:</strong> 
                                        <fmt:formatDate value="${request.requestDate}" pattern="dd-MM-yyyy"/>
                                    </p>

                                    <!-- Hiển thị thông tin thêm dựa trên status -->
                                    <c:choose>
                                        <c:when test="${request.status eq 'pending'}">
                                            <div class="alert alert-warning alert-sm mt-2">
                                                <i class="fas fa-info-circle me-1"></i>
                                                Waiting for librarian approval
                                            </div>
                                        </c:when>
                                        <c:when test="${request.status eq 'approved'}">
                                            <div class="alert alert-success alert-sm mt-2">
                                                <i class="fas fa-check-circle me-1"></i>
                                                Book approved for borrowing
                                            </div>
                                        </c:when>
                                        <c:when test="${request.status eq 'borrowed'}">
                                            <div class="alert alert-primary alert-sm mt-2">
                                                <i class="fas fa-book-reader me-1"></i>
                                                Book is currently borrowed
                                            </div>
                                        </c:when>
                                        <c:when test="${request.status eq 'returned'}">
                                            <div class="alert alert-info alert-sm mt-2">
                                                <i class="fas fa-check-double me-1"></i>
                                                Book has been returned successfully
                                            </div>
                                        </c:when>
                                        <c:when test="${request.status eq 'rejected'}">
                                            <div class="alert alert-danger alert-sm mt-2">
                                                <i class="fas fa-exclamation-circle me-1"></i>
                                                Request was rejected
                                            </div>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Auto-submit form when filter/sort changes
            document.addEventListener('DOMContentLoaded', function () {
                const statusFilter = document.getElementById('statusFilter');
                const sortBy = document.getElementById('sortBy');
                const filterForm = document.getElementById('filterForm');

                if (statusFilter) {
                    statusFilter.addEventListener('change', function () {
                        console.log('Status filter changed to:', this.value);
                        filterForm.submit();
                    });
                }

                if (sortBy) {
                    sortBy.addEventListener('change', function () {
                        console.log('Sort changed to:', this.value);
                        filterForm.submit();
                    });
                }
            });
        </script>
    </body>
</html>