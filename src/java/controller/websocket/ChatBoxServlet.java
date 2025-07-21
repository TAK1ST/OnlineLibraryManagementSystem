package controller.websocket;

import entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ChatBoxServlet", urlPatterns = {"/ChatBoxServlet"})
public class ChatBoxServlet extends HttpServlet {

      protected void processRequest(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
            response.setContentType("text/html;charset=UTF-8");
            HttpSession session = request.getSession();

            User loginedUser = (User) session.getAttribute("loginedUser");

            if (loginedUser != null) {
                  System.out.println("✅ User " + loginedUser.getName()+ " accessing chat box");
                  request.getRequestDispatcher("/view/user/ExampleChatBox.jsp").forward(request, response);
            } else {
                  System.out.println("❌ No logged user, redirecting to login");
                  response.sendRedirect("LoginServlet");
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
            return "Chat Box Servlet for user chat interface";
      }
}
