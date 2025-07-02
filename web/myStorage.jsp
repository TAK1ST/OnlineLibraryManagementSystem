<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Storage - Online Library</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/main.css" rel="stylesheet">
        <style>
            .book-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                margin-bottom: 20px;
                overflow: hidden;
                transition: transform 0.3s ease;
            }
            .book-card:hover {
                transform: translateY(-5px);
            }
            .book-card img {
                width: 120px;
                height: 160px;
                object-fit: cover;
            }
            .book-details {
                padding: 20px;
            }
            .return-btn {
                background-color: #dc3545;
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 5px;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }
            .return-btn:hover {
                background-color: #c82333;
            }
            .modal-confirm {
                color: #636363;
            }
            .modal-confirm .modal-content {
                padding: 20px;
                border-radius: 5px;
                border: none;
            }
            .modal-confirm .modal-header {
                border-bottom: none;   
                position: relative;
            }
            .modal-confirm .modal-footer {
                border: none;
                text-align: center;
                border-radius: 5px;
                padding: 20px;
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
                                <a class="nav-link" href="${pageContext.request.contextPath}/BorrowHistoryServlet">
                                    <i class="fas fa-history"></i>Borrowed History
                                </a>
                            </li>
                            <li class="nav-item">
                                <span class="nav-link">Hi, ${sessionScope.loginedUser.name}!</span>
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
            <h2 class="mb-4">My Storage</h2>
            
            <!-- Hiển thị thông báo -->
            <div id="messageAlert" class="alert alert-success alert-dismissible fade" role="alert" style="display: none;">
                <span id="messageText"></span>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>

            <!-- Danh sách sách đã mượn -->
            <jsp:useBean id="borrowRequestDAO" class="dao.implement.BorrowRequestDAO"/>
            <jsp:useBean id="bookDAO" class="dao.implement.BookDAO"/>
            
            <c:set var="approvedRequests" value="${borrowRequestDAO.getApprovedRequestsByUser(sessionScope.loginedUser.id)}"/>
            
            <c:choose>
                <c:when test="${empty approvedRequests}">
                    <div class="text-center py-5">
                        <i class="fas fa-books fa-3x text-muted mb-3"></i>
                        <h4>No books in stock</h4>
                        <p class="text-muted">You have not borrowed any books or have not had any requests approved.</p>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
                            <i class="fas fa-book me-2"></i>View book list
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row">
                        <c:forEach items="${approvedRequests}" var="request">
                            <div class="col-md-6 book-item" id="book-${request.id}">
                                <div class="book-card">
                                    <div class="row g-0">
                                        <div class="col-md-4 d-flex align-items-center justify-content-center">
                                            <c:set var="book" value="${bookDAO.getBookById(request.bookId)}"/>
                                            <img src="https://via.placeholder.com/120x160?text=${book.title}" 
                                                 alt="${book.title}" class="img-fluid">
                                        </div>
                                        <div class="col-md-8">
                                            <div class="book-details">
                                                <h5 class="card-title">${book.title}</h5>
                                                <p class="card-text mb-1">
                                                    <strong>Author:</strong> ${book.author}
                                                </p>
                                                <p class="card-text mb-1">
                                                    <strong>Categories:</strong> ${book.category}
                                                </p>
                                                <p class="card-text mb-3">
                                                    <strong>Borrowed date:</strong> ${request.requestDate}
                                                </p>
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <button class="return-btn" onclick="showReturnConfirmation(${request.id})">
                                                        <i class="fas fa-undo-alt me-1"></i>Return book
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Modal xác nhận trả sách -->
        <div class="modal fade modal-confirm" id="returnConfirmModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Confirm book return</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to return this book?</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-danger" id="confirmReturnBtn">Confirm</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            let currentRequestId = null;
            const returnModal = new bootstrap.Modal(document.getElementById('returnConfirmModal'));
            
            function showReturnConfirmation(requestId) {
                currentRequestId = requestId;
                returnModal.show();
            }
            
            document.getElementById('confirmReturnBtn').addEventListener('click', function() {
                if (currentRequestId) {
                    returnBook(currentRequestId);
                }
            });
            
            function returnBook(requestId) {
                fetch('${pageContext.request.contextPath}/ReturnBookServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'requestId=' + requestId
                })
                .then(response => response.json())
                .then(data => {
                    returnModal.hide();
                    
                    if (data.success) {
                        // Remove book card
                        document.getElementById('book-' + requestId).remove();
                        
                        // Show success message
                        showMessage(data.message, 'success');
                        
                        // If no more books, show empty state
                        if (document.getElementsByClassName('book-item').length === 0) {
                            location.reload();
                        }
                    } else {
                        showMessage(data.message, 'danger');
                    }
                })
                .catch(error => {
                    returnModal.hide();
                    showMessage('Error returning book: ' + error, 'danger');
                });
            }
            
            function showMessage(message, type) {
                const alert = document.getElementById('messageAlert');
                const messageText = document.getElementById('messageText');
                
                alert.className = 'alert alert-' + type + ' alert-dismissible fade show';
                messageText.textContent = message;
                alert.style.display = 'block';
                
                setTimeout(() => {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }, 3000);
            }
        </script>
    </body>
</html> 