/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import dao.implement.UserDAO;
import entity.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author asus
 */
public class LoginServlet extends HttpServlet {

    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        response.setContentType("text/html;charset=UTF-8");
    request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
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
        String email=request.getParameter("txtemail");
       String password=request.getParameter("txtpassword");
       if(email!=null && password!=null){
           UserDAO d=new UserDAO();
           User us=d.getUser(email, password);
           if(us==null || !us.getStatus().equalsIgnoreCase("active")){
               request.setAttribute("ERROR", "email or password is invalid");
               request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
           }else{
               HttpSession s=request.getSession();
               s.setAttribute("loginedUser", us);               
               
               if(us.getRole().equalsIgnoreCase("admin")){
                   request.getRequestDispatcher("admindashboard").forward(request, response);
               }else{
                    request.getRequestDispatcher("UserDashboard").forward(request, response);
               }
           }
       }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
