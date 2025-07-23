<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Set" %>
<%@ page import="service.implement.OnlineUserManager" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user-online.css"/>
        <title>Users Online</title>
        <!--            <style>
                          
                    </style>-->
    </head>
    <body>
        <%
            // Lấy danh sách người dùng online
            Set<String> onlineUsers = OnlineUserManager.getOnlineUsers();
            int userCount = OnlineUserManager.getOnlineUserCount();
    
            // Đưa dữ liệu vào request scope
            request.setAttribute("onlineUsers", onlineUsers);
            request.setAttribute("userCount", userCount);
        %>
        <!-- Navigation Bar -->
        <nav class="navbar">
            <div class="nav-container">
                <div class="logo">
                    <span>🏠</span>
                    <span>Online Users Manager</span>
                </div>
                <div class="nav-buttons">
                    <a href="home" class="nav-btn btn-home">
                        <span>🏠</span>
                        <span>Home</span>
                    </a>
                    <a href="LogoutServlet" class="nav-btn btn-logout">
                        <span>🚪</span>
                        <span>Logout</span>
                    </a>
                </div>
            </div>
        </nav>

        <!-- Main Content -->
        <div class="main-content">
            <div class="container">
                <div class="content-header">
                    <h2>
                        <span>👥</span>
                        <div>
                            <div>Users are online</div>
                            <div class="subtitle">Realtime list of active members</div>
                        </div>
                    </h2>
                </div>

                <div class="content-body">
                    <div class="status-section">
                        <div class="user-count">
                            <span>📊</span>
                            <span>Online now:</span>
                            <span class="count-number">${userCount}</span>
                            <span>people.</span>
                        </div>

                        <div class="refresh-section">
                            <button class="refresh-btn" onclick="refreshPage()">
                                <span>🔄</span>
                                <span>Refresh</span>
                            </button>
                            <div class="last-updated">
                                Updated at <span id="lastUpdated"></span>
                            </div>
                        </div>
                    </div>

                    <div class="loading" id="loading">
                        <span>⏳</span> Loading...
                    </div>

                    <c:choose>
                        <c:when test="${empty onlineUsers}">
                            <div class="no-users">
                                <div class="no-users-icon">😴</div>
                                <h3>No users are online.</h3>
                                <p>Try refreshing the page to check again.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <ul class="user-list">
                                <c:forEach var="username" items="${onlineUsers}" varStatus="status">
                                    <li class="user-item" style="animation-delay: ${status.index * 0.1}s">
                                        <span class="online-indicator"></span>
                                        <span class="username">
                                            <c:out value="${username}" escapeXml="true"/>
                                        </span>
                                        <span class="user-status">Online</span>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <script>
            // Cập nhật thời gian hiện tại
            function updateLastUpdated() {
                const now = new Date();
                const timeString = now.toLocaleTimeString('vi-VN');
                document.getElementById('lastUpdated').textContent = timeString;
            }

            // Refresh page với loading indicator
            function refreshPage() {
                const loadingEl = document.getElementById('loading');
                const refreshBtn = document.querySelector('.refresh-btn');

                loadingEl.style.display = 'block';
                refreshBtn.style.opacity = '0.6';
                refreshBtn.style.pointerEvents = 'none';

                setTimeout(function () {
                    window.location.reload();
                }, 800);
            }

            // Auto refresh every 30 seconds
            let autoRefreshInterval = setInterval(function () {
                refreshPage();
            }, 30000);

            // Pause auto refresh when user is not on the page
            document.addEventListener('visibilitychange', function () {
                if (document.hidden) {
                    clearInterval(autoRefreshInterval);
                } else {
                    autoRefreshInterval = setInterval(function () {
                        refreshPage();
                    }, 30000);
                    updateLastUpdated();
                }
            });

            // Initialize
            updateLastUpdated();

            // Keyboard shortcuts
            document.addEventListener('keydown', function (e) {
                if (e.key === 'F5' || (e.ctrlKey && e.key === 'r')) {
                    e.preventDefault();
                    refreshPage();
                }

                // ESC to go home
                if (e.key === 'Escape') {
                    window.location.href = 'index.jsp';
                }
            });

            // Show notification when users come online/offline
            let previousUserCount = ${userCount};

            function checkForUpdates() {
                fetch(window.location.href)
                        .then(response => response.text())
                        .then(html => {
                            const parser = new DOMParser();
                            const doc = parser.parseFromString(html, 'text/html');
                            const newCountEl = doc.querySelector('.count-number');

                            if (newCountEl) {
                                const newCount = parseInt(newCountEl.textContent);

                                if (newCount !== previousUserCount) {
                                    const change = newCount > previousUserCount ? 'tăng' : 'giảm';
                                    showNotification(`The number of online users is now ${change}: ${newCount} people`);
                                    previousUserCount = newCount;
                                }
                            }
                        })
                        .catch(error => console.log('Error checking updates:', error));
            }

            function showNotification(message) {
                // Create notification element
                const notification = document.createElement('div');
                notification.style.cssText = `
                    position: fixed;
                    top: 90px;
                    right: 20px;
                    background: linear-gradient(135deg, #1ABC9C, #16A085);
                    color: white;
                    padding: 15px 25px;
                    border-radius: 10px;
                    box-shadow: 0 8px 25px rgba(26, 188, 156, 0.3);
                    z-index: 1000;
                    animation: slideIn 0.4s ease-out;
                    font-weight: 600;
                    border-left: 4px solid #ECFOF1;
                `;

                notification.innerHTML = `
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <span>🔔</span>
                        <span>${message}</span>
                    </div>
                `;

                document.body.appendChild(notification);

                // Auto remove after 4 seconds
                setTimeout(() => {
                    notification.style.animation = 'fadeOut 0.3s ease-in forwards';
                    setTimeout(() => {
                        if (notification.parentNode) {
                            notification.remove();
                        }
                    }, 300);
                }, 4000);
            }

            // CSS animations for notifications
            const style = document.createElement('style');
            style.textContent = `
                @keyframes slideIn {
                    from {
                        transform: translateX(100%);
                        opacity: 0;
                    }
                    to {
                        transform: translateX(0);
                        opacity: 1;
                    }
                }
            
                @keyframes fadeOut {
                    from {
                        opacity: 1;
                        transform: translateX(0);
                    }
                    to {
                        opacity: 0;
                        transform: translateX(100%);
                    }
                }
            `;
            document.head.appendChild(style);

            // Check for updates every 15 seconds (without full page reload)
            setInterval(checkForUpdates, 15000);

            // Smooth scroll for better UX
            document.addEventListener('DOMContentLoaded', function () {
                document.documentElement.style.scrollBehavior = 'smooth';
            });
        </script>
    </body>
</html>