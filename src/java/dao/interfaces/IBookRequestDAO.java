/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.interfaces;

import dto.BookInforRequestStatusDTO;
import entity.BookRequest;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 *
 * @author asus
 */
public interface IBookRequestDAO {

      Optional<BookRequest> getBookRequestById(int id);

      boolean updateBookRequestStatus(int id, String newStatus);

      public List<BookInforRequestStatusDTO> getBookRequestStatusBySearch(String title, String status, int offset);
}
