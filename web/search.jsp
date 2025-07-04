<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Kết quả tìm kiếm - Thư viện trực tuyến</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --primary-dark: #2C3E50;
                --primary-light: #34495E;
                --accent-dark: #16A085;
                --accent-light: #1ABC9C;
                --light-bg: #F0F0F0;
                --white: #ffffff;
            }

            body {
                background-color: #F0F0F0;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            /* Navbar styles */
            .navbar {
                background: linear-gradient(135deg, var(--primary-dark) 0%, var(--primary-light) 100%) !important;
                padding: 1rem 0;
                box-shadow: 0 4px 20px rgba(44, 62, 80, 0.3);
            }

            .navbar-brand {
                font-weight: 700;
                font-size: 1.5rem;
                color: white !important;
            }

            .navbar-nav .nav-link {
                color: rgba(255, 255, 255, 0.9) !important;
                font-weight: 500;
                transition: all 0.3s ease;
                padding: 0.5rem 1rem !important;
                border-radius: 25px;
                margin: 0 0.2rem;
            }

            .navbar-nav .nav-link:hover {
                color: white !important;
                background-color: rgba(255, 255, 255, 0.1);
                transform: translateY(-2px);
            }

            /* Hero section */
            .banner{
                background-image: url('${pageContext.request.contextPath}/hinh/thu-vien-truong-dai-hoc-fpt-943111.jpg');
                background-size: cover;
                background-position: center;
                height: 40vh;
                position: relative;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #1ABC9C;
            }
            .banner::before{
                content: "";
                position: absolute;
                inset : 0;
                background-color: rgba(0, 0, 0, 0.4);
                z-index: 0;
            }
            
            .banner .content{
                position: relative;
                z-index: 1;
                text-align: center;
            }
            
            .header{
                font-size: 2.5rem;
                letter-spacing: 2px;
                text-transform: uppercase;
                color: white;
                font-weight: 600;
            }
            
            .header2{
                font-size: 1.1rem;
                font-weight: bold;
                line-height: 1.4;
                color: white;
            }

            /* Search section */
            .search-section .form-control,
            .search-section .form-select {
                margin-top: 30px;
                border: 1px solid black;
                border-radius: 15px;
                padding: 0.75rem 1rem;
                font-size: 1rem;
                transition: all 0.3s ease;
                background-color: var(--white);
            }

            .search-section .form-control:focus,
            .search-section .form-select:focus {
                margin-top: 30px;
                border: 1px solid black;
                box-shadow: 0 0 0 0.2rem rgba(26, 188, 156, 0.25);
                background-color: var(--white);
            }

            /* Buttons */
            .btn-primary {
                background: linear-gradient(135deg, var(--accent-light) 0%, var(--accent-dark) 100%);
                border: none;
                color: white;
                padding: 0.75rem 1.5rem;
                border-radius: 15px;
                font-weight: 600;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(26, 188, 156, 0.3);
            }

            .btn-primary:hover {
                background: linear-gradient(135deg, var(--accent-dark) 0%, var(--primary-light) 100%);
                transform: translateY(-3px);
                box-shadow: 0 6px 20px rgba(26, 188, 156, 0.4);
            }

            .btn-outline-primary {
                border: 2px solid var(--accent-light);
                color: var(--accent-dark);
                padding: 0.6rem 1.5rem;
                border-radius: 15px;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-outline-primary:hover {
                background: linear-gradient(135deg, var(--accent-light), var(--accent-dark));
                border-color: var(--accent-dark);
                color: white;
                transform: translateY(-2px);
            }

            /* Section title */
            .section-title {
                color: var(--primary-dark);
                font-weight: 700;
                font-size: 2.5rem;
                margin-bottom: 2rem;
                position: relative;
                padding-bottom: 1rem;
            }

            .section-title::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 50%;
                transform: translateX(-50%);
                width: 80px;
                height: 4px;
                background: linear-gradient(90deg, var(--accent-light), var(--accent-dark));
                border-radius: 2px;
            }
            
            .btn-search{
                margin-top: 30px;
            }    
            
            /* Book cards */
            .book-card {
                border: none;
                border-radius: 20px;
                transition: all 0.3s ease;
                height: 100%;
                box-shadow: 0 5px 20px rgba(44, 62, 80, 0.1);
                background: white;
                overflow: hidden;
            }

            .book-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 15px 40px rgba(44, 62, 80, 0.2);
            }

            .book-card .card-img-top {
                height: 250px;
                object-fit: cover;
                transition: transform 0.3s ease;
            }

            .book-card:hover .card-img-top {
                transform: scale(1.05);
            }

            .book-card .card-body {
                padding: 1.5rem;
            }

            .book-card .card-title {
                color: var(--primary-dark);
                font-weight: 600;
                font-size: 1.1rem;
                margin-bottom: 0.5rem;
                line-height: 1.3;
            }

            .book-card .card-text {
                color: var(--primary-light);
                margin-bottom: 1rem;
            }

            /* Badges */
            .badge.bg-primary {
                background: linear-gradient(135deg, var(--primary-dark), var(--primary-light)) !important;
                padding: 0.5rem 0.8rem;
                border-radius: 10px;
                font-weight: 500;
            }

            .badge.bg-success {
                background: linear-gradient(135deg, var(--accent-light), var(--accent-dark)) !important;
                padding: 0.5rem 0.8rem;
                border-radius: 10px;
                font-weight: 500;
            }

            .badge.bg-danger {
                background: linear-gradient(135deg, #e74c3c, #c0392b) !important;
                padding: 0.5rem 0.8rem;
                border-radius: 10px;
                font-weight: 500;
            }

            /* Results section */
            .results-section {
                padding: 3rem 0;
                background-color: #F0F0F0;
            }

            /* Empty results */
            .empty-results {
                text-align: center;
                padding: 4rem 2rem;
                background: white;
                border-radius: 20px;
                box-shadow: 0 5px 20px rgba(44, 62, 80, 0.1);
            }

            .empty-results i {
                font-size: 4rem;
                background: linear-gradient(135deg, var(--accent-light), var(--accent-dark));
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                margin-bottom: 1.5rem;
            }

            .empty-results h3 {
                color: var(--primary-dark);
                font-weight: 600;
                margin-bottom: 1rem;
            }

            .empty-results p {
                color: var(--primary-light);
                margin-bottom: 2rem;
            }

            /* Alert styles */
            .alert {
                border: none;
                border-radius: 15px;
                margin-bottom: 2rem;
            }

            .alert-success {
                background: linear-gradient(135deg, rgba(26, 188, 156, 0.1), rgba(22, 160, 133, 0.1));
                color: var(--accent-dark);
                border-left: 4px solid var(--accent-light);
            }

            .alert-danger {
                background: linear-gradient(135deg, rgba(231, 76, 60, 0.1), rgba(192, 57, 43, 0.1));
                color: #c0392b;
                border-left: 4px solid #e74c3c;
            }

            /* Responsive styles */
            @media (max-width: 768px) {
                .banner {
                    height: 30vh;
                }
                
                .header {
                    font-size: 2rem;
                }
                
                .search-section {
                    margin: 0 0.5rem 1.5rem 0.5rem;
                    padding: 2rem 0;
                }
                
                .section-title {
                    font-size: 2rem;
                }
                
                .search-section form > div {
                    margin-bottom: 1rem;
                }
            }
        </style>
    </head>
    <body>
        <!-- Thanh điều hướng -->
        <nav class="navbar navbar-expand-lg navbar-dark">
            <div class="container">
                <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
                    <i class="fas fa-book-reader me-2"></i>Thư viện trực tuyến
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <c:if test="${empty sessionScope.loginedUser}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/LoginServlet">
                                    <i class="fas fa-sign-in-alt me-1"></i>Đăng nhập
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/RegisterServlet">
                                    <i class="fas fa-user-plus me-1"></i>Đăng ký
                                </a>
                            </li>
                        </c:if>
                        <c:if test="${not empty sessionScope.loginedUser}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/BorrowHistoryServlet">
                                    <i class="fas fa-history me-1"></i> Lịch sử mượn
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/cart">
                                    <i class="fas fa-shopping-cart me-1"></i> Giỏ sách
                                </a>
                            </li>
                            <li class="nav-item">
                                <span class="nav-link">
                                    <i class="fas fa-user me-1"></i>Xin chào, ${sessionScope.loginedUser.name}!
                                </span>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/LogoutServlet">
                                    <i class="fas fa-sign-out-alt me-1"></i>Đăng xuất
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Phần Hero -->
        <div class="banner">
            <div class="content">
                <p class="header">Tìm kiếm sách</p>
                <p class="header2">Khám phá và tìm kiếm những cuốn sách yêu thích của bạn</p>
            </div>
        </div>

        <!-- Phần tìm kiếm -->
        <section class="search-section">
            <div class="container">
                <form action="${pageContext.request.contextPath}/search" method="GET" class="row justify-content-center">
                    <div class="col-md-3 mb-3">
                        <input type="text" name="title" class="form-control" placeholder="Tên sách" value="${param.title}">
                    </div>
                    <div class="col-md-3 mb-3">
                        <input type="text" name="author" class="form-control" placeholder="Tác giả" value="${param.author}">
                    </div>
                    <div class="col-md-3 mb-3">
                        <select name="category" class="form-select">
                            <option value="">Tất cả thể loại</option>
                            <c:forEach items="${categories}" var="category">
                                <option value="${category}" ${param.category eq category ? 'selected' : ''}>${category}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2 mb-3">
                        <button type="submit" class="btn btn-primary w-100 btn-search">
                            <i class="fas fa-search me-2"></i> Tìm kiếm
                        </button>
                    </div>
                </form>
            </div>
        </section>

        <div class="container">
            <!-- Hiển thị thông báo -->
            <c:if test="${not empty message}">
                <div class="alert alert-${messageType} alert-dismissible fade show" role="alert">
                    <i class="fas fa-info-circle me-2"></i>${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
        </div>

        <!-- Kết quả tìm kiếm -->
        <section class="results-section">
            <div class="container">
                <c:choose>
                    <c:when test="${empty books}">
                        <div class="empty-results">
                            <i class="fas fa-search"></i>
                            <h3>Không tìm thấy kết quả</h3>
                            <p class="text-muted">Vui lòng thử lại với từ khóa khác hoặc điều chỉnh bộ lọc tìm kiếm</p>
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
                                <i class="fas fa-home me-2"></i>Về trang chủ
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <h2 class="section-title text-center">Kết quả tìm kiếm</h2>
                        <div class="row">
                            <c:forEach items="${books}" var="book">
                                <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                                    <div class="book-card card">
                                        <img src="https://via.placeholder.com/300x400?text=${book.title}&bg=1ABC9C&color=FFFFFF" 
                                             class="card-img-top" alt="${book.title}">
                                        <div class="card-body">
                                            <h5 class="card-title">${book.title}</h5>
                                            <p class="card-text">
                                                <small class="text-muted">
                                                    <i class="fas fa-user me-1"></i>Tác giả: ${book.author}
                                                </small>
                                            </p>
                                            <p class="card-text">
                                                <span class="badge bg-primary me-2">${book.category}</span>
                                                <c:if test="${book.availableCopies > 0}">
                                                    <span class="badge bg-success">
                                                        <i class="fas fa-check me-1"></i>Còn sách
                                                    </span>
                                                </c:if>
                                                <c:if test="${book.availableCopies == 0}">
                                                    <span class="badge bg-danger">
                                                        <i class="fas fa-times me-1"></i>Hết sách
                                                    </span>
                                                </c:if>
                                            </p>
                                            <p class="card-text">
                                                <small class="text-muted">
                                                    <i class="fas fa-book me-1"></i>Có sẵn: ${book.availableCopies}/${book.totalCopies}
                                                </small>
                                            </p>
                                            <div class="d-grid gap-2">
                                                <a href="${pageContext.request.contextPath}/bookdetail?id=${book.id}" 
                                                   class="btn btn-primary">
                                                    <i class="fas fa-eye me-2"></i>Xem chi tiết
                                                </a>
                                                <c:if test="${not empty sessionScope.loginedUser && book.availableCopies > 0}">
                                                    <button onclick="addToCart(${book.id})" class="btn btn-outline-primary">
                                                        <i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ
                                                    </button>
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
        </section>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function addToCart(bookId) {
                fetch('${pageContext.request.contextPath}/UpdateCartServlet?bookId=' + bookId + '&change=1')
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            // Show success message with better styling
                            const alertDiv = document.createElement('div');
                            alertDiv.className = 'alert alert-success alert-dismissible fade show position-fixed';
                            alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
                            alertDiv.innerHTML = `
                                <i class="fas fa-check-circle me-2"></i>Đã thêm sách vào giỏ thành công!
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            `;
                            document.body.appendChild(alertDiv);
                            
                            // Auto remove after 3 seconds
                            setTimeout(() => {
                                if (alertDiv.parentNode) {
                                    alertDiv.parentNode.removeChild(alertDiv);
                                }
                            }, 3000);
                        } else {
                            // Show error message
                            const alertDiv = document.createElement('div');
                            alertDiv.className = 'alert alert-danger alert-dismissible fade show position-fixed';
                            alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
                            alertDiv.innerHTML = `
                                <i class="fas fa-exclamation-circle me-2"></i>${data.message}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            `;
                            document.body.appendChild(alertDiv);
                            
                            // Auto remove after 3 seconds
                            setTimeout(() => {
                                if (alertDiv.parentNode) {
                                    alertDiv.parentNode.removeChild(alertDiv);
                                }
                            }, 3000);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Có lỗi xảy ra, vui lòng thử lại!');
                    });
            }
        </script>
    </body>
</html>