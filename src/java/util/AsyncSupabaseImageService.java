package util;

import jakarta.servlet.http.Part;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.file.Paths;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.logging.Logger;
import java.util.logging.Level;

public class AsyncSupabaseImageService {

      private static final Logger logger = Logger.getLogger(AsyncSupabaseImageService.class.getName());
      private static final String SUPABASE_URL = "https://icdmgutnvthphneaxxsq.supabase.co";
      private static final String BUCKET = "image.library";
      private static final String ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImljZG1ndXRudnRocGhuZWF4eHNxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTEyNTUyOTUsImV4cCI6MjA2NjgzMTI5NX0.cv7UgCnqHFHoElI-Nvgv5ytkktzDJaFquU-bPUS1Hdo";

      // Default images trong Supabase
      private static final String DEFAULT_BOOK_IMAGE = "defaults/default-book.jpg";
      private static final String DEFAULT_AVATAR_IMAGE = "defaults/default-avatar.png";
      private static final String DEFAULT_UNKNOWN_IMAGE = "defaults/unknown.jpg";

      private static final ExecutorService executorService = Executors.newFixedThreadPool(20);

      /**
       * Upload image to Supabase Storage asynchronously
       *
       * @param filePart The file part from multipart request
       * @param folder Folder name in bucket (e.g., "books", "avatars")
       * @return CompletableFuture with public URL of uploaded image or null if failed
       */
      public static CompletableFuture<String> uploadImageAsync(Part filePart, String folder) {
            return CompletableFuture.supplyAsync(() -> {
                  try {
                        if (filePart == null || filePart.getSize() == 0) {
                              logger.warning("File part is null or empty");
                              return null;
                        }

                        // Validate file type
                        String contentType = filePart.getContentType();
                        if (!isValidImageType(contentType)) {
                              logger.log(Level.WARNING, "Invalid image type: {0}", contentType);
                              throw new IllegalArgumentException("Invalid image type: " + contentType);
                        }

                        // Generate unique filename
                        String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                        String fileExtension = getFileExtension(originalFileName);
                        String uniqueFileName = UUID.randomUUID().toString() + "_" + System.currentTimeMillis() + fileExtension;
                        String fullPath = folder + "/" + uniqueFileName;

                        logger.log(Level.INFO, "Starting upload for: {0}", fullPath);

                        // Upload to Supabase
                        String uploadUrl = SUPABASE_URL + "/storage/v1/object/" + BUCKET + "/" + fullPath;

                        HttpURLConnection conn = (HttpURLConnection) new URL(uploadUrl).openConnection();
                        conn.setDoOutput(true);
                        conn.setRequestMethod("PUT");
                        conn.setRequestProperty("Authorization", "Bearer " + ANON_KEY);
                        conn.setRequestProperty("apikey", ANON_KEY);
                        conn.setRequestProperty("Content-Type", contentType);
                        conn.setRequestProperty("x-upsert", "true");
                        conn.setConnectTimeout(10000); // 10 seconds
                        conn.setReadTimeout(30000); // 30 seconds

                        // Send file data
                        try ( OutputStream out = conn.getOutputStream();  InputStream fileStream = filePart.getInputStream()) {

                              byte[] buffer = new byte[8192];
                              int bytesRead;
                              long totalBytes = 0;

                              while ((bytesRead = fileStream.read(buffer)) != -1) {
                                    out.write(buffer, 0, bytesRead);
                                    totalBytes += bytesRead;
                              }

                              logger.log(Level.INFO, "Uploaded {0} bytes", totalBytes);
                        }

                        int responseCode = conn.getResponseCode();
                        if (responseCode == 200 || responseCode == 201) {
                              String publicUrl = SUPABASE_URL + "/storage/v1/object/public/" + BUCKET + "/" + fullPath;
                              logger.log(Level.INFO, "Upload successful: {0}", publicUrl);
                              return publicUrl;
                        } else {
                              // Log error
                              String errorMsg = readErrorResponse(conn);
                              logger.log(Level.SEVERE, "Supabase upload error ({0}): {1}", new Object[]{responseCode, errorMsg});
                              return null;
                        }

                  } catch (Exception e) {
                        logger.log(Level.SEVERE, "Error during async upload", e);
                        return null;
                  }
            }, executorService);
      }

      /**
       * Delete image from Supabase Storage asynchronously
       *
       * @param imagePath Path to image in Supabase
       * @return CompletableFuture with boolean result
       */
      public static CompletableFuture<Boolean> deleteImageAsync(String imagePath) {
            return CompletableFuture.supplyAsync(() -> {
                  try {
                        if (imagePath == null || imagePath.trim().isEmpty()) {
                              return false;
                        }

                        // Tạo biến mutable chứa imagePath
                        String processedPath = imagePath;

                        // Extract path from full URL if needed
                        if (processedPath.startsWith(SUPABASE_URL)) {
                              processedPath = processedPath.replace(
                                      SUPABASE_URL + "/storage/v1/object/public/" + BUCKET + "/", ""
                              );
                        }

                        String deleteUrl = SUPABASE_URL + "/storage/v1/object/" + BUCKET + "/" + processedPath;

                        HttpURLConnection conn = (HttpURLConnection) new URL(deleteUrl).openConnection();
                        conn.setRequestMethod("DELETE");
                        conn.setRequestProperty("Authorization", "Bearer " + ANON_KEY);
                        conn.setRequestProperty("apikey", ANON_KEY);
                        conn.setConnectTimeout(10000);
                        conn.setReadTimeout(10000);

                        int responseCode = conn.getResponseCode();
                        boolean success = responseCode == 200 || responseCode == 204;

                        logger.log(Level.INFO, "Delete operation for {0}: {1}", new Object[]{processedPath, success ? "SUCCESS" : "FAILED"});
                        return success;

                  } catch (Exception e) {
                        logger.log(Level.SEVERE, "Error during async delete", e);
                        return false;
                  }
            }, executorService);
      }

      /**
       * Batch upload multiple images asynchronously
       *
       * @param fileParts Array of file parts
       * @param folder Folder name
       * @return CompletableFuture with array of URLs
       */
      public static CompletableFuture<String[]> uploadMultipleImagesAsync(Part[] fileParts, String folder) {
            CompletableFuture<String>[] futures = new CompletableFuture[fileParts.length];

            for (int i = 0; i < fileParts.length; i++) {
                  futures[i] = uploadImageAsync(fileParts[i], folder);
            }

            return CompletableFuture.allOf(futures)
                    .thenApply(v -> {
                          String[] results = new String[futures.length];
                          for (int i = 0; i < futures.length; i++) {
                                try {
                                      results[i] = futures[i].get();
                                } catch (Exception e) {
                                      logger.log(Level.WARNING, "Failed to get result for upload " + i, e);
                                      results[i] = null;
                                }
                          }
                          return results;
                    });
      }

      /**
       * Get image from Supabase Storage (synchronous - just URL building)
       *
       * @param imagePath Path to image in Supabase
       * @return Public URL to access the image
       */
      public static String getImageUrl(String imagePath) {
            if (imagePath == null || imagePath.trim().isEmpty()) {
                  logger.log(Level.WARNING, "ImagePath is null or empty");
                  return null;
            }

            // If already a full URL, return as is
            if (imagePath.startsWith("http")) {
                  logger.log(Level.INFO, "ImagePath is already full URL: {0}", imagePath);
                  return imagePath;
            }

            // Build Supabase public URL
            String fullUrl = SUPABASE_URL + "/storage/v1/object/public/" + BUCKET + "/" + imagePath;
            logger.log(Level.INFO, "Generated Supabase URL: {0}", fullUrl);
            return fullUrl;
      }

      /**
       * Get default book image URL from Supabase
       *
       * @return Default book image URL
       */
      public static String getDefaultBookImageUrl() {
            return getImageUrl(DEFAULT_BOOK_IMAGE);
      }

      /**
       * Get default avatar image URL from Supabase
       *
       * @return Default avatar image URL
       */
      public static String getDefaultAvatarImageUrl() {
            return getImageUrl(DEFAULT_AVATAR_IMAGE);
      }

      /**
       * Get default unknown image URL from Supabase
       *
       * @return Default unknown image URL
       */
      public static String getDefaultUnknownImageUrl() {
            return getImageUrl(DEFAULT_UNKNOWN_IMAGE);
      }

      /**
       * Upload default images to Supabase if they don't exist Call this method during application
       * initialization
       */
      public static void initializeDefaultImages() {
            CompletableFuture.runAsync(() -> {
                  try {
                        // Check and upload default book image
                        if (!imageExistsAsync(DEFAULT_BOOK_IMAGE).get()) {
                              logger.info("Default book image not found, creating placeholder...");
                              // You can upload actual default images here
                        }

                        // Check and upload default avatar image
                        if (!imageExistsAsync(DEFAULT_AVATAR_IMAGE).get()) {
                              logger.info("Default avatar image not found, creating placeholder...");
                              // You can upload actual default images here
                        }

                        // Check and upload default unknown image
                        if (!imageExistsAsync(DEFAULT_UNKNOWN_IMAGE).get()) {
                              logger.info("Default unknown image not found, creating placeholder...");
                              // You can upload actual default images here
                        }

                  } catch (Exception e) {
                        logger.log(Level.WARNING, "Error initializing default images", e);
                  }
            }, executorService);
      }

      /**
       * Check if image exists asynchronously
       *
       * @param imagePath Path to image
       * @return CompletableFuture with boolean result
       */
      public static CompletableFuture<Boolean> imageExistsAsync(String imagePath) {
            return CompletableFuture.supplyAsync(() -> {
                  try {
                        String checkUrl = getImageUrl(imagePath);
                        if (checkUrl == null) {
                              return false;
                        }

                        HttpURLConnection conn = (HttpURLConnection) new URL(checkUrl).openConnection();
                        conn.setRequestMethod("HEAD");
                        conn.setConnectTimeout(5000);
                        conn.setReadTimeout(5000);

                        int responseCode = conn.getResponseCode();
                        return responseCode == 200;

                  } catch (Exception e) {
                        logger.log(Level.WARNING, "Error checking image existence", e);
                        return false;
                  }
            }, executorService);
      }

      private static boolean isValidImageType(String contentType) {
            return contentType != null && (contentType.equals("image/jpeg")
                    || contentType.equals("image/jpg")
                    || contentType.equals("image/png")
                    || contentType.equals("image/gif")
                    || contentType.equals("image/webp"));
      }

      private static String getFileExtension(String fileName) {
            if (fileName == null || fileName.lastIndexOf(".") == -1) {
                  return ".jpg";
            }
            return fileName.substring(fileName.lastIndexOf("."));
      }

      private static String readErrorResponse(HttpURLConnection conn) {
            try ( BufferedReader errorReader = new BufferedReader(new InputStreamReader(conn.getErrorStream()))) {
                  StringBuilder errorMsg = new StringBuilder();
                  String line;
                  while ((line = errorReader.readLine()) != null) {
                        errorMsg.append(line);
                  }
                  return errorMsg.toString();
            } catch (Exception e) {
                  return "Could not read error response";
            }
      }

      /**
       * Shutdown executor service gracefully
       */
      public static void shutdown() {
            executorService.shutdown();
            try {
                  if (!executorService.awaitTermination(60, java.util.concurrent.TimeUnit.SECONDS)) {
                        executorService.shutdownNow();
                  }
            } catch (InterruptedException e) {
                  executorService.shutdownNow();
                  Thread.currentThread().interrupt();
            }
      }
}
