package service.implement;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Quản lý người dùng đang online
 * @author CAU_TU
 */
public class OnlineUserManager {
    // Lưu trữ danh sách người dùng online với tên hiển thị
    private static final Set<String> onlineUsers = Collections.synchronizedSet(new HashSet<>());
    
    // Map để lưu trữ thông tin chi tiết người dùng (email -> tên hiển thị)
    private static final ConcurrentHashMap<String, String> userDisplayNames = new ConcurrentHashMap<>();
    
    /**
     * Thêm người dùng vào danh sách online
     * @param email Email của người dùng
     * @param displayName Tên hiển thị của người dùng
     */
    public static void addUser(String email, String displayName) {
        if (email != null && displayName != null) {
            userDisplayNames.put(email, displayName);
            onlineUsers.add(displayName);
        }
    }
    
    /**
     * Xóa người dùng khỏi danh sách online
     * @param email Email của người dùng
     */
    public static void removeUser(String email) {
        if (email != null) {
            String displayName = userDisplayNames.remove(email);
            if (displayName != null) {
                onlineUsers.remove(displayName);
            }
        }
    }
    
    /**
     * Lấy danh sách tên hiển thị của người dùng online
     * @return Set chứa tên hiển thị của những người dùng đang online
     */
    public static Set<String> getOnlineUsers() {
        return new HashSet<>(onlineUsers); // Trả về copy để tránh modification
    }
    
    /**
     * Lấy số lượng người dùng đang online
     * @return Số lượng người dùng online
     */
    public static int getOnlineUserCount() {
        return onlineUsers.size();
    }
    
    /**
     * Kiểm tra xem người dùng có đang online không
     * @param email Email của người dùng
     * @return true nếu đang online, false nếu không
     */
    public static boolean isUserOnline(String email) {
        return userDisplayNames.containsKey(email);
    }
    
    /**
     * Lấy tên hiển thị từ email
     * @param email Email của người dùng
     * @return Tên hiển thị hoặc null nếu không tìm thấy
     */
    public static String getDisplayName(String email) {
        return userDisplayNames.get(email);
    }
    
    /**
     * Xóa tất cả người dùng (dùng cho testing hoặc reset)
     */
    public static void clearAll() {
        onlineUsers.clear();
        userDisplayNames.clear();
    }
}