package controller.websocket;

import entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ChatServlet", urlPatterns = {"/ChatServlet"})
public class ChatServlet extends HttpServlet {

      protected void processRequest(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
            response.setContentType("text/html;charset=UTF-8");
            String url = "LoginServlet";
            
            try {
                  HttpSession session = request.getSession();
                  User user = (User) session.getAttribute("loginedUser");
                  
                  if (user != null) {
                        if ("admin".equals(user.getRole())) {
                              url = "/view/admin/AdminChat.jsp";
                        } else {
                              url = "ChatBoxServlet"; 
                        }
                  } else {
                        url = "LoginServlet";
                  }
                  
            } catch (Exception e) {
                  System.err.println("❌ Error in ChatServlet: " + e.getMessage());
                  e.printStackTrace();
                  url = "LoginServlet";
            } finally {
                  if (url.equals("LoginServlet")) {
                        response.sendRedirect(url);
                  } else {
                        request.getRequestDispatcher(url).forward(request, response);
                  }
            }
      }

      @Override
      protected void doGet(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
            processRequest(request, response);
      }

      @Override
      protected void doPost(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
            processRequest(request, response);
      }

      @Override
      public String getServletInfo() {
            return "Chat Servlet for routing to appropriate chat interface";
      }
}