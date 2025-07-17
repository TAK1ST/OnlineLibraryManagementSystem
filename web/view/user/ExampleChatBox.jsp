<%-- 
    Document   : ExampleChatBox
    Created on : Jul 15, 2025, 1:48:10 AM
    Author     : asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
      <head>
            <meta charset="UTF-8">
            <title>User Page</title>
            <style>
                  /* Floating Chatbox Style */
                  #chat-box {
                        position: fixed;
                        bottom: 20px;
                        right: 20px;
                        width: 300px;
                        height: 400px;
                        background: #f1f1f1;
                        border: 1px solid #ccc;
                        border-radius: 10px;
                        display: flex;
                        flex-direction: column;
                        box-shadow: 0 0 10px rgba(0,0,0,0.2);
                        font-family: sans-serif;
                  }

                  #chat-messages {
                        flex: 1;
                        padding: 10px;
                        overflow-y: auto;
                        background: white;
                        border-bottom: 1px solid #ccc;
                  }

                  #chat-input {
                        display: flex;
                        padding: 10px;
                  }

                  #chat-input input {
                        flex: 1;
                        padding: 8px;
                        border: 1px solid #ccc;
                        border-radius: 4px;
                  }

                  #chat-input button {
                        margin-left: 5px;
                        padding: 8px 12px;
                        background: #007bff;
                        color: white;
                        border: none;
                        border-radius: 4px;
                        cursor: pointer;
                  }

                  #chat-input button:hover {
                        background: #0056b3;
                  }
            </style>
      </head>
      <body>

            <h2>Chào bạn đến với hệ thống hỗ trợ! 🛠</h2>
            <p>Nếu cần hỗ trợ, hãy dùng hộp chat bên dưới.</p>

            <div id="chat-box">
                  <div id="chat-messages"></div>
                  <div id="chat-input">
                        <input id="message" type="text" placeholder="Nhập tin nhắn..." />
                        <button onclick="sendMessage()">Gửi</button>
                  </div>
            </div>

            <script>
                  const ws = new WebSocket("ws://localhost:8084/OnlineLibraryManagementSystem/chat");

                  ws.onopen = () => {
                        appendMsg("✅ Đã kết nối với admin.");
                  };

                  ws.onmessage = (event) => {
                        appendMsg("📩 " + event.data);
                  };

                  function sendMessage() {
                        const msg = document.getElementById("message").value;
                        if (msg.trim() !== "") {
                              ws.send(msg); // gửi raw message thôi, không cần FROMUSER::
                              appendMsg("🙋 Bạn: " + msg);
                              document.getElementById("message").value = '';
                        }
                  }

                  function appendMsg(text) {
                        const chat = document.getElementById("chat-messages");
                        const msgElem = document.createElement("div");
                        msgElem.textContent = text;
                        chat.appendChild(msgElem);
                        chat.scrollTop = chat.scrollHeight; // auto scroll
                  }
            </script>
      </body>
</html>
