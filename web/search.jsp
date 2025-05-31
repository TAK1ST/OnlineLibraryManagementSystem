<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Search Books - Online Library</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .book-card {
                height: 100%;
                transition: transform 0.2s;
                margin-bottom: 20px;
            }
            .book-card:hover {
                transform: scale(1.02);
            }
            .search-form {
                background-color: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 30px;
            }
        </style>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="container">
                <a class="navbar-brand" href="${pageContext.request.contextPath}/home">Online Library</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/home">Home</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container mt-4">
            <!-- Search Form -->
            <div class="search-form">
                <form action="${pageContext.request.contextPath}/search" method="GET" class="row g-3">
                    <div class="col-md-6">
                        <input type="text" name="txtsearch" class="form-control" value="${searchTerm}" placeholder="Enter search term...">
                    </div>
                    <div class="col-md-4">
                        <select name="searchBy" class="form-select">
                            <option value="title" ${searchBy == 'title' ? 'selected' : ''}>Title</option>
                            <option value="author" ${searchBy == 'author' ? 'selected' : ''}>Author</option>
                            <option value="category" ${searchBy == 'category' ? 'selected' : ''}>Category</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100">Search</button>
                    </div>
                </form>
            </div>

            <!-- Error Messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    ${error}
                </div>
            </c:if>

            <!-- Search Results -->
            <h2 class="mb-4">Search Results</h2>
            
            <c:choose>
                <c:when test="${empty books}">
                    <div class="alert alert-info" role="alert">
                        No books found matching your search criteria.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row">
                        <c:forEach items="${books}" var="book">
                            <div class="col-md-6 col-lg-4">
                                <div class="card book-card">
                                    <div class="card-body">
                                        <h5 class="card-title">${book.title}</h5>
                                        <p class="card-text">
                                            <strong>Author:</strong> ${book.author}<br>
                                            <strong>ISBN:</strong> ${book.isbn}<br>
                                            <strong>Category:</strong> ${book.category}<br>
                                            <strong>Published Year:</strong> ${book.publishedYear}<br>
                                            <strong>Available Copies:</strong> ${book.availableCopies}/${book.totalCopies}
                                        </p>
                                        <div class="d-flex justify-content-between align-items-center">
                                            <span class="badge bg-${book.availableCopies > 0 ? 'success' : 'danger'}">
                                                ${book.availableCopies > 0 ? 'Available' : 'Not Available'}
                                            </span>
                                            <c:if test="${book.availableCopies > 0}">
                                                <form action="${pageContext.request.contextPath}/borrow" method="POST" style="display: inline;">
                                                    <input type="hidden" name="bookId" value="${book.id}">
                                                    <button type="submit" class="btn btn-sm btn-primary">Borrow</button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </div>
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
