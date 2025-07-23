<%-- 
    Document   : bookdetail
    Created on : May 31, 2025, 10:28:02 AM
    Author     : CAU_TU
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="entity.Book" %>
<%@ page import="java.util.List" %>
<%@ page import="util.ImageDisplayHelper" %>
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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user-view-detail.css"/>
<!--        <style>
            
        </style>-->
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
                        <img src="<%= ImageDisplayHelper.getBookImageUrl((entity.Book) request.getAttribute("book")) %>" alt="${book.title}" 
                             style="max-width: 300px; max-height: 700px; object-fit: contain; border-radius: 10px; margin-bottom: 5px">
                        
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