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
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.time.LocalDate;
import service.implement.BookManagementService;

/**
 *
 * @author asus
 */
@MultipartConfig
public class AdminAddBookManager extends BaseAdminController {

      private final BookManagementService bookManagementService = new BookManagementService();

      @Override
      protected void doGet(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {

            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            User adminUser = checkAdminAuthentication(request, response);
            if (adminUser == null) {
                  return;
            }

            try {
                  // Set available options for dropdowns
                  request.setAttribute("categories", bookManagementService.getAvailableCategories());
                  request.setAttribute("statuses", bookManagementService.getAvailableStatuses());

                  // Generate a suggested ISBN
                  request.setAttribute("suggestedISBN", bookManagementService.generateUniqueISBN());

                  // Forward to add book form
                  request.getRequestDispatcher(ViewURL.ADMIN_ADD_BOOK_MANAGEMENT).forward(request, response);
            } catch (Exception e) {
                  System.err.println("Error in doGet: " + e.getMessage());
                  e.printStackTrace();
                  request.setAttribute("errorMessage", "Cannot load form add book: " + e.getMessage());
                  request.getRequestDispatcher("/error.jsp").forward(request, response);
            }
      }

      @Override
      public void doPost(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
            try {
                  // Get form parameters
                  String title = request.getParameter("title");
                  String author = request.getParameter("author");
                  String category = request.getParameter("category");
                  String status = request.getParameter("status");
                  String isbn = request.getParameter("isbn");
                  String totalCopiesStr = request.getParameter("totalCopies");
                  String publishedYearStr = request.getParameter("publishedYear");

                  System.out.println("Form parameters received:");
                  System.out.println("Title: " + title);
                  System.out.println("Author: " + author);
                  System.out.println("Category: " + category);
                  System.out.println("Status: " + status);
                  System.out.println("ISBN: " + isbn);
                  System.out.println("Total Copies: " + totalCopiesStr);
                  System.out.println("Published Year: " + publishedYearStr);

                  // Validate required parameters
                  if (title == null || title.trim().isEmpty()) {
                        throw new IllegalArgumentException("Book title is required");
                  }
                  if (author == null || author.trim().isEmpty()) {
                        throw new IllegalArgumentException("Author is required");
                  }
                  if (totalCopiesStr == null || totalCopiesStr.trim().isEmpty()) {
                        throw new IllegalArgumentException("Total copies is required");
                  }
                  if (publishedYearStr == null || publishedYearStr.trim().isEmpty()) {
                        throw new IllegalArgumentException("Published year is required");
                  }

                  // Parse numeric parameters
                  int totalCopies;
                  int publishedYear;

                  try {
                        totalCopies = Integer.parseInt(totalCopiesStr);
                        publishedYear = Integer.parseInt(publishedYearStr);
                  } catch (NumberFormatException e) {
                        throw new IllegalArgumentException("Invalid number format. Please check the copy number and publication year.");
                  }

                  // Validate numeric values
                  if (totalCopies < 1) {
                        throw new IllegalArgumentException("Total copies must be at least 1");
                  }

                  String currentYear = String.valueOf(LocalDate.now().getYear());
                  if (publishedYear < 1000 || publishedYear > Integer.parseInt(currentYear)) {
                        throw new IllegalArgumentException("Published year must be between 1000 and " + currentYear);
                  }

                  // Handle file upload
                  String imageUrl = null;
                  try {
                        Part filePart = request.getPart("bookImage");
                        if (filePart != null && filePart.getSize() > 0) {
                              System.out.println("Processing file upload...");
                              String uploadPath = getServletContext().getRealPath("/Uploads");
                              File uploadDir = new File(uploadPath);
                              if (!uploadDir.exists()) {
                                    boolean created = uploadDir.mkdirs();
                                    System.out.println("Upload directory created: " + created);
                              }

                              String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                              System.out.println("Original filename: " + fileName);

                              // Add timestamp to filename to avoid conflicts
                              String timestamp = String.valueOf(System.currentTimeMillis());
                              String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                              String uniqueFileName = timestamp + "_" + fileName.substring(0, fileName.lastIndexOf(".")) + fileExtension;

                              String fullPath = uploadPath + File.separator + uniqueFileName;
                              filePart.write(fullPath);
                              imageUrl = "/Uploads/" + uniqueFileName;
                              System.out.println("File saved to: " + fullPath);
                              System.out.println("Image URL: " + imageUrl);
                        }
                  } catch (Exception e) {
                        System.err.println("Error handling file upload: " + e.getMessage());
                        e.printStackTrace();
                        // Continue without image if upload fails
                  }

                  // Generate ISBN if not provided
                  if (isbn == null || isbn.trim().isEmpty()) {
                        isbn = bookManagementService.generateUniqueISBN();
                        System.out.println("Generated ISBN: " + isbn);
                  }

                  // Create book object
                  Book book = new Book();
                  book.setTitle(title.trim());
                  book.setAuthor(author.trim());
                  book.setIsbn(isbn.trim());
                  book.setCategory(category);
                  book.setPublishedYear(publishedYear);
                  book.setTotalCopies(totalCopies);
                  book.setAvailableCopies(totalCopies); // Initially all copies are available
                  book.setStatus(status != null ? status : "active");
                  book.setImageUrl(imageUrl);

                  System.out.println("Book object created successfully");
                  System.out.println("Calling bookManagementService.addBook()...");

                  // Add book using service - FIX: Correct logic
                  boolean success = bookManagementService.addBook(book);

                  System.out.println("addBook() returned: " + success);

                  if (success) {
                        System.out.println("Book added successfully, redirecting...");
                        response.sendRedirect(request.getContextPath() + "/bookmanagement?success=Book added successfully");
                  } else {
                        System.err.println("Failed to add book");
                        request.setAttribute("errorMessage", "Failed to add book. Please try again.");
                        request.setAttribute("book", book);
                        doGet(request, response);
                  }

            } catch (IllegalArgumentException e) {
                  System.err.println("Validation error: " + e.getMessage());
                  e.printStackTrace();
                  request.setAttribute("errorMessage", e.getMessage());
                  doGet(request, response);

            } catch (Exception e) {
                  System.err.println("Unexpected error in doPost: " + e.getMessage());
                  e.printStackTrace();
                  request.setAttribute("errorMessage", "Error adding book: " + e.getMessage());
                  doGet(request, response);
            }
      }
}
