<%-- 
    Document   : index
    Created on : May 20, 2025, 1:00:04 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.Book" %>
<!DOCTYPE html>
<html>
<head>
    <title>Online Library - Home</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <h1>📚 New Books in Our Library</h1>
    <div class="book-container">
        <%
            List<Book> books = (List<Book>) request.getAttribute("books");
            for (Book book : books) {
        %>
        <div class="book-card">
            <h3><%= book.getTitle() %></h3>
            <p><b>Author:</b> <%= book.getAuthor() %></p>
            <p><b>Category:</b> <%= book.getCategory() %></p>
        </div>
        <% } %>
    </div>
</body>
</html>