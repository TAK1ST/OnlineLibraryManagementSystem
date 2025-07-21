<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="entity.User"%>
<!DOCTYPE html>
<html lang="en">
      <head>
            <meta charset="UTF-8">
            <title>User Chat Support</title>
            <style>
                  body {
                        font-family: Arial, sans-serif;
                        margin: 0;
                        padding: 20px;
                        background-color: #f5f5f5;
                  }

                  .connection-status {
                        text-align: center;
                        padding: 10px;
                        margin-bottom: 20px;
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

                  #chat-box {
                        position: fixed;
                        bottom: 20px;
                        right: 20px;
                        width: 350px;
                        height: 450px;
                        background: #ffffff;
                        border: 1px solid #ddd;
                        border-radius: 10px;
                        display: flex;
                        flex-direction: column;
                        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                        font-family: sans-serif;
                        z-index: 1000;
                  }

                  .chat-header {
                        background: #007bff;
                        color: white;
                        padding: 15px;
                        border-radius: 10px 10px 0 0;
                        text-align: center;
                        font-weight: bold;
                  }

                  #chat-messages {
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

                  .message {
                        padding: 8px 12px;
                        border-radius: 18px;
                        max-width: 80%;
                        word-wrap: break-word;
                        position: relative;
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

                  .message.error {
                        background: #f8d7da;
                        color: #721c24;
                        align-self: center;
                        font-size: 12px;
                        text-align: center;
                        max-width: 90%;
                  }

                  .message-time {
                        font-size: 10px;
                        opacity: 0.7;
                        margin-top: 4px;
                  }

                  #chat-input {
                        display: flex;
                        padding: 15px;
                        gap: 10px;
                        background: white;
                        border-radius: 0 0 10px 10px;
                  }

                  #message-input {
                        flex: 1;
                        padding: 12px;
                        border: 1px solid #ddd;
                        border-radius: 20px;
                        outline: none;
                        font-size: 14px;
                        resize: none;
                        max-height: 60px;
                  }

                  #message-input:focus {
                        border-color: #007bff;
                        box-shadow: 0 0 0 2px rgba(0,123,255,0.25);
                  }

                  #send-button {
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

                  #send-button:hover:not(:disabled) {
                        background: #0056b3;
                  }

                  #send-button:disabled {
                        background: #6c757d;
                        cursor: not-allowed;
                  }
            </style>
      </head>
      <body>
            <%
                User loginedUser = (User) session.getAttribute("loginedUser");
                String username = loginedUser != null ? loginedUser.getName() : "Unknown";
            %>

            <div id="connection-status" class="connection-status status-connecting">
                  🔌 Đang kết nối với hệ thống hỗ trợ...
            </div>

            <div id="chat-box">
                  <div class="chat-header">
                        💬 Chat Hỗ Trợ - <%= username %>
                  </div>
                  <div id="chat-messages">
                        <div class="message system">
                              Xin chào <%= username %>! Vui lòng đợi kết nối với admin...
                        </div>
                  </div>
                  <div id="chat-input">
                        <textarea 
                              id="message-input" 
                              placeholder="Nhập tin nhắn của bạn..." 
                              rows="1"
                              disabled></textarea>
                        <button id="send-button" onclick="sendMessage()" disabled>Gửi</button>
                  </div>
            </div>

            <script>
                  let ws;
                  let isConnected = false;
                  let connectionAttempts = 0;
                  const maxConnectionAttempts = 5;
                  const currentUsername = '<%= username %>';

                  console.log("🚀 Initializing chat for user:", currentUsername);

                  function connect() {
                        try {
                              const wsUrl = 'ws://localhost:8084/OnlineLibraryManagementSystem/chat';
                              console.log("🔌 Attempting to connect to:", wsUrl);
                              updateConnectionStatus("Đang kết nối...", "connecting");

                              ws = new WebSocket(wsUrl);

                              ws.onopen = () => {
                                    console.log("✅ WebSocket connected successfully");
                                    isConnected = true;
                                    connectionAttempts = 0;
                                    updateConnectionStatus("Đã kết nối với hệ thống hỗ trợ", "connected");
                                    enableChatInput();
                                    addSystemMessage("✅ Kết nối thành công! Bạn có thể bắt đầu chat.");
                              };

                              ws.onmessage = (event) => {
                                    console.log("📨 Received message:", event.data);
                                    handleIncomingMessage(event.data);
                              };

                              ws.onclose = (event) => {
                                    console.log("❌ WebSocket connection closed:", event);
                                    isConnected = false;
                                    disableChatInput();
                                    if (connectionAttempts < maxConnectionAttempts) {
                                          connectionAttempts++;
                                          updateConnectionStatus(`Mất kết nối - Đang thử lại lần ${connectionAttempts}...`, "disconnected");
                                          setTimeout(connect, 3000);
                                    } else {
                                          updateConnectionStatus("Không thể kết nối với hệ thống hỗ trợ", "disconnected");
                                          addErrorMessage("❌ Không thể kết nối với admin. Vui lòng tải lại trang.");
                                    }
                              };

                              ws.onerror = (error) => {
                                    console.error("❌ WebSocket error:", error);
                                    updateConnectionStatus("Lỗi kết nối", "disconnected");
                              };
                        } catch (error) {
                              console.error("❌ Failed to create WebSocket:", error);
                              updateConnectionStatus("Không thể tạo kết nối", "disconnected");
                        }
                  }

                  function updateConnectionStatus(message, status) {
                        const statusEl = document.getElementById("connection-status");
                        if (statusEl) {
                              statusEl.textContent = message;
                              statusEl.className = `connection-status status-${status}`;
                        } else {
                              console.error("❌ Element with ID 'connection-status' not found");
                        }
                  }

                  function handleIncomingMessage(message) {
                        console.log("🔍 Processing message:", message);
                        if (message.startsWith("👨‍💼 Admin:")) {
                              const adminMsg = message.substring("👨‍💼 Admin:".length).trim();
                              console.log("✅ Admin message received:", adminMsg);
                              addAdminMessage(adminMsg);
                              return;
                        }
                        if (message.startsWith("SYSTEM:")) {
                              const systemMsg = message.substring("SYSTEM:".length).trim();
                              addSystemMessage(systemMsg);
                              return;
                        }
                        if (message.startsWith("ERROR:")) {
                              const errorMsg = message.substring("ERROR:".length).trim();
                              addErrorMessage(`❌ ${errorMsg}`);
                              return;
                        }
                        addSystemMessage(message);
                  }

                  function addSystemMessage(content) {
                        addMessage(content, 'system');
                  }

                  function addErrorMessage(content) {
                        addMessage(content, 'error');
                  }

                  function addUserMessage(content) {
                        addMessage(content, 'user');
                  }

                  function addAdminMessage(content) {
                        addMessage(content, 'admin');
                  }

                  function addMessage(content, type) {
                        const chatMessages = document.getElementById("chat-messages");
                        if (chatMessages) {
                              const messageEl = document.createElement("div");
                              messageEl.className = `message ${type}`;
                              const now = new Date();
                              const timeStr = now.toLocaleTimeString('vi-VN', {hour: '2-digit', minute: '2-digit'});
                              if (type === 'system' || type === 'error') {
                                    messageEl.textContent = content;
                              } else {
                                    messageEl.innerHTML = `
                                <div>${content}</div>
                                <div class="message-time">${timeStr}</div>
                            `;
                              }
                              chatMessages.appendChild(messageEl);
                              console.log("✅ Added message to DOM:", content, "Type:", type);
                              scrollToBottom();
                        } else {
                              console.error("❌ Element with ID 'chat-messages' not found");
                        }
                  }

                  function sendMessage() {
                        if (!isConnected || !ws || ws.readyState !== WebSocket.OPEN) {
                              console.warn("❌ Cannot send - Not connected");
                              addErrorMessage("⚠️ Chưa kết nối với hệ thống. Vui lòng đợi...");
                              return;
                        }
                        const messageInput = document.getElementById("message-input");
                        if (messageInput) {
                              const message = messageInput.value.trim();
                              if (!message) {
                                    return;
                              }
                              try {
                                    console.log("📤 Sending message:", message);
                                    ws.send(message);
                                    addUserMessage(message);
                                    messageInput.value = '';
                                    messageInput.focus();
                                    console.log("✅ Message sent successfully");
                              } catch (error) {
                                    console.error("❌ Failed to send message:", error);
                                    addErrorMessage("❌ Không thể gửi tin nhắn. Vui lòng thử lại.");
                              }
                        } else {
                              console.error("❌ Element with ID 'message-input' not found");
                        }
                  }

                  function enableChatInput() {
                        const messageInput = document.getElementById("message-input");
                        const sendButton = document.getElementById("send-button");
                        if (messageInput && sendButton) {
                              messageInput.disabled = false;
                              sendButton.disabled = false;
                              messageInput.focus();
                        } else {
                              console.error("❌ Element with ID 'message-input' or 'send-button' not found");
                        }
                  }

                  function disableChatInput() {
                        const messageInput = document.getElementById("message-input");
                        const sendButton = document.getElementById("send-button");
                        if (messageInput && sendButton) {
                              messageInput.disabled = true;
                              sendButton.disabled = true;
                        } else {
                              console.error("❌ Element with ID 'message-input' or 'send-button' not found");
                        }
                  }

                  function scrollToBottom() {
                        const chatMessages = document.getElementById("chat-messages");
                        if (chatMessages) {
                              chatMessages.scrollTop = chatMessages.scrollHeight;
                              console.log("✅ Scrolled to bottom of chat-messages");
                        } else {
                              console.error("❌ Element with ID 'chat-messages' not found");
                        }
                  }

                  document.addEventListener("DOMContentLoaded", function () {
                        console.log("🚀 Initializing user chat interface for:", currentUsername);
                        const messageInput = document.getElementById("message-input");
                        if (messageInput) {
                              messageInput.addEventListener("keydown", function (e) {
                                    if (e.key === "Enter" && !e.shiftKey) {
                                          e.preventDefault();
                                          sendMessage();
                                    }
                              });
                        } else {
                              console.error("❌ Element with ID 'message-input' not found");
                        }
                        connect();
                  });

                  window.addEventListener("beforeunload", function () {
                        if (ws && ws.readyState === WebSocket.OPEN) {
                              ws.close();
                        }
                  });

                  document.addEventListener("visibilitychange", function () {
                        if (!document.hidden && !isConnected) {
                              console.log("👁️ Page visible again, attempting reconnect...");
                              connect();
                        }
                  });
            </script>
      </body>
</html>