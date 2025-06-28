<%-- 
    Document   : delete-confirm-modal
    Created on : Jun 27, 2025, 11:30:04 PM
    Author     : asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div id="deleteModal" class="modal">
      <div class="modal-content">
            <h3>
                  <i class="fas fa-exclamation-triangle" style="color: #dc3545;"></i> 
                  Confirm Delete
            </h3>
            <p>Are you sure you want to delete this book?</p>
            <p><strong id="bookTitle"></strong></p>
            <p style="color: #6c757d; font-size: 14px; margin-top: 12px;">This action will mark the book as inactive and cannot be undone.</p>
            <div class="modal-buttons">
                  <button type="button" class="modal-btn btn-cancel" onclick="closeDeleteModal()">Cancel</button>
                  <button type="button" class="modal-btn btn-confirm" onclick="executeDelete()">Delete Book</button>
            </div>      
      </div>
</div>

<!-- Hidden Delete Form -->
<form id="deleteForm" method="POST" action="bookmanagement" style="display: none;">
      <input type="hidden" name="action" value="delete">
      <input type="hidden" name="bookId" id="deleteBookId">
      <!-- Preserve current filters -->
      <input type="hidden" name="currentTitle" value="${titleFilter}">
      <input type="hidden" name="currentAuthor" value="${authorFilter}">
      <input type="hidden" name="currentCategory" value="${categoryFilter}">
      <input type="hidden" name="currentStatus" value="${statusFilter}">
      <input type="hidden" name="currentPage" value="${currentPage}">
      <input type="hidden" name="currentSize" value="${pageSize}">
</form>
