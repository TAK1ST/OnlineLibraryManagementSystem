/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import dao.implement.UserDAO;
import entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import util.AsyncSupabaseImageService;

/**
 *
 * @author CAU_TU
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class SaveProfileServlet extends HttpServlet {

    public void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String action = request.getParameter("action");
            String id = request.getParameter("txtid");

            if (id == null || id.isEmpty()) {
                response.sendRedirect("ChangeProfile?error=invalid_user");
                return;
            }

            UserDAO userDAO = new UserDAO();
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("loginedUser");

            if (currentUser == null || currentUser.getId() != Integer.parseInt(id)) {
                response.sendRedirect("login.jsp?error=unauthorized");
                return;
            }

            if ("updateProfile".equals(action)) {
                handleProfileUpdate(request, response, userDAO, session, currentUser);
            } else if ("changePassword".equals(action)) {
                handlePasswordChange(request, response, userDAO, session, currentUser);
            } else {
                // Fallback for old behavior
                handleLegacyUpdate(request, response, userDAO, session);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ChangeProfile?error=system_error");
        }
    }

    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response,
            UserDAO userDAO, HttpSession session, User currentUser)
            throws ServletException, IOException {
        try {
            String name = request.getParameter("txtname");

            if (name == null || name.trim().isEmpty()) {
                response.sendRedirect("ChangeProfile?error=invalid_name");
                return;
            }

            // Handle avatar upload
            String avatarPath = null;
            Part filePart = request.getPart("avatar");
            if (filePart != null && filePart.getSize() > 0) {
                avatarPath = handleAvatarUpload(filePart, request);
                if (avatarPath == null) {
                    response.sendRedirect("ChangeProfile?error=upload_failed");
                    return;
                }
            }

            // Update user profile
            int result = userDAO.updateUserProfile(currentUser.getId(), name.trim(), avatarPath);

            if (result > 0) {
                // IMPORTANT: Always fetch fresh data from database after update
                User updatedUser = userDAO.getId(currentUser.getId());
                if (updatedUser != null) {
                    // Update session with fresh data - this ensures the view gets latest data
                    session.setAttribute("loginedUser", updatedUser);
                    System.out.println("Session updated with fresh user data: " + updatedUser.getName());
                } else {
                    System.out.println("Warning: Could not fetch updated user data from database");
                }
                response.sendRedirect("ChangeProfile?success=profile_updated");
            } else {
                response.sendRedirect("ChangeProfile?error=update_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ChangeProfile?error=system_error");
        }
    }

    private void handlePasswordChange(HttpServletRequest request, HttpServletResponse response,
            UserDAO userDAO, HttpSession session, User currentUser)
            throws ServletException, IOException {
        try {
            String currentPassword = request.getParameter("txtcurrentpassword");
            String newPassword = request.getParameter("txtnewpassword");
            String confirmPassword = request.getParameter("txtconfirmnewpassword");

            // Validate inputs
            if (currentPassword == null || currentPassword.trim().isEmpty()
                    || newPassword == null || newPassword.trim().isEmpty()
                    || confirmPassword == null || confirmPassword.trim().isEmpty()) {
                response.sendRedirect("ChangeProfile?error=empty_password_fields");
                return;
            }

            // Check if new passwords match
            if (!newPassword.equals(confirmPassword)) {
                response.sendRedirect("ChangeProfile?error=password_mismatch");
                return;
            }

            // Validate password strength
            if (!isPasswordStrong(newPassword)) {
                response.sendRedirect("ChangeProfile?error=weak_password");
                return;
            }

            // Verify current password
            if (!userDAO.verifyPassword(currentUser.getId(), currentPassword)) {
                response.sendRedirect("ChangeProfile?error=wrong_current_password");
                return;
            }

            // Update password
            int result = userDAO.updatePassword(currentUser.getId(), newPassword);

            if (result > 0) {
                response.sendRedirect("ChangeProfile?success=password_changed");
            } else {
                response.sendRedirect("ChangeProfile?error=password_update_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ChangeProfile?error=system_error");
        }
    }

    private void handleLegacyUpdate(HttpServletRequest request, HttpServletResponse response,
            UserDAO userDAO, HttpSession session)
            throws ServletException, IOException {
        try {
            String id = request.getParameter("txtid");
            String name = request.getParameter("txtname");
            String password = request.getParameter("txtpassword");

            if (id != null && name != null && password != null) {
                int result = userDAO.updateUser(Integer.parseInt(id), name, password, null);
                response.sendRedirect("ChangeProfile?success=updated");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ChangeProfile?error=system_error");
        }
    }

    private String handleAvatarUpload(Part filePart, HttpServletRequest request) {
        try {
            // Use Supabase instead of local storage
            String imageUrl = AsyncSupabaseImageService.uploadImageAsync(filePart, "avatars").get();
            
            if (imageUrl != null) {
                // Store the Supabase path in database (not full URL)
                String imagePath = imageUrl.replace(
                    "https://icdmgutnvthphneaxxsq.supabase.co/storage/v1/object/public/image.library/", 
                    ""
                );
                return imagePath;
            }
            
            return null;
            
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private boolean isPasswordStrong(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }

        boolean hasUpper = false;
        boolean hasLower = false;
        boolean hasDigit = false;
        boolean hasSpecial = false;

        for (char c : password.toCharArray()) {
            if (Character.isUpperCase(c)) {
                hasUpper = true;
            } else if (Character.isLowerCase(c)) {
                hasLower = true;
            } else if (Character.isDigit(c)) {
                hasDigit = true;
            } else if (!Character.isLetterOrDigit(c)) {
                hasSpecial = true;
            }
        }

        return hasUpper && hasLower && hasDigit && hasSpecial;
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Profile management servlet with avatar upload and password change functionality";
    }// </editor-fold>

}
