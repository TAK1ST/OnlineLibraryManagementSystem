package listener;

import entity.User;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSessionAttributeListener;
import jakarta.servlet.http.HttpSessionBindingEvent;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;
import service.implement.OnlineUserManager;

/**
 * Listener để theo dõi người dùng online/offline
 * @author CAU_TU
 */
@WebListener
public class OnlineUserTrackerListener implements HttpSessionAttributeListener, HttpSessionListener {

    // Khi người dùng đăng nhập → thêm vào danh sách
    @Override
    public void attributeAdded(HttpSessionBindingEvent event) {
        if ("loginedUser".equals(event.getName())) { 
            // Giả sử loginedUser là một object có email và name
            Object userObj = event.getValue();
            
            // Nếu userObj là String (email), bạn cần lấy tên từ database
            // Hoặc nếu là User object, lấy trực tiếp
            if (userObj != null) {
                String userInfo = userObj.toString();
                
                // Kiểm tra xem có phải là User object không
                if (userObj instanceof User) {
                    User user = (User) userObj;
                    OnlineUserManager.addUser(user.getEmail(), user.getName());
                } else {
                    // Nếu chỉ là String email, cần lấy tên từ database
                    // Tạm thời sử dụng email làm display name
                    String email = userInfo;
                    String displayName = extractDisplayName(email); // Hàm tự tạo
                    OnlineUserManager.addUser(email, displayName);
                }
            }
        }
    }

    // Khi attribute bị remove (ví dụ user logout) → xóa khỏi danh sách
    @Override
    public void attributeRemoved(HttpSessionBindingEvent event) {
        if ("loginedUser".equals(event.getName())) {
            Object userObj = event.getValue();
            if (userObj != null) {
                String email = extractEmail(userObj);
                OnlineUserManager.removeUser(email);
            }
        }
    }

    // Khi session hết hạn → kiểm tra và xóa user nếu còn trong danh sách
    @Override
    public void sessionDestroyed(HttpSessionEvent event) {
        Object userObj = event.getSession().getAttribute("loginedUser");
        if (userObj != null) {
            String email = extractEmail(userObj);
            OnlineUserManager.removeUser(email);
        }
    }

    // Optional: không cần xử lý khi session created
    @Override
    public void sessionCreated(HttpSessionEvent event) {
        // Do nothing
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
     * Trích xuất tên hiển thị từ email hoặc user object
     * Bạn có thể customize hàm này để lấy tên từ database
     */
    private String extractDisplayName(String email) {
        // Cách 1: Lấy phần trước @ của email
        if (email.contains("@")) {
            return email.substring(0, email.indexOf("@"));
        }
        
        // Cách 2: Query database để lấy tên thật
        // UserDAO userDAO = new UserDAO();
        // User user = userDAO.getUserByEmail(email);
        // return user != null ? user.getName() : email;
        
        return email; // Fallback
    }
}