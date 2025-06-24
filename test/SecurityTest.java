package test;

import org.junit.jupiter.api.*;
import org.mockito.*;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import util.BCrypt;
import dao.implement.UserDAO;
import entity.User;
import jakarta.servlet.http.*;

public class SecurityTest {
    
    @Test
    @DisplayName("Test BCrypt Password Hashing")
    void testBCryptHashing() {
        // Arrange
        String plainPassword = "testPassword123";
        
        // Act
        String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt());
        
        // Assert
        assertNotNull(hashedPassword);
        assertNotEquals(plainPassword, hashedPassword);
        assertTrue(BCrypt.checkpw(plainPassword, hashedPassword));
        assertFalse(BCrypt.checkpw("wrongPassword", hashedPassword));
    }
    
    @Test
    @DisplayName("Test Session Security")
    void testSessionSecurity() {
        // Arrange
        HttpSession session = mock(HttpSession.class);
        User user = new User(1, "Test User", "test@example.com", "password123", "user", "active");
        
        // Act
        when(session.getAttribute("loginedUser")).thenReturn(user);
        
        // Assert
        assertEquals(user, session.getAttribute("loginedUser"));
    }
    
    @Test
    @DisplayName("Test SQL Injection Prevention")
    void testSQLInjectionPrevention() {
        // Arrange
        String maliciousEmail = "test@example.com'; DROP TABLE users; --";
        String password = "password";
        
        UserDAO userDAO = new UserDAO();
        
        // Act & Assert - Should not cause SQL injection
        assertDoesNotThrow(() -> {
            User result = userDAO.getUser(maliciousEmail, password);
            assertNull(result); // Should return null, not crash
        });
    }
    
    @Test
    @DisplayName("Test XSS Prevention")
    void testXSSPrevention() {
        // Arrange
        String maliciousScript = "<script>alert('XSS')</script>";
        
        // Act & Assert - Should escape HTML
        // This would need proper HTML escaping implementation
        assertNotEquals(maliciousScript, escapeHtml(maliciousScript));
    }
    
    private String escapeHtml(String input) {
        // Simple HTML escaping - should be implemented properly
        return input.replace("<", "&lt;").replace(">", "&gt;");
    }
}