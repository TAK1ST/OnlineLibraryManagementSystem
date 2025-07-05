<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
            .status-rejected {
                background-color: #dc3545;
                color: white;
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
                                <a class="nav-link" href="${pageContext.request.contextPath}/BorrowHistoryServlet">
                                    <i class="fas fa-history"></i>Borrowed History
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/ChangeProfile">
                                    <i class="fas fa-user me-1"></i>Hi, ${sessionScope.loginedUser.name}!
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/LogoutServlet">
                                    <i class="fas fa-sign-out-alt me-1"></i>Log out
                                </a>
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

            <!-- Danh sách lịch sử mượn -->
            <jsp:useBean id="bookDAO" class="dao.implement.BookDAO"/>
            
            <c:choose>
                <c:when test="${empty borrowHistory}">
                    <div class="text-center py-5">
                        <i class="fas fa-history fa-3x text-muted mb-3"></i>
                        <h4>No history of borrowing books</h4>
                        <p class="text-muted">You have not borrowed any books yet.</p>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
                            <i class="fas fa-book me-2"></i>View book list
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
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
                                                    <i class="fas fa-clock me-1"></i>Pending approval
                                                </c:when>
                                                <c:when test="${request.status eq 'approved'}">
                                                    <i class="fas fa-check me-1"></i>Approved
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
                                        <strong>Request date:</strong> ${request.requestDate}
                                    </p>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html> 