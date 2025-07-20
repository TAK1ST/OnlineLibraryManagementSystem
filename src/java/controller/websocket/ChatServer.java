
import jakarta.servlet.http.HttpSession;
import jakarta.websocket.EndpointConfig;
import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;
import util.websocket.CustomConfigurator;

@ServerEndpoint(value = "/chat", configurator = CustomConfigurator.class)
public class ChatServer {

      private static final ConcurrentHashMap<Session, String> userSessions = new ConcurrentHashMap<>();
      private static final ConcurrentHashMap<String, Session> userMap = new ConcurrentHashMap<>();

      @OnOpen
      public void onOpen(Session session, EndpointConfig config) {
            HttpSession s = (HttpSession) config.getUserProperties().get("httpSession");

            if (s != null) {
                  String userId = (String) s.getAttribute("user_id");

                  if (userId != null) {
                        userSessions.put(session, userId);
                        userMap.put(userId, session);
                        System.out.println("✅ " + userId + " connected");
                  } else {
                        System.out.println("⚠ No user_id in session");
                  }
            } else {
                  System.out.println("❌ HttpSession is null");
            }
      }

      @OnMessage
      public void onMessage(String message, Session session) throws IOException {
            String senderId = userSessions.get(session);
            System.out.println("📨 Message from " + senderId + ": " + message);

            if ("admin".equals(senderId) && message.startsWith("TO:")) {
                  String[] parts = message.split(":", 3);
                  if (parts.length == 3) {
                        String targetUserId = parts[1];
                        String actualMsg = parts[2];
                        Session targetSession = userMap.get(targetUserId);
                        if (targetSession != null && targetSession.isOpen()) {
                              targetSession.getBasicRemote().sendText("👨‍💼 Admin: " + actualMsg);
                        } else {
                              session.getBasicRemote().sendText("❌ Không tìm thấy user: " + targetUserId);
                        }
                  }
            } else {
                  // User nhắn → gửi cho admin
                  Session adminSession = userMap.get("admin");
                  if (adminSession != null && adminSession.isOpen()) {
                        adminSession.getBasicRemote().sendText("📩 Từ " + senderId + ": " + message);
                  }
            }
      }

      @OnClose
      public void onClose(Session session) {
            String userId = userSessions.remove(session);
            if (userId != null) {
                  userMap.remove(userId);
                  System.out.println("❌ " + userId + " disconnected.");
            }
      }

      @OnError
      public void onError(Session session, Throwable throwable) {
            System.err.println("❗ Error: " + throwable.getMessage());
      }
}
