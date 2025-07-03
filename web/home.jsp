<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thư viện trực tuyến</title>
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

            /* New books section */
            .new-books {
                padding: 3rem 0;
                background-color: #F0F0F0;
            }

            /* Category cards */
            .popular-categories {
                background-color: #F0F0F0;
                padding: 3rem 0;
            }

            .category-card {
                background: white;
                border-radius: 20px;
                padding: 2rem;
                text-align: center;
                box-shadow: 0 8px 25px rgba(44, 62, 80, 0.1);
                transition: all 0.3s ease;
                height: 100%;
                border: none;
            }

            .category-card:hover {
                transform: translateY(-8px);
                box-shadow: 0 15px 40px rgba(44, 62, 80, 0.15);
            }

            .category-icon {
                font-size: 3rem;
                background: linear-gradient(135deg, var(--accent-light), var(--accent-dark));
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                margin-bottom: 1.5rem;
            }

            .category-title {
                font-size: 1.3rem;
                font-weight: 600;
                color: var(--primary-dark);
                margin-bottom: 0.5rem;
            }

            .category-count {
                color: var(--primary-light);
                margin-bottom: 1.5rem;
                font-size: 0.95rem;
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

            /* Responsive styles */
            @media (max-width: 768px) {
                .hero-section {
                    padding: 2.5rem 0;
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
            .banner-container {
                width: 100%;
                max-width: 100%;
                height: 400px;
                overflow: hidden;
                position: relative;
                border: 2px solid #ddd; /* Để debug */
            }

            .banner-slide {
                display: flex;
                width: 400%; /* 4 slides = 400% */
                height: 100%;
                transition: transform 1s ease-in-out;
            }

            .slide-item {
                position: relative;
                width: 25%; /* Mỗi slide chiếm 25% của container */
                flex-shrink: 0;
                background: #f0f0f0; /* Màu nền để debug */
            }

            .slide-item img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                display: block;
            }

            .caption {
                position: absolute;
                bottom: 170px; /* Điều chỉnh vị trí */
                left: 0;
                width: 100%;
                padding: 20px;
                background: rgba(0, 0, 0, 0.7);
                color: white;
                font-size: 24px;
                text-align: center;
                box-sizing: border-box;
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
                        <c:if test="${empty sessionScope.loginedUser}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/LoginServlet">
                                    <i class="fas fa-sign-in-alt me-1"></i>Login
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/RegisterServlet">
                                    <i class="fas fa-user-plus me-1"></i>Register
                                </a>
                            </li>
                        </c:if>
                        <c:if test="${not empty sessionScope.loginedUser}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/BorrowHistoryServlet">
                                    <i class="fas fa-history me-1"></i>Borrowed History
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
                                <a class="nav-link" href="${pageContext.request.contextPath}/LogoutServlet">
                                    <i class="fas fa-sign-out-alt me-1"></i>Logout
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Phần Hero -->
        <div class="banner-container">
            <div class="banner-slide" id="slide">
                <div class="slide-item">
                    <img src="./hinh/OIP.jpg" alt="Ảnh 1">
                    <div class="caption">Welcome to the Online Library</div>
                </div>
                <div class="slide-item">
                    <img src="./hinh/R.jpg" alt="Ảnh 2">
                    <div class="caption">Explore thousands of books and expand your knowledge</div>
                </div>
                <div class="slide-item">
                    <img src="./hinh/1.jpg" alt="Ảnh 3">
                    <div class="caption">Every book is a door – an online library that opens up the world for you.</div>
                </div>
                <div class="slide-item">
                    <img src="./hinh/4.jpg" alt="Ảnh 4">
                    <div class="caption">Every book is a door – an online library that opens up the world for you.</div>
                </div>
            </div>
        </div>

        <!-- Phần tìm kiếm -->
        <section class="search-section">
            <div class="container">
                <form action="${pageContext.request.contextPath}/search" method="GET" class="row justify-content-center">
                    <div class="col-md-3 mb-3">
                        <input type="text" name="title" class="form-control" placeholder="Title">
                    </div>
                    <div class="col-md-3 mb-3">
                        <input type="text" name="author" class="form-control" placeholder="Author">
                    </div>
                    <div class="col-md-3 mb-3">
                        <select name="category" class="form-select">
                            <option value="">All category</option>
                            <c:forEach items="${categories}" var="category">
                                <option value="${category}" ${param.category eq category ? 'selected' : ''}>${category}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2 mb-3">
                        <button type="submit" class="btn btn-primary w-100 btn-search">
                            <i class="fas fa-search me-2"></i>Find
                        </button>
                    </div>
                </form>
            </div>
        </section>

        <!-- Sách mới -->
        <section class="new-books">
            <div class="container">
                <h2 class="section-title text-center">NEW BOOKS</h2>
                <div class="row">
                    <c:forEach items="${newBooks}" var="book">
                        <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                            <div class="book-card card">
                                <img src="https://via.placeholder.com/300x400?text=${book.title}&bg=1ABC9C&color=FFFFFF" 
                                     class="card-img-top" alt="${book.title}">
                                <div class="card-body">
                                    <h5 class="card-title">${book.title}</h5>
                                    <p class="card-text">
                                        <small class="text-muted">
                                            <i class="fas fa-user me-1"></i>Author: ${book.author}
                                        </small>
                                    </p>
                                    <p class="card-text">
                                        <span class="badge bg-primary me-2">${book.category}</span>
                                        <c:if test="${book.availableCopies > 0}">
                                            <span class="badge bg-success">
                                                <i class="fas fa-check me-1"></i>Still have books
                                            </span>
                                        </c:if>
                                        <c:if test="${book.availableCopies == 0}">
                                            <span class="badge bg-danger">
                                                <i class="fas fa-times me-1"></i>Out of book
                                            </span>
                                        </c:if>
                                    </p>
                                    <p class="card-text">
                                        <small class="text-muted">
                                            <i class="fas fa-book me-1"></i>Available: ${book.availableCopies}/${book.totalCopies}
                                        </small>
                                    </p>
                                    <div class="d-grid gap-2">
                                        <a href="${pageContext.request.contextPath}/bookdetail?id=${book.id}" 
                                           class="btn btn-primary">
                                            <i class="fas fa-eye me-2"></i>See details
                                        </a>
                                        <c:if test="${not empty sessionScope.loginedUser && book.availableCopies > 0}">
                                            <button onclick="addToCart(${book.id})" class="btn btn-outline-primary">
                                                <i class="fas fa-cart-plus me-2"></i>Add to cart
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </section>

        <c:if test="${not empty recommendedBooks}">
            <section class="new-books"> 
                <div class="container">
                    <h2 class="section-title text-center">
                        RECOMMEND BOOKS
                    </h2>
                    <div class="row">
                        <c:forEach items="${recommendedBooks}" var="book">
                            <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                                <div class="book-card card"> <!-- Sử dụng cùng class với sách mới -->
                                    <img src="https://via.placeholder.com/300x400?text=${book.title}&bg=16A085&color=FFFFFF" 
                                         class="card-img-top" alt="${book.title}">
                                    <div class="card-body">
                                        <h5 class="card-title">${book.title}</h5>
                                        <p class="card-text">
                                            <small class="text-muted">
                                                <i class="fas fa-user me-1"></i>Author: ${book.author}
                                            </small>
                                        </p>
                                        <p class="card-text">
                                            <span class="badge bg-primary me-2">${book.category}</span>
                                            <c:if test="${book.availableCopies > 0}">
                                                <span class="badge bg-success">
                                                    <i class="fas fa-check me-1"></i>Still have books
                                                </span>
                                            </c:if>
                                            <c:if test="${book.availableCopies == 0}">
                                                <span class="badge bg-danger">
                                                    <i class="fas fa-times me-1"></i>Out of book
                                                </span>
                                            </c:if>
                                        </p>
                                        <div class="d-grid gap-2">
                                            <a href="${pageContext.request.contextPath}/bookdetail?id=${book.id}" 
                                               class="btn btn-primary">
                                                <i class="fas fa-eye me-2"></i>See details
                                            </a>
                                            <c:if test="${not empty sessionScope.loginedUser && book.availableCopies > 0}">
                                                <button onclick="addToCart(${book.id})" class="btn btn-outline-primary">
                                                    <i class="fas fa-cart-plus me-2"></i>Add to cart
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                <!-- Button mở chat -->
                <div id="chat-icon" onclick="toggleChat()" style="
                     position: fixed; bottom: 20px; right: 20px;
                     background-color: #ff5722; color: white;
                     padding: 10px 15px; border-radius: 50px;
                     cursor: pointer; z-index: 1000;
                     ">
                    💬 Chat
                </div>

                <!-- Khung chat box -->
                <div id="chat-box" style="
                     position: fixed; bottom: 80px; right: 20px;
                     width: 300px; background: white; border: 1px solid #ccc;
                     border-radius: 10px; padding: 10px; display: none; z-index: 1000;
                     box-shadow: 0 0 10px rgba(0,0,0,0.2);
                     ">
                    <h5>Send Message to Admin</h5>
                    <form method="post" action="SendMessageServlet">
                        <input type="text" name="subject" placeholder="Tiêu đề" required style="width: 100%; margin-bottom: 5px;"><br>
                        <textarea name="message" placeholder="Nội dung" rows="3" required style="width: 100%;"></textarea><br>
                        <button type="submit" style="margin-top: 5px;">Send</button>
                    </form>
                </div>

            </section>
        </c:if>
        <!-- Footer -->
        <footer class="footer text-white pt-4 pb-3 mt-5" style="background-color: #2F4256; height: 100px; display: flex; flex-direction: column; justify-content: center; align-items: center;">
            <div class="container text-center" style="padding-top: 30px">
                <p class="mb-1">&copy; 2025 Group 7 - Library Management System</p>
                <p class="mb-1">vdtuan245@gmail.com</p>
                <div class="social-icons mt-2">
                    <a href="#" class="text-white me-3"><i class="bi bi-facebook"></i></a>
                    <a href="#" class="text-white me-3"><i class="bi bi-envelope-fill"></i></a>
                    <a href="#" class="text-white me-3"><i class="bi bi-github"></i></a>
                </div>
            </div>
        </footer>





        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                    let currentSlide = 0;
                    const totalSlides = 4;
                    const slide = document.getElementById('slide');
                    const indicators = document.querySelectorAll('.indicator');
                    let autoSlideInterval;

                    function updateSlide() {
                        // Move slide
                        slide.style.transform = `translateX(-${currentSlide * 25}%)`;

                        // Update indicators
                        indicators.forEach((indicator, index) => {
                            indicator.classList.toggle('active', index === currentSlide);
                        });
                    }

                    function changeSlide(direction) {
                        currentSlide = (currentSlide + direction + totalSlides) % totalSlides;
                        updateSlide();
                        resetAutoSlide();
                    }

                    function goToSlide(index) {
                        currentSlide = index;
                        updateSlide();
                        resetAutoSlide();
                    }

                    function nextSlide() {
                        currentSlide = (currentSlide + 1) % totalSlides;
                        updateSlide();
                    }

                    function startAutoSlide() {
                        autoSlideInterval = setInterval(nextSlide, 4000);
                    }

                    function resetAutoSlide() {
                        clearInterval(autoSlideInterval);
                        startAutoSlide();
                    }

                    // Start auto slide when page loads
                    document.addEventListener('DOMContentLoaded', function () {
                        startAutoSlide();
                    });

                    // Pause auto slide when hovering
                    const bannerContainer = document.querySelector('.banner-container');
                    bannerContainer.addEventListener('mouseenter', () => {
                        clearInterval(autoSlideInterval);
                    });

                    bannerContainer.addEventListener('mouseleave', () => {
                        startAutoSlide();
                    });
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
                                <i class="fas fa-check-circle me-2"></i>Book added to cart successfully!
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
                    function toggleChat() {
                    var chatBox = document.getElementById("chat-box");
                    if (chatBox.style.display === "none") {
                    chatBox.style.display = "block";
                    } else {
                        chatBox.style.display = "none";
                    }
                }
        </script>
    </body>
</html>