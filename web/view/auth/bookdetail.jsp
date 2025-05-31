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
        <title>Chi tiết sách</title>
        <style>
            body {
                font-family: Arial, sans-serif;
            }
            .container {
                max-width: 600px;
                margin: auto;
                padding: 20px;
                border: 1px solid #ccc;
            }
            h1 {
                text-align: center;
            }
            .detail {
                margin: 10px 0;
            }
            .label {
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Chi tiết sách</h1>
            <% if (book != null) { %>
            <div class="detail"><span class="label">Tiêu đề:</span> <%= book.getTitle() %></div>
            <div class="detail"><span class="label">Tác giả:</span> <%= book.getAuthor() %></div>
            <div class="detail"><span class="label">ISBN:</span> <%= book.getIsbn() %></div>
            <div class="detail"><span class="label">Danh mục:</span> <%= book.getCategory() %></div>
            <div class="detail"><span class="label">Năm xuất bản:</span> <%= book.getPublishedYear() %></div>
            <div class="detail"><span class="label">Tổng số bản:</span> <%= book.getTotalCopies() %></div>
            <div class="detail"><span class="label">Số bản có sẵn:</span> <%= book.getAvailableCopies() %></div>
            <div class="detail"><span class="label">Trạng thái:</span> <%= book.getStatus() %></div>
            <% } else { %>
            <p>Không tìm thấy sách.</p>
            <% } %>
            <a href="register.jsp">Quay lại trang chủ</a>
        </div>
    </body>
</html>
