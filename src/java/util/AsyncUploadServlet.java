package util;

import jakarta.servlet.AsyncContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet(value = "/upload", asyncSupported = true)
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class AsyncUploadServlet extends HttpServlet {

      private static final Logger logger = Logger.getLogger(AsyncUploadServlet.class.getName());
      private static final ExecutorService executorService = Executors.newFixedThreadPool(10);
      private static final AtomicBoolean shutdownInitiated = new AtomicBoolean(false);

      @Override
      protected void doPost(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {

            // Enable async processing
            final AsyncContext asyncContext = request.startAsync();
            asyncContext.setTimeout(30000); // 30 seconds timeout

            // Set response type immediately
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Process upload asynchronously
            CompletableFuture.supplyAsync(() -> {
                  try {
                        Part filePart = request.getPart("bookImage");
                        String folder = request.getParameter("folder");

                        if (folder == null || folder.trim().isEmpty()) {
                              folder = "general";
                        }

                        // Validate file part
                        if (filePart == null || filePart.getSize() == 0) {
                              return new UploadResult(false, null, "No file selected");
                        }

                        // Validate file size
                        if (filePart.getSize() > 1024 * 1024 * 10) { // 10MB
                              return new UploadResult(false, null, "File too large");
                        }

                        // Validate file type
                        String contentType = filePart.getContentType();
                        if (!isValidImageType(contentType)) {
                              return new UploadResult(false, null, "Invalid file type");
                        }

                        logger.log(Level.INFO, "Starting async upload for file: {0}", filePart.getSubmittedFileName());

                        // Upload to Supabase asynchronously
                        String imageUrl = AsyncSupabaseImageService.uploadImageAsync(filePart, folder).join();

                        if (imageUrl != null) {
                              logger.log(Level.INFO, "Upload successful: {0}", imageUrl);
                              return new UploadResult(true, imageUrl, "Upload successful");
                        } else {
                              logger.log(Level.WARNING, "Upload failed for file: {0}", filePart.getSubmittedFileName());
                              return new UploadResult(false, null, "Upload failed");
                        }

                  } catch (Exception e) {
                        logger.log(Level.SEVERE, "Error during async upload", e);
                        return new UploadResult(false, null, "Upload error: " + e.getMessage());
                  }
            }, executorService)
                    .thenAccept(result -> {
                          try {
                                HttpServletResponse asyncResponse = (HttpServletResponse) asyncContext.getResponse();

                                if (!result.success) {
                                      asyncResponse.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                                }

                                String jsonResponse = String.format(
                                        "{\"success\": %s, \"imageUrl\": \"%s\", \"message\": \"%s\"}",
                                        result.success,
                                        result.imageUrl != null ? result.imageUrl : "",
                                        result.message != null ? result.message.replace("\"", "\\\"") : ""
                                );

                                asyncResponse.getWriter().write(jsonResponse);
                                asyncResponse.getWriter().flush();

                          } catch (IOException e) {
                                logger.log(Level.SEVERE, "Error writing async response", e);
                          } finally {
                                asyncContext.complete();
                          }
                    })
                    .exceptionally(throwable -> {
                          logger.log(Level.SEVERE, "Async upload failed", throwable);
                          try {
                                HttpServletResponse asyncResponse = (HttpServletResponse) asyncContext.getResponse();
                                asyncResponse.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                                asyncResponse.getWriter().write(
                                        "{\"success\": false, \"message\": \"Internal server error\"}"
                                );
                          } catch (IOException e) {
                                logger.log(Level.SEVERE, "Error writing error response", e);
                          } finally {
                                asyncContext.complete();
                          }
                          return null;
                    });
      }

      private boolean isValidImageType(String contentType) {
            return contentType != null && (contentType.equals("image/jpeg")
                    || contentType.equals("image/jpg")
                    || contentType.equals("image/png")
                    || contentType.equals("image/gif")
                    || contentType.equals("image/webp"));
      }

      @Override
      public void destroy() {
            shutdownInitiated.set(true);
            executorService.shutdown();
            try {
                  if (!executorService.awaitTermination(60, java.util.concurrent.TimeUnit.SECONDS)) {
                        executorService.shutdownNow();
                  }
            } catch (InterruptedException e) {
                  executorService.shutdownNow();
                  Thread.currentThread().interrupt();
            }
            super.destroy();
      }

      // Inner class for upload result
      private static class UploadResult {

            final boolean success;
            final String imageUrl;
            final String message;

            UploadResult(boolean success, String imageUrl, String message) {
                  this.success = success;
                  this.imageUrl = imageUrl;
                  this.message = message;
            }
      }
}