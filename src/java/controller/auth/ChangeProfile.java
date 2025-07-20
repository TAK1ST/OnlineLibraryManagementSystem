/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.implement.UserManagerService;

/**
 *
 * @author CAU_TU
 */
public class ChangeProfile extends HttpServlet {

    private final UserManagerService userManagerService;

    public ChangeProfile() {
        this.userManagerService = new UserManagerService();
    }

    public void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Handle success and error messages
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        HttpSession session = request.getSession();

        // Get user from session (using consistent attribute name)
        User user = (User) session.getAttribute("loginedUser");

        if (user == null) {
            // If no user in session, redirect to login
            response.sendRedirect("view/auth/login.jsp");
            return;
        }

        // Always fetch fresh data from database to ensure we have the latest information
        User freshUser = userManagerService.getUserById(user.getId());

        if (freshUser != null) {
            // Update session with fresh data
            session.setAttribute("loginedUser", freshUser);
            // Set fresh data for the view
            request.setAttribute("user", freshUser);
        } else {
            // If user not found in database, use session data as fallback
            request.setAttribute("user", user);
        }

        // Handle success messages
        if (success != null) {
            request.setAttribute("successMessage", getSuccessMessage(success));
        }

        // Handle error messages
        if (error != null) {
            request.setAttribute("errorMessage", getErrorMessage(error));
        }

        // Forward to JSP
        request.getRequestDispatcher("view/dashboard/user/ChangeProfile.jsp").forward(request, response);
    }

    private String getSuccessMessage(String successCode) {
        switch (successCode) {
            case "profile_updated":
                return "Profile updated successfully!";
            case "password_changed":
                return "Password changed successfully!";
            case "updated":
                return "Information updated successfully!";
            default:
                return "Operation completed successfully!";
        }
    }

    private String getErrorMessage(String errorCode) {
        switch (errorCode) {
            case "invalid_user":
                return "Invalid user information.";
            case "unauthorized":
                return "You are not authorized to perform this action.";
            case "invalid_name":
                return "Please enter a valid name.";
            case "upload_failed":
                return "Failed to upload avatar. Please try again.";
            case "update_failed":
                return "Failed to update profile. Please try again.";
            case "empty_password_fields":
                return "All password fields are required.";
            case "password_mismatch":
                return "New passwords do not match.";
            case "weak_password":
                return "Password must be at least 8 characters with uppercase, lowercase, number, and special character.";
            case "wrong_current_password":
                return "Current password is incorrect.";
            case "password_update_failed":
                return "Failed to update password. Please try again.";
            case "system_error":
                return "A system error occurred. Please try again later.";
            default:
                return "An error occurred. Please try again.";
        }
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
        return "Change Profile servlet with message handling";
    }// </editor-fold>

}
