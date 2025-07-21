package controller.websocket;

import entity.User;
import jakarta.servlet.http.HttpSession;
import jakarta.websocket.EndpointConfig;
import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Arrays;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentLinkedQueue;
import util.websocket.CustomConfigurator;

@ServerEndpoint(value = "/chat", configurator = CustomConfigurator.class)
public class ChatServer {

      private static final ConcurrentHashMap<Session, String> userSessions = new ConcurrentHashMap<>();
      private static final ConcurrentHashMap<String, Session> userMap = new ConcurrentHashMap<>();
      private static final ConcurrentHashMap<String, ConcurrentLinkedQueue<String>> pendingMessages = new ConcurrentHashMap<>();

      @OnOpen
      public void onOpen(Session session, EndpointConfig config) {
            System.out.println("🔌 NEW CONNECTION ATTEMPT");
            try {

                  HttpSession httpSession = (HttpSession) config.getUserProperties().get("httpSession");

                  if (httpSession != null) {
                        User loginedUser = (User) httpSession.getAttribute("loginedUser");
                        String userId = null;

                        if (loginedUser != null) {
                              if ("admin".equals(loginedUser.getRole())) {
                                    userId = "admin";
                              } else {
                                    userId = loginedUser.getName();
                              }
                        }

                        System.out.println("📋 Session loginedUser: " + loginedUser);
                        System.out.println("📋 Extracted userId: " + userId);

                        if (userId != null) {
                              userSessions.put(session, userId);
                              userMap.put(userId, session);
                              System.out.println("✅ " + userId + " connected successfully");
                              System.out.println("📋 Current userMap: " + userMap.keySet());

                              if (!"admin".equals(userId)) {
                                    notifyAdminUserOnline(userId);
                                    // Gửi tin nhắn đang chờ (nếu có) khi user online
                                    ConcurrentLinkedQueue<String> pending = pendingMessages.get(userId);
                                    if (pending != null) {
                                          while (!pending.isEmpty()) {
                                                String msg = pending.poll();
                                                session.getBasicRemote().sendText(msg);
                                                System.out.println("✅ Sent pending message to " + userId + ": " + msg);
                                          }
                                          pendingMessages.remove(userId);
                                    }
                              } else {
                                    // Gửi danh sách user online cho admin khi admin kết nối
                                    userMap.keySet().stream()
                                            .filter(id -> !"admin".equals(id))
                                            .forEach(id -> notifyAdminUserOnline(id));
                              }
                        } else {
                              System.out.println("⚠WARNING: No valid user in session");
                        }
                  } else {
                        System.out.println("❌ ERROR: HttpSession is null");
                  }
            } catch (Exception e) {
                  e.printStackTrace();
            }

      }

      @OnMessage
      public void onMessage(String message, Session session) throws IOException {
            String senderId = userSessions.get(session);
            System.out.println("📨 RAW MESSAGE from " + senderId + ": " + message);

            if ("admin".equals(senderId) && message.startsWith("TO:")) {
                  String[] parts = message.split(":", 3);
                  if (parts.length == 3 && !parts[1].trim().isEmpty()) {
                        String targetUserId = parts[1].trim();
                        String actualMsg = parts[2].trim();
                        Session targetSession = userMap.get(targetUserId);

                        if (targetSession != null && targetSession.isOpen()) {
                              targetSession.getBasicRemote().sendText("👨‍💼 Admin: " + actualMsg);
                        } else {
                              // Lưu pending message
                              pendingMessages.computeIfAbsent(targetUserId, k -> new ConcurrentLinkedQueue<>())
                                      .add("👨‍💼 Admin: " + actualMsg);
                        }
                  }
            } else if (senderId != null && !"admin".equals(senderId)) {
                  Session adminSession = userMap.get("admin");
                  if (adminSession != null && adminSession.isOpen()) {
                        adminSession.getBasicRemote().sendText("From " + senderId + ": " + message);
                  } else {
                        // Lưu pending cho admin
                        pendingMessages.computeIfAbsent("admin", k -> new ConcurrentLinkedQueue<>())
                                .add("From " + senderId + ": " + message);
                  }
            }
      }

      @OnClose
      public void onClose(Session session) {
            String userId = userSessions.remove(session);
            if (userId != null) {
                  userMap.remove(userId);
                  System.out.println("❌ " + userId + " disconnected");
                  System.out.println("📋 Current userMap: " + userMap.keySet());
                  if (!"admin".equals(userId)) {
                        notifyAdminUserOffline(userId);
                  }
            }
      }

      private void notifyAdminUserOnline(String userId) {
            Session adminSession = userMap.get("admin");
            if (adminSession != null && adminSession.isOpen()) {
                  try {
                        adminSession.getBasicRemote().sendText("USER_ONLINE:" + userId);
                        System.out.println("📢 Notified admin: " + userId + " is online");
                  } catch (IOException e) {
                        System.out.println("❌ Failed to notify admin about user online: " + e.getMessage());
                  }
            }
      }

      private void notifyAdminUserOffline(String userId) {
            Session adminSession = userMap.get("admin");
            if (adminSession != null && adminSession.isOpen()) {
                  try {
                        adminSession.getBasicRemote().sendText("USER_OFFLINE:" + userId);
                        System.out.println("📢 Notified admin: " + userId + " is offline");
                  } catch (IOException e) {
                        System.out.println("❌ Failed to notify admin about user offline: " + e.getMessage());
                  }
            }
      }

      @OnError
      public void onError(Session session, Throwable throwable) {
            String userId = userSessions.get(session);
            System.err.println("❗ WebSocket Error for user " + userId + ": " + throwable.getMessage());
            throwable.printStackTrace();
            if (session.isOpen()) {
                  try {
                        session.getBasicRemote().sendText("ERROR: WebSocket connection error");
                  } catch (IOException e) {
                        System.err.println("❌ Failed to send error notification: " + e.getMessage());
                  }
            }
      }

      public static int getOnlineUsersCount() {
            return (int) userMap.keySet().stream()
                    .filter(userId -> !"admin".equals(userId))
                    .count();
      }

      public static String[] getOnlineUsers() {
            return userMap.keySet().stream()
                    .filter(userId -> !"admin".equals(userId))
                    .toArray(String[]::new);
      }
}
