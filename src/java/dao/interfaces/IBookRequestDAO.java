/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.interfaces;

import entity.BookRequest;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 *
 * @author asus
 */
public interface IBookRequestDAO  extends IBaseDAO<BookRequest> {

      Optional<BookRequest> getBookRequestById(int id);

      List<BookRequest> getBookRequestsByUserId(int userId);

      boolean updateBookRequestStatus(int id, String newStatus);

      List<BookRequest> getAllPendingRequests();

      List<BookRequest> getBookRequestsByBookId(int bookId);

}
