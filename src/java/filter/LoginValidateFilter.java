/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Filter.java to edit this template
 */
package filter;

import constant.Regex;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author CAU_TU
 */
public class LoginValidateFilter implements Filter {

    private static final boolean debug = false; // Tắt debug để tránh spam log
    private FilterConfig filterConfig = null;

    public LoginValidateFilter() {
    }

    /**
     * Xử lý trước khi filter chạy
     */
    private void doBeforeProcessing(ServletRequest request, ServletResponse response)
            throws IOException, ServletException {
        if (debug) {
            log("LoginValidateFilter:DoBeforeProcessing");
        }
    }

    /**
     * Xử lý sau khi filter chạy
     */
    private void doAfterProcessing(ServletRequest request, ServletResponse response)
            throws IOException, ServletException {
        if (debug) {
            log("LoginValidateFilter:DoAfterProcessing");
        }
    }

    /**
     * Filter chính - validate dữ liệu đăng nhập
     */
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        if (debug) {
            log("LoginValidateFilter:doFilter()");
        }

        doBeforeProcessing(request, response);

        Throwable problem = null;
        try {
            HttpServletRequest httpRequest = (HttpServletRequest) request;
            HttpServletResponse httpResponse = (HttpServletResponse) response;

            // Chỉ validate khi là POST request (submit form đăng nhập)
            if ("POST".equalsIgnoreCase(httpRequest.getMethod())) {
                String email = request.getParameter("txtemail");
                String password = request.getParameter("txtpassword");

                // Validate email
                if (email == null || email.trim().isEmpty()) {
                    request.setAttribute("error", "Email cannot be empty!");
                    request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
                    return;
                }

                // Validate email format
                if (!email.trim().matches(Regex.EMAIL_REGEX)) {
                    request.setAttribute("error", "You must enter your email format correctly! (Ex: abc@gmail.com)");
                    request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
                    return;
                }

                // Validate password
                if (password == null || password.trim().isEmpty()) {
                    request.setAttribute("error", "Password cannot be empty!");
                    request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
                    return;
                }

                // Nếu validation pass, tiếp tục đến LoginServlet
                chain.doFilter(request, response);
            } else {
                // Đối với GET request, chỉ cần forward
                chain.doFilter(request, response);
            }

        } catch (Throwable t) {
            problem = t;
            if (debug) {
                t.printStackTrace();
            }
        }

        doAfterProcessing(request, response);

        // Xử lý lỗi nếu có
        if (problem != null) {
            if (problem instanceof ServletException) {
                throw (ServletException) problem;
            }
            if (problem instanceof IOException) {
                throw (IOException) problem;
            }
            sendProcessingError(problem, response);
        }
    }

    /**
     * Getter cho FilterConfig
     */
    public FilterConfig getFilterConfig() {
        return (this.filterConfig);
    }

    /**
     * Setter cho FilterConfig
     */
    public void setFilterConfig(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
    }

    /**
     * Destroy method
     */
    public void destroy() {
        // Cleanup resources if needed
    }

    /**
     * Init method
     */
    public void init(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
        if (filterConfig != null) {
            if (debug) {
                log("LoginValidateFilter: Initializing filter");
            }
        }
    }

    /**
     * ToString method
     */
    @Override
    public String toString() {
        if (filterConfig == null) {
            return ("LoginValidateFilter()");
        }
        StringBuffer sb = new StringBuffer("LoginValidateFilter(");
        sb.append(filterConfig);
        sb.append(")");
        return (sb.toString());
    }

    /**
     * Xử lý lỗi và hiển thị stack trace
     */
    private void sendProcessingError(Throwable t, ServletResponse response) {
        String stackTrace = getStackTrace(t);

        if (stackTrace != null && !stackTrace.equals("")) {
            try {
                response.setContentType("text/html");
                PrintStream ps = new PrintStream(response.getOutputStream());
                PrintWriter pw = new PrintWriter(ps);
                pw.print("<html>\n<head>\n<title>Error</title>\n</head>\n<body>\n");
                pw.print("<h1>The resource did not process correctly</h1>\n<pre>\n");
                pw.print(stackTrace);
                pw.print("</pre></body>\n</html>");
                pw.close();
                ps.close();
                response.getOutputStream().close();
            } catch (Exception ex) {
                // Log exception nếu cần
            }
        } else {
            try {
                PrintStream ps = new PrintStream(response.getOutputStream());
                t.printStackTrace(ps);
                ps.close();
                response.getOutputStream().close();
            } catch (Exception ex) {
                // Log exception nếu cần
            }
        }
    }

    /**
     * Lấy stack trace dưới dạng String
     */
    public static String getStackTrace(Throwable t) {
        String stackTrace = null;
        try {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            t.printStackTrace(pw);
            pw.close();
            sw.close();
            stackTrace = sw.getBuffer().toString();
        } catch (Exception ex) {
            // Ignore
        }
        return stackTrace;
    }

    /**
     * Log message
     */
    public void log(String msg) {
        if (filterConfig != null) {
            filterConfig.getServletContext().log(msg);
        }
    }
}