package listener;

import entity.User;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;
import service.implement.OnlineUserManager;

/**
 * Listener để đếm số session online (bổ sung cho OnlineUserManager)
 * @author CAU_TU
 */
@WebListener
public class OnlineUserCounterListener implements HttpSessionListener {

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        // Không cần đếm session nữa vì đã có OnlineUserManager
        // Chỉ log để debug
//        System.out.println("Session created: " + se.getSession().getId());
//        System.out.println("Current online users: " + OnlineUserManager.getOnlineUserCount());
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        // Đảm bảo user được remove khỏi danh sách khi session hết hạn
        Object userObj = se.getSession().getAttribute("loginedUser");
        if (userObj != null) {
            String email = extractEmail(userObj);
            OnlineUserManager.removeUser(email);
        }
//        
//        System.out.println("Session destroyed: " + se.getSession().getId());
//        System.out.println("Current online users: " + OnlineUserManager.getOnlineUserCount());
    }
    
    /**
     * Trích xuất email từ user object
     */
    private String extractEmail(Object userObj) {
        if (userObj instanceof User) {
            return ((User) userObj).getEmail();
        }
        return userObj.toString(); // Giả sử toString trả về email
    }
    
    /**
     * Lấy số lượng người dùng online từ OnlineUserManager
     * @return Số lượng người dùng online
     */
    public static int getOnlineUsers() {
        return OnlineUserManager.getOnlineUserCount();
    }
}