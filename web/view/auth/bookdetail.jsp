<%-- 
    Document   : bookdetail
    Created on : May 31, 2025, 10:28:02 AM
    Author     : CAU_TU
--%>

<%-- 
    Document   : booklist
    Created on : June 4, 2025
    Author     : CAU_TU
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="entity.Book" %>
<%@ page import="java.util.List" %>
<%
    List<Book> books = (List<Book>) request.getAttribute("books");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Danh sách sách - Library Management</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #2C3E50 0%, #34495E 50%, #1ABC9C 100%);
                min-height: 100vh;
                padding: 20px;
                position: relative;
                overflow-x: hidden;
            }

            body::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="books" x="0" y="0" width="20" height="20" patternUnits="userSpaceOnUse"><rect width="3" height="15" x="2" y="2" fill="rgba(255,255,255,0.03)"/><rect width="3" height="12" x="6" y="5" fill="rgba(255,255,255,0.02)"/><rect width="3" height="18" x="10" y="1" fill="rgba(255,255,255,0.04)"/></pattern></defs><rect width="100" height="100" fill="url(%23books)"/></svg>');
                pointer-events: none;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                position: relative;
                z-index: 1;
            }

            .header {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                border-radius: 25px;
                padding: 40px;
                text-align: center;
                margin-bottom: 30px;
                box-shadow: 0 25px 60px rgba(0, 0, 0, 0.3);
                animation: fadeInDown 0.8s ease-out;
            }

            .header-icon {
                width: 80px;
                height: 80px;
                background: linear-gradient(135deg, #1ABC9C, #16A085);
                border-radius: 50%;
                margin: 0 auto 20px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 30px;
                color: white;
                box-shadow: 0 10px 30px rgba(26, 188, 156, 0.3);
            }

            .header-title {
                font-size: 36px;
                font-weight: 700;
                color: #2C3E50;
                margin-bottom: 10px;
            }

            .header-subtitle {
                font-size: 16px;
                color: #34495E;
                opacity: 0.8;
            }

            .books-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
                gap: 25px;
                margin-bottom: 40px;
            }

            .book-card {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                border-radius: 20px;
                overflow: hidden;
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
                transition: all 0.3s ease;
                animation: fadeInUp 0.6s ease-out;
                animation-fill-mode: both;
                position: relative;
            }

            .book-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
            }

            .book-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 5px;
                background: linear-gradient(135deg, #1ABC9C, #16A085);
            }

            .book-header {
                padding: 25px;
                text-align: center;
                background: linear-gradient(135deg, rgba(26, 188, 156, 0.1), rgba(22, 160, 133, 0.05));
            }

            .book-icon {
                width: 60px;
                height: 60px;
                background: linear-gradient(135deg, #1ABC9C, #16A085);
                border-radius: 12px;
                margin: 0 auto 15px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24px;
                color: white;
            }

            .book-title {
                font-size: 20px;
                font-weight: 600;
                color: #2C3E50;
                margin-bottom: 8px;
                line-height: 1.3;
                height: 52px;
                overflow: hidden;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
            }

            .book-author {
                font-size: 14px;
                color: #1ABC9C;
                font-weight: 500;
            }

            .book-content {
                padding: 20px 25px;
            }

            .book-details {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px;
                margin-bottom: 20px;
            }

            .detail-item {
                background: #F8F9FA;
                border-radius: 10px;
                padding: 12px;
                text-align: center;
            }

            .detail-label {
                font-size: 11px;
                color: #34495E;
                text-transform: uppercase;
                font-weight: 600;
                margin-bottom: 5px;
                letter-spacing: 0.5px;
            }

            .detail-value {
                font-size: 14px;
                color: #2C3E50;
                font-weight: 600;
            }

            .availability-indicator {
                display: flex;
                align-items: center;
                justify-content: space-between;
                background: linear-gradient(135deg, #1ABC9C, #16A085);
                color: white;
                padding: 15px;
                border-radius: 12px;
                margin-bottom: 20px;
            }

            .availability-count {
                font-size: 20px;
                font-weight: 700;
            }

            .availability-text {
                font-size: 12px;
                opacity: 0.9;
            }

            .book-actions {
                display: flex;
                gap: 10px;
            }

            .btn {
                padding: 12px 20px;
                border: none;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 600;
                text-decoration: none;
                text-align: center;
                cursor: pointer;
                transition: all 0.3s ease;
                flex: 1;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
            }

            .btn-primary {
                background: linear-gradient(135deg, #1ABC9C, #16A085);
                color: white;
            }

            .btn-secondary {
                background: #ECF0F1;
                color: #2C3E50;
            }

            .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            }

            .status-badge {
                display: inline-block;
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 11px;
                font-weight: 600;
                text-transform: uppercase;
                background: linear-gradient(135deg, #27AE60, #2ECC71);
                color: white;
            }

            .no-books {
                text-align: center;
                padding: 60px 40px;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                border-radius: 20px;
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            }

            .no-books-icon {
                font-size: 80px;
                color: #34495E;
                margin-bottom: 25px;
                opacity: 0.3;
            }

            .no-books-title {
                font-size: 24px;
                color: #2C3E50;
                font-weight: 600;
                margin-bottom: 15px;
            }

            .no-books-desc {
                font-size: 16px;
                color: #34495E;
                opacity: 0.8;
            }

            .error-message {
                background: #E74C3C;
                color: white;
                padding: 15px 20px;
                border-radius: 10px;
                margin-bottom: 20px;
                text-align: center;
            }

            .back-button {
                position: fixed;
                bottom: 30px;
                right: 30px;
                width: 60px;
                height: 60px;
                background: linear-gradient(135deg, #1ABC9C, #16A085);
                color: white;
                border: none;
                border-radius: 50%;
                font-size: 20px;
                cursor: pointer;
                box-shadow: 0 10px 30px rgba(26, 188, 156, 0.3);
                transition: all 0.3s ease;
                z-index: 1000;
            }

            .back-button:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 40px rgba(26, 188, 156, 0.4);
            }

            @keyframes fadeInDown {
                from {
                    opacity: 0;
                    transform: translateY(-50px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

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

            .book-card:nth-child(1) {
                animation-delay: 0.1s;
            }
            .book-card:nth-child(2) {
                animation-delay: 0.2s;
            }
            .book-card:nth-child(3) {
                animation-delay: 0.3s;
            }
            .book-card:nth-child(4) {
                animation-delay: 0.4s;
            }
            .book-card:nth-child(5) {
                animation-delay: 0.5s;
            }
            .book-card:nth-child(6) {
                animation-delay: 0.6s;
            }

            @media (max-width: 768px) {
                .container {
                    margin: 10px;
                }

                .header {
                    padding: 30px 20px;
                }

                .header-title {
                    font-size: 28px;
                }

                .books-grid {
                    grid-template-columns: 1fr;
                    gap: 20px;
                }

                .book-details {
                    grid-template-columns: 1fr;
                    gap: 10px;
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
                <h1 class="header-title">Thư viện sách</h1>
                <p class="header-subtitle">Danh sách tất cả các cuốn sách có sẵn</p>
            </div>

            <% if (error != null) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-triangle"></i>
                <%= error %>
            </div>
            <% } %>

            <% if (books != null && !books.isEmpty()) { %>
            <div class="books-grid">
                <% for (Book book : books) { %>
                <div class="book-card">
                    <div class="book-header">
                        <div class="book-icon">
                            <i class="fas fa-book"></i>
                        </div>
                        <h3 class="book-title"><%= book.getTitle() %></h3>
                        <p class="book-author"><%= book.getAuthor() %></p>
                    </div>

                    <div class="book-content">
                        <div class="book-details">
                            <div class="detail-item">
                                <div class="detail-label">Danh mục</div>
                                <div class="detail-value"><%= book.getCategory() %></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Năm XB</div>
                                <div class="detail-value"><%= book.getPublishedYear() %></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">ISBN</div>
                                <div class="detail-value"><%= book.getIsbn() %></div>
                            </div>
                        </div>
                    </div>

                    <div class="availability-indicator">
                        <div class="availability-count"><%= book.getQuantity() %></div>
                        <div class="availability-text">Sách còn lại</div>
                    </div>

                    <div class="book-actions">
                        <a href="bookdetail?id=<%= book.getId() %>" class="btn btn-primary">
                            <i class="fas fa-info-circle"></i> Chi tiết
                        </a>
                        <a href="borrow?id=<%= book.getId() %>" class="btn btn-secondary">
                            <i class="fas fa-book-reader"></i> Mượn sách
                        </a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <% } else { %>
        <div class="no-books">
            <div class="no-books-icon">
                <i class="fas fa-box-open"></i>
            </div>
            <h2 class="no-books-title">Không có sách nào!</h2>
            <p class="no-books-desc">Hiện tại không có sách nào được liệt kê trong hệ thống.</p>
        </div>
        <% } %>

        <button class="back-button" onclick="window.history.back();">
            <i class="fas fa-arrow-left"></i>
        </button>
    </body>
</html>
