<%-- 
    Document   : modal-overdue-book
    Created on : Jun 20, 2025, 2:36:26 PM
    Author     : asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div class="modal fade" id="overdueModal" tabindex="-1" aria-labelledby="overdueModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                  <div class="modal-header">
                        <h5 class="modal-title" id="overdueModalLabel">Overdue Fine</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body text-center">
                        <i class="fas fa-exclamation-triangle fa-3x text-warning mb-3"></i>
                        <h4>Overdue Fine Amount</h4>
                        <p class="fs-5" id="fineAmount">${data-fine} VND</p>
                        <p class="text-muted">This request has an overdue fine. Do you want to approve it?</p>
                  </div>
                  <div class="modal-footer justify-content-center">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" id="confirmOverdueApprove">Confirm Approve</button>
                  </div>
            </div>
      </div>
</div>
