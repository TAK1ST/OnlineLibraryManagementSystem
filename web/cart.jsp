<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Shopping Cart - Library System</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <!-- Navigation Bar -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="container">
                <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
                    <i class="fas fa-book-reader me-2"></i>Online Library
                </a>
                <div class="d-flex align-items-center">
                    <c:if test="${not empty sessionScope.loginedUser}">
                        <span class="text-light me-3">Hi, ${sessionScope.loginedUser.name}!</span>
                        <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-outline-light">Logout</a>
                    </c:if>
                </div>
            </div>
        </nav>

        <div class="container mt-4">
            <h2 class="mb-4">Your Cart</h2>
            
            <!-- Message Display -->
            <c:if test="${not empty message}">
                <div class="alert alert-${messageType} alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${empty cart}">
                    <div class="alert alert-info">
                        Your cart is empty. <a href="${pageContext.request.contextPath}/home">Continue browsing books</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card">
                        <div class="card-body">
                            <form action="SubmitBorrowRequestServlet" method="POST">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Title</th>
                                            <th>Author</th>
                                            <th>Category</th>
                                            <th>Quantity</th>
                                            <th>Available</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${cart}" var="item">
                                            <tr>
                                                <td>${item.book.title}</td>
                                                <td>${item.book.author}</td>
                                                <td>${item.book.category}</td>
                                                <td>
                                                    <div class="input-group" style="width: 120px;">
                                                        <button type="button" class="btn btn-outline-secondary btn-sm" 
                                                                onclick="window.location.href='UpdateCartServlet?bookId=${item.book.id}&action=decrease'">
                                                            <i class="fas fa-minus"></i>
                                                        </button>
                                                        <span class="input-group-text">${item.quantity}</span>
                                                        <button type="button" class="btn btn-outline-secondary btn-sm"
                                                                onclick="window.location.href='UpdateCartServlet?bookId=${item.book.id}&action=increase'">
                                                            <i class="fas fa-plus"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                                <td>${item.book.availableCopies}</td>
                                                <td>
                                                    <a href="RemoveFromCart?bookId=${item.book.id}" 
                                                       class="btn btn-danger btn-sm">
                                                        <i class="fas fa-trash"></i> Remove
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                
                                <div class="mt-3">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-paper-plane"></i> Submit Borrow Request
                                    </button>
                                    <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">
                                        <i class="fas fa-arrow-left"></i> Continue Browsing
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html> 