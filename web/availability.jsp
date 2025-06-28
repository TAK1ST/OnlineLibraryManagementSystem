<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Availability - Online Library</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>Book Availability</h2>
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead>
                    <tr>
                        <th>Title</th>
                        <th>Author</th>
                        <th>Category</th>
                        <th>Total Copies</th>
                        <th>Available Copies</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="book" items="${books}">
                        <tr>
                            <td>${book.title}</td>
                            <td>${book.author}</td>
                            <td>${book.category}</td>
                            <td>${book.totalCopies}</td>
                            <td>
                                <span class="badge bg-${book.availableCopies > 0 ? 'success' : 'danger'}">
                                    ${book.availableCopies}
                                </span>
                            </td>
                            <td>${book.status}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
