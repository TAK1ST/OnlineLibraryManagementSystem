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
    <title>Chi tiết sách - Thư viện Sách</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #ECF0F1 0%, #34495E 100%);
            min-height: 100vh;
            padding: 20px;
            color: #2C3E50;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            animation: fadeIn 0.6s ease-out;
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
        }

        .header-icon {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, #1ABC9C, #16A085);
            border-radius: 50%;
            margin: 0 auto 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 28px;
        }

        .header-title {
            font-size: 2rem;
            font-weight: 700;
            color: #2C3E50;
            margin-bottom: 5px;
        }

        .header-subtitle {
            font-size: 0.9rem;
            color: #34495E;
            opacity: 0.8;
        }

        .book-card {
            background: #FFFFFF;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            border: 1px solid #ECF0F1;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .book-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }

        .book-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #2C3E50;
            margin-bottom: 10px;
        }

        .book-detail {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 20px;
        }

        .detail-item {
            background: #F9FAFB;
            padding: 12px;
            border-radius: 8px;
            text-align: center;
        }

        .detail-label {
            font-size: 0.75rem;
            color: #34495E;
            text-transform: uppercase;
            font-weight: 500;
            margin-bottom: 5px;
        }

        .detail-value {
            font-size: 1rem;
            color: #2C3E50;
            font-weight: 500;
        }

        .availability {
            background: linear-gradient(135deg, #1ABC9C, #16A085);
            color: white;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 20px;
        }

        .availability-count {
            font-size: 1.8rem;
            font-weight: 700;
        }

        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 600;
            margin-top: 10px;
        }

        .status-available { background: #1ABC9C; }
        .status-limited { background: #F39C12; }
        .status-unavailable { background: #E74C3C; }

        .book-actions {
            display: flex;
            gap: 10px;
        }

        .btn {
            flex: 1;
            padding: 10px;
            border: none;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.3s ease, background 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(135deg, #1ABC9C, #16A085);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            background: linear-gradient(135deg, #16A085, #1ABC9C);
        }

        .btn:disabled {
            background: #BDC3C7;
            cursor: not-allowed;
        }

        .error-message {
            background: #E74C3C;
            color: white;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 20px;
        }

        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            background: #34495E;
            color: white;
            padding: 8px 15px;
            border-radius: 8px;
            text-decoration: none;
            transition: transform 0.3s ease;
        }

        .back-button:hover {
            transform: translateX(-2px);
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @media (max-width: 768px) {
            .container {
                padding: 15px;
            }
            .book-detail {
                grid-template-columns: 1fr;
            }
            .book-actions {
                flex-direction: column;
            }
        }
    </style>
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
                <c:if test="${book.availableCopies > 0}">
                    <a href="AddToCartServlet?bookId=${book.id}" class="btn btn-primary">
                        <i class="fas fa-hand-holding-heart"></i>Add to Cart
                    </a>
                </c:if>
                <c:if test="${book.availableCopies == 0}">
                    <button class="btn" disabled>
                        <i class="fas fa-clock"></i>Not Available
                    </button>
                </c:if>
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