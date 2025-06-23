<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thư viện trực tuyến</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/theme.css" rel="stylesheet">
        <style>
            /* Hero section */
            .hero-section {
                background: var(--gradient-primary);
                color: var(--light);
                padding: var(--spacing-xl) 0;
                text-align: center;
                margin-bottom: var(--spacing-xl);
            }

            .hero-section h1 {
                font-size: 3rem;
                margin-bottom: var(--spacing-md);
                font-weight: 700;
            }

            .hero-section p {
                font-size: 1.2rem;
                opacity: 0.9;
            }

            /* Search section */
            .search-form {
                background: var(--light);
                padding: var(--spacing-lg);
                border-radius: var(--border-radius-lg);
                box-shadow: var(--shadow-md);
                margin-bottom: var(--spacing-xl);
            }

            /* Book cards */
            .book-card {
                height: 100%;
                transition: all 0.3s ease;
                margin-bottom: var(--spacing-md);
                border: none;
                border-radius: var(--border-radius-lg);
                box-shadow: var(--shadow-sm);
                overflow: hidden;
                background: white;
            }

            .book-card:hover {
                transform: translateY(-5px);
                box-shadow: var(--shadow-lg);
            }

            .book-card .card-img-top {
                height: 250px;
                object-fit: cover;
            }

            .book-card .card-body {
                padding: var(--spacing-md);
            }

            .book-card .card-title {
                color: var(--primary-dark);
                font-weight: 600;
                margin-bottom: var(--spacing-sm);
            }

            .book-card .card-text {
                color: var(--secondary-dark);
                font-size: 0.9rem;
            }

            /* Section titles */
            .section-title {
                border-left: 5px solid var(--primary-accent);
                padding-left: var(--spacing-md);
                margin-bottom: var(--spacing-lg);
                color: var(--primary-dark);
            }

            /* Badges */
            .badge-new {
                position: absolute;
                top: var(--spacing-sm);
                right: var(--spacing-sm);
                background: var(--gradient-accent);
                padding: var(--spacing-xs) var(--spacing-sm);
                border-radius: var(--border-radius-sm);
                color: var(--light);
                font-weight: 500;
                box-shadow: var(--shadow-sm);
            }

            /* Navbar */
            .navbar {
                background: var(--gradient-primary) !important;
                padding: var(--spacing-md) var(--spacing-lg);
                box-shadow: var(--shadow-md);
            }

            .navbar-brand {
                color: var(--light) !important;
                font-weight: 600;
            }

            .nav-link {
                color: var(--light) !important;
                transition: all 0.3s ease;
            }

            .nav-link:hover {
                color: var(--primary-accent) !important;
            }

            /* Buttons */
            .btn-primary {
                background: var(--gradient-accent);
                border: none;
                padding: var(--spacing-sm) var(--spacing-md);
                border-radius: var(--border-radius-md);
                color: var(--light);
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: var(--shadow-md);
            }

            /* Category badges */
            .category-badge {
                background: rgba(26, 188, 156, 0.1);
                color: var(--primary-accent);
                padding: var(--spacing-xs) var(--spacing-sm);
                border-radius: var(--border-radius-sm);
                font-size: 0.8rem;
                font-weight: 500;
            }
        </style>
    </head>
    <body>
        <!-- Navbar -->
        <nav class="navbar navbar-expand-lg">
            <div class="container">
                <a class="navbar-brand" href="#">
                    <i class="fas fa-book-reader me-2"></i>
                    Thư viện trực tuyến
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/LoginServlet">
                                <i class="fas fa-sign-in-alt me-1"></i>
                                Đăng nhập
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/RegisterServlet">
                                <i class="fas fa-user-plus me-1"></i>
                                Đăng ký
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Hero Section -->
        <section class="hero-section">
            <div class="container">
                <h1>Chào mừng đến với Thư viện trực tuyến</h1>
                <p>Khám phá hàng ngàn đầu sách và mở rộng kiến thức của bạn</p>
            </div>
        </section>

        <!-- Search Section -->
        <div class="container">
            <div class="search-form">
                <form action="${pageContext.request.contextPath}/search" method="GET" class="row g-3">
                    <div class="col-md-4">
                        <input type="text" class="form-control" name="title" placeholder="Tên sách">
                    </div>
                    <div class="col-md-4">
                        <input type="text" class="form-control" name="author" placeholder="Tác giả">
                    </div>
                    <div class="col-md-3">
                        <select class="form-select" name="category">
                            <option value="">Tất cả thể loại</option>
                            <c:forEach items="${categories}" var="category">
                                <option value="${category.id}">${category.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-1">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </form>
            </div>

            <!-- Latest Books Section -->
            <h2 class="section-title">Sách mới nhất</h2>
            <div class="row">
                <c:forEach items="${latestBooks}" var="book">
                    <div class="col-md-3 mb-4">
                        <div class="card book-card">
                            <c:if test="${book.isNew}">
                                <span class="badge-primary position-absolute top-2 end-2">Mới</span>
                            </c:if>
                            <img src="${book.coverImage}" class="card-img-top" alt="${book.title}">
                            <div class="card-body">
                                <h5 class="card-title">${book.title}</h5>
                                <p class="card-text">${book.author}</p>
                                <span class="badge-primary">${book.category}</span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Footer -->
        <footer class="footer">
            <div class="container text-center">
                <p class="mb-0">&copy; 2024 Thư viện trực tuyến. All rights reserved.</p>
            </div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
