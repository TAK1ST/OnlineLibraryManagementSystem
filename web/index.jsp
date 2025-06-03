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
            .card-img-top {
                height: 200px;
                object-fit: cover;
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
                <a class="navbar-brand" href="home">
                    <i class="fas fa-book-reader me-2"></i>Online Library
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav me-auto">
                        <li class="nav-item">
                            <a class="nav-link active" href="home">Home</a>
                        </li>
                    </ul>
                    <ul class="navbar-nav">
                        <li class="nav-item">
                            <a class="nav-link" href="login">Login</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container mt-4">
            <!-- Search Form -->
            <div class="search-form">
                <h4 class="mb-4 section-title">Search Books</h4>
                <form action="search" method="GET" class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label">Title</label>
                        <input type="text" name="title" class="form-control" value="${title}">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Author</label>
                        <input type="text" name="author" class="form-control" value="${author}">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Category</label>
                        <select name="category" class="form-select">
                            <option value="">Select Category</option>
                            <c:forEach items="${categories}" var="cat">
                                <option value="${cat}" ${cat eq selectedCategory ? 'selected' : ''}>
                                    ${cat}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">&nbsp;</label>
                        <button type="submit" class="btn btn-primary w-100">Search</button>
                    </div>
                </form>
            </div>

            <!-- Search Results -->
            <c:if test="${not empty books}">
                <h3 class="section-title">Search Results</h3>
                <div class="row">
                    <c:forEach items="${books}" var="book">
                        <div class="col-md-4 mb-3">
                            <div class="card book-card">
                                <div class="card-body">
                                    <h5 class="card-title">${book.title}</h5>
                                    <p class="card-text">
                                        <strong>ISBN:</strong> ${book.isbn}<br>
                                        <strong>Author:</strong> ${book.author}<br>
                                        <strong>Category:</strong> ${book.category}<br>
                                        <strong>Published Year:</strong> ${book.publishedYear}<br>
                                        <strong>Available Copies:</strong> ${book.availableCopies}
                                    </p>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="badge bg-${book.availableCopies > 0 ? 'success' : 'danger'}">
                                            ${book.availableCopies > 0 ? 'Available' : 'Not Available'}
                                        </span>
                                        <a href="availability?id=${book.id}" class="btn btn-primary btn-sm">Details</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
            
            <c:if test="${empty books && searchValue != null}">
                <div class="alert alert-info">
                    No books found matching your search criteria.
                </div>
            </c:if>

            <!-- New Books Section -->
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
                                    <small class="text-muted">Category: ${book.category}</small><br>
                                    <small class="text-muted">Year: ${book.publishedYear}</small>
                                </p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="badge bg-${book.availableCopies > 0 ? 'success' : 'danger'}">
                                        ${book.availableCopies > 0 ? 'Available' : 'Not Available'}
                                    </span>
                                    <a href="availability?id=${book.id}" class="btn btn-primary btn-sm">Details</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- All Books Section -->
            <h4 class="mt-5 mb-4 section-title">All Books</h4>
            <div class="row">
                <c:forEach items="${allBooks}" var="book">
                    <div class="col-md-3 mb-4">
                        <div class="card book-card">
                            <div class="card-body">
                                <h5 class="card-title">${book.title}</h5>
                                <p class="card-text">
                                    <small class="text-muted">By ${book.author}</small><br>
                                    <small class="text-muted">Category: ${book.category}</small><br>
                                    <small class="text-muted">Year: ${book.publishedYear}</small>
                                </p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="badge bg-${book.availableCopies > 0 ? 'success' : 'danger'}">
                                        ${book.availableCopies > 0 ? 'Available' : 'Not Available'}
                                    </span>
                                    <a href="availability?id=${book.id}" class="btn btn-primary btn-sm">Details</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
