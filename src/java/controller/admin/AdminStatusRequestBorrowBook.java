/*
 * Click nbfs://SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.admin;

import constant.ViewURL;
import static constant.constance.RECORDS_PER_LOAD;
import dto.BookInforRequestStatusDTO;
import entity.Book;
import entity.BookRequest;
import entity.User;
import java.io.IOException;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import service.implement.BookRequestStatusService;

/**
 *
 * @author asus
 */
public class AdminStatusRequestBorrowBook extends BaseAdminController {

      @Override
      public void doGet(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {

            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            User adminUser = checkAdminAuthentication(request, response);
            if (adminUser == null) {
                  return;
            }

            BookRequestStatusService service = new BookRequestStatusService();
            String ajax = request.getParameter("ajax");
            String searchTitle = request.getParameter("searchTitle");
            String searchStatus = request.getParameter("searchStatus");
            int offset = request.getParameter("offset") != null ? Integer.parseInt(request.getParameter("offset")) : 0;

            if (searchTitle != null && searchTitle.trim().isEmpty()) {
                  searchTitle = null;
            }
            if (searchStatus != null && !searchStatus.trim().isEmpty()) {
                  searchStatus = searchStatus.split("_")[0].toLowerCase();
            }

            List<BookInforRequestStatusDTO> bookStatusList = service.getAllBookRequestStatusLazyLoading(searchTitle, searchStatus, offset);
            if (bookStatusList == null) {
                  bookStatusList = new ArrayList<>();
            }
            request.setAttribute("bookStatusList", bookStatusList);
            System.out.println("bookStatusList size: " + (bookStatusList != null ? bookStatusList.size() : "null"));

            if (bookStatusList.isEmpty()) {
                  request.setAttribute("emptyMessage", "No matching book borrowing requests found!");
            }

            request.setAttribute("recordsPerPage", RECORDS_PER_LOAD);
            request.setAttribute("offset", offset);

            HttpSession session = request.getSession();
            String successMessage = (String) session.getAttribute("successMessage");
            String errorMessage = (String) session.getAttribute("errorMessage");

            if (successMessage != null) {
                  request.setAttribute("successMessage", successMessage);
                  session.removeAttribute("successMessage");
            }

            if (errorMessage != null) {
                  request.setAttribute("errorMessage", errorMessage);
                  session.removeAttribute("errorMessage");
            }

            if ("true".equals(ajax)) {
                  response.setContentType("text/html; charset=UTF-8");
                  request.getRequestDispatcher(ViewURL.BOOK_REQUEST_LIST_FRAGMENT).include(request, response);
            } else {
                  request.getRequestDispatcher(ViewURL.ADMIN_STATUS_REQUEST_BORROW_BOOK).forward(request, response);
            }
      }

      @Override
      public void doPost(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
            BookRequestStatusService service = new BookRequestStatusService();
            String requestId = request.getParameter("requestId");
            String action = request.getParameter("action");
            HttpSession session = request.getSession();

            try {
                  if (requestId == null || requestId.trim().isEmpty() || !requestId.matches("\\d+")) {
                        throw new IllegalArgumentException("ID yêu cầu không hợp lệ");
                  }

                  if (action == null || action.trim().isEmpty()) {
                        throw new IllegalArgumentException("Hành động không hợp lệ");
                  }

                  int id = Integer.parseInt(requestId);

                  if (!action.equals("approve") && !action.equals("reject") && !action.equals("borrow")) {
                        throw new IllegalArgumentException("Hành động không hợp lệ: " + action);
                  }

                  switch (action) {
                        case "approve":
                              processApprove(service, id, session, request);
                              break;
                        case "reject":
                              processReject(service, id, session);
                              break;
                        case "borrow":
                              processBorrow(service, id, session);
                              break;
                  }

                  response.sendRedirect(request.getContextPath() + "/statusrequestborrowbook");

            } catch (NumberFormatException e) {
                  e.printStackTrace();
                  session.setAttribute("errorMessage", "Định dạng ID yêu cầu không hợp lệ");
                  response.sendRedirect(request.getContextPath() + "/statusrequestborrowbook");
            } catch (Exception e) {
                  e.printStackTrace();
                  session.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
                  response.sendRedirect(request.getContextPath() + "/statusrequestborrowbook");
            }
      }

      private void processApprove(BookRequestStatusService service, int requestId, HttpSession session, HttpServletRequest request) throws Exception {
            try {
                  BookRequest bookRequest = service.getBookRequestById(requestId)
                          .orElseThrow(() -> new Exception("Yêu cầu không tìm thấy với ID: " + requestId));

                  String requestType = bookRequest.getRequestType() != null ? bookRequest.getRequestType().toLowerCase() : "borrow";
                  String currentStatus = bookRequest.getStatus() != null ? bookRequest.getStatus().toLowerCase() : "pending";

                  if (!"pending".equals(currentStatus)) {
                        throw new IllegalStateException("Yêu cầu không ở trạng thái pending: " + currentStatus);
                  }

                  // Kiểm tra số lượng bản sao sách nếu là yêu cầu mượn
                  if ("borrow".equalsIgnoreCase(requestType)) {
                        Book book = service.getBookDAO(requestId);
                        if (book == null) {
                              throw new IllegalStateException("Sách không tìm thấy với ID: " + bookRequest.getBookId());
                        }
                        if (book.getAvailableCopies() <= 0) {
                              throw new IllegalStateException("Sách không còn bản sao nào khả dụng");
                        }
                        if (!"active".equalsIgnoreCase(book.getStatus())) {
                              throw new IllegalStateException("Sách không ở trạng thái active");
                        }
                  }

                  // Cập nhật trạng thái
                  String newStatus = "borrow".equalsIgnoreCase(requestType) ? "approved-borrow" : "approved-return";
                  boolean success = service.updateBookRequestStatus(requestId, newStatus);
                  if (!success) {
                        throw new Exception("Không thể cập nhật trạng thái yêu cầu");
                  }

                  String actionType = "borrow".equalsIgnoreCase(requestType) ? "mượn" : "trả";
                  session.setAttribute("successMessage", "Yêu cầu #" + requestId + " đã được phê duyệt cho " + actionType + " thành công!");
                  System.out.println("Phê duyệt yêu cầu ID: " + requestId + ", Loại: " + requestType + ", Trạng thái mới: " + newStatus);

            } catch (Exception e) {
                  System.err.println("Lỗi trong processApprove: " + e.getMessage());
                  e.printStackTrace();
                  session.setAttribute("errorMessage", e.getMessage()); // Cập nhật thông báo lỗi chi tiết
                  throw e;
            }
      }

      private void processReject(BookRequestStatusService service, int requestId, HttpSession session) throws Exception {
            try {
                  boolean success = service.updateBookRequestStatus(requestId, "rejected");
                  if (!success) {
                        throw new Exception("Không thể từ chối yêu cầu");
                  }
                  session.setAttribute("successMessage", "Yêu cầu #" + requestId + " đã bị từ chối thành công!");
                  System.out.println("Từ chối yêu cầu ID: " + requestId);
            } catch (Exception e) {
                  System.err.println("Lỗi trong processReject: " + e.getMessage());
                  e.printStackTrace();
                  throw e;
            }
      }

      private void processBorrow(BookRequestStatusService service, int requestId, HttpSession session) throws Exception {
            try {
                  BookRequest req = service.getBookRequestById(requestId)
                          .orElseThrow(() -> new Exception("Yêu cầu không tìm thấy với ID: " + requestId));

                  if (!"borrow".equalsIgnoreCase(req.getRequestType())) {
                        throw new IllegalStateException("Loại yêu cầu phải là 'borrow', hiện tại là: " + req.getRequestType());
                  }

                  if (!"approved-borrow".equalsIgnoreCase(req.getStatus())) {
                        throw new IllegalStateException("Yêu cầu phải ở trạng thái approved-borrow, hiện tại là: " + req.getStatus());
                  }

                  boolean success = service.createBorrowRecord(requestId);
                  if (!success) {
                        throw new Exception("Không thể tạo bản ghi mượn");
                  }

                  // Cập nhật trạng thái thành borrowed
                  boolean statusUpdated = service.updateBookRequestStatus(requestId, "borrowed");
                  if (!statusUpdated) {
                        throw new Exception("Không thể cập nhật trạng thái thành borrowed");
                  }

                  session.setAttribute("successMessage", "Bản ghi mượn được tạo thành công cho yêu cầu #" + requestId + "!");
                  System.out.println("Tạo bản ghi mượn thành công cho yêu cầu ID: " + requestId + ", Trạng thái mới: borrowed");
            } catch (Exception e) {
                  System.err.println("Lỗi trong processBorrow: " + e.getMessage());
                  e.printStackTrace();
                  session.setAttribute("errorMessage", e.getMessage());
                  throw e;
            }
      }
}
