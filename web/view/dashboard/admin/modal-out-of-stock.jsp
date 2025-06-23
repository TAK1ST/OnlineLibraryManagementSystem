<%-- 
    Document   : modal-out-of-stock
    Created on : Jun 20, 2025, 2:41:21 PM
    Author     : asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="modal fade" id="outOfStockModal" tabindex="-1" aria-labelledby="outOfStockModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                  <div class="modal-header">
                        <h5 class="modal-title" id="outOfStockModalLabel">Out of Stock</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body text-center">
                        <i class="fas fa-exclamation-circle fa-3x text-danger mb-3"></i>
                        <h4>This book is out of stock.</h4>
                  </div>
                  <div class="modal-footer justify-content-center">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">OK</button>
                  </div>
            </div>
      </div>
</div>
