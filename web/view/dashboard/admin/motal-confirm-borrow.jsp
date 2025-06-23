<%-- 
    Document   : motal-confirm-borrow
    Created on : Jun 21, 2025, 4:00:34 PM
    Author     : asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div class="modal fade" id="borrowModal" tabindex="-1" aria-labelledby="borrowModalLabel" aria-hidden="true">
      <div class="modal-dialog">
            <div class="modal-content">
                  <div class="modal-header">
                        <h5 class="modal-title" id="borrowModalLabel">
                              <i class="fas fa-book me-2"></i>Process Borrow Request
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                        <p><i class="fas fa-question-circle me-2"></i>Are you sure you want to create a borrow record for this approved request?</p>
                        <div class="alert alert-info">
                              <i class="fas fa-info-circle me-2"></i>
                              This will create a new borrow record and update the book's available copies.
                        </div>
                  </div>
                  <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <div id="borrowFormContainer"></div>
                  </div>
            </div>
      </div>
</div>
