    /*
     * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
     * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
     */
    package controller.auth;

    import dao.implement.UserDAO;
    import dao.implement.BookDAO;
    import entity.User;
    import entity.Book;
    import java.io.IOException;
    import jakarta.servlet.ServletException;
    import jakarta.servlet.annotation.WebServlet;
    import jakarta.servlet.http.HttpServlet;
    import jakarta.servlet.http.HttpServletRequest;
    import jakarta.servlet.http.HttpServletResponse;
    import jakarta.servlet.http.HttpSession;
    import java.util.ArrayList;
    import java.util.List;
    import java.util.logging.Level;
    import java.util.logging.Logger;

    /**
     *
     * @author asus
     */
    @WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
    public class LoginServlet extends HttpServlet {

        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
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
            // Set encoding
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            String email = request.getParameter("txtemail");
            String password = request.getParameter("txtpassword");

            System.out.println("Debug Login - Email: " + email);
            System.out.println("Debug Login - Password length: " + (password != null ? password.length() : "null"));

            // Validate input
            if(email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
                request.setAttribute("ERROR", "Email and password are required");
                request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
                return;
            }


            UserDAO d = new UserDAO();
            User us = d.getUser(email.trim(), password);

            if(us == null || !us.getStatus().equalsIgnoreCase("active")) {
                request.setAttribute("ERROR", "Email or password is invalid");
                request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("loginedUser", us);

                try {
                    // Kiểm tra xem có URL redirect không
                    String redirectUrl = (String) session.getAttribute("redirectUrl");
                    if (redirectUrl != null && !redirectUrl.isEmpty()) {
                        session.removeAttribute("redirectUrl");
                        response.sendRedirect(redirectUrl);
                        return;
                    }

                    // Nếu không có URL redirect, chuyển hướng theo role
                    if(us.getRole().equalsIgnoreCase("admin")) {
                        response.sendRedirect(request.getContextPath() + "/admindashboard");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/home");
                    }
                } catch (Exception ex) {
                    Logger.getLogger(LoginServlet.class.getName()).log(Level.SEVERE, null, ex);
                    request.setAttribute("ERROR", "Error loading application data: " + ex.getMessage());
                    request.getRequestDispatcher("/view/auth/login.jsp").forward(request, response);
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
        }
    }