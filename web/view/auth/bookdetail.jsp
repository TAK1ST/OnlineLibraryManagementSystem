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

<%
    // Get data from request attributes
    List<Book> books = (List<Book>) request.getAttribute("books");
    String error = (String) request.getAttribute("error");
    
    // Initialize NumberFormat for currency formatting
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    
    // Debug information
    if (books != null) {
        System.out.println("JSP: Received " + books.size() + " books");
    } else {
        System.out.println("JSP: Books list is null");
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách sách - Library Management System</title>
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
            padding: 20px;
            position: relative;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }

        .header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 40px;
            text-align: center;
            margin-bottom: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            animation: slideDown 0.8s ease-out;
        }

        .header-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 50%;
            margin: 0 auto 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
            color: white;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
        }

        .header-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 10px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .header-subtitle {
            font-size: 1.1rem;
            color: #4a5568;
            opacity: 0.8;
        }

        .stats-bar {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin-top: 20px;
            flex-wrap: wrap;
        }

        .stat-item {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 15px 25px;
            border-radius: 15px;
            text-align: center;
            min-width: 120px;
        }

        .stat-number {
            font-size: 1.8rem;
            font-weight: 700;
            display: block;
        }

        .stat-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }

        .books-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .book-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.08);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            animation: fadeInUp 0.6s ease-out;
            animation-fill-mode: both;
            position: relative;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .book-card:hover {
            transform: translateY(-15px) scale(1.02);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
        }

        .book-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #667eea, #764ba2);
        }

        .book-header {
            padding: 30px 25px 20px;
            text-align: center;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.05), rgba(118, 75, 162, 0.05));
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }

        .book-icon {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 15px;
            margin: 0 auto 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            color: white;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }

        .book-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 8px;
            line-height: 1.4;
            min-height: 60px;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }

        .book-author {
            font-size: 1rem;
            color: #667eea;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .book-isbn {
            font-size: 0.85rem;
            color: #718096;
            font-family: 'Courier New', monospace;
            background: #f7fafc;
            padding: 4px 8px;
            border-radius: 6px;
            display: inline-block;
        }

        .book-content {
            padding: 25px;
        }

        .book-details {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 25px;
        }

        .detail-item {
            background: #f8fafc;
            border-radius: 12px;
            padding: 15px;
            text-align: center;
            transition: all 0.3s ease;
            border: 1px solid #e2e8f0;
        }

        .detail-item:hover {
            background: #edf2f7;
            transform: translateY(-2px);
        }

        .detail-label {
            font-size: 0.75rem;
            color: #4a5568;
            text-transform: uppercase;
            font-weight: 700;
            margin-bottom: 8px;
            letter-spacing: 0.5px;
        }

        .detail-value {
            font-size: 1rem;
            color: #2d3748;
            font-weight: 600;
        }

        .availability-section {
            margin-bottom: 25px;
        }

        .availability-indicator {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 15px;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.2);
        }

        .availability-left {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .availability-icon {
            font-size: 24px;
        }

        .availability-info h4 {
            font-size: 1.1rem;
            margin-bottom: 4px;
        }

        .availability-info p {
            font-size: 0.9rem;
            opacity: 0.9;
        }

        .availability-count {
            font-size: 2rem;
            font-weight: 800;
            text-align: center;
        }

        .status-badges {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            justify-content: center;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-available {
            background: linear-gradient(135deg, #48bb78, #38a169);
            color: white;
        }

        .status-limited {
            background: linear-gradient(135deg, #ed8936, #dd6b20);
            color: white;
        }

        .status-unavailable {
            background: linear-gradient(135deg, #e53e3e, #c53030);
            color: white;
        }

        .book-actions {
            display: flex;
            gap: 12px;
        }

        .btn {
            padding: 14px 20px;
            border: none;
            border-radius: 12px;
            font-size: 0.95rem;
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
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #4fd1c7, #14b8a6);
            color: white;
            box-shadow: 0 4px 15px rgba(79, 209, 199, 0.3);
        }

        .btn-secondary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(79, 209, 199, 0.4);
        }

        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none !important;
        }

        .no-books {
            text-align: center;
            padding: 80px 40px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            animation: fadeIn 1s ease-out;
        }

        .no-books-icon {
            font-size: 100px;
            color: #cbd5e0;
            margin-bottom: 30px;
            animation: bounce 2s infinite;
        }

        .no-books-title {
            font-size: 2rem;
            color: #2d3748;
            font-weight: 700;
            margin-bottom: 15px;
        }

        .no-books-desc {
            font-size: 1.1rem;
            color: #4a5568;
            opacity: 0.8;
            max-width: 500px;
            margin: 0 auto;
        }

        .error-message {
            background: linear-gradient(135deg, #fed7d7, #feb2b2);
            color: #c53030;
            padding: 20px 25px;
            border-radius: 15px;
            margin-bottom: 25px;
            text-align: center;
            border: 1px solid #fbb6ce;
            animation: shake 0.5s ease-in-out;
        }

        .error-icon {
            font-size: 1.2rem;
            margin-right: 10px;
        }

        .back-button {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 65px;
            height: 65px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            border-radius: 50%;
            font-size: 22px;
            cursor: pointer;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .back-button:hover {
            transform: translateY(-5px) scale(1.1);
            box-shadow: 0 15px 40px rgba(102, 126, 234, 0.4);
        }

        .loading-spinner {
            display: none;
            text-align: center;
            padding: 50px;
        }

        .spinner {
            width: 50px;
            height: 50px;
            border: 4px solid #e2e8f0;
            border-top: 4px solid #667eea;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }

        @keyframes slideDown {
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

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {
                transform: translateY(0);
            }
            40% {
                transform: translateY(-10px);
            }
            60% {
                transform: translateY(-5px);
            }
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Animation delays for staggered effect */
        .book-card:nth-child(1) { animation-delay: 0.1s; }
        .book-card:nth-child(2) { animation-delay: 0.2s; }
        .book-card:nth-child(3) { animation-delay: 0.3s; }
        .book-card:nth-child(4) { animation-delay: 0.4s; }
        .book-card:nth-child(5) { animation-delay: 0.5s; }
        .book-card:nth-child(6) { animation-delay: 0.6s; }

        @media (max-width: 1200px) {
            .books-grid {
                grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            }
        }

        @media (max-width: 768px) {
            .container {
                margin: 10px;
                padding: 0 10px;
            }

            .header {
                padding: 30px 20px;
            }

            .header-title {
                font-size: 2rem;
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

            .stats-bar {
                flex-direction: column;
                gap: 15px;
            }

            .availability-indicator {
                flex-direction: column;
                text-align: center;
                gap: 15px;
            }
        }

        @media (max-width: 480px) {
            .header-title {
                font-size: 1.8rem;
            }
            
            .books-grid {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            
            .book-card {
                margin: 0 5px;
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
            <h1 class="header-title">Thư viện Sách Điện tử</h1>
            <p class="header-subtitle">Khám phá kho tàng tri thức với hàng nghìn cuốn sách chất lượng</p>
            
            <% if (books != null) { %>
            <div class="stats-bar">
                <div class="stat-item">
                    <span class="stat-number"><%= books.size() %></span>
                    <span class="stat-label">Tổng sách</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number">
                        <%
                            int availableCount = 0;
                            for (Book book : books) {
                                if (book.getAvailableCopies() > 0) {
                                    availableCount++;
                                }
                            }
                        %>
                        <%= availableCount %>
                    </span>
                    <span class="stat-label">Có sẵn</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number">
                        <%
                            java.util.Set<String> categories = new java.util.HashSet<>();
                            for (Book book : books) {
                                if (book.getCategory() != null && !book.getCategory().trim().isEmpty()) {
                                    categories.add(book.getCategory());
                                }
                            }
                        %>
                        <%= categories.size() %>
                    </span>
                    <span class="stat-label">Danh mục</span>
                </div>
            </div>
            <% } %>
        </div>

        <!-- Error Message -->
        <% if (error != null && !error.trim().isEmpty()) { %>
        <div class="error-message">
            <i class="fas fa-exclamation-triangle error-icon"></i>
            <strong>Lỗi:</strong> <%= error %>
        </div>
        <% } %>

        <!-- Loading Spinner -->
        <div id="loadingSpinner" class="loading-spinner">
            <div class="spinner"></div>
            <p>Đang tải dữ liệu sách...</p>
        </div>

        <!-- Books Grid -->
        <% if (books != null && !books.isEmpty()) { %>
        <div class="books-grid" id="booksGrid">
            <% 
                int cardIndex = 0;
                for (Book book : books) { 
                    cardIndex++;
                    // Determine availability status
                    String availabilityClass = "";
                    String availabilityText = "";
                    String availabilityIcon = "";
                    
                    if (book.getAvailableCopies() == 0) {
                        availabilityClass = "status-unavailable";
                        availabilityText = "Hết sách";
                        availabilityIcon = "fas fa-times-circle";
                    } else if (book.getAvailableCopies() <= 2) {
                        availabilityClass = "status-limited";
                        availabilityText = "Sắp hết";
                        availabilityIcon = "fas fa-exclamation-circle";
                    } else {
                        availabilityClass = "status-available";
                        availabilityText = "Còn nhiều";
                        availabilityIcon = "fas fa-check-circle";
                    }
            %>
            <div class="book-card" style="animation-delay: <%= (cardIndex * 0.1) %>s;">
                <!-- Book Header -->
                <div class="book-header">
                    <div class="book-icon">
                        <i class="fas fa-book"></i>
                    </div>
                    <h3 class="book-title" title="<%= book.getTitle() %>">
                        <%= book.getTitle() != null ? book.getTitle() : "Không có tiêu đề" %>
                    </h3>
                    <p class="book-author">
                        <i class="fas fa-user-edit"></i>
                        <%= book.getAuthor() != null ? book.getAuthor() : "Không rõ tác giả" %>
                    </p>
                    <% if (book.getIsbn() != null && !book.getIsbn().trim().isEmpty()) { %>
                    <div class="book-isbn">
                        ISBN: <%= book.getIsbn() %>
                    </div>
                    <% } %>
                </div>

                <!-- Book Content -->
                <div class="book-content">
                    <!-- Book Details -->
                    <div class="book-details">
                        <div class="detail-item">
                            <div class="detail-label">
                                <i class="fas fa-tag"></i> Danh mục
                            </div>
                            <div class="detail-value">
                                <%= book.getCategory() != null ? book.getCategory() : "Chưa phân loại" %>
                            </div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">
                                <i class="fas fa-calendar-alt"></i> Năm XB
                            </div>
                            <div class="detail-value">
                                <%= book.getPublishedYear() > 0 ? book.getPublishedYear() : "N/A" %>
                            </div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">
                                <i class="fas fa-books"></i> Tổng số
                            </div>
                            <div class="detail-value">
                                <%= book.getTotalCopies() %> cuốn
                            </div>
                        </div>
                        <div class="detail-item">
                            <div class="detail-label">
                                <i class="fas fa-chart-pie"></i> Đã mượn
                            </div>
                            <div class="detail-value">
                                <%= book.getTotalCopies() - book.getAvailableCopies() %> cuốn
                            </div>
                        </div>
                    </div>

                    <!-- Availability Section -->
                    <div class="availability-section">
                        <div class="availability-indicator">
                            <div class="availability-left">
                                <div class="availability-icon">
                                    <i class="fas fa-warehouse"></i>
                                </div>
                                <div class="availability-info">
                                    <h4>Số lượng còn lại</h4>
                                    <p>Sách có thể mượn ngay</p>
                                </div>
                            </div>
                            <div class="availability-count">
                                <%= book.getAvailableCopies() %>
                            </div>
                        </div>
                        
                        <div class="status-badges">
                            <span class="status-badge <%= availabilityClass %>">
                                <i class="<%= availabilityIcon %>"></i>
                                <%= availabilityText %>
                            </span>
                            <% if ("active".equals(book.getStatus())) { %>
                            <span class="status-badge status-available">
                                <i class="fas fa-check"></i>
                                Đang hoạt động
                            </span>
                            <% } %>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="book-actions">
                        <a href="bookdetail?action=view&id=<%= book.getId() %>" 
                           class="btn btn-primary" 
                           title="Xem chi tiết sách">
                            <i class="fas fa-info-circle"></i> 
                            Chi tiết
                        </a>
                        <% if (book.getAvailableCopies() > 0) { %>
                        <a href="borrow?id=<%= book.getId() %>" 
                           class="btn btn-secondary" 
                           title="Mượn sách này">
                            <i class="fas fa-hand-holding-heart"></i> 
                            Mượn sách
                        </a>
                        <% } else { %>
                        <button class="btn btn-secondary" 
                                disabled 
                                title="Sách hiện không có sẵn">
                            <i class="fas fa-clock"></i> 
                            Hết sách
                        </button>
                        <% } %>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <% } else if (error == null || error.trim().isEmpty()) { %>
        <!-- No Books Found -->
        <div class="no-books">
            <div class="no-books-icon">
                <i class="fas fa-book-open"></i>
            </div>
            <h2 class="no-books-title">Chưa có sách nào!</h2>
            <p class="no-books-desc">
                Hiện tại thư viện chưa có sách nào được thêm vào hệ thống. 
                Vui lòng quay lại sau hoặc liên hệ với quản trị viên để biết thêm thông tin.
            </p>
        </div>
        <% } %>
    </div>

    <!-- Back Button -->
    <button class="back-button" onclick="goBack()" title="Quay lại trang trước">
        <i class="fas fa-arrow-left"></i>
    </button>

    <script>
        // Show loading spinner on page load
        document.addEventListener('DOMContentLoaded', function() {
            const spinner = document.getElementById('loadingSpinner');
            const booksGrid = document.getElementById('booksGrid');
            
            // Hide spinner after content loads
            setTimeout(() => {
                if (spinner) spinner.style.display = 'none';
                if (booksGrid) booksGrid.style.opacity = '1';
            }, 500);
        });

        // Back button functionality
        function goBack() {
            if (window.history.length > 1) {
                window.history.back();
            } else {
                window.location.href = '/'; // Fallback to home page
            }
        }

        // Add smooth scrolling for better UX
        document.documentElement.style.scrollBehavior = 'smooth';

        // Add click animation to cards
        document.querySelectorAll('.book-card').forEach(card => {
            card.addEventListener('click', function(e) {
                // Don't trigger if clicking on buttons
                if (!e.target.closest('.btn')) {
                    this.style.transform = 'scale(0.98)';
                    setTimeout(() => {
                        this.style.transform = '';
                    }, 150);
                }
            });
        });

        // Add keyboard navigation
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                goBack();
            }
        });

        // Debug information
        console.log('Books page loaded successfully');
        console.log('Total books displayed: <%= books != null ? books.size() : 0 %>');
    </script>
</body>
</html>