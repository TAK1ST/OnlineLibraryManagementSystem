/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.auth;

import entity.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import util.DBConnection;

@WebServlet(name="SendMessageServlet", urlPatterns={"/SendMessageServlet"})
public class SendMessageServlet extends HttpServlet {
   
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
       
    } 

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loginedUser");

        if (user == null) {
            response.sendRedirect("view/auth/login.jsp");
            return;
        }
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO messages (user_id, subject, message) VALUES (?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, user.getId());
                stmt.setString(2, subject);
                stmt.setString(3, message);
                stmt.executeUpdate();
            }
            

            response.sendRedirect("home?messageSent=true");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
