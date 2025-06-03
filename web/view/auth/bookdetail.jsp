<%-- 
    Document   : bookdetail
    Created on : May 31, 2025, 10:28:02 AM
    Author     : CAU_TU
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="entity.Book" %>
<%@ page import="java.sql.*" %>
<%
    // Lấy id sách từ request
    String bookId = request.getParameter("id");
    Book book = null;

    if (bookId != null) {
        try (Connection conn = util.DBConnection.getConnection()) {
            String sql = "SELECT * FROM books WHERE id=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(bookId));
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                book = new Book(
                    rs.getInt("id"),
                    rs.getString("title"),
                    rs.getString("author"),
                    rs.getString("isbn"),
                    rs.getString("category"),
                    rs.getInt("published_year"),
                    rs.getInt("total_copies"),
                    rs.getInt("available_copies"),
                    rs.getString("status")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chi tiết sách - Library Management</title>
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
                max-width: 900px;
                margin: 0 auto;
                position: relative;
                z-index: 1;
            }

            .book-card {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                border-radius: 25px;
                box-shadow: 
                    0 25px 60px rgba(0, 0, 0, 0.3),
                    0 0 0 1px rgba(255, 255, 255, 0.2);
                overflow: hidden;
                position: relative;
                animation: fadeInUp 0.8s ease-out;
            }

            .book-header {
                background: linear-gradient(135deg, #1ABC9C, #16A085);
                padding: 40px;
                text-align: center;
                position: relative;
                overflow: hidden;
            }

            .book-header::before {
                content: '';
                position: absolute;
                top: -50%;
                left: -50%;
                width: 200%;
                height: 200%;
                background: linear-gradient(45deg, transparent, rgba(255,255,255,0.1), transparent);
                animation: shimmer 3s infinite;
            }

            .book-icon {
                width: 120px;
                height: 120px;
                background: rgba(255, 255, 255, 0.2);
                border-radius: 15px;
                margin: 0 auto 25px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 50px;
                color: white;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
                position: relative;
                z-index: 2;
            }

            .book-title {
                font-size: 32px;
                font-weight: 700;
                color: white;
                margin-bottom: 10px;
                text-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
                position: relative;
                z-index: 2;
            }

            .book-subtitle {
                font-size: 16px;
                color: rgba(255, 255, 255, 0.9);
                position: relative;
                z-index: 2;
            }

            .book-content {
                padding: 50px;
            }

            .detail-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 25px;
                margin-bottom: 40px;
            }

            .detail-item {
                background: linear-gradient(135deg, #ECFOF1, rgba(236, 240, 241, 0.5));
                border-radius: 15px;
                padding: 25px;
                border-left: 5px solid #1ABC9C;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .detail-item::before {
                content: '';
                position: absolute;
                top: 0;
                right: 0;
                width: 50px;
                height: 50px;
                background: linear-gradient(135deg, #1ABC9C, transparent);
                border-radius: 0 15px 0 100%;
                opacity: 0.1;
            }

            .detail-item:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 35px rgba(26, 188, 156, 0.2);
                background: linear-gradient(135deg, #ECFOF1, white);
            }

            .detail-label {
                font-weight: 700;
                color: #2C3E50;
                font-size: 14px;
                text-transform: uppercase;
                letter-spacing: 1px;
                margin-bottom: 8px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .detail-value {
                font-size: 18px;
                color: #34495E;
                font-weight: 500;
                line-height: 1.4;
            }

            .status-badge {
                display: inline-block;
                padding: 8px 20px;
                border-radius: 25px;
                font-size: 14px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                background: linear-gradient(135deg, #16A085, #1ABC9C);
                color: white;
                box-shadow: 0 5px 15px rgba(22, 160, 133, 0.3);
            }

            .availability-indicator {
                display: flex;
                align-items: center;
                gap: 15px;
                background: linear-gradient(135deg, #1ABC9C, #16A085);
                color: white;
                padding: 20px;
                border-radius: 15px;
                margin: 30px 0;
                box-shadow: 0 10px 25px rgba(26, 188, 156, 0.3);
            }

            .availability-circle {
                width: 60px;
                height: 60px;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.2);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24px;
                font-weight: bold;
            }

            .availability-text {
                flex: 1;
            }

            .availability-title {
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 5px;
            }

            .availability-desc {
                font-size: 14px;
                opacity: 0.9;
            }

            .action-buttons {
                display: flex;
                gap: 20px;
                justify-content: center;
                margin-top: 40px;
                flex-wrap: wrap;
            }

            .btn {
                padding: 15px 30px;
                border: none;
                border-radius: 50px;
                font-size: 16px;
                font-weight: 600;
                text-decoration: none;
                text-transform: uppercase;
                letter-spacing: 1px;
                transition: all 0.3s ease;
                cursor: pointer;
                display: inline-flex;
                align-items: center;
                gap: 10px;
                position: relative;
                overflow: hidden;
            }

            .btn-primary {
                background: linear-gradient(135deg, #1ABC9C, #16A085);
                color: white;
                box-shadow: 0 8px 25px rgba(26, 188, 156, 0.3);
            }

            .btn-secondary {
                background: linear-gradient(135deg, #34495E, #2C3E50);
                color: white;
                box-shadow: 0 8px 25px rgba(52, 73, 94, 0.3);
            }

            .btn:hover {
                transform: translateY(-3px);
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            }

            .btn::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
                transition: left 0.5s;
            }

            .btn:hover::before {
                left: 100%;
            }

            .not-found {
                text-align: center;
                padding: 60px 40px;
            }

            .not-found-icon {
                font-size: 80px;
                color: #34495E;
                margin-bottom: 25px;
                opacity: 0.5;
            }

            .not-found-title {
                font-size: 28px;
                color: #2C3E50;
                font-weight: 600;
                margin-bottom: 15px;
            }

            .not-found-desc {
                font-size: 16px;
                color: #34495E;
                opacity: 0.8;
                margin-bottom: 30px;
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(60px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            @keyframes shimmer {
                0% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
                100% { transform: translateX(100%) translateY(100%) rotate(45deg); }
            }

            .detail-item {
                animation: fadeInUp 0.6s ease-out;
                animation-fill-mode: both;
            }

            .detail-item:nth-child(1) { animation-delay: 0.1s; }
            .detail-item:nth-child(2) { animation-delay: 0.2s; }
            .detail-item:nth-child(3) { animation-delay: 0.3s; }
            .detail-item:nth-child(4) { animation-delay: 0.4s; }
            .detail-item:nth-child(5) { animation-delay: 0.5s; }
            .detail-item:nth-child(6) { animation-delay: 0.6s; }

            @media (max-width: 768px) {
                .container {
                    margin: 10px;
                }
                
                .book-header {
                    padding: 30px 20px;
                }
                
                .book-title {
                    font-size: 24px;
                }
                
                .book-content {
                    padding: 30px 20px;
                }
                
                .detail-grid {
                    grid-template-columns: 1fr;
                    gap: 15px;
                }
                
                .detail-item {
                    padding: 20px;
                }
                
                .action-buttons {
                    flex-direction: column;
                    align-items: center;
                }
                
                .btn {
                    width: 100%;
                    max-width: 300px;
                    justify-content: center;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="book-card">
                <% if (book != null) { %>
                <div class="book-header">
                    <div class="book-icon">
                        <i class="fas fa-book"></i>
                    </div>
                    <h1 class="book-title"><%= book.getTitle() %></h1>
                    <p class="book-subtitle">Chi tiết thông tin sách</p>
                </div>
                
                <div class="book-content">
                    <div class="detail-grid">
                        <div class="detail-item">
                            <div class="detail-label">
                                <i class="fas fa-user"></i>
                                Tác giả
                            </div>
                            <div class="detail-value"><%= book.getAuthor() %></div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-label">
                                <i class="fas fa-barcode"></i>
                                ISBN
                            </div>
                            <div class="detail-value"><%= book.getIsbn() %></div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-label">
                                <i class="fas fa-tags"></i>
                                Danh mục
                            </div>
                            <div class="detail-value"><%= book.getCategory() %></div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-label">
                                <i class="fas fa-calendar-alt"></i>
                                Năm xuất bản
                            </div>
                            <div class="detail-value"><%= book.getPublishedYear() %></div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-label">
                                <i class="fas fa-clone"></i>
                                Tổng số bản
                            </div>
                            <div class="detail-value"><%= book.getTotalCopies() %> bản</div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-label">
                                <i class="fas fa-info-circle"></i>
                                Trạng thái
                            </div>
                            <div class="detail-value">
                                <span class="status-badge"><%= book.getStatus() %></span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="availability-indicator">
                        <div class="availability-circle">
                            <%= book.getAvailableCopies() %>
                        </div>
                        <div class="availability-text">
                            <div class="availability-title">Số bản có sẵn để mượn</div>
                            <div class="availability-desc">
                                <%= book.getAvailableCopies() %> trên tổng số <%= book.getTotalCopies() %> bản
                            </div>
                        </div>
                        <div class="availability-circle">
                            <i class="fas fa-check-circle"></i>
                        </div>
                    </div>
                    
                    <div class="action-buttons">
                        <% if (book.getAvailableCopies() > 0) { %>
                        <a href="#" class="btn btn-primary">
                            <i class="fas fa-book-reader"></i>
                            Mượn sách
                        </a>
                        <% } %>
                        <a href="register.jsp" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i>
                            Quay lại trang chủ
                        </a>
                    </div>
                </div>
                <% } else { %>
                <div class="book-content">
                    <div class="not-found">
                        <div class="not-found-icon">
                            <i class="fas fa-book-dead"></i>
                        </div>
                        <h2 class="not-found-title">Không tìm thấy sách</h2>
                        <p class="not-found-desc">Xin lỗi, sách bạn đang tìm kiếm không tồn tại hoặc đã bị xóa.</p>
                        <div class="action-buttons">
                            <a href="register.jsp" class="btn btn-primary">
                                <i class="fas fa-home"></i>
                                Về trang chủ
                            </a>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </body>
</html>