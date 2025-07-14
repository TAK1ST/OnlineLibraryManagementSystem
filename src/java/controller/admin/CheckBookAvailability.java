/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.implement.BookDAO;
import entity.Book;

/**
 *
 * @author asus
 */
public class CheckBookAvailability extends HttpServlet {

      BookDAO bookDAO = new BookDAO();

      @Override
      protected void doGet(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {

            response.setContentType("application/json;charset=UTF-8");
            response.setCharacterEncoding("UTF-8");

            HttpSession session = request.getSession(false);
            if (session == null || !isAdmin(session)) {
                  response.getWriter().print("{\"success\": false, \"error\": \"UNAUTHORIZED\"}");
                  return;
            }

            String bookIdParam = request.getParameter("bookId");
            if (bookIdParam == null || bookIdParam.trim().isEmpty()) {
                  response.getWriter().print("{\"success\": false, \"error\": \"MISSING_ID\"}");
                  return;
            }

            try {
                  int bookId = Integer.parseInt(bookIdParam.trim());
                  Book book = bookDAO.getBookById(bookId);

                  if (book == null) {
                        response.getWriter().print("{\"success\": false, \"error\": \"NOT_FOUND\"}");
                  } else if (!"active".equalsIgnoreCase(book.getStatus())) {
                        response.getWriter().print("{\"success\": false, \"error\": \"INACTIVE\"}");
                  } else if (book.getAvailableCopies() <= 0) {
                        response.getWriter().print("{\"success\": false, \"error\": \"NO_COPIES\", \"availableCopies\": 0}");
                  } else {
                        response.getWriter().print("{\"success\": true, \"availableCopies\": " + book.getAvailableCopies()
                                + ", \"status\": \"" + book.getStatus() + "\"}");
                  }

            } catch (NumberFormatException e) {
                  response.getWriter().print("{\"success\": false, \"error\": \"INVALID_ID\"}");
            } catch (Exception e) {
                  response.getWriter().print("{\"success\": false, \"error\": \"ERROR\"}");
            }
      }

      @Override
      protected void doPost(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
            response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            response.getWriter().print("POST_NOT_ALLOWED");
      }

      private boolean isAdmin(HttpSession session) {
            Object role = session.getAttribute("userRole");
            return role != null && role.toString().equalsIgnoreCase("admin");
      }
}
