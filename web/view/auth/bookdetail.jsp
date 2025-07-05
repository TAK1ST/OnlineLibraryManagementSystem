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
        <title>Book Detail</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                color: #333;
                line-height: 1.6;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }

            /* Header Styles */
            .header {
                text-align: center;
                margin-bottom: 40px;
                background: rgba(255, 255, 255, 0.1);
                backdrop-filter: blur(10px);
                border-radius: 20px;
                padding: 30px;
                border: 1px solid rgba(255, 255, 255, 0.2);
            }

            .header-icon {
                font-size: 3rem;
                color: #fff;
                margin-bottom: 15px;
            }

            .header-title {
                font-size: 2.5rem;
                color: #fff;
                margin-bottom: 10px;
                font-weight: 700;
            }

            .header-subtitle {
                font-size: 1.1rem;
                color: rgba(255, 255, 255, 0.8);
                font-weight: 300;
            }

            /* Error Message */
            .error-message {
                background: linear-gradient(135deg, #ff6b6b, #ee5a24);
                color: white;
                padding: 20px;
                border-radius: 15px;
                margin-bottom: 30px;
                text-align: center;
                font-size: 1.1rem;
                box-shadow: 0 8px 32px rgba(255, 107, 107, 0.3);
            }

            /* Book Card */
            .book-card {
                background: rgba(255, 255, 255, 0.95);
                border-radius: 25px;
                padding: 40px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.3);
            }

            .book-title {
                font-size: 2.2rem;
                color: #2c3e50;
                margin-bottom: 15px;
                font-weight: 700;
                text-align: center;
                padding-bottom: 15px;
                border-bottom: 3px solid #3498db;
            }

            .book-author {
                font-size: 1.3rem;
                color: #7f8c8d;
                text-align: center;
                margin-bottom: 30px;
                font-style: italic;
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
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
                margin-bottom: 20px;
            }

            .availability-section {
                background: linear-gradient(135deg, #74b9ff, #0984e3);
                color: white;
                padding: 20px;
                border-radius: 15px;
                text-align: center;
                width: 100%;
                max-width: 300px;
            }

            .availability-count {
                font-size: 3rem;
                font-weight: 700;
                margin-bottom: 10px;
            }

            .availability-text {
                font-size: 1.1rem;
                margin-bottom: 15px;
            }

            .status-badge {
                display: inline-block;
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 0.9rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .status-available {
                background: #00b894;
                color: white;
            }

            .status-limited {
                background: #fdcb6e;
                color: #2d3436;
            }

            .status-unavailable {
                background: #e17055;
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
                padding: 15px;
                background: #f8f9fa;
                border-radius: 10px;
                border-left: 4px solid #3498db;
                transition: all 0.3s ease;
            }

            .detail-item:hover {
                background: #e9ecef;
                transform: translateX(5px);
            }

            .detail-label {
                font-weight: 600;
                color: #2c3e50;
                min-width: 140px;
                display: flex;
                align-items: center;
            }

            .detail-label i {
                margin-right: 10px;
                color: #3498db;
                width: 20px;
            }

            .detail-value {
                color: #34495e;
                font-weight: 500;
                flex: 1;
            }

            /* Action Buttons */
            .book-actions {
                display: flex;
                gap: 15px;
                justify-content: center;
                margin-top: 30px;
                flex-wrap: wrap;
            }

            .btn {
                display: inline-flex;
                align-items: center;
                padding: 12px 24px;
                border: none;
                border-radius: 25px;
                font-size: 1rem;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.3s ease;
                cursor: pointer;
                min-width: 160px;
                justify-content: center;
            }

            .btn i {
                margin-right: 8px;
            }

            .btn-primary {
                background: linear-gradient(135deg, #667eea, #764ba2);
                color: white;
            }

            .btn-primary:hover {
                background: linear-gradient(135deg, #5a6fd8, #6a4190);
                transform: translateY(-2px);
                box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
            }

            .btn-secondary {
                background: linear-gradient(135deg, #fd79a8, #e84393);
                color: white;
            }

            .btn-secondary:hover {
                background: linear-gradient(135deg, #fd6c9e, #e03e8a);
                transform: translateY(-2px);
                box-shadow: 0 10px 25px rgba(253, 121, 168, 0.4);
            }

            .btn:disabled {
                background: #bdc3c7;
                color: #7f8c8d;
                cursor: not-allowed;
                transform: none;
            }

            .btn:disabled:hover {
                transform: none;
                box-shadow: none;
            }

            /* No Book Found */
            .no-book {
                text-align: center;
                color: #7f8c8d;
                font-size: 1.3rem;
                margin-bottom: 30px;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .container {
                    padding: 15px;
                }

                .header {
                    padding: 20px;
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
            }
        </style>
    </head>
    <body>
        <div class="container">
            <!-- Header Section -->
            <div class="header">
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
                <i class="fas fa-exclamation-triangle"></i>
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
                                Total Book
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
                        <i class="fas fa-arrow-left"></i> Back
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
                    <i class="fas fa-search" style="font-size: 3rem; margin-bottom: 20px; color: #bdc3c7;"></i>
                    <p>Book details not found.</p>
                </div>
                <div class="book-actions">
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
                        <i class="fas fa-home"></i> Back home
                    </a>
                </div>
            </div>
            <% } %>
        </div>
    </body>
</html>