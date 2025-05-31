<%-- 
    Document   : admin-box-add-book-manager
    Created on : May 29, 2025, 10:25:36 PM
    Author     : asus
--%>

<!DOCTYPE html>
<html lang="en">
      <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Update Inventory</title>
            <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css"/>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/container.css"/>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css"/>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-overdue-book.css"/>

      </head>
      <body>
            <div class="header">
                  <div class="header-content">
                        <a href="admindashboard" class="back-arrow">
                              <i class="fas fa-arrow-left fa-2x"></i>
                        </a>
                        <h1>Overdue Book</h1>
                        <button class="logout-btn" onclick="logout()">
                              Logout
                        </button>
                  </div>
            </div>

            <div class="table-container">
                  <table class="table table-hover inventory-table">
                        <thead >
                              <tr>
                                    <th>isbn</th>
                                    <th>title</th>
                                    <th>author</th>
                                    <th>available copies</th>
                                    <th>overdue fine</th>
                                    <th>action</th>
                              </tr>
                        </thead>
                        <tbody id="inventoryTableBody">
                              <!-- Empty state -->
                              <tr>
                                    <td colspan="6" class="empty-state">
                                          <i class="fas fa-box-open"></i>
                                          <h3>No inventory updates pending</h3>
                                          <p>There are currently no items requiring review or approval.</p>
                                    </td>
                              </tr>
                        </tbody>
                  </table>
            </div>
      </body>
</html>