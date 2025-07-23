/*
     * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
     * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * LoginServlet - Chỉ xử lý điều hướng sau khi đăng nhập thành công
 * Toàn bộ logic đăng nhập được xử lý bởi LoginValidateFilter
 * 
 * @author asus
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra xem có phải từ filter với đăng nhập thành công không
        Boolean loginSuccess = (Boolean) request.getAttribute("loginSuccess");
        
        if (loginSuccess != null && loginSuccess) {
            // Xử lý điều hướng sau khi đăng nhập thành công
            handleSuccessfulLogin(request, response);
        } else {
            // Nếu truy cập trực tiếp, hiển thị trang đăng nhập
            request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra xem có phải từ filter với đăng nhập thành công không
        Boolean loginSuccess = (Boolean) request.getAttribute("loginSuccess");
        
        if (loginSuccess != null && loginSuccess) {
            // Xử lý điều hướng sau khi đăng nhập thành công
            handleSuccessfulLogin(request, response);
        } else {
            // Nếu không thành công, redirect về trang login (không bình thường)
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
        }
    }

    /**
     * Xử lý điều hướng sau khi đăng nhập thành công
     */
    private void handleSuccessfulLogin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loginedUser");
        
        if (loggedUser == null) {
            // Fallback nếu không có user trong session
            loggedUser = (User) request.getAttribute("loggedUser");
        }
        
        if (loggedUser == null) {
            // Nếu vẫn không có user, redirect về login
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // Kiểm tra redirectUrl trong session
        String redirectUrl = (String) session.getAttribute("redirectUrl");
        if (redirectUrl != null && !redirectUrl.isEmpty()) {
            session.removeAttribute("redirectUrl");
            response.sendRedirect(redirectUrl);
            return;
        }

        // Điều hướng dựa trên role
        if (loggedUser.getRole().equalsIgnoreCase("admin")) {
            response.sendRedirect(request.getContextPath() + "/admindashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Login Servlet - Navigation handler only";
    }
}