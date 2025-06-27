/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import constant.ViewURL;
import entity.Book;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import javax.naming.Context;
import service.implement.BookManagementService;

/**
 *
 * @author asus
 */
public class AdminEditBook extends HttpServlet {

      private final BookManagementService bookManagementService = new BookManagementService();

      @Override
      protected void doGet(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {

            String idParam = request.getParameter("id");

            if (idParam == null || idParam.trim().isEmpty()) {
                  request.setAttribute("errorMessage", "Book ID is required.");
                  response.sendRedirect("bookmanagement");
                  return;
            }

            try {
                  int bookId = Integer.parseInt(idParam);

                  // Fetch book details
                  Book book = bookManagementService.getBookById(bookId);
                  if (book == null) {
                        request.setAttribute("errorMessage", "Book not found with ID: " + bookId);
                        response.sendRedirect("bookmanagement");
                        return;
                  }

                  // Set book as request attribute for the form
                  request.setAttribute("selectedBook", book);

                  // Get dropdown options for form
                  request.setAttribute("categories", bookManagementService.getAvailableCategories());
                  request.setAttribute("statuses", bookManagementService.getAvailableStatuses());

                  // Forward to edit book page hoặc book management page với modal
                  request.getRequestDispatcher(ViewURL.ADMIN_BOOK_MANAGEMENT).forward(request, response);

            } catch (NumberFormatException e) {
                  request.setAttribute("errorMessage", "Invalid book ID format");
                  response.sendRedirect("bookmanagement");
            }
      }

      @Override
      protected void doPost(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
            response.setContentType("text/html;charset=UTF-8");
            request.setCharacterEncoding("UTF-8");
            try {
                  // Get form parameters
                  String bookIdStr = request.getParameter("bookId");
                  String isbn = request.getParameter("isbn");
                  String title = request.getParameter("title");
                  String author = request.getParameter("author");
                  String category = request.getParameter("category");
                  String publishedYearStr = request.getParameter("publishedYear");
                  String totalCopiesStr = request.getParameter("totalCopies");
                  String availableCopiesStr = request.getParameter("availableCopies");
                  String status = request.getParameter("status");
                  String imageUrl = request.getParameter("imageUrl");

                  // Validate inputs
                  StringBuilder errorMessage = new StringBuilder();
                  if (isEmpty(title)) {
                        errorMessage.append("Title is required. ");
                  }
                  if (isEmpty(author)) {
                        errorMessage.append("Author is required. ");
                  }
                  if (isEmpty(category)) {
                        errorMessage.append("Category is required. ");
                  }
                  if (isEmpty(status)) {
                        errorMessage.append("Status is required. ");
                  }
                  if (!"active".equalsIgnoreCase(status) && !"blocked".equalsIgnoreCase(status)) {
                        errorMessage.append("Invalid status value. ");
                  }

                  int bookId = parseIntParameter(bookIdStr, "Book ID");
                  int publishedYear = parseIntParameter(publishedYearStr, "Published Year");
                  int totalCopies = parseIntParameter(totalCopiesStr, "Total Copies");
                  int availableCopies = parseIntParameter(availableCopiesStr, "Available Copies");

                  String currentYear = String.valueOf(LocalDate.now().getYear());
                  if (publishedYear < 0 || publishedYear > Integer.parseInt(currentYear)) {
                        errorMessage.append("Published Year must be between 0 and ")
                                .append(currentYear)
                                .append(".");
                  }

                  if (totalCopies < 0) {
                        errorMessage.append("Total Copies cannot be negative. ");
                  }
                  if (availableCopies < 0 || availableCopies > totalCopies) {
                        errorMessage.append("Available Copies must be between 0 and Total Copies. ");
                  }

                  if (errorMessage.length() > 0) {
                        request.setAttribute("errorMessage", errorMessage.toString());
                        // Reload book data to repopulate form
                        Book book = bookManagementService.getBookById(bookId);
                        request.setAttribute("selectedBook", book);
                        preserveFilterParameters(request);
                        request.getRequestDispatcher(ViewURL.ADMIN_BOOK_MANAGEMENT).forward(request, response);
                        return;
                  }

                  // Create and populate Book object
                  Book book = new Book();
                  book.setId(bookId);
                  book.setIsbn(isbn);
                  book.setTitle(title);
                  book.setAuthor(author);
                  book.setCategory(category);
                  book.setPublishedYear(publishedYear);
                  book.setTotalCopies(totalCopies);
                  book.setAvailableCopies(availableCopies);
                  book.setStatus(status);
                  book.setImageUrl(imageUrl != null ? imageUrl : "");

                  // Update book in the database
                  boolean updated = bookManagementService.updateBook(book);

                  HttpSession session = request.getSession();
                  if (updated) {
                        session.setAttribute("successMessage", "Book updated successfully.");
                  } else {
                        session.setAttribute("errorMessage", "Failed to update book.");
                  }

                  // Redirect to  bookmanagement with filter parameters preserve
                  String redirectUrl = buildRedirectUrlWithFilters(request);
                  response.sendRedirect(redirectUrl);

            } catch (Exception e) {
                  request.setAttribute("errorMessage", "Error updating book: " + e.getMessage());
                  response.sendRedirect("bookmanagement");
            }
      }

      /**
       * Parses a string parameter to an integer, throwing an exception if invalid.
       */
      private int parseIntParameter(String value, String fieldName) throws NumberFormatException {
            if (value == null || value.trim().isEmpty()) {
                  throw new NumberFormatException(fieldName + " is required.");
            }
            try {
                  return Integer.parseInt(value);
            } catch (NumberFormatException e) {
                  throw new NumberFormatException(fieldName + " must be a valid number.");
            }
      }

      /**
       * Checks if a string is null or empty.
       */
      private boolean isEmpty(String value) {
            return value == null || value.trim().isEmpty();
      }

      /**
       * Preserves filter and pagination parameters in the request.
       */
      private void preserveFilterParameters(HttpServletRequest request) {
            request.setAttribute("titleFilter", request.getParameter("currentTitle"));
            request.setAttribute("authorFilter", request.getParameter("currentAuthor"));
            request.setAttribute("categoryFilter", request.getParameter("currentCategory"));
            request.setAttribute("statusFilter", request.getParameter("currentStatus"));
            request.setAttribute("currentPage", request.getParameter("currentPage"));
            request.setAttribute("pageSize", request.getParameter("currentSize"));
      }

      private String buildRedirectUrlWithFilters(HttpServletRequest request) {
            StringBuilder url = new StringBuilder("bookmanagement?");

            String title = request.getParameter("currentTitle");
            String author = request.getParameter("currentAuthor");
            String category = request.getParameter("currentCategory");
            String status = request.getParameter("currentStatus");
            String page = request.getParameter("currentPage");
            String size = request.getParameter("currentSize");

            if (title != null && !title.trim().isEmpty()) {
                  url.append("title=").append(title).append("&");
            }
            if (author != null && !author.trim().isEmpty()) {
                  url.append("author=").append(author).append("&");
            }
            if (category != null && !category.trim().isEmpty()) {
                  url.append("category=").append(category).append("&");
            }
            if (status != null && !status.trim().isEmpty()) {
                  url.append("status=").append(status).append("&");
            }
            if (page != null && !page.trim().isEmpty()) {
                  url.append("page=").append(page).append("&");
            }
            if (size != null && !size.trim().isEmpty()) {
                  url.append("size=").append(size).append("&");
            }

            return url.toString();
      }

      /**
       * Returns a short description of the servlet.
       */
      @Override
      public String getServletInfo() {
            return "Servlet for editing book details in the admin panel.";
      }
}
