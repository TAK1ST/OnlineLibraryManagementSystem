package util;

import entity.Book;
import entity.User;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ImageDisplayHelper {

      private static final Logger logger = Logger.getLogger(ImageDisplayHelper.class.getName());

      // Supabase base URL
      private static final String SUPABASE_BASE_URL = "https://icdmgutnvthphneaxxsq.supabase.co/storage/v1/object/public/image.library/";

      // Default images
      private static final String DEFAULT_BOOK_IMAGE = "defaults/default-book.jpg";
      private static final String DEFAULT_AVATAR_IMAGE = "defaults/default-avatar.png";

      /**
       * Get display URL for book image
       *
       * @param book The book object
       * @return URL to display the book image
       */
      public static String getBookImageUrl(Book book) {
            if (book == null) {
                  logger.log(Level.WARNING, "Book object is null, returning default image");
                  return SUPABASE_BASE_URL + DEFAULT_BOOK_IMAGE;
            }

            String imageUrl = book.getImageUrl();
            if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                  // Nếu đã là full URL, trả về ngay
                  if (imageUrl.startsWith("http")) {
                        return imageUrl;
                  }
                  // Thêm base URL vào trước image path
                  return SUPABASE_BASE_URL + imageUrl;
            }

            // Trả về default image nếu không có image_url
            return SUPABASE_BASE_URL + DEFAULT_BOOK_IMAGE;
      }

      /**
       * Get display URL for user avatar
       *
       * @param user The user object
       * @return URL to display the user avatar
       */
      public static String getUserAvatarUrl(User user) {
            if (user == null) {
                  logger.log(Level.WARNING, "User object is null, returning default avatar");
                  return SUPABASE_BASE_URL + DEFAULT_AVATAR_IMAGE;
            }

            String avatar = user.getAvatar();
            if (avatar != null && !avatar.trim().isEmpty()) {
                  // Nếu đã là full URL, trả về ngay
                  if (avatar.startsWith("http")) {
                        return avatar;
                  }
                  // Thêm base URL vào trước avatar path
                  return SUPABASE_BASE_URL + avatar;
            }

            // Trả về default avatar nếu không có avatar
            return SUPABASE_BASE_URL + DEFAULT_AVATAR_IMAGE;
      }

      /**
       * Get thumbnail URL for book image
       *
       * @param book The book object
       * @param width Thumbnail width (kept for compatibility)
       * @param height Thumbnail height (kept for compatibility)
       * @return URL to display the book thumbnail
       */
      public static String getBookThumbnailUrl(Book book, int width, int height) {
            return getBookImageUrl(book);
      }

      /**
       * Get thumbnail URL for book image with default size
       *
       * @param book The book object
       * @return URL to display the book thumbnail
       */
      public static String getBookThumbnailUrl(Book book) {
            return getBookImageUrl(book);
      }

      /**
       * Get safe book image URL
       *
       * @param book The book object
       * @return Safe book image URL
       */
      public static String getSafeBookImageUrl(Book book) {
            return getBookImageUrl(book);
      }

      /**
       * Get safe user avatar URL
       *
       * @param user The user object
       * @return Safe user avatar URL
       */
      public static String getSafeUserAvatarUrl(User user) {
            return getUserAvatarUrl(user);
      }

      /**
       * Debug method to check what URL is being generated
       *
       * @param book The book object
       * @return Debug information
       */
      public static String debugBookImageUrl(Book book) {
            if (book == null) {
                  return "DEBUG: Book is null, using default: " + SUPABASE_BASE_URL + DEFAULT_BOOK_IMAGE;
            }

            String imageUrl = book.getImageUrl();
            String generated = getBookImageUrl(book);

            String result = String.format(
                    "DEBUG: Book='%s', ImageUrl='%s', Generated='%s'",
                    book.getTitle(), imageUrl, generated
            );

            logger.log(Level.INFO, result);
            return result;
      }
}
