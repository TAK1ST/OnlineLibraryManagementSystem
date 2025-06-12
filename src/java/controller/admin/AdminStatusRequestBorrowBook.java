/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import constant.ViewURL;
import static constant.constance.RECORDS_PER_LOAD;
import dto.BookInforRequestStatusDTO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import service.implement.BookRequestStatusService;

/**
 *
 * @author asus
 */
public class AdminStatusRequestBorrowBook extends HttpServlet {

      @Override
      protected void doGet(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
            BookRequestStatusService bookRequestStatusService = new BookRequestStatusService();
            String ajax = request.getParameter("ajax");
            String searchISBN = request.getParameter("searchISBN");
            String searchTitle = request.getParameter("searchTitle");
            int offset = request.getParameter("offset") != null ? Integer.parseInt(request.getParameter("offset")) : 0;

            List<BookInforRequestStatusDTO> bookRequestList
                    = bookRequestStatusService.getAllBookRequestStatusLazyLoading(searchISBN, searchTitle, offset);

            request.setAttribute("bookStatusList", bookRequestList);
            request.setAttribute("recordsPerPage", RECORDS_PER_LOAD);
            request.setAttribute("offset", offset);

            if ("true".equals(ajax)) {
                  response.setContentType("text/html");
                  request.getRequestDispatcher(ViewURL.BOOK_REQUEST_LIST_FRAGMENT).include(request, response);
            } else {
                  request.getRequestDispatcher(ViewURL.ADMIN_STATUS_REQUEST_BORROW_BOOK).forward(request, response);
            }
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
            BookRequestStatusService bookRequestStatusServlet = new BookRequestStatusService();

            String requestId = request.getParameter("requestId");
            String action = request.getParameter("action");
            try {
                  if (requestId == null || action == null) {
                        throw new Exception();
                  }
                  int id = Integer.parseInt(requestId);
                  if (!action.equals("approve") && !action.equals("reject")) {
                        throw new Exception();
                  }

                  String status = action.equals("approve") ? "approved" : "rejected";

                  bookRequestStatusServlet.updateBookRequestStatus(id, status);
                  response.sendRedirect(request.getContextPath() + "/statusrequestborrowbook");
            } catch (Exception e) {
                  e.printStackTrace();
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
