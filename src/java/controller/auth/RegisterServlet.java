/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import constant.Regex;
import dao.implement.UserDAO;
import entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.SendMail;

/**
 *
 * @author asus
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
        request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
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
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("txtname");
        String email = request.getParameter("txtemail");
        String password = request.getParameter("txtpassword");
        String confirmPassword = request.getParameter("txtconfirmpassword");
        
        SendMail s = new SendMail();
        
//        // Validate input fields
//        if (name == null || name.trim().isEmpty() || 
//            email == null || email.trim().isEmpty() ||
//            password == null || password.trim().isEmpty() ||
//            confirmPassword == null || confirmPassword.trim().isEmpty()) {
//            request.setAttribute("error", "All fields are required.");
//            request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
//            return;
//        }
//        
//        if (!name.matches(Regex.NAME_REGEX)) {
//            request.setAttribute("error", "Invalid name. Letters and spaces only.");
//            request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
//            return;
//        }
//        
//        // Validate email format
//        if (!email.matches(Regex.EMAIL_REGEX)) {
//            request.setAttribute("error", "Invalid email format.");
//            request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
//            return;
//        }
//        
//        // Validate password length
//        if (password.length() < 6) {
//            request.setAttribute("error", "Password must be at least 6 characters long.");
//            request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
//            return;
//        }
//        
//        // Check password confirmation
//        if (!password.equals(confirmPassword)) {
//            request.setAttribute("error", "Passwords do not match!");
//            request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
//            return;
//        }

        UserDAO d = new UserDAO();
        User existingUser = d.getEmail(email.trim());
        
        // Check if email already exists
        if (existingUser != null) {
            request.setAttribute("error", "Email is already registered.");
            request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
            return;
        }
        
//        try {
//            // Debug: Test BCrypt before inserting
//            UserDAO testDAO = new UserDAO();
//            testDAO.testBCrypt(password);
//            
//            // Insert new user with hashed password
//            int result = d.insertNewUser(name.trim(), email.trim(), password);
//            if (result == 1) {
//                request.setAttribute("message", "Registration successful! Please log in.");
//                s.sendWelcomeEmail(email, name);
//                request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
//            } else {
//                request.setAttribute("error", "Registration failed. Please try again.");
//                request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//            request.setAttribute("error", "An error occurred during registration. Please try again.");
//            request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
//        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }
}