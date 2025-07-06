<%-- 
    Document   : user-modal-fragment
    Created on : Jun 10, 2025, 12:57:45 PM
    Author     : asus
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>

<div class="modal fade" id="userModal" tabindex="-1" aria-labelledby="userModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-lg">
            <div class="modal-content">
                  <div class="modal-header">
                        <h5 class="modal-title" id="userModalLabel">
                              <i class="fas fa-user-edit me-2"></i>Edit User Profile
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                        <div class="modal-user-section">
                              <div class="user-modal-avatar">
                                    <i class="fas fa-user"></i>
                              </div>
                              <form class="modal-form" id="userForm" action="${pageContext.request.contextPath}/usermanagement" method="POST">
                                    <input type="hidden" name="userId" value="${selectedUser.id}">
                                    <div class="form-row">
                                          <label for="modalEmail" class="modal-label">Email</label>
                                          <input type="email" class="modal-input" id="modalEmail" name="email" 
                                                 value="${selectedUser.email}" readonly>
                                    </div>
                                    <div class="form-row">
                                          <label for="modalName" class="modal-label">Name</label>
                                          <input type="text" class="modal-input" id="modalName" name="name" 
                                                 value="${selectedUser.name}">
                                    </div>
                                    <div class="form-row">
                                          <label for="modalPassword" class="modal-label">Password</label>
                                          <input type="password" class="modal-input" id="modalPassword" name="password" 
                                                 placeholder="Enter new password">
                                    </div>
                                    <div class="form-row">
                                          <label for="modalRole" class="modal-label">Role</label>
                                          <select class="modal-select" id="modalRole" name="role" disabled>
                                                <option value="user" ${selectedUser.role.equalsIgnoreCase("user") ? "selected" : ""}>User</option>
                                                <option value="admin" ${selectedUser.role.equalsIgnoreCase("admin") ? "selected" : ""}>Administrator</option>
                                          </select>
                                    </div>
                                    <div class="form-row">
                                          <label for="modalStatus" class="modal-label">Status</label>
                                          <select class="modal-select" id="modalStatus" name="status">
                                                <option value="active" ${selectedUser.status.equalsIgnoreCase("active") ? "selected" : ""}>Active</option>
                                                <option value="inactive" ${selectedUser.status.equalsIgnoreCase("blocked") ? "selected" : ""}>Block</option>
                                          </select>
                                    </div>
                                    <div class="button-row">
                                          <button type="submit" class="btn-update">
                                                <i class="fas fa-save me-2"></i>Update
                                          </button>
                                    </div>
                              </form>
                        </div>
                  </div>
            </div>
      </div>
</div>
