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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user-view-detail.css"/>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="header-icon">
                <i class="fas fa-book-open"></i>
            </div>
            <h1 class="header-title">Book Detail</h1>
            <p class="header-subtitle">Detailed information about the book you are looking for:</p>
        </div>

        <% Book book = (Book) request.getAttribute("book"); %>
        <% String error = (String) request.getAttribute("error"); %>

        <% if (error != null && !error.trim().isEmpty()) { %>
        <div class="error-message">
            <strong>Lỗi:</strong> <%= error %>
        </div>
        <% } else if (book != null) { %>
        <div class="book-card">
            <h2 class="book-title"><%= book.getTitle() != null ? book.getTitle() : "Title not found" %></h2>
            <p><strong>Author: </strong> <%= book.getAuthor() != null ? book.getAuthor() : "Noone" %></p>

            <div class="book-detail">
                <div class="detail-item">
                    <div class="detail-label">Category</div>
                    <div class="detail-value"><%= book.getCategory() != null ? book.getCategory() : "Uncategorized" %></div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Published Year</div>
                    <div class="detail-value"><%= book.getPublishedYear() > 0 ? book.getPublishedYear() : "N/A" %></div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Total Book</div>
                    <div class="detail-value"><%= book.getTotalCopies() %> books</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Borrowed</div>
                    <div class="detail-value"><%= book.getTotalCopies() - book.getAvailableCopies() %> books</div>
                </div>
            </div>
            <!-- 
                <div class="availability">
                <div class="availability-count"><%= book.getAvailableCopies() %></div>
                <p>Số lượng còn lại</p>
                <%// if (book.getAvailableCopies() == 0) { %>
                    <span class="status-badge status-unavailable">Hết sách</span>
                <%// } else if (book.getAvailableCopies() <= 2) { %>
                    <span class="status-badge status-limited">Sắp hết</span>
                <%// } else { %>
                    <span class="status-badge status-available">Còn nhiều</span>
                <%// } %>
                </div> 
            -->
            

            <div class="book-actions">
                <a href="${pageContext.request.contextPath}/search" class="btn btn-primary">
                    <i class="fas fa-arrow-left"></i> Back home.
                </a>
                <c:if test="${book.availableCopies > 0}">
                    <a href="AddToCartServlet?bookId=${book.id}" class="btn btn-primary">
                        <i class="fas fa-hand-holding-heart"></i>Add to Cart.
                    </a>
                </c:if>
                <c:if test="${book.availableCopies == 0}">
                    <button class="btn" disabled>
                        <i class="fas fa-clock"></i>Not Available.
                    </button>
                </c:if>
            </div>
        </div>
        <% } else { %>
        <div class="book-card">
            <p>Not found Book's detail.</p>
            <a href="${pageContext.request.contextPath}/home" class="back-button">
                <i class="fas fa-arrow-left"></i> Back home.
            </a>
        </div>
        <% } %>
    </div>
</body>
</html>