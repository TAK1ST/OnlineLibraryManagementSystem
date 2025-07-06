package util;

import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Asynchronous Email Service with improved error handling and configuration
 *
 * @author CAU_TU
 */
public class AsyncSendMail {

      private static final Logger logger = Logger.getLogger(AsyncSendMail.class.getName());

      // Configuration - should be moved to properties file
      private final String fromEmail;
      private final String password;
      private final String companyName;
      private final String websiteUrl;
      private final Properties smtpProps;

      // Thread pool for async operations
      private final ExecutorService executorService;

      /**
       * Constructor with configuration
       */
      public AsyncSendMail(String fromEmail, String password, String companyName, String websiteUrl) {
            this.fromEmail = fromEmail;
            this.password = password;
            this.companyName = companyName;
            this.websiteUrl = websiteUrl;
            this.executorService = Executors.newFixedThreadPool(5); // Pool of 5 threads
            this.smtpProps = createSmtpProperties();
      }

      /**
       * Default constructor using environment variables or default values
       */
      public AsyncSendMail() {
            this(
                    System.getenv("EMAIL_FROM") != null ? System.getenv("EMAIL_FROM") : "vdtuan245@gmail.com",
                    System.getenv("EMAIL_PASSWORD") != null ? System.getenv("EMAIL_PASSWORD") : "xirr aaho kljm etlh",
                    System.getenv("COMPANY_NAME") != null ? System.getenv("COMPANY_NAME") : "Online Library Management",
                    System.getenv("WEBSITE_URL") != null ? System.getenv("WEBSITE_URL") : "https://www.youtube.com/"
            );
      }

      private Properties createSmtpProperties() {
            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.timeout", "10000");
            props.put("mail.smtp.connectiontimeout", "10000");
            return props;
      }

      /**
       * Send welcome email asynchronously
       *
       * @param toEmail recipient email
       * @param username recipient username
       * @return CompletableFuture<Boolean> indicating success/failure
       */
      public CompletableFuture<Boolean> sendWelcomeEmailAsync(String toEmail, String username) {
            return CompletableFuture.supplyAsync(() -> {
                  return sendEmail(toEmail, username, "welcome", null);
            }, executorService);
      }

      /**
       * Send password reset email asynchronously
       *
       * @param toEmail recipient email
       * @param username recipient username
       * @param resetLink password reset link
       * @return CompletableFuture<Boolean> indicating success/failure
       */
      public CompletableFuture<Boolean> sendPasswordResetEmailAsync(String toEmail, String username, String resetLink) {
            return CompletableFuture.supplyAsync(() -> {
                  return sendEmail(toEmail, username, "password_reset", resetLink);
            }, executorService);
      }

      /**
       * Send account verification email asynchronously
       *
       * @param toEmail recipient email
       * @param username recipient username
       * @param verificationLink verification link
       * @return CompletableFuture<Boolean> indicating success/failure
       */
      public CompletableFuture<Boolean> sendAccountVerificationEmailAsync(String toEmail, String username, String verificationLink) {
            return CompletableFuture.supplyAsync(() -> {
                  return sendEmail(toEmail, username, "verification", verificationLink);
            }, executorService);
      }

      /**
       * Send multiple emails asynchronously
       *
       * @param emails array of email data
       * @return CompletableFuture<Boolean> indicating if all emails were sent successfully
       */
      public CompletableFuture<Boolean> sendBulkEmailsAsync(EmailData[] emails) {
            CompletableFuture<Boolean>[] futures = new CompletableFuture[emails.length];

            for (int i = 0; i < emails.length; i++) {
                  EmailData email = emails[i];
                  futures[i] = CompletableFuture.supplyAsync(() -> {
                        return sendEmail(email.toEmail, email.username, email.type, email.actionLink);
                  }, executorService);
            }

            return CompletableFuture.allOf(futures)
                    .thenApply(v -> {
                          for (CompletableFuture<Boolean> future : futures) {
                                try {
                                      if (!future.get()) {
                                            return false;
                                      }
                                } catch (Exception e) {
                                      logger.log(Level.SEVERE, "Error in bulk email sending", e);
                                      return false;
                                }
                          }
                          return true;
                    });
      }

      /**
       * Core method to send email
       *
       * @param toEmail recipient email
       * @param username recipient username
       * @param emailType type of email (welcome, password_reset, verification)
       * @param actionLink optional action link for reset/verification emails
       * @return boolean indicating success/failure
       */
      private boolean sendEmail(String toEmail, String username, String emailType, String actionLink) {
            try {
                  // Input validation
                  if (toEmail == null || toEmail.trim().isEmpty()) {
                        logger.warning("Invalid recipient email address");
                        return false;
                  }

                  if (username == null || username.trim().isEmpty()) {
                        logger.warning("Invalid username");
                        return false;
                  }

                  Session session = Session.getInstance(smtpProps, new jakarta.mail.Authenticator() {
                        @Override
                        protected PasswordAuthentication getPasswordAuthentication() {
                              return new PasswordAuthentication(fromEmail, password);
                        }
                  });

                  Message msg = new MimeMessage(session);
                  msg.setFrom(new InternetAddress(fromEmail, companyName, "UTF-8"));
                  msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));

                  // Set subject and content based on email type
                  switch (emailType.toLowerCase()) {
                        case "welcome":
                              msg.setSubject("Welcome to " + companyName + "!");
                              msg.setContent(getWelcomeEmailTemplate(username), "text/html; charset=UTF-8");
                              break;
                        case "password_reset":
                              if (actionLink == null || actionLink.trim().isEmpty()) {
                                    logger.warning("Password reset link is required");
                                    return false;
                              }
                              msg.setSubject("Password Reset Request - " + companyName);
                              msg.setContent(getPasswordResetTemplate(username, actionLink), "text/html; charset=UTF-8");
                              break;
                        case "verification":
                              if (actionLink == null || actionLink.trim().isEmpty()) {
                                    logger.warning("Verification link is required");
                                    return false;
                              }
                              msg.setSubject("Verify Your Account - " + companyName);
                              msg.setContent(getVerificationTemplate(username, actionLink), "text/html; charset=UTF-8");
                              break;
                        default:
                              logger.warning("Unknown email type: " + emailType);
                              msg.setSubject("Notification from " + companyName);
                              msg.setContent(getWelcomeEmailTemplate(username), "text/html; charset=UTF-8");
                  }

                  Transport.send(msg);
                  logger.info("Email sent successfully to: " + toEmail + " (Type: " + emailType + ")");
                  return true;

            } catch (Exception e) {
                  logger.log(Level.SEVERE, "Failed to send email to: " + toEmail + " (Type: " + emailType + ")", e);
                  return false;
            }
      }

      /**
       * Shutdown the executor service gracefully
       */
      public void shutdown() {
            executorService.shutdown();
            try {
                  if (!executorService.awaitTermination(60, TimeUnit.SECONDS)) {
                        executorService.shutdownNow();
                        if (!executorService.awaitTermination(60, TimeUnit.SECONDS)) {
                              logger.warning("Pool did not terminate");
                        }
                  }
            } catch (InterruptedException ie) {
                  executorService.shutdownNow();
                  Thread.currentThread().interrupt();
            }
      }

      /**
       * Get executor service statistics
       */
      public String getExecutorStats() {
            if (executorService instanceof java.util.concurrent.ThreadPoolExecutor) {
                  java.util.concurrent.ThreadPoolExecutor tpe = (java.util.concurrent.ThreadPoolExecutor) executorService;
                  return String.format("Active: %d, Completed: %d, Task: %d, isShutdown: %s",
                          tpe.getActiveCount(), tpe.getCompletedTaskCount(), tpe.getTaskCount(), tpe.isShutdown());
            }
            return "Stats not available";
      }

      // Email templates remain the same but extracted for better maintainability
      private String getWelcomeEmailTemplate(String username) {
            String currentDate = LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));

            return "<!DOCTYPE html>"
                    + "<html lang='vi'>"
                    + "<head>"
                    + "    <meta charset='UTF-8'>"
                    + "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>"
                    + "    <title>Welcome Email</title>"
                    + "</head>"
                    + "<body style='margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;'>"
                    + "    <table role='presentation' style='width: 100%; border-collapse: collapse;'>"
                    + "        <tr>"
                    + "            <td style='padding: 0;'>"
                    + "                <table role='presentation' style='width: 100%; max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);'>"
                    + "                    <tr>"
                    + "                        <td style='background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 40px 30px; text-align: center;'>"
                    + "                            <h1 style='color: #ffffff; margin: 0; font-size: 28px; font-weight: 700;'>🎉 Chào mừng bạn!</h1>"
                    + "                            <p style='color: #ffffff; margin: 10px 0 0 0; font-size: 16px; opacity: 0.9;'>Cảm ơn bạn đã tham gia cộng đồng của chúng tôi</p>"
                    + "                        </td>"
                    + "                    </tr>"
                    + "                    <tr>"
                    + "                        <td style='padding: 40px 30px;'>"
                    + "                            <h2 style='color: #333333; margin: 0 0 20px 0; font-size: 24px;'>Xin chào " + username + "!</h2>"
                    + "                            <p style='color: #666666; line-height: 1.6; margin: 0 0 20px 0; font-size: 16px;'>"
                    + "                                Chúng tôi rất vui mừng chào đón bạn đến với <strong>" + companyName + "</strong>. "
                    + "                                Tài khoản của bạn đã được tạo thành công và bạn có thể bắt đầu khám phá các tính năng của chúng tôi ngay bây giờ."
                    + "                            </p>"
                    + "                            <div style='background-color: #f8f9fa; border-radius: 8px; padding: 25px; margin: 25px 0;'>"
                    + "                                <h3 style='color: #333333; margin: 0 0 15px 0; font-size: 18px;'>🚀 Bạn có thể làm gì tiếp theo?</h3>"
                    + "                                <ul style='color: #666666; margin: 0; padding-left: 20px; line-height: 1.8;'>"
                    + "                                    <li>Hoàn thiện thông tin cá nhân của bạn</li>"
                    + "                                    <li>Khám phá các tính năng mới</li>"
                    + "                                    <li>Kết nối với cộng đồng</li>"
                    + "                                    <li>Tham gia các hoạt động thú vị</li>"
                    + "                                </ul>"
                    + "                            </div>"
                    + "                            <div style='text-align: center; margin: 30px 0;'>"
                    + "                                <a href='" + websiteUrl + "' style='display: inline-block; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: #ffffff; text-decoration: none; padding: 15px 30px; border-radius: 25px; font-weight: 600; font-size: 16px; transition: all 0.3s ease;'>Bắt đầu ngay</a>"
                    + "                            </div>"
                    + "                        </td>"
                    + "                    </tr>"
                    + "                    <tr>"
                    + "                        <td style='background-color: #f8f9fa; padding: 30px; text-align: center; border-top: 1px solid #e9ecef;'>"
                    + "                            <p style='color: #666666; margin: 0 0 10px 0; font-size: 14px;'>"
                    + "                                Cần hỗ trợ? Liên hệ với chúng tôi tại <a href='mailto:" + fromEmail + "' style='color: #667eea; text-decoration: none;'>" + fromEmail + "</a>"
                    + "                            </p>"
                    + "                            <p style='color: #999999; margin: 0; font-size: 12px;'>"
                    + "                                © 2024 " + companyName + ". Tất cả quyền được bảo lưu.<br>"
                    + "                                Email được gửi vào ngày " + currentDate
                    + "                            </p>"
                    + "                        </td>"
                    + "                    </tr>"
                    + "                </table>"
                    + "            </td>"
                    + "        </tr>"
                    + "    </table>"
                    + "</body>"
                    + "</html>";
      }

      private String getPasswordResetTemplate(String username, String resetLink) {
            return "<!DOCTYPE html>"
                    + "<html lang='vi'>"
                    + "<head>"
                    + "    <meta charset='UTF-8'>"
                    + "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>"
                    + "    <title>Password Reset</title>"
                    + "</head>"
                    + "<body style='margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;'>"
                    + "    <table role='presentation' style='width: 100%; max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);'>"
                    + "        <tr>"
                    + "            <td style='background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%); padding: 40px 30px; text-align: center;'>"
                    + "                <h1 style='color: #ffffff; margin: 0; font-size: 28px; font-weight: 700;'>🔐 Đặt lại mật khẩu</h1>"
                    + "            </td>"
                    + "        </tr>"
                    + "        <tr>"
                    + "            <td style='padding: 40px 30px;'>"
                    + "                <h2 style='color: #333333; margin: 0 0 20px 0;'>Xin chào " + username + "!</h2>"
                    + "                <p style='color: #666666; line-height: 1.6; margin: 0 0 20px 0;'>"
                    + "                    Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn. "
                    + "                    Nhấp vào nút bên dưới để tạo mật khẩu mới:"
                    + "                </p>"
                    + "                <div style='text-align: center; margin: 30px 0;'>"
                    + "                    <a href='" + resetLink + "' style='display: inline-block; background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%); color: #ffffff; text-decoration: none; padding: 15px 30px; border-radius: 25px; font-weight: 600;'>Đặt lại mật khẩu</a>"
                    + "                </div>"
                    + "                <div style='background-color: #fff3cd; border: 1px solid #ffeaa7; border-radius: 8px; padding: 20px; margin: 20px 0;'>"
                    + "                    <p style='color: #856404; margin: 0; font-size: 14px;'> <strong> Lưu ý:</strong> Link này sẽ hết hạn sau 24 giờ. Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này."
                    + "                    </p>"
                    + "                </div>"
                    + "            </td>"
                    + "        </tr>"
                    + "    </table>"
                    + "</body>"
                    + "</html>";
      }

      private String getVerificationTemplate(String username, String verificationLink) {
            return "<!DOCTYPE html>"
                    + "<html lang='vi'>"
                    + "<head>"
                    + "    <meta charset='UTF-8'>"
                    + "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>"
                    + "    <title>Account Verification</title>"
                    + "</head>"
                    + "<body style='margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;'>"
                    + "    <table role='presentation' style='width: 100%; max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);'>"
                    + "        <tr>"
                    + "            <td style='background: linear-gradient(135deg, #2ed573 0%, #1e90ff 100%); padding: 40px 30px; text-align: center;'>"
                    + "                <h1 style='color: #ffffff; margin: 0; font-size: 28px; font-weight: 700;'>✅ Xác thực tài khoản</h1>"
                    + "            </td>"
                    + "        </tr>"
                    + "        <tr>"
                    + "            <td style='padding: 40px 30px;'>"
                    + "                <h2 style='color: #333333; margin: 0 0 20px 0;'>Xin chào " + username + "!</h2>"
                    + "                <p style='color: #666666; line-height: 1.6; margin: 0 0 20px 0;'>"
                    + "                    Để hoàn tất quá trình đăng ký, vui lòng xác thực địa chỉ email của bạn bằng cách nhấp vào nút bên dưới:"
                    + "                </p>"
                    + "                <div style='text-align: center; margin: 30px 0;'>"
                    + "                    <a href='" + verificationLink + "' style='display: inline-block; background: linear-gradient(135deg, #2ed573 0%, #1e90ff 100%); color: #ffffff; text-decoration: none; padding: 15px 30px; border-radius: 25px; font-weight: 600;'>Xác thực tài khoản</a>"
                    + "                </div>"
                    + "            </td>"
                    + "        </tr>"
                    + "    </table>"
                    + "</body>"
                    + "</html>";
      }

      /**
       * Data class for bulk email operations
       */
      public static class EmailData {

            public final String toEmail;
            public final String username;
            public final String type;
            public final String actionLink;

            public EmailData(String toEmail, String username, String type, String actionLink) {
                  this.toEmail = toEmail;
                  this.username = username;
                  this.type = type;
                  this.actionLink = actionLink;
            }

            public EmailData(String toEmail, String username, String type) {
                  this(toEmail, username, type, null);
            }
      }
}
