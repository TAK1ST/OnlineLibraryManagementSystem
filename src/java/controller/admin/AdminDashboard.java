/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import constant.ViewURL;
import dto.BorrowedBookDTO;
import entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import service.implement.StatisticService;

/**
 *
 * @author asus
 */
public class AdminDashboard extends BaseAdminController {

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
       // Check authentication and authorization
        User adminUser = checkAdminAuthentication(request, response);
        if (adminUser == null) {
            return; // Already redirected to login //why it need return
        }
        
        StatisticService statisticService = new StatisticService();
        
        List<BorrowedBookDTO> bookList = statisticService.getTop5BorrowedBooks();
        int[] monthlyData = statisticService.getMonthlyData();
        int totalUser = statisticService.getTotalUser();
        int totalBook = statisticService.getTotalBook();
        int currentlyBorrowed = statisticService.getTotalCurrentBorrowPerWeek();
        int avgDuration = statisticService.calculateAverageBorrowPerDay();

        request.setAttribute("totalUsersCount", totalUser);
        request.setAttribute("totalBooksCount", totalBook);
        request.setAttribute("currentlyBorrowed", currentlyBorrowed);
        request.setAttribute("avgDuration", avgDuration);
        request.setAttribute("bookList", bookList);
        request.setAttribute("monthlyData", monthlyData);
        request.getRequestDispatcher(ViewURL.ADMIN_DASHBOARD).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Admin Dashboard Controller";
    }
}
