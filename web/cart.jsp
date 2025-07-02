<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Giỏ sách - Thư viện trực tuyến</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/main.css" rel="stylesheet">
        <style>
            .cart-item {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                margin-bottom: 20px;
                overflow: hidden;
                transition: transform 0.3s ease;
            }
            .cart-item:hover {
                transform: translateY(-5px);
            }
            .cart-item img {
                width: 120px;
                height: 160px;
                object-fit: cover;
            }
            .item-details {
                padding: 20px;
            }
            .quantity-control {
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .quantity-btn {
                background: #f8f9fa;
                border: none;
                padding: 5px 10px;
                border-radius: 5px;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }
            .quantity-btn:hover {
                background: #e9ecef;
            }
            .remove-btn {
                color: #dc3545;
                background: none;
                border: none;
                padding: 0;
                cursor: pointer;
            }
            .remove-btn:hover {
                color: #c82333;
            }
            .empty-cart {
                text-align: center;
                padding: 40px 20px;
            }
            .empty-cart i {
                font-size: 4rem;
                color: #6c757d;
                margin-bottom: 20px;
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
            <h2 class="mb-4">Your Cart</h2>
            
            <!-- Hiển thị thông báo -->
            <c:if test="${not empty message}">
                <div class="alert alert-${messageType} alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${empty cart}">
                    <div class="empty-cart">
                        <i class="fas fa-shopping-cart"></i>
                        <h3>Empty</h3>
                        <p class="text-muted">Please! Add books to your cart to borrow.</p>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
                            <i class="fas fa-book me-2"></i>View book list
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="cart-items">
                        <c:forEach items="${cart}" var="item">
                            <div class="cart-item">
                                <div class="row align-items-center">
                                    <div class="col-md-2">
                                        <img src="https://via.placeholder.com/120x160?text=${item.book.title}" 
                                             alt="${item.book.title}" class="img-fluid">
                                    </div>
                                    <div class="col-md-6 item-details">
                                        <h5>${item.book.title}</h5>
                                        <p class="text-muted mb-1">Author: ${item.book.author}</p>
                                        <p class="text-muted mb-1">Category: ${item.book.category}</p>
                                        <c:if test="${item.book.availableCopies > 0}">
                                            <span class="badge bg-success">Still have ${item.book.availableCopies} book</span>
                                        </c:if>
                                        <c:if test="${item.book.availableCopies == 0}">
                                            <span class="badge bg-danger">Out of book</span>
                                        </c:if>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="quantity-control">
                                            <button class="quantity-btn" onclick="updateQuantity(${item.book.id}, -1)">
                                                <i class="fas fa-minus"></i>
                                            </button>
                                            <span>${item.quantity}</span>
                                            <button class="quantity-btn" onclick="updateQuantity(${item.book.id}, 1)">
                                                <i class="fas fa-plus"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="col-md-2 text-end pe-5">
                                        <button class="remove-btn" onclick="removeFromCart(${item.book.id})">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                        
                        <div class="d-flex justify-content-between align-items-center mt-4">
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-primary">
                                <i class="fas fa-arrow-left me-2"></i>Continue reading
                            </a>
                            <form action="${pageContext.request.contextPath}/SubmitBorrowRequestServlet" method="POST">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-check me-2"></i>Confirm book borrowing
                                </button>
                            </form>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function updateQuantity(bookId, change) {
                fetch('${pageContext.request.contextPath}/UpdateCartServlet?bookId=' + bookId + '&change=' + change)
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            location.reload();
                        } else {
                            alert(data.message);
                        }
                    });
            }
            
            function removeFromCart(bookId) {
                if (confirm('Bạn có chắc muốn xóa sách này khỏi giỏ?')) {
                    fetch('${pageContext.request.contextPath}/RemoveFromCartServlet?bookId=' + bookId)
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                location.reload();
                            } else {
                                alert(data.message);
                            }
                        });
                }
            }
        </script>
    </body>
</html> 