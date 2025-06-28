/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import constant.ViewURL;
import entity.Book;
import entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import service.implement.BookManagementService;

/**
 *
 * @author asus
 */
public class AdminBookManagement extends BaseAdminController {

      private final BookManagementService bookManagementService;

      public AdminBookManagement() {
            this.bookManagementService = new BookManagementService();
      }

      @Override
      public void doGet(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {

            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            User adminUser = checkAdminAuthentication(request, response);
            if (adminUser == null) {
                  return;
            }

            // Get filter parameters
            String titleFilter = getParameterOrDefault(request, "title", "");
            String authorFilter = getParameterOrDefault(request, "author", "");
            String categoryFilter = getParameterOrDefault(request, "category", "");
            String statusFilter = getParameterOrDefault(request, "status", "");

            // Get pagination parameters
            int page = getIntParameter(request, "page", 1);
            int size = getIntParameter(request, "size", 10);

            try {
                  // Get books with filters and pagination
                  List<Book> books = bookManagementService.getBooks(page, size, titleFilter,
                          authorFilter, categoryFilter, statusFilter);
                  int totalBooks = bookManagementService.getTotalBooksCount(titleFilter,
                          authorFilter, categoryFilter, statusFilter);
                  int totalPages = bookManagementService.getTotalPages(totalBooks, size);

                  // Set attributes for JSP
                  setBookAttributes(request, books, page, totalPages, totalBooks, size);
                  setFilterAttributes(request, titleFilter, authorFilter, categoryFilter, statusFilter);

                  // Set dropdown options
                  request.setAttribute("categories", bookManagementService.getAvailableCategories());
                  request.setAttribute("statuses", bookManagementService.getAvailableStatuses());

                  // Check for success/error messages
                  HttpSession session = request.getSession();
                  String successMessage = (String) session.getAttribute("successMessage");
                  String errorMessage = (String) session.getAttribute("errorMessage");

                  if (successMessage != null) {
                        request.setAttribute("successMessage", successMessage);
                        session.removeAttribute("successMessage");
                  }
                  if (errorMessage != null) {
                        request.setAttribute("errorMessage", errorMessage);
                        session.removeAttribute("errorMessage");
                  }

                  request.getRequestDispatcher(ViewURL.ADMIN_BOOK_MANAGEMENT)
                          .forward(request, response);

            } catch (Exception e) {
                  e.printStackTrace();
                  request.setAttribute("errorMessage", "Error loading books: " + e.getMessage());
                  request.getRequestDispatcher(ViewURL.ADMIN_BOOK_MANAGEMENT)
                          .forward(request, response);
            }
      }

      @Override
      public void doPost(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {

            // Check authentication and authorization
            User adminUser = checkAdminAuthentication(request, response);
            if (adminUser == null) {
                  return; // Already redirected to login
            }

            String action = request.getParameter("action");
            HttpSession session = request.getSession();

            if ("delete".equals(action)) {
                  handleSoftDelete(request, response, session);
            } else {
                  session.setAttribute("errorMessage", "Invalid action specified.");
                  response.sendRedirect("bookmanagement");
            }
      }

      private void handleSoftDelete(HttpServletRequest request, HttpServletResponse response,
              HttpSession session) throws IOException {
            try {
                  int bookId = Integer.parseInt(request.getParameter("bookId"));

                  // Check if book exists and get details
                  Book book = bookManagementService.getBookById(bookId);
                  if (book == null) {
                        session.setAttribute("errorMessage", "Book not found.");
                        response.sendRedirect("bookmanagement");
                        return;
                  }

                  // Check if book is currently borrowed
                  if (bookManagementService.isBookCurrentlyBorrowed(bookId)) {
                        session.setAttribute("errorMessage",
                                "Cannot delete book '" + book.getTitle() + "' as it is currently borrowed.");
                        response.sendRedirect("bookmanagement");
                        return;
                  }

                  // Perform soft delete
                  boolean success = bookManagementService.softDeleteBook(bookId);

                  if (success) {
                        session.setAttribute("successMessage",
                                "Book '" + book.getTitle() + "' has been successfully removed.");
                  } else {
                        session.setAttribute("errorMessage",
                                "Failed to remove book '" + book.getTitle() + "'.");
                  }

            } catch (NumberFormatException e) {
                  session.setAttribute("errorMessage", "Invalid book ID format.");
            } catch (Exception e) {
                  e.printStackTrace();
                  session.setAttribute("errorMessage", "Error deleting book: " + e.getMessage());
            }

            // Redirect back to book management with current filters
            String redirectUrl = buildRedirectUrl(request);
            response.sendRedirect(redirectUrl);
      }

      private String buildRedirectUrl(HttpServletRequest request) {
            StringBuilder url = new StringBuilder("bookmanagement?");

            appendParameterIfNotEmpty(url, "title", request.getParameter("currentTitle"));
            appendParameterIfNotEmpty(url, "author", request.getParameter("currentAuthor"));
            appendParameterIfNotEmpty(url, "category", request.getParameter("currentCategory"));
            appendParameterIfNotEmpty(url, "status", request.getParameter("currentStatus"));
            appendParameterIfNotEmpty(url, "page", request.getParameter("currentPage"));
            appendParameterIfNotEmpty(url, "size", request.getParameter("currentSize"));

            return url.toString();
      }

      private void appendParameterIfNotEmpty(StringBuilder url, String paramName, String paramValue) {
            if (paramValue != null && !paramValue.trim().isEmpty()) {
                  if (url.length() > url.lastIndexOf("?") + 1) {
                        url.append("&");
                  }
                  url.append(paramName).append("=").append(paramValue);
            }
      }

      private String getParameterOrDefault(HttpServletRequest request, String paramName, String defaultValue) {
            String value = request.getParameter(paramName);
            return (value == null) ? defaultValue : value.trim();
      }

      private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
            try {
                  String value = request.getParameter(paramName);
                  if (value != null && !value.isEmpty()) {
                        return Integer.parseInt(value);
                  }
            } catch (NumberFormatException e) {
                  // Return default value
            }
            return defaultValue;
      }

      private void setBookAttributes(HttpServletRequest request, List<Book> books,
              int currentPage, int totalPages, int totalBooks, int pageSize) {
            request.setAttribute("books", books);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalBooks", totalBooks);
            request.setAttribute("pageSize", pageSize);
      }

      private void setFilterAttributes(HttpServletRequest request, String titleFilter,
              String authorFilter, String categoryFilter, String statusFilter) {
            request.setAttribute("titleFilter", titleFilter);
            request.setAttribute("authorFilter", authorFilter);
            request.setAttribute("categoryFilter", categoryFilter);
            request.setAttribute("statusFilter", statusFilter);
      }

}
