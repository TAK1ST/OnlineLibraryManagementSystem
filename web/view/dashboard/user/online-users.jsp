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
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            animation: fadeIn 0.5s ease-in;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: #333;
            border-bottom: 3px solid #4CAF50;
            padding-bottom: 15px;
            margin-bottom: 25px;
        }
        
        .header h2 {
            margin: 0;
            font-size: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .count {
            background: linear-gradient(45deg, #4CAF50, #45a049);
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 20px;
            display: inline-block;
            box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
        }
        
        .user-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .user-item {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            margin: 8px 0;
            padding: 15px 20px;
            border-radius: 10px;
            border-left: 5px solid #4CAF50;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .user-item:hover {
            background: linear-gradient(135deg, #e8f5e8 0%, #d4edda 100%);
            transform: translateX(5px);
            box-shadow: 0 5px 15px rgba(76, 175, 80, 0.2);
        }
        
        .online-indicator {
            color: #4CAF50;
            font-size: 20px;
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.5; }
            100% { opacity: 1; }
        }
        
        .username {
            font-weight: 600;
            color: #333;
            font-size: 16px;
        }
        
        .no-users {
            color: #666;
            font-style: italic;
            text-align: center;
            padding: 40px;
            background: #f8f9fa;
            border-radius: 10px;
            border: 2px dashed #dee2e6;
        }
        
        .refresh-btn {
            background: linear-gradient(45deg, #4CAF50, #45a049);
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .refresh-btn:hover {
            background: linear-gradient(45deg, #45a049, #3d8b40);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(76, 175, 80, 0.4);
        }
        
        .refresh-btn:active {
            transform: translateY(0);
        }
        
        .status-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 10px;
        }
        
        .last-updated {
            color: #666;
            font-size: 14px;
            font-style: italic;
        }
        
        .loading {
            display: none;
            color: #666;
            font-style: italic;
        }
        
        @media (max-width: 600px) {
            .container {
                margin: 10px;
                padding: 20px;
            }
            
            .header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .status-bar {
                flex-direction: column;
                align-items: stretch;
            }
            
            .user-item {
                padding: 12px 15px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>
                <span>👥</span>
                Người dùng đang online
            </h2>
            <button class="refresh-btn" onclick="refreshPage()">
                <span>🔄</span>
                Làm mới
            </button>
        </div>
        
        <div class="status-bar">
            <div class="count">
                Tổng cộng: <strong>${userCount}</strong> người đang online
            </div>
            <div class="last-updated">
                Cập nhật lúc: <span id="lastUpdated"></span>
            </div>
        </div>
        
        <div class="loading" id="loading">
            Đang tải dữ liệu...
        </div>
        
        <c:choose>
            <c:when test="${empty onlineUsers}">
                <div class="no-users">
                    <h3>🔍 Không có người dùng nào đang online</h3>
                    <p>Hãy thử làm mới trang để kiểm tra lại</p>
                </div>
            </c:when>
            <c:otherwise>
                <ul class="user-list">
                    <c:forEach var="username" items="${onlineUsers}">
                        <li class="user-item">
                            <span class="online-indicator">●</span>
                            <span class="username">
                                <c:out value="${username}" escapeXml="true"/>
                            </span>
                        </li>
                    </c:forEach>
                </ul>
            </c:otherwise>
        </c:choose>
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
            document.getElementById('loading').style.display = 'block';
            setTimeout(function() {
                window.location.reload();
            }, 500);
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
        });
        
        // Show notification when users come online/offline
        let previousUserCount = ${userCount};
        
        function checkForUpdates() {
            fetch(window.location.href)
                .then(response => response.text())
                .then(html => {
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(html, 'text/html');
                    const newCount = doc.querySelector('.count strong').textContent;
                    
                    if (parseInt(newCount) !== previousUserCount) {
                        previousUserCount = parseInt(newCount);
                        showNotification('Danh sách người dùng đã được cập nhật!');
                    }
                })
                .catch(error => console.log('Error checking updates:', error));
        }
        
        function showNotification(message) {
            // Simple notification - you can enhance this with a proper notification system
            const notification = document.createElement('div');
            notification.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                background: #4CAF50;
                color: white;
                padding: 15px 20px;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.3);
                z-index: 1000;
                animation: slideIn 0.3s ease;
            `;
            notification.textContent = message;
            document.body.appendChild(notification);
            
            setTimeout(() => {
                notification.remove();
            }, 3000);
        }
        
        // Check for updates every 10 seconds (without full page reload)
        setInterval(checkForUpdates, 10000);
    </script>
</body>
</html>