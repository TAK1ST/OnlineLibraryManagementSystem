package controller.admin;

import entity.User;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Base class for all admin controllers with authentication and authorization
 */
public abstract class BaseAdminController extends HttpServlet {
    
    /**
     * Check if user is authenticated and has admin role
     * @param request HTTP request
     * @param response HTTP response
     * @return User object if authenticated admin, null otherwise
     * @throws IOException if redirect fails
     */
    protected User checkAdminAuthentication(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false); 
        
        // Check if session exists
        if (session == null) {
            redirectToLogin(request, response);
            return null;
        }
        
        // Try to get user from session (check both possible attribute names)
        User user = (User) session.getAttribute("loginedUser");
        if (user == null) {
            user = (User) session.getAttribute("user");
        }
        
        // Check if user is logged in
        if (user == null) {
            redirectToLogin(request, response);
            return null;
        }
        
        // Check if user has admin role
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            redirectToLogin(request, response);
            return null;
        }
        
        // Check if user account is active
        if (!"active".equalsIgnoreCase(user.getStatus())) {
            session.invalidate();
            redirectToLogin(request, response);
            return null;
        }
        
        return user;
    }
    
    /**
     * Redirect to login page with current URL for redirect after login
     */
    private void redirectToLogin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();
        
        // Store current URL for redirect after login
        String currentUrl = request.getRequestURL().toString();
        if (request.getQueryString() != null) {
            currentUrl += "?" + request.getQueryString();
        }
        session.setAttribute("redirectUrl", currentUrl);
        
        // Redirect to login
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
    }
    
    /**
     * Set standard user session attribute (normalize to loginedUser)
       * @param request
       * @param user
     */
    protected void setUserSession(HttpServletRequest request, User user) {
        HttpSession session = request.getSession();
        session.setAttribute("loginedUser", user);
        // Also set "user" for backward compatibility
        session.setAttribute("user", user);
    }
}