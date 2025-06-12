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
            <title>Status Request Borrow Book</title>
            <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css"/>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/container.css"/>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css"/>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-status-resquest-borrow-book.css"/>

      </head>
      <body>
            <div class="header">
                  <div class="header-content">
                        <a href="admindashboard" class="back-arrow">
                              <i class="fas fa-arrow-left fa-2x"></i>
                        </a>
                        <h1>Status Request Borrow Book</h1>
                        <button class="logout-btn" onclick="logout()">
                              Logout
                        </button>
                  </div>
            </div>

            <div class="table-container">
                  <div class="search-section">
                        <h2 class="search-title">
                              <i class="fas fa-search"></i>
                              Search RequestBook
                        </h2>
                        <form action="searchBook" method="GET">
                              <div class="search-form">
                                    <div class="form-group">
                                          <label for="searchEmail" class="form-label">
                                                <i class="fas fa-envelope me-2"></i>isbn
                                          </label>
                                          <input type="email" class="form-control" id="searchISBN" name="searchISBN" 
                                                 value="${param.searchISBN}" placeholder="Enter ISBN to search...">
                                    </div>
                                    <div class="form-group">
                                          <label for="searchTitle" class="form-label">
                                                <i class="fas fa-user me-2"></i>Title
                                          </label>
                                          <input type="text" class="form-control" id="searchTitle" name="searchTitle" 
                                                 value="${param.searchTitle}" placeholder="Enter title to search...">
                                    </div>

                                    <div class="form-group">      
                                          <button type="submit" class="search-btn" id="searchBtn">
                                                <i class="fas fa-search me-2"></i>Search
                                          </button>
                                          <button type="button" class="clear-btn" id="clearBtn">
                                                <i class="fas fa-times me-2"></i>Clear
                                          </button>
                                    </div>
                              </div>
                        </form>
                        <div id="loading" style="display: none; text-align: center; padding: 20px;">
                              <i class="fas fa-spinner fa-spin"></i> Loading...
                        </div>
                        <table class="inventory-table">
                              <thead >
                                    <tr>
                                          <th style="border-top-left-radius: 20px;">isbn</th>
                                          <th>title</th>
                                          <th>status</th>
                                          <th>available copies</th>
                                          <th>overdue fine</th>
                                          <th style="border-top-right-radius: 20px;">action</th>
                                    </tr>
                              </thead>
                              </thead>
                              <tbody id="inventoryTableBody">
                                    <jsp:include page="/view/dashboard/admin/book-request-list-fragment.jsp"/>
                              </tbody>
                        </table>
                  </div>
            </div>

            <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
            <script>
                              let offset = ${requestScope.offset != null ? requestScope.offset : 0};
                              let isLoading = false;
                              let hasMoreData = true;
                              let searchISBN = "${param.searchISBN != null ? param.searchISBN : ''}";
                              let searchTitle = "${param.searchTitle != null ? param.searchTitle : ''}";
                              let isSearchMode = false;

                              function updateSearchMode() {
                                    isSearchMode = (searchISBN.trim() !== '' || searchTitle.trim() !== '');
                              }

                              updateSearchMode();

                              window.addEventListener('scroll', function () {
                                    if (window.innerHeight + window.scrollY >= document.body.offsetHeight - 50 && !isLoading && hasMoreData) {
                                          loadMoreBookRequests();
                                    }
                              });

                              function loadMoreBookRequests() {
                                    if (isLoading)
                                          return;
                                    isLoading = true;
                                    document.getElementById('loading').style.display = 'block';
                                    let url = 'statusrequestborrowbook?ajax=true&offset=' + offset;
                                    if (searchISBN && searchISBN.trim() !== '') {
                                          url += '&searchISBN=' + encodeURIComponent(searchISBN);
                                    }
                                    if (searchTitle && searchTitle.trim() !== '') {
                                          url += '&searchTitle=' + encodeURIComponent(searchTitle);
                                    }

                                    fetch(url)
                                            .then(response => {
                                                  if (!response.ok)
                                                        throw new Error('Network response was not ok');
                                                  return response.text();
                                            })
                                            .then(html => {
                                                  const trimmedHtml = html.trim();
                                                  if (trimmedHtml.includes('class="empty-state"') || trimmedHtml.includes('No book requests found')) {
                                                        if (offset === 0) {
                                                              document.getElementById('inventoryTableBody').innerHTML = trimmedHtml;
                                                        }
                                                        hasMoreData = false;
                                                  } else if (trimmedHtml === '' || trimmedHtml.length < 50) {
                                                        hasMoreData = false;
                                                        if (offset === 0) {
                                                              document.getElementById('inventoryTableBody').innerHTML =
                                                                      '<tr><td colspan="6" class="empty-state"><i class="fas fa-book"></i><p>Not request book</p></td></tr>';
                                                        }
                                                  } else {
                                                        if (offset === 0) {
                                                              document.getElementById('inventoryTableBody').innerHTML = trimmedHtml;
                                                        } else {
                                                              document.getElementById('inventoryTableBody').insertAdjacentHTML('beforeend', trimmedHtml);
                                                        }
                                                        offset += ${requestScope.recordsPerPage != null ? requestScope.recordsPerPage : 10};
                                                        const bookRows = trimmedHtml.match(/class="book-request-row"/g);
                                                        const recordCount = bookRows ? bookRows.length : 0;
                                                        if (recordCount < ${requestScope.recordsPerPage != null ? requestScope.recordsPerPage : 10}) {
                                                              hasMoreData = false;
                                                        }
                                                  }
                                                  isLoading = false;
                                                  document.getElementById('loading').style.display = 'none';
                                            })
                                            .catch(error => {
                                                  console.error('Error borrow book:  ', error);
                                                  isLoading = false;
                                                  document.getElementById('loading').style.display = 'none';
                                            });
                              }

                              document.getElementById('searchBtn').addEventListener('click', function (e) {
                                    e.preventDefault();
                                    searchISBN = document.getElementById('searchISBN').value.trim();
                                    searchTitle = document.getElementById('searchTitle').value.trim();
                                    offset = 0;
                                    hasMoreData = true;
                                    updateSearchMode();
                                    document.getElementById('inventoryTableBody').innerHTML = '';
                                    loadMoreBookRequests();
                              });

                              document.getElementById('clearBtn').addEventListener('click', function () {
                                    document.getElementById('searchISBN').value = '';
                                    document.getElementById('searchTitle').value = '';
                                    searchISBN = '';
                                    searchTitle = '';
                                    offset = 0;
                                    hasMoreData = true;
                                    updateSearchMode();
                                    document.getElementById('inventoryTableBody').innerHTML = '';
                                    loadMoreBookRequests();
                              });
                              <script/>
                                      </body>
                                      </html>