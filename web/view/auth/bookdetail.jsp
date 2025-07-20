<%-- 
    Document   : bookdetail
    Created on : May 31, 2025, 10:28:02 AM
    Author     : CAU_TU
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="entity.Book" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Book Detail - Online Library</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --primary-dark: #2C3E50;
                --primary-light: #34495E;
                --accent-light: #1ABC9C;
                --accent-dark: #16A085;
                --light-bg: #ECF0F1;
                --white: #ffffff;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: var(--light-bg);
                min-height: 100vh;
                color: #333;
                line-height: 1.6;
            }

            /* Navbar styles - giống search.jsp */
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

            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }

            /* Header Styles */
            .page-header {
                text-align: center;
                margin: 40px 0;
                background: linear-gradient(135deg, var(--accent-light) 0%, var(--accent-dark) 100%);
                backdrop-filter: blur(10px);
                border-radius: 20px;
                padding: 40px 30px;
                color: white;
                box-shadow: 0 10px 30px rgba(26, 188, 156, 0.3);
            }

            .header-icon {
                font-size: 3rem;
                color: #fff;
                margin-bottom: 15px;
                text-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            }

            .header-title {
                font-size: 2.5rem;
                color: #fff;
                margin-bottom: 10px;
                font-weight: 700;
                text-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            }

            .header-subtitle {
                font-size: 1.1rem;
                color: rgba(255, 255, 255, 0.9);
                font-weight: 300;
            }

            /* Error Message */
            .error-message {
                background: linear-gradient(135deg, #e74c3c, #c0392b);
                color: white;
                padding: 20px;
                border-radius: 15px;
                margin-bottom: 30px;
                text-align: center;
                font-size: 1.1rem;
                box-shadow: 0 8px 32px rgba(231, 76, 60, 0.3);
            }

            /* Book Card */
            .book-card {
                background: var(--white);
                border-radius: 25px;
                padding: 40px;
                box-shadow: 0 20px 60px rgba(44, 62, 80, 0.1);
                border: 1px solid rgba(26, 188, 156, 0.1);
            }

            .book-title {
                font-size: 2.2rem;
                color: var(--primary-dark);
                margin-bottom: 15px;
                font-weight: 700;
                text-align: center;
                padding-bottom: 15px;
                border-bottom: 3px solid var(--accent-light);
                position: relative;
            }

            .book-title::after {
                content: '';
                position: absolute;
                bottom: -3px;
                left: 50%;
                transform: translateX(-50%);
                width: 60px;
                height: 3px;
                background: var(--accent-dark);
                border-radius: 2px;
            }

            .book-author {
                font-size: 1.3rem;
                color: var(--primary-light);
                text-align: center;
                margin-bottom: 30px;
                font-style: italic;
            }

            .book-author i {
                color: var(--accent-light);
                margin-right: 8px;
            }

            /* Book Content Layout */
            .book-content {
                display: grid;
                grid-template-columns: 1fr 2fr;
                gap: 40px;
                margin-bottom: 40px;
            }

            .book-image-section {
                display: flex;
                flex-direction: column;
                align-items: center;
            }

            .book-image {
                width: 100%;
                max-width: 300px;
                height: 400px;
                object-fit: cover;
                border-radius: 15px;
                box-shadow: 0 15px 35px rgba(44, 62, 80, 0.15);
                margin-bottom: 20px;
                border: 3px solid rgba(26, 188, 156, 0.1);
                transition: transform 0.3s ease;
            }

            .book-image:hover {
                transform: scale(1.02);
            }

            .availability-section {
                background: linear-gradient(135deg, var(--accent-light), var(--accent-dark));
                color: white;
                padding: 25px 20px;
                border-radius: 20px;
                text-align: center;
                width: 100%;
                max-width: 300px;
                box-shadow: 0 10px 30px rgba(26, 188, 156, 0.3);
            }

            .availability-count {
                font-size: 3rem;
                font-weight: 700;
                margin-bottom: 10px;
                text-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            }

            .availability-text {
                font-size: 1.1rem;
                margin-bottom: 15px;
                font-weight: 500;
            }

            .status-badge {
                display: inline-block;
                padding: 10px 18px;
                border-radius: 25px;
                font-size: 0.9rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }

            .status-available {
                background: linear-gradient(135deg, #27ae60, #2ecc71);
                color: white;
            }

            .status-limited {
                background: linear-gradient(135deg, #f39c12, #e67e22);
                color: white;
            }

            .status-unavailable {
                background: linear-gradient(135deg, #e74c3c, #c0392b);
                color: white;
            }

            /* Book Details */
            .book-details {
                display: grid;
                gap: 20px;
            }

            .detail-item {
                display: flex;
                align-items: center;
                padding: 20px;
                background: var(--white);
                border-radius: 15px;
                border-left: 4px solid var(--accent-light);
                transition: all 0.3s ease;
                box-shadow: 0 5px 15px rgba(44, 62, 80, 0.08);
            }

            .detail-item:hover {
                background: var(--light-bg);
                transform: translateX(8px);
                box-shadow: 0 8px 25px rgba(26, 188, 156, 0.15);
                border-left-color: var(--accent-dark);
            }

            .detail-label {
                font-weight: 600;
                color: var(--primary-dark);
                min-width: 140px;
                display: flex;
                align-items: center;
            }

            .detail-label i {
                margin-right: 12px;
                color: var(--accent-light);
                width: 20px;
                font-size: 1.1rem;
            }

            .detail-value {
                color: var(--primary-light);
                font-weight: 500;
                flex: 1;
                font-size: 1rem;
                text-align: center;
            }

            /* Action Buttons */
            .book-actions {
                display: flex;
                gap: 15px;
                justify-content: center;
                margin-top: 40px;
                flex-wrap: wrap;
            }

            .btn {
                display: inline-flex;
                align-items: center;
                padding: 14px 28px;
                border: none;
                border-radius: 25px;
                font-size: 1rem;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.3s ease;
                cursor: pointer;
                min-width: 180px;
                justify-content: center;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            }

            .btn i {
                margin-right: 10px;
                font-size: 1.1rem;
            }

            .btn-primary {
                background: linear-gradient(135deg, var(--primary-dark), var(--primary-light));
                color: white;
            }

            .btn-primary:hover {
                background: linear-gradient(135deg, var(--primary-light), var(--accent-dark));
                transform: translateY(-3px);
                box-shadow: 0 12px 30px rgba(44, 62, 80, 0.4);
                color: white;
            }

            .btn-secondary {
                background: linear-gradient(135deg, var(--accent-light), var(--accent-dark));
                color: white;
            }

            .btn-secondary:hover {
                background: linear-gradient(135deg, var(--accent-dark), var(--primary-light));
                transform: translateY(-3px);
                box-shadow: 0 12px 30px rgba(26, 188, 156, 0.4);
                color: white;
            }

            .btn:disabled {
                background: #bdc3c7 !important;
                color: #7f8c8d !important;
                cursor: not-allowed !important;
                transform: none !important;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1) !important;
            }

            .btn:disabled:hover {
                transform: none !important;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1) !important;
            }

            /* No Book Found */
            .no-book {
                text-align: center;
                color: var(--primary-light);
                font-size: 1.3rem;
                margin-bottom: 30px;
                padding: 40px 20px;
            }

            .no-book i {
                font-size: 4rem;
                color: var(--accent-light);
                margin-bottom: 20px;
            }

            /* Footer */
            .footer {
                background: linear-gradient(135deg, var(--primary-dark), var(--primary-light)) !important;
                margin-top: 60px;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .container {
                    padding: 15px;
                }

                .page-header {
                    padding: 30px 20px;
                    margin: 20px 0;
                }

                .header-title {
                    font-size: 2rem;
                }

                .book-content {
                    grid-template-columns: 1fr;
                    gap: 30px;
                }

                .book-title {
                    font-size: 1.8rem;
                }

                .book-actions {
                    flex-direction: column;
                    align-items: center;
                }

                .btn {
                    width: 100%;
                    max-width: 300px;
                }

                .detail-item {
                    padding: 15px;
                }

                .detail-label {
                    min-width: 120px;
                    font-size: 0.9rem;
                }
            }

            /* Animation effects */
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .book-card {
                animation: fadeInUp 0.6s ease-out;
            }

            .detail-item {
                animation: fadeInUp 0.6s ease-out;
            }

            .detail-item:nth-child(1) { animation-delay: 0.1s; }
            .detail-item:nth-child(2) { animation-delay: 0.2s; }
            .detail-item:nth-child(3) { animation-delay: 0.3s; }
            .detail-item:nth-child(4) { animation-delay: 0.4s; }
        </style>
    </head>
    <body>
        <!-- Thanh điều hướng - giống search.jsp -->
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
                                    <i class="fas fa-sign-in-alt me-1"></i>Log in
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
                                    <i class="fas fa-sign-out-alt me-1"></i>Log out
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container">
            <!-- Header Section -->
            <div class="page-header">
                <div class="header-icon">
                    <i class="fas fa-book-open"></i>
                </div>
                <h1 class="header-title">Book Detail</h1>
                <p class="header-subtitle">Detailed information about the book you are looking for.</p>
            </div>

            <% Book book = (Book) request.getAttribute("book"); %>
            <% String error = (String) request.getAttribute("error"); %>

            <!-- Error Message -->
            <% if (error != null && !error.trim().isEmpty()) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <strong>Error:</strong> <%= error %>
            </div>
            <% } else if (book != null) { %>
            
            <!-- Book Card -->
            <div class="book-card">
                <!-- Book Title & Author -->
                <h2 class="book-title">
                    <%= book.getTitle() != null ? book.getTitle() : "Title Unknown" %>
                </h2>
                <p class="book-author">
                    <i class="fas fa-user-edit"></i>
                    Author: <%= book.getAuthor() != null ? book.getAuthor() : "Unknown" %>
                </p>

                <!-- Book Content -->
                <div class="book-content">
                    <!-- Image & Availability Section -->
                    <div class="book-image-section">
                        <img src="hinh/book.jpg" alt="The book image could not be loaded" class="book-image">
                        
                        <div class="availability-section">
                            <div class="availability-count"><%= book.getAvailableCopies() %></div>
                            <p class="availability-text">Remaining quantity</p>
                            <% if (book.getAvailableCopies() == 0) { %>
                            <span class="status-badge status-unavailable">No books available</span>
                            <% } else if (book.getAvailableCopies() <= 2) { %>
                            <span class="status-badge status-limited">Running low</span>
                            <% } else { %>
                            <span class="status-badge status-available">Sufficient quantity</span>
                            <% } %>
                        </div>
                    </div>

                    <!-- Book Details Section -->
                    <div class="book-details">
                        <div class="detail-item">
                            <div class="detail-label">
                                <i class="fas fa-tags"></i>
                                Category
                            </div>
                            <div class="detail-value">
                                <%= book.getCategory() != null ? book.getCategory() : "Uncategorized" %>
                            </div>
                        </div>

                        <div class="detail-item">
                            <div class="detail-label">
                                <i class="fas fa-calendar-alt"></i>
                                Published Year
                            </div>
                            <div class="detail-value">
                                <%= book.getPublishedYear() > 0 ? book.getPublishedYear() : "Unknown" %>
                            </div>
                        </div>

                        <div class="detail-item">
                            <div class="detail-label">
                                <i class="fas fa-book"></i>
                                Total Books
                            </div>
                            <div class="detail-value">
                                <%= book.getTotalCopies() %> books
                            </div>
                        </div>

                        <div class="detail-item">
                            <div class="detail-label">
                                <i class="fas fa-hand-holding"></i>
                                Borrowed
                            </div>
                            <div class="detail-value">
                                <%= book.getTotalCopies() - book.getAvailableCopies() %> books
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="book-actions">
                    <a href="${pageContext.request.contextPath}/search" class="btn btn-primary">
                        <i class="fas fa-arrow-left"></i> Back to Search
                    </a>
                    <c:if test="${book.availableCopies > 0}">
                        <a href="AddToCartServlet?bookId=${book.id}" class="btn btn-secondary">
                            <i class="fas fa-shopping-cart"></i> Add to Your Cart
                        </a>
                    </c:if>
                    <c:if test="${book.availableCopies == 0}">
                        <button class="btn" disabled>
                            <i class="fas fa-ban"></i> Not Available
                        </button>
                    </c:if>
                </div>
            </div>
            
            <% } else { %>
            <!-- No Book Found -->
            <div class="book-card">
                <div class="no-book">
                    <i class="fas fa-search"></i>
                    <p>Book details not found.</p>
                </div>
                <div class="book-actions">
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
                        <i class="fas fa-home"></i> Back to Home
                    </a>
                </div>
            </div>
            <% } %>
        </div>

        <!-- Footer -->
        <footer class="footer text-white pt-4 pb-3 mt-5" style="height: 100px; display: flex; flex-direction: column; justify-content: center; align-items: center;">
            <div class="container text-center" style="padding-top: 30px">
                <p class="mb-1">&copy; 2025 Group 7 - Library Management System</p>
                <p class="mb-1">vdtuan245@gmail.com</p>
                <div class="social-icons mt-2">
                    <a href="#" class="text-white me-3"><i class="fab fa-facebook"></i></a>
                    <a href="#" class="text-white me-3"><i class="fas fa-envelope"></i></a>
                    <a href="#" class="text-white me-3"><i class="fab fa-github"></i></a>
                </div>
            </div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>