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

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết sách - Thư viện Sách</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user-view-detail.css"/>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="header-icon">
                <i class="fas fa-book-open"></i>
            </div>
            <h1 class="header-title">Chi tiết sách</h1>
            <p class="header-subtitle">Thông tin chi tiết về cuốn sách</p>
        </div>

        <% Book book = (Book) request.getAttribute("book"); %>
        <% String error = (String) request.getAttribute("error"); %>

        <% if (error != null && !error.trim().isEmpty()) { %>
        <div class="error-message">
            <strong>Lỗi:</strong> <%= error %>
        </div>
        <% } else if (book != null) { %>
        <div class="book-card">
            <h2 class="book-title"><%= book.getTitle() != null ? book.getTitle() : "Không có tiêu đề" %></h2>
            <p><strong>Tác giả:</strong> <%= book.getAuthor() != null ? book.getAuthor() : "Không rõ" %></p>

            <div class="book-detail">
                <div class="detail-item">
                    <div class="detail-label">Danh mục</div>
                    <div class="detail-value"><%= book.getCategory() != null ? book.getCategory() : "Chưa phân loại" %></div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Năm xuất bản</div>
                    <div class="detail-value"><%= book.getPublishedYear() > 0 ? book.getPublishedYear() : "N/A" %></div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Tổng số</div>
                    <div class="detail-value"><%= book.getTotalCopies() %> cuốn</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Đã mượn</div>
                    <div class="detail-value"><%= book.getTotalCopies() - book.getAvailableCopies() %> cuốn</div>
                </div>
            </div>

            <div class="availability">
                <div class="availability-count"><%= book.getAvailableCopies() %></div>
                <p>Số lượng còn lại</p>
                <% if (book.getAvailableCopies() == 0) { %>
                    <span class="status-badge status-unavailable">Hết sách</span>
                <% } else if (book.getAvailableCopies() <= 2) { %>
                    <span class="status-badge status-limited">Sắp hết</span>
                <% } else { %>
                    <span class="status-badge status-available">Còn nhiều</span>
                <% } %>
            </div>

            <div class="book-actions">
                <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
                <% if (book.getAvailableCopies() > 0) { %>
                <a href="borrow?id=<%= book.getId() %>" class="btn btn-primary">
                    <i class="fas fa-hand-holding-heart"></i> Mượn sách
                </a>
                <% } else { %>
                <button class="btn" disabled>
                    <i class="fas fa-clock"></i> Hết sách
                </button>
                <% } %>
            </div>
        </div>
        <% } else { %>
        <div class="book-card">
            <p>Không tìm thấy thông tin sách.</p>
            <a href="${pageContext.request.contextPath}/home" class="back-button">
                <i class="fas fa-arrow-left"></i> Quay lại
            </a>
        </div>
        <% } %>
    </div>
</body>
</html>