<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
      <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Admin Chat Support Dashboard</title>
            <style>
                  body {
                        font-family: Arial, sans-serif;
                        margin: 0;
                        padding: 20px;
                        background-color: #f5f5f5;
                  }

                  .header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding: 10px 20px;
                        background: #007bff;
                        color: white;
                        border-radius: 5px;
                  }

                  .header a {
                        text-decoration: none;
                        color: white;
                        font-size: 24px;
                  }

                  .status {
                        text-align: center;
                        padding: 10px;
                        margin-top: 10px;
                        border-radius: 5px;
                        font-weight: bold;
                  }

                  .status-connecting {
                        background-color: #fff3cd;
                        color: #856404;
                        border: 1px solid #ffeaa7;
                  }

                  .status-connected {
                        background-color: #d4edda;
                        color: #155724;
                        border: 1px solid #c3e6cb;
                  }

                  .status-disconnected {
                        background-color: #f8d7da;
                        color: #721c24;
                        border: 1px solid #f5c6cb;
                  }

                  .main-container {
                        display: flex;
                        gap: 20px;
                        max-width: 1200px;
                        margin: 20px auto;
                  }

                  .sidebar {
                        width: 250px;
                        background: #ffffff;
                        border: 1px solid #ddd;
                        border-radius: 10px;
                        padding: 15px;
                        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                  }

                  .users-header {
                        font-weight: bold;
                        margin-bottom: 10px;
                        display: flex;
                        justify-content: space-between;
                  }

                  .users-list {
                        max-height: 500px;
                        overflow-y: auto;
                  }

                  .user-item {
                        padding: 10px;
                        margin: 5px 0;
                        background: #e9ecef;
                        border-radius: 5px;
                        cursor: pointer;
                  }

                  .user-item.online {
                        background: #d4edda;
                        color: #155724;
                  }

                  .chat-container {
                        flex: 1;
                        height: 500px;
                        background: #ffffff;
                        border: 1px solid #ddd;
                        border-radius: 10px;
                        display: flex;
                        flex-direction: column;
                        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                  }

                  .chat-header {
                        background: #007bff;
                        color: white;
                        padding: 15px;
                        border-radius: 10px 10px 0 0;
                        display: flex;
                        align-items: center;
                        gap: 10px;
                  }

                  .current-user-avatar {
                        width: 40px;
                        height: 40px;
                        background: #e9ecef;
                        border-radius: 50%;
                  }

                  .current-user-info h3 {
                        margin: 0;
                        font-size: 18px;
                  }

                  .current-user-status span {
                        font-size: 14px;
                        color: #d4edda;
                  }

                  .messages-container {
                        flex: 1;
                        padding: 15px;
                        overflow-y: auto;
                        background: #fafafa;
                        border-bottom: 1px solid #eee;
                        display: flex;
                        flex-direction: column;
                        gap: 10px;
                        min-height: 0; /* Đảm bảo container co lại đúng */
                  }

                  .empty-state {
                        text-align: center;
                        color: #666;
                        margin-top: 50px;
                  }

                  .empty-state-icon {
                        font-size: 40px;
                        margin-bottom: 10px;
                  }

                  .message {
                        padding: 8px 12px;
                        border-radius: 18px;
                        max-width: 80%;
                        word-wrap: break-word;
                  }

                  .message.user {
                        background: #007bff;
                        color: white;
                        align-self: flex-end;
                        margin-left: auto;
                  }

                  .message.admin {
                        background: #e9ecef;
                        color: #333;
                        align-self: flex-start;
                        margin-right: auto;
                  }

                  .message.system {
                        background: #fff3cd;
                        color: #856404;
                        align-self: center;
                        font-size: 12px;
                        font-style: italic;
                        text-align: center;
                        max-width: 90%;
                  }

                  .message-time {
                        font-size: 10px;
                        opacity: 0.7;
                        margin-top: 4px;
                  }

                  .input-container {
                        display: flex;
                        padding: 15px;
                        gap: 10px;
                        background: white;
                        border-radius: 0 0 10px 10px;
                  }

                  .message-input {
                        flex: 1;
                        padding: 12px;
                        border: 1px solid #ddd;
                        border-radius: 20px;
                        outline: none;
                        font-size: 14px;
                        resize: none;
                        max-height: 60px;
                  }

                  .message-input:focus {
                        border-color: #007bff;
                        box-shadow: 0 0 0 2px rgba(0,123,255,0.25);
                  }

                  .send-button {
                        padding: 12px 20px;
                        background: #007bff;
                        color: white;
                        border: none;
                        border-radius: 20px;
                        cursor: pointer;
                        font-size: 14px;
                        font-weight: bold;
                        transition: background-color 0.2s;
                  }

                  .send-button:hover:not(:disabled) {
                        background: #0056b3;
                  }

                  .send-button:disabled {
                        background: #6c757d;
                        cursor: not-allowed;
                  }
            </style>
      </head>
      <body>
            <div class="header">
                  <div>
                        <h1>Admin Chat Support Dashboard</h1>
                        <div class="status status-connecting" id="connectionStatus">🔌 Đang kết nối với hệ thống hỗ trợ...</div>
                  </div>
                  <a href="admindashboard" style="text-decoration: none; color: white; font-size: 24px;">Back</a>
            </div>

            <div class="main-container">
                  <div class="sidebar">
                        <div class="users-header">
                              <span>Online Users</span>
                              <span class="online-count" id="onlineCount">0</span>
                        </div>
                        <div class="users-list" id="usersList"></div>
                  </div>

                  <div class="chat-container">
                        <div class="chat-header" id="chatHeader" style="display: none;">
                              <div class="current-user-avatar" id="currentAvatar"></div>
                              <div class="current-user-info">
                                    <h3 id="currentUserName"></h3>
                                    <div class="current-user-status">
                                          <span>Online</span>
                                    </div>
                              </div>
                        </div>

                        <div class="messages-container" id="messagesContainer">
                              <div class="empty-state" id="emptyState">
                                    <div class="empty-state-icon">💬</div>
                                    <h3>Vui lòng chọn một người dùng để bắt đầu hỗ trợ</h3>
                                    <p>Người dùng online sẽ xuất hiện ở bên trái khi họ kết nối</p>
                              </div>
                        </div>

                        <div class="input-container" id="inputContainer" style="display: none;">
                              <textarea 
                                    class="message-input" 
                                    id="messageInput" 
                                    placeholder="Nhập tin nhắn hỗ trợ của bạn..."
                                    rows="1"></textarea>
                              <button class="send-button" id="sendButton" onclick="sendMessage()">Gửi</button>
                        </div>
                  </div>
            </div>

            <script>
                  let ws;
                  let isConnected = false;
                  let selectedUser = null;

                  function connect() {
                        try {
                              const wsUrl = 'ws://localhost:8084/OnlineLibraryManagementSystem/chat';
                              console.log("🔌 Attempting to connect to:", wsUrl);
                              updateConnectionStatus("Đang kết nối...", "connecting");

                              ws = new WebSocket(wsUrl);

                              ws.onopen = () => {
                                    console.log("✅ WebSocket connected successfully");
                                    isConnected = true;
                                    updateConnectionStatus("Đã kết nối với hệ thống hỗ trợ", "connected");
                                    enableChatInput();
                                    addSystemMessage("✅ Kết nối thành công!");
                              };

                              ws.onmessage = (event) => {
                                    console.log("📨 Received message:", event.data);
                                    handleIncomingMessage(event.data);
                              };

                              ws.onclose = (event) => {
                                    console.log("❌ WebSocket connection closed:", event);
                                    isConnected = false;
                                    disableChatInput();
                                    updateConnectionStatus("Mất kết nối", "disconnected");
                                    addSystemMessage("❌ Mất kết nối với hệ thống.");
                              };

                              ws.onerror = (error) => {
                                    console.error("❌ WebSocket error:", error);
                                    updateConnectionStatus("Lỗi kết nối", "disconnected");
                                    addSystemMessage("❌ Lỗi kết nối với hệ thống.");
                              };
                        } catch (error) {
                              console.error("❌ Failed to create WebSocket:", error);
                              updateConnectionStatus("Không thể tạo kết nối", "disconnected");
                        }
                  }

                  function updateConnectionStatus(message, status) {
                        const statusEl = document.getElementById("connectionStatus");
                        if (statusEl) {
                              statusEl.textContent = message;
                              statusEl.className = `status status-${status}`;
                        } else {
                              console.error("❌ Element with ID 'connectionStatus' not found");
                        }
                  }

                  function handleIncomingMessage(message) {
                        console.log("🔍 Processing incoming message:", message);
                        if (message.startsWith("USER_ONLINE:")) {
                              const userId = message.substring("USER_ONLINE:".length).trim();
                              addOnlineUser(userId);
                              return;
                        }

                        if (message.startsWith("USER_OFFLINE:")) {
                              const userId = message.substring("USER_OFFLINE:".length).trim();
                              removeOnlineUser(userId);
                              return;
                        }

                        if (message.startsWith("From ")) {
                              // Sửa cách parse tin nhắn từ user
                              const fromIndex = message.indexOf("From ");
                              const colonIndex = message.indexOf(": ", fromIndex);
                              
                              if (colonIndex !== -1) {
                                    const userId = message.substring(fromIndex + 5, colonIndex).trim();
                                    const actualMsg = message.substring(colonIndex + 2).trim();
                                    
                                    console.log("📨 Message from user:", userId, "Content:", actualMsg);
                                    
                                    if (userId === selectedUser) {
                                          addUserMessage(actualMsg);
                                    } else {
                                          console.log("⚠️ Message from non-selected user:", userId);
                                          sessionStorage.setItem(`pendingMessage_${userId}`, actualMsg);
                                          addSystemMessage(`Tin nhắn mới từ ${userId}. Vui lòng chọn user để xem.`);
                                    }
                              }
                              return;
                        }

                        if (message.startsWith("SYSTEM:")) {
                              const systemMsg = message.substring("SYSTEM:".length).trim();
                              addSystemMessage(systemMsg);
                              return;
                        }

                        addSystemMessage(message);
                  }

                  function addOnlineUser(userId) {
                        const userList = document.getElementById("usersList");
                        if (userList) {
                              // Xóa user cũ nếu đã tồn tại để tránh trùng lặp
                              const existingItems = userList.getElementsByClassName("user-item");
                              for (let item of existingItems) {
                                    if (item.textContent === userId) {
                                          userList.removeChild(item);
                                    }
                              }
                              const userItem = document.createElement("div");
                              userItem.className = "user-item online";
                              userItem.textContent = userId;
                              userItem.onclick = () => selectUser(userId);
                              userList.appendChild(userItem);
                              updateOnlineCount();
                              console.log("✅ Added online user:", userId);
                              // Hiển thị tin nhắn đang chờ nếu có
                              const pendingMsg = sessionStorage.getItem(`pendingMessage_${userId}`);
                              if (pendingMsg && selectedUser === userId) {
                                    addUserMessage(pendingMsg);
                                    sessionStorage.removeItem(`pendingMessage_${userId}`);
                              }
                        } else {
                              console.error("❌ Element with ID 'usersList' not found");
                        }
                  }

                  function removeOnlineUser(userId) {
                        const userList = document.getElementById("usersList");
                        if (userList) {
                              const userItems = userList.getElementsByClassName("user-item");
                              for (let item of userItems) {
                                    if (item.textContent === userId) {
                                          userList.removeChild(item);
                                          break;
                                    }
                              }
                              if (selectedUser === userId) {
                                    selectedUser = null;
                                    const chatHeader = document.getElementById("chatHeader");
                                    if (chatHeader) {
                                          chatHeader.style.display = "none";
                                    }
                                    const messagesContainer = document.getElementById("messagesContainer");
                                    if (messagesContainer) {
                                          messagesContainer.innerHTML = `
                                    <div class="empty-state" id="emptyState">
                                        <div class="empty-state-icon">💬</div>
                                        <h3>Vui lòng chọn một người dùng để bắt đầu hỗ trợ</h3>
                                        <p>Người dùng online sẽ xuất hiện ở bên trái khi họ kết nối</p>
                                    </div>`;
                                    }
                                    const inputContainer = document.getElementById("inputContainer");
                                    if (inputContainer) {
                                          inputContainer.style.display = "none";
                                    }
                                    disableChatInput();
                              }
                              updateOnlineCount();
                              console.log("✅ Removed offline user:", userId);
                        } else {
                              console.error("❌ Element with ID 'usersList' not found");
                        }
                  }

                  function updateOnlineCount() {
                        const userList = document.getElementById("usersList");
                        const onlineCount = document.getElementById("onlineCount");
                        if (userList && onlineCount) {
                              onlineCount.textContent = userList.childElementCount;
                        } else {
                              console.error("❌ Element with ID 'usersList' or 'onlineCount' not found");
                        }
                  }

                  function selectUser(userId) {
                        selectedUser = userId;
                        console.log("✅ Selected user:", userId);
                        const chatHeader = document.getElementById("chatHeader");
                        const currentUserName = document.getElementById("currentUserName");
                        if (chatHeader && currentUserName) {
                              chatHeader.style.display = "flex";
                              currentUserName.textContent = userId;
                        } else {
                              console.error("❌ Element with ID 'chatHeader' or 'currentUserName' not found");
                        }
                        const messagesContainer = document.getElementById("messagesContainer");
                        if (messagesContainer) {
                              messagesContainer.innerHTML = "";
                        } else {
                              console.error("❌ Element with ID 'messagesContainer' not found");
                        }
                        const inputContainer = document.getElementById("inputContainer");
                        if (inputContainer) {
                              inputContainer.style.display = "flex";
                        } else {
                              console.error("❌ Element with ID 'inputContainer' not found");
                        }
                        enableChatInput();
                        // Hiển thị tin nhắn đang chờ nếu có
                        const pendingMsg = sessionStorage.getItem(`pendingMessage_${userId}`);
                        if (pendingMsg) {
                              addUserMessage(pendingMsg);
                              sessionStorage.removeItem(`pendingMessage_${userId}`);
                        }
                  }

                  function addSystemMessage(content) {
                        addMessage(content, "system");
                  }

                  function addUserMessage(content) {
                        addMessage(content, "user");
                  }

                  function addAdminMessage(content) {
                        addMessage(content, "admin");
                  }

                  function addMessage(content, type) {
                        const messagesContainer = document.getElementById("messagesContainer");
                        if (messagesContainer) {
                              const emptyState = document.getElementById("emptyState");
                              if (emptyState) {
                                    emptyState.remove();
                              }
                              const messageEl = document.createElement("div");
                              messageEl.className = `message ${type}`;
                              const now = new Date();
                              const timeStr = now.toLocaleTimeString("vi-VN", {hour: "2-digit", minute: "2-digit"});
                              if (type === "system") {
                                    messageEl.textContent = content;
                              } else {
                                    messageEl.innerHTML = `
                                <div>${content}</div>
                                <div class="message-time">${timeStr}</div>
                            `;
                              }
                              messagesContainer.appendChild(messageEl);
                              console.log("✅ Added message to DOM:", content, "Type:", type);
                              scrollToBottom();
                        } else {
                              console.error("❌ Element with ID 'messagesContainer' not found");
                        }
                  }

                  function sendMessage() {
                        if (!isConnected || !ws || ws.readyState !== WebSocket.OPEN) {
                              addSystemMessage("⚠ Chưa kết nối với hệ thống. Vui lòng đợi...");
                              return;
                        }
                        if (!selectedUser || selectedUser.trim() === "") {
                              addSystemMessage("⚠ Vui lòng chọn một người dùng để gửi tin nhắn.");
                              console.error("❌ No user selected for sending message");
                              return;
                        }
                        const messageInput = document.getElementById("messageInput");
                        if (messageInput) {
                              const message = messageInput.value.trim();
                              if (!message) {
                                    return;
                              }
                              try {
                                    console.log("📤 Sending message to:", selectedUser, "Content:", message);
                                    ws.send(`TO:${selectedUser}:${message}`);
                                    addAdminMessage(message);
                                    messageInput.value = "";
                                    messageInput.focus();
                              } catch (error) {
                                    console.error("❌ Failed to send message:", error);
                                    addSystemMessage("❌ Không thể gửi tin nhắn. Vui lòng thử lại.");
                              }
                        } else {
                              console.error("❌ Element with ID 'messageInput' not found");
                        }
                  }

                  function enableChatInput() {
                        if (selectedUser) {
                              const messageInput = document.getElementById("messageInput");
                              const sendButton = document.getElementById("sendButton");
                              if (messageInput && sendButton) {
                                    messageInput.disabled = false;
                                    sendButton.disabled = false;
                                    messageInput.focus();
                              } else {
                                    console.error("❌ Element with ID 'messageInput' or 'sendButton' not found");
                              }
                        }
                  }

                  function disableChatInput() {
                        const messageInput = document.getElementById("messageInput");
                        const sendButton = document.getElementById("sendButton");
                        if (messageInput && sendButton) {
                              messageInput.disabled = true;
                              sendButton.disabled = true;
                        } else {
                              console.error("❌ Element with ID 'messageInput' or 'sendButton' not found");
                        }
                  }

                  function scrollToBottom() {
                        const messagesContainer = document.getElementById("messagesContainer");
                        if (messagesContainer) {
                              messagesContainer.scrollTop = messagesContainer.scrollHeight;
                              console.log("✅ Scrolled to bottom of messagesContainer");
                        } else {
                              console.error("❌ Element with ID 'messagesContainer' not found");
                        }
                  }

                  document.addEventListener("DOMContentLoaded", function () {
                        console.log("🚀 Initializing admin chat interface");
                        const messageInput = document.getElementById("messageInput");
                        if (messageInput) {
                              messageInput.addEventListener("keydown", function (e) {
                                    if (e.key === "Enter" && !e.shiftKey) {
                                          e.preventDefault();
                                          sendMessage();
                                    }
                              });
                        } else {
                              console.error("❌ Element with ID 'messageInput' not found");
                        }
                        connect();
                  });

                  window.addEventListener("beforeunload", function () {
                        if (ws && ws.readyState === WebSocket.OPEN) {
                              ws.close();
                        }
                  });
            </script>
      </body>
</html>