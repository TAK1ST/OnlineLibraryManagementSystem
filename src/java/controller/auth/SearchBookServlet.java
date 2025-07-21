package controller.auth;

import dao.implement.BookDAO;
import entity.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "SearchBook", urlPatterns = {"/search"})
public class SearchBookServlet extends HttpServlet {

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy các tham số tìm kiếm
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String category = request.getParameter("category");

        BookDAO bookDAO = new BookDAO();
        ArrayList<Book> books = new ArrayList<>();
        ArrayList<Book> newBooks = new ArrayList<>();
        String contextPath = request.getContextPath();

        try {
            if ((title == null || title.trim().isEmpty())
                    && (author == null || author.trim().isEmpty())
                    && (category == null || category.trim().isEmpty())) {

                books = new ArrayList<>(bookDAO.getAllBook());
                newBooks = new ArrayList<>(bookDAO.getNewBooks());
            } else {
                books = bookDAO.searchBooks(title, author, category);
            }

            // TẠO COOKIE CHỈ KHI SEARCH BẰNG TITLE
            if (title != null && !title.trim().isEmpty()) {
                try {
                    Cookie recentKeyword = new Cookie("recentKeyword", URLEncoder.encode(title.trim(), "UTF-8"));
                    if (contextPath == null || contextPath.isEmpty()) {
                        recentKeyword.setPath("/");
                    } else {
                        recentKeyword.setPath(contextPath + "/");
                    }
                    recentKeyword.setMaxAge(7*24*3600); // 7 ngày
                    recentKeyword.setHttpOnly(false);
                    response.addCookie(recentKeyword);

                    // Debug log
                    System.out.println("=== COOKIE CREATED ===");
                    System.out.println("Title searched: " + title.trim());
                    System.out.println("Encoded title: " + URLEncoder.encode(title.trim(), "UTF-8"));
                    System.out.println("Cookie path: " + recentKeyword.getPath());
                    System.out.println("Context path: " + contextPath);
                    System.out.println("=== END COOKIE DEBUG ===");
                } catch (Exception e) {
                    System.err.println("Error encoding cookie: " + e.getMessage());
                }
            }

            // Gửi danh mục thể loại cho dropdown
            ArrayList<String> categories = bookDAO.getAllCategories();

            // Gửi dữ liệu về JSP
            request.setAttribute("categories", categories);
            request.setAttribute("books", books);
            request.setAttribute("newBooks", newBooks);
            request.setAttribute("title", title);
            request.setAttribute("author", author);
            request.setAttribute("category", category);

        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(SearchBookServlet.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "Đã xảy ra lỗi khi xử lý tìm kiếm.");
        } catch (Exception ex) {
            Logger.getLogger(SearchBookServlet.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "Đã xảy ra lỗi không xác định.");
        }

        request.getRequestDispatcher("search.jsp").forward(request, response);
    }
}
