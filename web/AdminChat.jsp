<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
      <head>
            <title>Admin Chat</title>
            <style>
                  #chat {
                        height: 300px;
                        overflow-y: auto;
                        border: 1px solid #ccc;
                        margin-bottom: 10px;
                        padding: 5px;
                  }
                  input {
                        padding: 5px;
                  }
            </style>
      </head>
      <body>
            <h2>👨‍💼 Trang quản trị hỗ trợ</h2>
            <div id="chat"></div>

            <input id="targetUser" type="text" placeholder="User ID (vd: user123)" />
            <input id="message" type="text" placeholder="Nội dung tin nhắn..." />
            <button onclick="sendToUser()">Gửi</button>

            <script>
                  let ws;

                  function connect() {
                        ws = new WebSocket("ws://localhost:8084/OnlineLibraryManagementSystem/chat");

                        ws.onopen = () => {
                              append("✅ Kết nối WebSocket với tư cách admin");
                        };

                        ws.onmessage = (e) => {
                              append(e.data);
                        };

                        ws.onclose = () => {
                              append("⚠️ Mất kết nối. Đang thử lại sau 3 giây...");
                              setTimeout(connect, 3000);
                        };

                        ws.onerror = (e) => {
                              console.error("WebSocket error:", e);
                        };
                  }

                  connect(); // gọi khi trang load

                  function sendToUser() {
                        const uid = document.getElementById("targetUser").value;
                        const msg = document.getElementById("message").value;

                        if (!ws || ws.readyState !== WebSocket.OPEN) {
                              append("❌ WebSocket chưa kết nối hoặc đã đóng.");
                              return;
                        }

                        if (uid && msg) {
                              ws.send("TO:" + uid + ":" + msg);
                              append("📤 Đã gửi đến " + uid + ": " + msg);
                              document.getElementById("message").value = '';
                        }
                  }

                  function append(msg) {
                        const chat = document.getElementById("chat");
                        const div = document.createElement("div");
                        div.textContent = msg;
                        chat.appendChild(div);
                        chat.scrollTop = chat.scrollHeight;
                  }
            </script>
      </body>
</html>
