/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.logging.Logger;

/**
 * Servlet xử lý đăng xuất và xóa cookie Remember Me
 * @author CAU_TU
 */
@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

    private static final String COOKIE_NAME_EMAIL = "rememberEmail";
    private static final String COOKIE_NAME_TOKEN = "rememberToken";
    private static final Logger logger = Logger.getLogger(LogoutServlet.class.getName());

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy session hiện tại
        HttpSession session = request.getSession(false);
        
        // Nếu có session, hủy session
        if (session != null) {
            // Log thông tin user trước khi đăng xuất
            Object loginedUser = session.getAttribute("loginedUser");
            if (loginedUser != null) {
                logger.info("User logged out: " + loginedUser.toString());
            }
            
            // Hủy session
            session.invalidate();
        }
        
        // Xóa cookie Remember Me
        clearRememberMeCookie(response);
        
        // Redirect về trang đăng nhập với thông báo thành công
        response.sendRedirect(request.getContextPath() + "/LoginServlet?message=logout_success");
    }

    /**
     * Xóa cookie Remember Me
     */
    private void clearRememberMeCookie(HttpServletResponse response) {
        // Xóa cookie email
        Cookie emailCookie = new Cookie(COOKIE_NAME_EMAIL, "");
        emailCookie.setMaxAge(0);
        emailCookie.setHttpOnly(true);
        emailCookie.setPath("/");

        // Xóa cookie token
        Cookie tokenCookie = new Cookie(COOKIE_NAME_TOKEN, "");
        tokenCookie.setMaxAge(0);
        tokenCookie.setHttpOnly(true);
        tokenCookie.setPath("/");

        response.addCookie(emailCookie);
        response.addCookie(tokenCookie);
        
        logger.info("Remember Me cookies cleared");
    }

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
        return "Logout Servlet with Remember Me cookie cleanup";
    }
}