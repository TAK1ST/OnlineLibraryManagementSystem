package controller.auth;

import dao.implement.BookDAO;
import entity.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            BookDAO dao = new BookDAO();

            // Lấy sách mới nhất
            List<Book> newBooks = dao.getNewBooks();
            request.setAttribute("newBooks", newBooks);

            // Lấy tất cả categories cho dropdown
            List<String> categories = dao.getAllCategories();
            request.setAttribute("categories", categories);

            // Đọc cookie recentKeyword
            String recentKeyword = null;
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("recentKeyword".equals(cookie.getName())) {
                        try {
                            recentKeyword = URLDecoder.decode(cookie.getValue(), "UTF-8");
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        break;
                    }
                }
}

            if (recentKeyword != null && !recentKeyword.trim().isEmpty()) {
                List<Book> recommendedBooks = dao.getBookByTitle(recentKeyword);
                request.setAttribute("recommendedBooks", recommendedBooks);
                request.setAttribute("recentKeyword", recentKeyword);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi tải trang.");
        }

        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
}
