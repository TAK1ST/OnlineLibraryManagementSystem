/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import constant.ViewURL;
import dao.implement.OverdueBookDAO;
import entity.OverdueBook;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author asus
 */
public class AdminOverdueBook extends HttpServlet {

    private OverdueBookDAO overdueBookDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        overdueBookDAO = new OverdueBookDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get all overdue books
            List<OverdueBook> overdueBooks = overdueBookDAO.getAllOverdueBooks();

            // Get statistics
            int totalOverdueBooks = overdueBookDAO.getTotalOverdueBooks();
            double totalFines = overdueBookDAO.getTotalFines();
            int averageOverdueDays = overdueBookDAO.getAverageOverdueDays();

            // Set attributes for JSP
            request.setAttribute("overdueBooks", overdueBooks);
            request.setAttribute("totalOverdueBooks", totalOverdueBooks);
            request.setAttribute("totalFines", totalFines);
            request.setAttribute("averageOverdueDays", averageOverdueDays);

            // Check if there are any overdue books
            if (overdueBooks == null || overdueBooks.isEmpty()) {
                request.setAttribute("message", "No overdue books found.");
            }

            // Forward to JSP view
            request.getRequestDispatcher(ViewURL.ADMIN_OVER_BOOK).forward(request, response);

        } catch (Exception e) {
            // Log the error
            e.printStackTrace();

            // Set error message
            request.setAttribute("error", "An error occurred while retrieving overdue books: " + e.getMessage());
            request.getRequestDispatcher(ViewURL.ADMIN_OVER_BOOK).forward(request, response);
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
        String action = request.getParameter("action");

        if (action == null) {
            doGet(request, response);
            return;
        }

        try {
            switch (action) {
                case "refresh":
                    // Simply redirect to GET to refresh the data
                    response.sendRedirect(request.getContextPath() + "/admin/overdue-books");
                    break;

                case "export":
                    // Future implementation for exporting overdue books data
                    // For now, just redirect back
                    response.sendRedirect(request.getContextPath() + "/admin/overdue-books");
                    break;

                default:
                    doGet(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your request: " + e.getMessage());
            doGet(request, response);
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
