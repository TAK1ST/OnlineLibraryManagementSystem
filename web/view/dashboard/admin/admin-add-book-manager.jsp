<%-- 
    Document   : admin-add-book-manager
    Created on : May 29, 2025, 11:04:26 PM
    Author     : asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
      <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Add Book Management</title>
            <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css"/>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/container.css"/>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css"/>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/add-book-manager.css"/>
      </head>
      <body>
            <div class="container-fluid">
                  <!-- Sidebar -->
                  <div class="sidebar">
                        <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" alt="Avatar">
                        <h3>Role: Adminator</h3>
                        <a href="admindashboard" class="nav-link">Dashboard</a>
                        <a href="systemconfig" class="nav-link">System Config</a>
                        <a href="usermanagement" class="nav-link">User Management</a>
                        <a href="statusrequestborrowbook" class="nav-link">View Request Books</a>
                        <a href="bookmanagement" class="nav-link active">Book Management</a>
                        <a href="updateinventory" class="nav-link">Update Inventory</a>
                  </div>

                  <!-- Main Content -->
                  <div class="main-content">
                        <!-- Header -->
                        <div class="header">
                              <button class="back-btn" onclick="history.back()">
                                    <i class="fas fa-arrow-left"></i>
                              </button>
                              <h1 class="page-title">Book Management</h1>
                              <button class="logout-btn" onclick="logout()">
                                    Logout
                              </button>
                        </div>

                        <!-- Form Container -->
                        <div class="form-container">
                              <form action="addBook" method="post" enctype="multipart/form-data">
                                    <div class="form-content">
                                          <!-- Image Upload Section -->
                                          <div class="image-upload">
                                                <div class="upload-box" onclick="document.getElementById('bookImage').click()">
                                                </div>
                                                <input type="file" id="bookImage" name="bookImage" accept="image/*" class="hidden-file-input">
                                          </div>

                                          <!-- Form Fields -->
                                          <div class="form-fields">
                                                <div class="form-group">
                                                      <input type="text" name="title" class="form-input" placeholder="Enter the title" required>
                                                </div>

                                                <div class="form-group">
                                                      <input type="text" name="author" class="form-input" placeholder="Enter the author" required>
                                                </div>

                                                <div class="form-row">
                                                      <div class="form-group">
                                                            <input type="number" name="totalCopies" class="form-input" placeholder="Enter total copies" min="1" required>
                                                      </div>
                                                      <div class="form-group">
                                                            <input type="number" name="publishedYear" class="form-input" placeholder="published year" min="1000" max="2025" required>
                                                      </div>
                                                </div>

                                                <div class="form-row">
                                                      <div class="form-group">
                                                            <select name="category" class="form-input" required>
                                                                  <option value="" disabled selected>category</option>
                                                                  <option value="Fiction">Fiction</option>
                                                                  <option value="Non-Fiction">Non-Fiction</option>
                                                                  <option value="Science">Science</option>
                                                                  <option value="Technology">Technology</option>
                                                                  <option value="History">History</option>
                                                                  <option value="Biography">Biography</option>
                                                                  <option value="Education">Education</option>
                                                                  <option value="Literature">Literature</option>
                                                            </select>
                                                      </div>
                                                      <div class="form-group">
                                                            <select name="status" class="form-input" required>
                                                                  <option value="" disabled selected>status</option>
                                                                  <option value="Available">Available</option>
                                                                  <option value="Unavailable">Unavailable</option>
                                                            </select>
                                                      </div>
                                                </div>

                                                <button type="submit" class="add-btn">Add</button>
                                          </div>
                                    </div> 
                              </form>
                        </div>
                  </div>
                  <!-- Footer -->
                  <div class="footer">
                        ©Copyright Group 7
                  </div>
            </div>
      </body>
</html>
