<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Update Inventory</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-update-inventory.css"/>
    </head>
    <body>
        <!-- Improved Header with Centered Layout -->
        <div class="header">
            <div class="header-container">
                <div class="header-left">
                    <!--                    <button class="back-btn" onclick="history.back()">
                                            <i class="fas fa-arrow-left"></i>
                                            <span>Back</span>
                                        </button>-->
                    <a href="admindashboard" style="text-decoration: none">
                        <button class="back-btn">
                            <i class="fas fa-arrow-left"></i>
                        </button>
                    </a>
                </div>
                <div class="header-center">
                    <div class="header-title">
                        <h1>
                            <i class="fas fa-warehouse"></i>
                            Update Inventory
                        </h1>
                        <p class="header-subtitle">Manage your book collection efficiently</p>
                    </div>
                </div>
                <div class="header-right">
                    <a href="LogoutServlet" class="logout-btn">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Logout</span>
                    </a>
                </div>
            </div>
        </div>
        <!-- Main Content - Centered -->
        <div class="main-container">
            <!-- Statistics -->
            <div class="stats-grid fade-in">
                <div class="stat-card total">
                    <div class="stat-icon"><i class="fas fa-book"></i></div>
                    <div class="stat-number">${totalBooks != null ? totalBooks : 0}</div>
                    <div class="stat-label">Total Books</div>
                </div>
                <div class="stat-card available">
                    <div class="stat-icon"><i class="fas fa-check-circle"></i></div>
                    <div class="stat-number">${availableBooks != null ? availableBooks : 0}</div>
                    <div class="stat-label">Available</div>
                </div>
                <div class="stat-card borrowed">
                    <div class="stat-icon"><i class="fas fa-hand-holding"></i></div>
                    <div class="stat-number">${borrowedBooks != null ? borrowedBooks : 0}</div>
                    <div class="stat-label">Borrowed</div>
                </div>
                <div class="stat-card low-stock">
                    <div class="stat-icon"><i class="fas fa-exclamation-triangle"></i></div>
                    <div class="stat-number">${lowStockBooks != null ? lowStockBooks : 0}</div>
                    <div class="stat-label">Low Stock</div>
                </div>
            </div>

            <!-- Search Section -->
            <div class="search-section fade-in">
                <h3 class="search-title">
                    <i class="fas fa-search"></i>
                    Search & Filter Books
                </h3>
                <form class="search-form" action="${pageContext.request.contextPath}/updateinventory" method="GET">
                    <input type="text" name="searchTerm" placeholder="Enter search term..." value="${param.searchTerm}">
                    <select name="searchType">
                        <option value="title" ${param.searchType == 'title' ? 'selected' : ''}>Title</option>
                        <option value="author" ${param.searchType == 'author' ? 'selected' : ''}>Author</option>
                        <option value="category" ${param.searchType == 'category' ? 'selected' : ''}>Category</option>
                        <option value="isbn" ${param.searchType == 'isbn' ? 'selected' : ''}>ISBN</option>
                    </select>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-search"></i> Search
                    </button>
                    <a href="${pageContext.request.contextPath}/updateinventory" class="btn btn-secondary">
                        <i class="fas fa-refresh"></i> Reset
                    </a>
                </form>
            </div>

            <!-- Messages -->
            <c:if test="${not empty message}">
                <div class="${message.contains('failed') || message.contains('Invalid') || message.contains('negative') ? 'error' : 'message'} fade-in">
                    <i class="fas ${message.contains('failed') || message.contains('Invalid') || message.contains('negative') ? 'fa-exclamation-circle' : 'fa-check-circle'}"></i>
                    ${message}
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="error fade-in">
                    <i class="fas fa-exclamation-circle"></i>
                    ${error}
                </div>
            </c:if>

            <!-- Books Table -->
            <c:choose>
                <c:when test="${not empty books}">
                    <div class="table-container fade-in">
                        <div class="table-header">
                            <i class="fas fa-table"></i>
                            <h3>Book Inventory Management</h3>
                        </div>
                        <table>
                            <thead class="menu-detail-book">
                                <tr>
                                    <th><i class="fas fa-book"></i> Title</th>
                                    <th><i class="fas fa-user"></i> Author</th>
                                    <th><i class="fas fa-barcode"></i> ISBN</th>
                                    <th><i class="fas fa-tag"></i> Category</th>
                                    <th><i class="fas fa-calendar"></i> Year</th>
                                    <th><i class="fas fa-layer-group"></i> Total</th>
                                    <th><i class="fas fa-check"></i> Available</th>
                                    <th><i class="fas fa-cog"></i> Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${books}" var="book">
                                    <tr>
                                        <td><strong>${book.title}</strong></td>
                                        <td>${book.author}</td>
                                        <td><code class="isbn-code">${book.isbn}</code></td>
                                        <td><span class="category-badge">${book.category}</span></td>
                                        <td>${book.publishedYear}</td>
                                        <td><strong>${book.totalCopies}</strong></td>
                                        <td><span class="available-count">${book.availableCopies}</span></td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/updateinventory" method="post" style="margin: 0;">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="bookId" value="${book.id}">
                                                <div class="action-group">
                                                    <div class="input-group">
                                                        <button type="button" onclick="decrement(this)">−</button>
                                                        <input type="number" name="totalCopies" value="${book.totalCopies}" min="0" required>
                                                        <button type="button" onclick="increment(this)">+</button>
                                                    </div>
                                                    <button type="submit" class="btn btn-primary btn-small">
                                                        <i class="fas fa-save"></i> Update
                                                    </button>
                                                    <a href="#" class="btn btn-secondary btn-small">
                                                        <i class="fas fa-eye"></i> Details
                                                    </a>
                                                </div>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-container fade-in">
                        <div class="no-books">
                            <i class="fas fa-search"></i>
                            <h3>No books found</h3>
                            <p>Try adjusting your search criteria or browse all available books</p>
                            <a href="${pageContext.request.contextPath}/updateinventory" class="btn btn-primary" style="margin-top: 20px;">
                                <i class="fas fa-list"></i> Show All Books
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Floating Action Buttons -->
        <div class="floating-actions">
            <button class="floating-btn pulse" title="Scroll to top" onclick="scrollToTop()">
                <i class="fas fa-arrow-up"></i>
            </button>
            <!--            <button class="floating-btn" title="Refresh page" onclick="location.reload()">
                            <i class="fas fa-sync-alt"></i>
                        </button>-->
        </div>
        <script>
            function increment(button) {
                const input = button.previousElementSibling;
                input.stepUp();
            }

            function decrement(button) {
                const input = button.nextElementSibling;
                if (parseInt(input.value) > 0) {
                    input.stepDown();
                }
            }

            function scrollToTop() {
                window.scrollTo({
                    top: 0,
                    behavior: 'smooth'
                });
            }

// Enhanced smooth animations with staggered effect
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };

            const observer = new IntersectionObserver((entries) => {
                entries.forEach((entry, index) => {
                    if (entry.isIntersecting) {
                        setTimeout(() => {
                            entry.target.style.opacity = '1';
                            entry.target.style.transform = 'translateY(0)';
                        }, index * 100);
                    }
                });
            }, observerOptions);

// Observe all fade-in elements with enhanced styling
            document.querySelectorAll('.fade-in').forEach(el => {
                el.style.opacity = '0';
                el.style.transform = 'translateY(20px)';
                el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                observer.observe(el);
            });

// Add hover effects to stat cards
            document.querySelectorAll('.stat-card').forEach(card => {
                card.addEventListener('mouseenter', function () {
                    this.style.transform = 'translateY(-8px) scale(1.02)';
                });

                card.addEventListener('mouseleave', function () {
                    this.style.transform = 'translateY(0) scale(1)';
                });
            });

// Add loading animation for form submissions
            document.querySelectorAll('form').forEach(form => {
                form.addEventListener('submit', function () {
                    const submitBtn = this.querySelector('button[type="submit"]');
                    if (submitBtn) {
                        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Updating...';
                        submitBtn.disabled = true;
                    }
                });
            });

// Add smooth scroll behavior for better UX
            document.documentElement.style.scrollBehavior = 'smooth';

// Add keyboard shortcuts
            document.addEventListener('keydown', function (e) {
                // Ctrl/Cmd + F to focus search
                if ((e.ctrlKey || e.metaKey) && e.key === 'f') {
                    e.preventDefault();
                    const searchInput = document.querySelector('input[name="searchTerm"]');
                    if (searchInput) {
                        searchInput.focus();
                        searchInput.select();
                    }
                }

                // Escape to clear search
                if (e.key === 'Escape') {
                    const searchInput = document.querySelector('input[name="searchTerm"]');
                    if (searchInput && searchInput === document.activeElement) {
                        searchInput.value = '';
                    }
                }
            });

// Auto-hide messages after 5 seconds
            document.querySelectorAll('.message, .error').forEach(msg => {
                setTimeout(() => {
                    msg.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                    msg.style.opacity = '0';
                    msg.style.transform = 'translateY(-20px)';
                    setTimeout(() => {
                        msg.remove();
                    }, 500);
                }, 5000);
            });

// Add table row click to highlight
            document.querySelectorAll('tbody tr').forEach(row => {
                row.addEventListener('click', function () {
                    // Remove previous highlights
                    document.querySelectorAll('tbody tr').forEach(r => r.classList.remove('highlighted'));
                    // Add highlight to clicked row
                    this.classList.add('highlighted');
                });
            });

// Add CSS for highlighted row
            const style = document.createElement('style');
            style.textContent = `
                tbody tr.highlighted {
                    background: linear-gradient(135deg, rgba(26, 188, 156, 0.1) 0%, rgba(22, 160, 133, 0.1) 100%) !important;
                    border-left: 4px solid var(--primary-green) !important;
                }
            `;
            document.head.appendChild(style);

// Performance optimization: Lazy load images if any
            if ('IntersectionObserver' in window) {
                const imageObserver = new IntersectionObserver((entries, observer) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            const img = entry.target;
                            img.src = img.dataset.src;
                            img.classList.remove('lazy');
                            imageObserver.unobserve(img);
                        }
                    });
                });

                document.querySelectorAll('img[data-src]').forEach(img => {
                    imageObserver.observe(img);
                });
            }
        </script>
    </body>
</html>