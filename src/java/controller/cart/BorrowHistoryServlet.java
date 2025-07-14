package controller.cart;

import dao.implement.BorrowRequestDAO;
import entity.BorrowRequest;
import entity.User;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "BorrowHistoryServlet", urlPatterns = {"/BorrowHistoryServlet"})
public class BorrowHistoryServlet extends HttpServlet {

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loginedUser = (User) session.getAttribute("loginedUser");
        
        if (loginedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            BorrowRequestDAO borrowRequestDAO = new BorrowRequestDAO();

            List<BorrowRequest> allBorrowHistory = borrowRequestDAO.getBorrowRequestsByUser(loginedUser.getId());
            
            // Lấy filter parameter
            String filterStatus = request.getParameter("status");
            String sortBy = request.getParameter("sort");
            
            // Đếm số lượng theo từng status TRƯỚC KHI filter
            long pendingCount = allBorrowHistory.stream().filter(br -> "pending".equalsIgnoreCase(br.getStatus())).count();
            long approvedCount = allBorrowHistory.stream().filter(br -> "approved".equalsIgnoreCase(br.getStatus())).count();
            long borrowedCount = allBorrowHistory.stream().filter(br -> "borrowed".equalsIgnoreCase(br.getStatus())).count(); // THÊM DÒNG NÀY
            long returnedCount = allBorrowHistory.stream().filter(br -> "returned".equalsIgnoreCase(br.getStatus())).count();
            long rejectedCount = allBorrowHistory.stream().filter(br -> "rejected".equalsIgnoreCase(br.getStatus())).count();
            
            // Tạo bản copy để filter
            List<BorrowRequest> borrowHistory = allBorrowHistory;
            
            // Filter theo status nếu có
            if (filterStatus != null && !filterStatus.trim().isEmpty() && !filterStatus.equals("all")) {
                borrowHistory = borrowHistory.stream()
                    .filter(br -> br.getStatus().equalsIgnoreCase(filterStatus))
                    .collect(Collectors.toList());
            }
            
            // Sort theo tiêu chí
            if (sortBy != null && !sortBy.trim().isEmpty()) {
                switch (sortBy) {
                    case "date_desc":
                        borrowHistory.sort((a, b) -> b.getRequestDate().compareTo(a.getRequestDate()));
                        break;
                    case "date_asc":
                        borrowHistory.sort((a, b) -> a.getRequestDate().compareTo(b.getRequestDate()));
                        break;
                    case "status":
                        borrowHistory.sort((a, b) -> {
                            // Sắp xếp theo thứ tự: pending -> approved -> borrowed -> returned -> rejected
                            int priorityA = getStatusPriority(a.getStatus());
                            int priorityB = getStatusPriority(b.getStatus());
                            return Integer.compare(priorityA, priorityB);
                        });
                        break;
                    default:
                        // Mặc định sắp xếp theo ngày mới nhất
                        borrowHistory.sort((a, b) -> b.getRequestDate().compareTo(a.getRequestDate()));
                        break;
                }
            } else {
                // Mặc định sắp xếp theo ngày mới nhất
                borrowHistory.sort((a, b) -> b.getRequestDate().compareTo(a.getRequestDate()));
            }
            
            // Debug: In ra giá trị để kiểm tra
            System.out.println("Filter Status: " + filterStatus);
            System.out.println("Sort By: " + sortBy);
            System.out.println("Total records after filter: " + borrowHistory.size());
            System.out.println("Borrowed Count: " + borrowedCount); // THÊM DEBUG
       
            request.setAttribute("borrowHistory", borrowHistory);
            request.setAttribute("currentFilter", filterStatus);
            request.setAttribute("currentSort", sortBy);
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("approvedCount", approvedCount);
            request.setAttribute("borrowedCount", borrowedCount); // THÊM DÒNG NÀY
            request.setAttribute("returnedCount", returnedCount);
            request.setAttribute("rejectedCount", rejectedCount);
            request.setAttribute("totalCount", borrowHistory.size());
            
            request.getRequestDispatcher("/borrowHistory.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace(); // Thêm để debug
            request.setAttribute("message", "Error fetching borrow history: " + e.getMessage());
            request.setAttribute("messageType", "danger");
            request.getRequestDispatcher("/borrowHistory.jsp").forward(request, response);
        }
    }
    
    private int getStatusPriority(String status) {
        switch (status.toLowerCase()) {
            case "pending":
                return 1;
            case "approved":
                return 2;
            case "borrowed":
                return 3; 
            case "returned":
                return 4; 
            case "rejected":
                return 5; 
            default:
                return 6;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}