<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Library Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            .book-card {
                height: 100%;
                transition: transform 0.2s;
                margin-bottom: 20px;
                border: none;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            .book-card:hover {
                transform: scale(1.02);
                box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            }
            .search-form {
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                padding: 25px;
                border-radius: 15px;
                margin-bottom: 30px;
                box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            }
            .section-title {
                border-left: 5px solid #0d6efd;
                padding-left: 15px;
                margin-bottom: 25px;
            }
            .badge-new {
                position: absolute;
                top: 10px;
                right: 10px;
                background-color: #198754;
                padding: 5px 10px;
                border-radius: 5px;
                color: white;
            }
        </style>
    </head>
    <body class="bg-light">
        <!-- Navigation Bar -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="container">
                <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
                    <i class="fas fa-book-reader me-2"></i>Online Library
                </a>
                <div class="d-flex align-items-center">
                    <c:choose>
                        <c:when test="${not empty sessionScope.loginedUser}">
                            <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-light me-3">
                                <i class="fas fa-shopping-cart"></i>
                                <span class="ms-1">Cart</span>
                            </a>
                            <span class="text-light me-3">Hi, ${sessionScope.loginedUser.name}!</span>
                            <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-outline-light">Logout</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/LoginServlet" class="btn btn-outline-light">Login</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </nav>

        <div class="container mt-4">
            <!-- Message Display -->
            <c:if test="${not empty message}">
                <div class="alert alert-${messageType == 'success' ? 'success' : 'danger'} alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            
            <!-- Search Form -->
            <div class="search-form">
                <h4 class="mb-4 section-title">Tìm kiếm sách</h4>
                <form action="${pageContext.request.contextPath}/search" method="GET" class="row g-3">
                    <div class="col-md-4">
                        <input type="text" class="form-control" name="title" placeholder="Tên sách" value="${title}">
                    </div>
                    <div class="col-md-3">
                        <input type="text" class="form-control" name="author" placeholder="Tác giả" value="${author}">
                    </div>
                    <div class="col-md-3">
                        <select class="form-select" name="category">
                            <option value="">Chọn thể loại</option>
                            <c:forEach items="${categories}" var="cat">
                                <option value="${cat}" ${cat eq category ? 'selected' : ''}>${cat}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100">Tìm kiếm</button>
                    </div>
                </form>
            </div>

            <!-- New Arrivals Section -->
            <c:if test="${empty param.title and empty param.author and empty param.category}">
                <h4 class="mb-4 section-title">New Arrivals</h4>
                <div class="row">
                    <c:forEach items="${newBooks}" var="book">
                        <div class="col-md-3">
                            <div class="card book-card">
                                <div class="badge-new">New</div>
                                <div class="card-body">
                                    <h5 class="card-title">${book.title}</h5>
                                    <p class="card-text">
                                        <small class="text-muted">By ${book.author}</small><br>
                                        <span class="badge bg-info">${book.category}</span>
                                    </p>
                                    <p class="card-text">
                                        <small class="text-muted">Available Copies: ${book.availableCopies}</small>
                                    </p>
                                    <c:if test="${book.availableCopies > 0}">
                                        <a href="AddToCartServlet?bookId=${book.id}" class="btn btn-primary btn-sm me-2">
                                            <i class="fas fa-cart-plus me-1"></i>Add to Cart
                                        </a>
                                    </c:if>
                                    <c:if test="${book.availableCopies == 0}">
                                        <button class="btn btn-secondary btn-sm me-2" disabled>
                                            <i class="fas fa-ban me-1"></i>Not Available
                                        </button>
                                    </c:if>
                                    <a href="BookDetailServlet?id=${book.id}" class="btn btn-outline-primary btn-sm">
                                        <i class="fas fa-info-circle me-1"></i>View Details
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <!-- Search Results or All Books -->
            <c:if test="${not empty books}">
                <h4 class="mb-4 section-title">${empty param.title and empty param.author and empty param.category ? 'All Books' : 'Search Results'}</h4>
                <div class="row">
                    <c:forEach items="${books}" var="book">
                        <div class="col-md-3">
                            <div class="card book-card">
                                <div class="card-body">
                                    <h5 class="card-title">${book.title}</h5>
                                    <p class="card-text">
                                        <small class="text-muted">By ${book.author}</small><br>
                                        <span class="badge bg-info">${book.category}</span>
                                    </p>
                                    <p class="card-text">
                                        <small class="text-muted">Available Copies: ${book.availableCopies}</small>
                                    </p>
                                    <c:if test="${book.availableCopies > 0}">
                                        <a href="AddToCartServlet?bookId=${book.id}" class="btn btn-primary btn-sm me-2">
                                            <i class="fas fa-cart-plus me-1"></i>Add to Cart
                                        </a>
                                    </c:if>
                                    <c:if test="${book.availableCopies == 0}">
                                        <button class="btn btn-secondary btn-sm me-2" disabled>
                                            <i class="fas fa-ban me-1"></i>Not Available
                                        </button>
                                    </c:if>
                                    <a href="BookDetailServlet?id=${book.id}" class="btn btn-outline-primary btn-sm">
                                        <i class="fas fa-info-circle me-1"></i>View Details
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <c:if test="${empty books and (not empty param.title or not empty param.author or not empty param.category)}">
                <div class="alert alert-info">
                    No books found matching your search criteria.
                </div>
            </c:if>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
