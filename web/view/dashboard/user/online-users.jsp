<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Set" %>
<%@ page import="service.implement.OnlineUserManager" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
    // Lấy danh sách người dùng online
    Set<String> onlineUsers = OnlineUserManager.getOnlineUsers();
    int userCount = OnlineUserManager.getOnlineUserCount();
    
    // Đưa dữ liệu vào request scope
    request.setAttribute("onlineUsers", onlineUsers);
    request.setAttribute("userCount", userCount);
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Người dùng đang online</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1ABC9C 0%, #ECFOF1 100%);
            min-height: 100vh;
            color: #2C3E50;
        }
        
        /* Header Navigation */
        .navbar {
            background: rgba(44, 62, 80, 0.95);
            backdrop-filter: blur(10px);
            padding: 15px 0;
            box-shadow: 0 2px 20px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        
        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
        }
        
        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #ffffff;
            font-size: 20px;
            font-weight: bold;
        }
        
        .nav-buttons {
            display: flex;
            gap: 15px;
        }
        
        .nav-btn {
            padding: 10px 20px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .btn-home {
            background: linear-gradient(45deg, #1ABC9C, #16A085);
            color: white;
            box-shadow: 0 4px 15px rgba(26, 188, 156, 0.3);
        }
        
        .btn-home:hover {
            background: linear-gradient(45deg, #16A085, #1ABC9C);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(26, 188, 156, 0.4);
        }
        
        .btn-logout {
            background: linear-gradient(45deg, #e74c3c, #c0392b);
            color: white;
            box-shadow: 0 4px 15px rgba(231, 76, 60, 0.3);
        }
        
        .btn-logout:hover {
            background: linear-gradient(45deg, #c0392b, #e74c3c);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(231, 76, 60, 0.4);
        }
        
        /* Main Content */
        .main-content {
            padding: 30px 20px;
        }
        
        .container {
            max-width: 900px;
            margin: 0 auto;
            background: rgba(236, 240, 241, 0.98);
            border-radius: 20px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1);
            overflow: hidden;
            animation: fadeIn 0.6s ease-out;
        }
        
        @keyframes fadeIn {
            from { 
                opacity: 0; 
                transform: translateY(30px);
            }
            to { 
                opacity: 1; 
                transform: translateY(0);
            }
        }
        
        .content-header {
            background: linear-gradient(135deg, #1ABC9C, #16A085);
            color: #ffffff;
            padding: 30px;
            text-align: center;
        }
        
        .content-header h2 {
            font-size: 28px;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }
        
        .content-header .subtitle {
            opacity: 0.9;
            font-size: 16px;
        }
        
        .content-body {
            padding: 30px;
        }
        
        .status-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: linear-gradient(135deg, #1ABC9C, #16A085);
            color: white;
            padding: 20px 25px;
            border-radius: 15px;
            margin-bottom: 25px;
            box-shadow: 0 8px 25px rgba(26, 188, 156, 0.2);
        }
        
        .user-count {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 18px;
            font-weight: bold;
        }
        
        .count-number {
            background: rgba(255,255,255,0.2);
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 20px;
        }
        
        .refresh-section {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .refresh-btn {
            background: rgba(255,255,255,0.2);
            color: white;
            border: 2px solid rgba(255,255,255,0.3);
            padding: 10px 18px;
            border-radius: 25px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .refresh-btn:hover {
            background: rgba(255,255,255,0.3);
            border-color: rgba(255,255,255,0.5);
            transform: translateY(-1px);
        }
        
        .last-updated {
            font-size: 13px;
            opacity: 0.9;
        }
        
        /* User List */
        .user-list {
            list-style: none;
            display: grid;
            gap: 12px;
        }
        
        .user-item {
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            padding: 18px 25px;
            border-radius: 12px;
            border-left: 4px solid #1ABC9C;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        .user-item:hover {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            transform: translateX(8px);
            box-shadow: 0 5px 20px rgba(26, 188, 156, 0.15);
            border-left-color: #16A085;
        }
        
        .online-indicator {
            width: 12px;
            height: 12px;
            background: #1ABC9C;
            border-radius: 50%;
            animation: pulse 2s infinite;
            box-shadow: 0 0 0 4px rgba(26, 188, 156, 0.3);
        }
        
        @keyframes pulse {
            0% { 
                box-shadow: 0 0 0 0 rgba(26, 188, 156, 0.7);
            }
            70% { 
                box-shadow: 0 0 0 10px rgba(26, 188, 156, 0);
            }
            100% { 
                box-shadow: 0 0 0 0 rgba(26, 188, 156, 0);
            }
        }
        
        .username {
            font-weight: 600;
            color: #2C3E50;
            font-size: 16px;
        }
        
        .user-status {
            margin-left: auto;
            background: #1ABC9C;
            color: white;
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .no-users {
            text-align: center;
            padding: 60px 30px;
            color: #7f8c8d;
        }
        
        .no-users-icon {
            font-size: 48px;
            margin-bottom: 20px;
            opacity: 0.7;
        }
        
        .no-users h3 {
            color: #34495E;
            margin-bottom: 10px;
            font-size: 22px;
        }
        
        .no-users p {
            font-size: 16px;
            opacity: 0.8;
        }
        
        /* Loading State */
        .loading {
            display: none;
            text-align: center;
            padding: 20px;
            color: #7f8c8d;
            font-style: italic;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .nav-container {
                flex-direction: column;
                gap: 15px;
                padding: 0 15px;
            }
            
            .nav-buttons {
                width: 100%;
                justify-content: center;
            }
            
            .container {
                margin: 0 10px;
                border-radius: 15px;
            }
            
            .content-header {
                padding: 25px 20px;
            }
            
            .content-header h2 {
                font-size: 24px;
                flex-direction: column;
                gap: 8px;
            }
            
            .content-body {
                padding: 20px;
            }
            
            .status-section {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .refresh-section {
                flex-direction: column;
                gap: 10px;
            }
            
            .user-item {
                padding: 15px 20px;
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .user-status {
                margin-left: 0;
                align-self: flex-end;
            }
        }
        
        @media (max-width: 480px) {
            .main-content {
                padding: 15px 10px;
            }
            
            .nav-btn {
                padding: 8px 16px;
                font-size: 13px;
            }
        }
        
        /* Animation enhancements */
        .user-item:nth-child(odd) {
            animation: slideInLeft 0.6s ease-out;
        }
        
        .user-item:nth-child(even) {
            animation: slideInRight 0.6s ease-out;
        }
        
        @keyframes slideInLeft {
            from {
                opacity: 0;
                transform: translateX(-30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="nav-container">
            <div class="logo">
                <span>🏠</span>
                <span>Online Users Manager</span>
            </div>
            <div class="nav-buttons">
                <a href="home.jsp" class="nav-btn btn-home">
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
            
            setTimeout(function() {
                window.location.reload();
            }, 800);
        }
        
        // Auto refresh every 30 seconds
        let autoRefreshInterval = setInterval(function() {
            refreshPage();
        }, 30000);
        
        // Pause auto refresh when user is not on the page
        document.addEventListener('visibilitychange', function() {
            if (document.hidden) {
                clearInterval(autoRefreshInterval);
            } else {
                autoRefreshInterval = setInterval(function() {
                    refreshPage();
                }, 30000);
                updateLastUpdated();
            }
        });
        
        // Initialize
        updateLastUpdated();
        
        // Keyboard shortcuts
        document.addEventListener('keydown', function(e) {
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
        document.addEventListener('DOMContentLoaded', function() {
            document.documentElement.style.scrollBehavior = 'smooth';
        });
    </script>
</body>
</html>