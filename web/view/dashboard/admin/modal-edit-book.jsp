<%-- 
    Document   : edit-book-fragment
    Created on : Jun 27, 2025, 4:10:30 PM
    Author     : asus
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-edit-book-modal.css"/>

<div class="modal fade" id="editBookModal" tabindex="-1" aria-labelledby="editBookModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-lg">
            <div class="modal-content">
                  <div class="modal-header">
                        <h5 class="modal-title" id="editBookModalLabel">
                              <i class="fas fa-book me-2"></i>Edit Book
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                        <div class="modal-edit-book-section">
                              <form class="modal-form" id="editBookForm" action="${pageContext.request.contextPath}/editbook" method="POST">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" id="modalBookId" name="bookId" value="">

                                    <!-- Hidden fields to preserve filters -->
                                    <input type="hidden" id="currentTitle" name="currentTitle" value="">
                                    <input type="hidden" id="currentAuthor" name="currentAuthor" value="">
                                    <input type="hidden" id="currentCategory" name="currentCategory" value="">
                                    <input type="hidden" id="currentStatus" name="currentStatus" value="">
                                    <input type="hidden" id="currentPage" name="currentPage" value="">
                                    <input type="hidden" id="currentSize" name="currentSize" value="">

                                    <div class="row">
                                          <div class="col-md-6">
                                                <div class="form-row mb-3">
                                                      <label for="modalIsbn" class="modal-label">ISBN <span class="text-danger">*</span></label>
                                                      <input type="text" class="form-control modal-input" id="modalIsbn" name="isbn" readonly>
                                                </div>
                                          </div>
                                          <div class="col-md-6">
                                                <div class="form-row mb-3">
                                                      <label for="modalTitle" class="modal-label">Title <span class="text-danger">*</span></label>
                                                      <input type="text" class="form-control modal-input" id="modalTitle" name="title" required>
                                                </div>
                                          </div>
                                    </div>

                                    <div class="row">
                                          <div class="col-md-6">
                                                <div class="form-row mb-3">
                                                      <label for="modalAuthor" class="modal-label">Author <span class="text-danger">*</span></label>
                                                      <input type="text" class="form-control modal-input" id="modalAuthor" name="author" required>
                                                </div>
                                          </div>
                                          <div class="col-md-6">
                                                <div class="form-row mb-3">
                                                      <label for="modalCategory" class="modal-label">Category <span class="text-danger">*</span></label>
                                                      <input type="text" class="form-control modal-input" id="modalCategory" name="category" required>
                                                </div>
                                          </div>
                                    </div>

                                    <div class="row">
                                          <div class="col-md-4">
                                                <div class="form-row mb-3">
                                                      <label for="modalPublishedYear" class="modal-label">Published Year <span class="text-danger">*</span></label>
                                                      <input type="number" class="form-control modal-input" id="modalPublishedYear" name="publishedYear" min="1000" max="2025" required>
                                                </div>
                                          </div>
                                          <div class="col-md-4">
                                                <div class="form-row mb-3">
                                                      <label for="modalTotalCopies" class="modal-label">Total Copies <span class="text-danger">*</span></label>
                                                      <input type="number" class="form-control modal-input" id="modalTotalCopies" name="totalCopies" min="0" required>
                                                </div>
                                          </div>
                                          <div class="col-md-4">
                                                <div class="form-row mb-3">
                                                      <label for="modalAvailableCopies" class="modal-label">Available Copies <span class="text-danger">*</span></label>
                                                      <input type="number" class="form-control modal-input" id="modalAvailableCopies" name="availableCopies" min="0" required>
                                                </div>
                                          </div>
                                    </div>

                                    <div class="row">
                                          <div class="col-md-6">
                                                <div class="form-row mb-3">
                                                      <label for="modalStatus" class="modal-label">Status <span class="text-danger">*</span></label>
                                                      <select class="form-select modal-select" id="modalStatus" name="status" required>
                                                            <option value="">Select Status</option>
                                                            <option value="active">Active</option>
                                                            <option value="blocked">Blocked</option>
                                                      </select>
                                                </div>
                                          </div>
                                          <div class="col-md-6">
                                                <div class="form-row mb-3">
                                                      <label for="modalImageUrl" class="modal-label">Image URL</label>
                                                      <input type="url" class="form-control modal-input" id="modalImageUrl" name="imageUrl" placeholder="https://example.com/image.jpg"  readonly>
                                                </div>
                                          </div>
                                    </div>

                                    <div class="modal-footer">
                                          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                                <i class="fas fa-times me-2"></i>Cancel
                                          </button>
                                          <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-save me-2"></i>Update Book
                                          </button>
                                    </div>
                              </form>
                        </div>
                  </div>
            </div>
      </div>
</div>