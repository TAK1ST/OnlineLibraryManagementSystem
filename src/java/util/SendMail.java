/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 *
 * @author CAU_TU
 */
public class SendMail {
    
    private final String fromEmail = "vdtuan245@gmail.com";
    private final String password = "xirr aaho kljm etlh";
    private final String companyName = "Online Library Management";
    private final String websiteUrl = "https://www.youtube.com/";
    
    public void sendWelcomeEmail(String toEmail, String username) {
        sendEmail(toEmail, username, "welcome");
    }
    
    public void sendPasswordResetEmail(String toEmail, String username, String resetLink) {
        sendCustomEmail(toEmail, username, "password_reset", resetLink);
    }
    
    public void sendAccountVerificationEmail(String toEmail, String username, String verificationLink) {
        sendCustomEmail(toEmail, username, "verification", verificationLink);
    }
    
    private void sendEmail(String toEmail, String username, String emailType) {
        sendCustomEmail(toEmail, username, emailType, null);
    }
    
    private void sendCustomEmail(String toEmail, String username, String emailType, String actionLink) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        
        Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });
        
        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(fromEmail, companyName, "UTF-8"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            
            // Set subject and content based on email type
            switch (emailType) {
                case "welcome":
                    msg.setSubject("Welcome to " + companyName + "!");
                    msg.setContent(getWelcomeEmailTemplate(username), "text/html; charset=UTF-8");
                    break;
                case "password_reset":
                    msg.setSubject("Password Reset Request - " + companyName);
                    msg.setContent(getPasswordResetTemplate(username, actionLink), "text/html; charset=UTF-8");
                    break;
                case "verification":
                    msg.setSubject("Verify Your Account - " + companyName);
                    msg.setContent(getVerificationTemplate(username, actionLink), "text/html; charset=UTF-8");
                    break;
                default:
                    msg.setSubject("Notification from " + companyName);
                    msg.setContent(getWelcomeEmailTemplate(username), "text/html; charset=UTF-8");
            }
            
            Transport.send(msg);
            System.out.println("Email sent successfully to: " + toEmail);
            
        } catch (Exception e) {
            System.err.println("Failed to send email to: " + toEmail);
            e.printStackTrace();
        }
    }
    
    private String getWelcomeEmailTemplate(String username) {
        String currentDate = LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        
        return "<!DOCTYPE html>" +
                "<html lang='vi'>" +
                "<head>" +
                "    <meta charset='UTF-8'>" +
                "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                "    <title>Welcome Email</title>" +
                "</head>" +
                "<body style='margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;'>" +
                "    <table role='presentation' style='width: 100%; border-collapse: collapse;'>" +
                "        <tr>" +
                "            <td style='padding: 0;'>" +
                "                <table role='presentation' style='width: 100%; max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);'>" +
                "                    <!-- Header -->" +
                "                    <tr>" +
                "                        <td style='background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 40px 30px; text-align: center;'>" +
                "                            <h1 style='color: #ffffff; margin: 0; font-size: 28px; font-weight: 700;'>🎉 Chào mừng bạn!</h1>" +
                "                            <p style='color: #ffffff; margin: 10px 0 0 0; font-size: 16px; opacity: 0.9;'>Cảm ơn bạn đã tham gia cộng đồng của chúng tôi</p>" +
                "                        </td>" +
                "                    </tr>" +
                "                    <!-- Content -->" +
                "                    <tr>" +
                "                        <td style='padding: 40px 30px;'>" +
                "                            <h2 style='color: #333333; margin: 0 0 20px 0; font-size: 24px;'>Xin chào " + username + "!</h2>" +
                "                            <p style='color: #666666; line-height: 1.6; margin: 0 0 20px 0; font-size: 16px;'>" +
                "                                Chúng tôi rất vui mừng chào đón bạn đến với <strong>" + companyName + "</strong>. " +
                "                                Tài khoản của bạn đã được tạo thành công và bạn có thể bắt đầu khám phá các tính năng của chúng tôi ngay bây giờ." +
                "                            </p>" +
                "                            <div style='background-color: #f8f9fa; border-radius: 8px; padding: 25px; margin: 25px 0;'>" +
                "                                <h3 style='color: #333333; margin: 0 0 15px 0; font-size: 18px;'>🚀 Bạn có thể làm gì tiếp theo?</h3>" +
                "                                <ul style='color: #666666; margin: 0; padding-left: 20px; line-height: 1.8;'>" +
                "                                    <li>Hoàn thiện thông tin cá nhân của bạn</li>" +
                "                                    <li>Khám phá các tính năng mới</li>" +
                "                                    <li>Kết nối với cộng đồng</li>" +
                "                                    <li>Tham gia các hoạt động thú vị</li>" +
                "                                </ul>" +
                "                            </div>" +
                "                            <div style='text-align: center; margin: 30px 0;'>" +
                "                                <a href='" + websiteUrl + "' style='display: inline-block; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: #ffffff; text-decoration: none; padding: 15px 30px; border-radius: 25px; font-weight: 600; font-size: 16px; transition: all 0.3s ease;'>Bắt đầu ngay</a>" +
                "                            </div>" +
                "                        </td>" +
                "                    </tr>" +
                "                    <!-- Footer -->" +
                "                    <tr>" +
                "                        <td style='background-color: #f8f9fa; padding: 30px; text-align: center; border-top: 1px solid #e9ecef;'>" +
                "                            <p style='color: #666666; margin: 0 0 10px 0; font-size: 14px;'>" +
                "                                Cần hỗ trợ? Liên hệ với chúng tôi tại <a href='mailto:" + fromEmail + "' style='color: #667eea; text-decoration: none;'>" + fromEmail + "</a>" +
                "                            </p>" +
                "                            <p style='color: #999999; margin: 0; font-size: 12px;'>" +
                "                                © 2024 " + companyName + ". Tất cả quyền được bảo lưu.<br>" +
                "                                Email được gửi vào ngày " + currentDate +
                "                            </p>" +
                "                        </td>" +
                "                    </tr>" +
                "                </table>" +
                "            </td>" +
                "        </tr>" +
                "    </table>" +
                "</body>" +
                "</html>";
    }
    
    private String getPasswordResetTemplate(String username, String resetLink) {
        return "<!DOCTYPE html>" +
                "<html lang='vi'>" +
                "<head>" +
                "    <meta charset='UTF-8'>" +
                "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                "    <title>Password Reset</title>" +
                "</head>" +
                "<body style='margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;'>" +
                "    <table role='presentation' style='width: 100%; max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);'>" +
                "        <tr>" +
                "            <td style='background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%); padding: 40px 30px; text-align: center;'>" +
                "                <h1 style='color: #ffffff; margin: 0; font-size: 28px; font-weight: 700;'>🔐 Đặt lại mật khẩu</h1>" +
                "            </td>" +
                "        </tr>" +
                "        <tr>" +
                "            <td style='padding: 40px 30px;'>" +
                "                <h2 style='color: #333333; margin: 0 0 20px 0;'>Xin chào " + username + "!</h2>" +
                "                <p style='color: #666666; line-height: 1.6; margin: 0 0 20px 0;'>" +
                "                    Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn. " +
                "                    Nhấp vào nút bên dưới để tạo mật khẩu mới:" +
                "                </p>" +
                "                <div style='text-align: center; margin: 30px 0;'>" +
                "                    <a href='" + resetLink + "' style='display: inline-block; background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%); color: #ffffff; text-decoration: none; padding: 15px 30px; border-radius: 25px; font-weight: 600;'>Đặt lại mật khẩu</a>" +
                "                </div>" +
                "                <div style='background-color: #fff3cd; border: 1px solid #ffeaa7; border-radius: 8px; padding: 20px; margin: 20px 0;'>" +
                "                    <p style='color: #856404; margin: 0; font-size: 14px;'>" +
                "                        <strong>⚠️ Lưu ý:</strong> Link này sẽ hết hạn sau 24 giờ. Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này." +
                "                    </p>" +
                "                </div>" +
                "            </td>" +
                "        </tr>" +
                "    </table>" +
                "</body>" +
                "</html>";
    }
    
    private String getVerificationTemplate(String username, String verificationLink) {
        return "<!DOCTYPE html>" +
                "<html lang='vi'>" +
                "<head>" +
                "    <meta charset='UTF-8'>" +
                "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                "    <title>Account Verification</title>" +
                "</head>" +
                "<body style='margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;'>" +
                "    <table role='presentation' style='width: 100%; max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);'>" +
                "        <tr>" +
                "            <td style='background: linear-gradient(135deg, #2ed573 0%, #1e90ff 100%); padding: 40px 30px; text-align: center;'>" +
                "                <h1 style='color: #ffffff; margin: 0; font-size: 28px; font-weight: 700;'>✅ Xác thực tài khoản</h1>" +
                "            </td>" +
                "        </tr>" +
                "        <tr>" +
                "            <td style='padding: 40px 30px;'>" +
                "                <h2 style='color: #333333; margin: 0 0 20px 0;'>Xin chào " + username + "!</h2>" +
                "                <p style='color: #666666; line-height: 1.6; margin: 0 0 20px 0;'>" +
                "                    Để hoàn tất quá trình đăng ký, vui lòng xác thực địa chỉ email của bạn bằng cách nhấp vào nút bên dưới:" +
                "                </p>" +
                "                <div style='text-align: center; margin: 30px 0;'>" +
                "                    <a href='" + verificationLink + "' style='display: inline-block; background: linear-gradient(135deg, #2ed573 0%, #1e90ff 100%); color: #ffffff; text-decoration: none; padding: 15px 30px; border-radius: 25px; font-weight: 600;'>Xác thực tài khoản</a>" +
                "                </div>" +
                "            </td>" +
                "        </tr>" +
                "    </table>" +
                "</body>" +
                "</html>";
    }
}