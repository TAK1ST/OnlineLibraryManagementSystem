<%-- Document : admin-status-request-borrow-book 
Created on : May 29, 2025, 10:25:36 PM 
Author : asus 
--%>
<!DOCTYPE html>
<html lang="en">
      <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Status Request Borrow Book</title>
            <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-status-resquest-borrow-book.css"/>
      </head>
      <body>
            <div class="header">
                  <% if (request.getAttribute("errorMessage") != null) { %>
                  <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <strong>Error: </strong> <%= request.getAttribute("errorMessage") %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                  </div>
                  <% } %>
                  <% if (request.getAttribute("successMessage") != null) { %>
                  <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <strong>Success: </strong> <%= request.getAttribute("successMessage") %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                  </div>
                  <% } %>
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
                              Search Request Book
                        </h2>
                        <form action="statusrequestborrowbook" method="GET" id="searchForm">
                              <div class="search-form">
                                    <div class="form-group">
                                          <label for="searchTitle" class="form-label">
                                                <i class="fas fa-book me-2"></i>Title
                                          </label>
                                          <input type="text" class="form-control" id="searchTitle" name="searchTitle" 
                                                 value="${param.searchTitle}" placeholder="Enter Title to search...">
                                    </div>
                                    <div class="form-group">
                                          <label for="searchStatus" class="form-label">
                                                <i class="fas fa-filter me-2"></i>Status
                                          </label>
                                          <select name="searchStatus" id="searchStatus" class="form-select">
                                                <option value="">All Requests</option>
                                                <optgroup label="Pending Requests">
                                                      <option value="pending_borrow" ${param.searchStatus == 'pending_borrow' ? 'selected' : ''}>
                                                            Pending Borrow
                                                      </option>
                                                      <option value="pending_return" ${param.searchStatus == 'pending_return' ? 'selected' : ''}>
                                                            Pending Return
                                                      </option>
                                                </optgroup>
                                                <optgroup label="Active Status">
                                                      <option value="borrowed" ${param.searchStatus == 'borrowed' ? 'selected' : ''}>
                                                            Borrowed (Currently with User)
                                                      </option>
                                                </optgroup>
                                                <optgroup label="Approved Status">
                                                      <option value="approved-borrow" ${param.searchStatus == 'approved-borrow' ? 'selected' : ''}>
                                                            Approved Borrow
                                                      </option>
                                                      <option value="completed" ${param.searchStatus == 'completed' ? 'selected' : ''}>
                                                            Completed
                                                      </option>
                                                </optgroup>
                                                <optgroup label="Rejected Status">
                                                      <option value="rejected" ${param.searchStatus == 'rejected' ? 'selected' : ''}>
                                                            Rejected
                                                      </option>
                                                </optgroup>
                                          </select>
                                    </div>
                                    <div class="form-group">      
                                          <button type="submit" class="search-btn" id="searchBtn">
                                                <i class="fas fa-search me-2"></i>Filter
                                          </button>
                                          <a href="statusrequestborrowbook">
                                                <button type="button" class="clear-btn" id="clearBtn">
                                                      <i class="fas fa-times me-2"></i>Clear
                                                </button>
                                          </a>
                                    </div>
                              </div>
                        </form>
                  </div>

                  <div id="loading" style="display: none; text-align: center; padding: 20px;">
                        <i class="fas fa-spinner fa-spin"></i> Loading...
                  </div>

                  <table class="inventory-table">
                        <thead>
                              <tr>
                                    <th style="border-top-left-radius: 20px;">ISBN</th>
                                    <th>Title</th>
                                    <th>Quantity</th>
                                    <th>Username</th>
                                    <th>Status Request</th>
                                    <th style="border-top-right-radius: 20px;">Action</th>
                              </tr>
                        </thead>
                        <tbody id="inventoryTableBody">
                              <jsp:include page="/view/admin/book-request-list-fragment.jsp"/>
                        </tbody>
                  </table>

                  <div id="noMoreData" style="display: none; text-align: center; padding: 20px;">
                        <i class="fas fa-info-circle"></i> No more records to load
                  </div>
            </div>

            <!-- Scroll to Top Button -->
            <button id="scrollToTopBtn" class="scroll-to-top-btn" onclick="scrollToTop()" title="Go to top">
                  <i class="fas fa-chevron-up"></i>
            </button>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
            <script>
                  // Global variables
                  let offset = ${requestScope.offset != null ? requestScope.offset : 0};
                  let isLoading = false;
                  let hasMoreData = true;
                  let searchTitle = "${requestScope.searchTitle != null ? requestScope.searchTitle : ''}";
                  let searchStatus = "${requestScope.searchStatus != null ? requestScope.searchStatus : ''}";
                  const recordsPerPage = ${requestScope.recordsPerPage != null ? requestScope.recordsPerPage : 10};


                  document.addEventListener('DOMContentLoaded', function () {
                        console.log('Page loaded, initializing...');
                        console.log("Initial searchStatus:", searchStatus);

                        const tbody = document.getElementById('inventoryTableBody');
                        if (!tbody.innerHTML.trim() || tbody.innerHTML.trim() === '') {
                              console.log('Loading initial data...');
                              loadMoreBookRequests();
                        }
                  });

                  document.getElementById('searchForm').addEventListener('submit', function (e) {
                        e.preventDefault();
                        console.log('Search form submitted');

                        searchTitle = document.getElementById('searchTitle').value.trim();
                        searchStatus = document.getElementById('searchStatus').value.trim();

                        console.log("Search - searchTitle:", searchTitle);
                        console.log("Search - searchStatus:", searchStatus);

                        offset = 0;
                        hasMoreData = true;

                        document.getElementById('inventoryTableBody').innerHTML = '';
                        document.getElementById('noMoreData').style.display = 'none';

                        loadMoreBookRequests();
                  });

                  // Load more book requests via AJAX
                  function loadMoreBookRequests() {
                        if (isLoading || !hasMoreData) {
                              return;
                        }

                        console.log('Loading more book requests, offset=' + offset);
                        isLoading = true;
                        document.getElementById('loading').style.display = 'block';

                        let url = 'statusrequestborrowbook?ajax=true&offset=' + offset;
                        if (searchTitle && searchTitle.trim() !== '') {
                              url += '&searchTitle=' + encodeURIComponent(searchTitle);
                        }
                        if (searchStatus && searchStatus.trim() !== '') {
                              url += '&searchStatus=' + encodeURIComponent(searchStatus);
                        }

                        console.log('Fetching URL:', url);

                        fetch(url)
                                .then(response => response.text())
                                .then(html => {
                                      const trimmedHtml = html.trim();
                                      if (isEmptyResponse(trimmedHtml)) {
                                            handleEmptyResponse(trimmedHtml);
                                      } else {
                                            handleValidResponse(trimmedHtml);
                                      }
                                })
                                .catch(error => {
                                      console.error('Error loading book requests:', error);
                                      handleError(error);
                                })
                                .finally(() => {
                                      isLoading = false;
                                      document.getElementById('loading').style.display = 'none';
                                });
                  }

                  // Improved empty response detection
                  function isEmptyResponse(html) {
                        return html === '' ||
                                html.length < 50 ||
                                html.includes('class="empty-state"') ||
                                html.includes('No book requests found') ||
                                html.includes('No matching book borrowing requests found') ||
                                html.includes('No Book Requests Found') ||
                                !html.includes('<tr') || // No table rows
                                html.includes('colspan="5"'); // Empty state row
                  }

                  //Handle empty response
                  function handleEmptyResponse(html) {
                        hasMoreData = false;
                        document.getElementById('noMoreData').style.display = 'block';
                        if (offset === 0) {
                              // First load and no data
                              if (html.includes('class="empty-state"')) {
                                    document.getElementById('inventoryTableBody').innerHTML = html;
                              } else {
                                    document.getElementById('inventoryTableBody').innerHTML =
                                            '<tr><td colspan="5" class="empty-state text-center py-5">' +
                                            '<div class="d-flex flex-column align-items-center">' +
                                            '<div class="empty-icon mb-3"><i class="fas fa-book-open fa-4x text-muted"></i></div>' +
                                            '<h5 class="text-muted mb-2">No Book Requests Found</h5>' +
                                            '<p class="text-muted mb-0">No book borrowing requests found!</p>' +
                                            '<small class="text-muted mt-2">Try adjusting your search filters or check back later</small>' +
                                            '</div></td></tr>';
                              }
                        }
                  }

                  function handleValidResponse(html) {
                        const tableBody = document.getElementById('inventoryTableBody');
                        if (offset === 0) {
                              tableBody.innerHTML = html;
                        } else {
                              tableBody.insertAdjacentHTML('beforeend', html);
                        }

                        // count row <tr>
                        const newRows = html.match(/<tr[^>]*class="[^"]*\bbook-request-row\b[^"]*"/g);
                        const recordCount = newRows ? newRows.length : 0;
                        console.log(newRows);
                        console.log('Records received:', recordCount);
                        // update off by that row get
                        offset += recordCount;
                        if (recordCount === 0 || recordCount < recordsPerPage) {
                              hasMoreData = false;
                              document.getElementById('noMoreData').style.display = 'block';
                        }
                  }


                  //Handle fetch errors
                  function handleError(error) {
                        if (offset === 0) {
                              document.getElementById('inventoryTableBody').innerHTML =
                                      '<tr><td colspan="5" class="text-center text-danger py-4">' +
                                      '<i class="fas fa-exclamation-triangle me-2"></i>' +
                                      'Error loading data. Please try again.' +
                                      '</td></tr>';
                        } else {
                              // Show error message for subsequent loads
                              const errorRow = document.createElement('tr');
                              errorRow.innerHTML = '<td colspan="5" class="text-center text-danger py-2">' +
                                      '<i class="fas fa-exclamation-triangle me-2"></i>' +
                                      'Error loading more data. Please try again.' +
                                      '</td>';
                              document.getElementById('inventoryTableBody').appendChild(errorRow);
                        }
                  }

                  //Infinite scroll handler
                  window.addEventListener('scroll', function () {
                        const scrollPosition = window.innerHeight + window.scrollY;
                        const documentHeight = document.body.offsetHeight;
                        if (scrollPosition >= documentHeight - 100 && !isLoading && hasMoreData) {
                              console.log('Scroll triggered, loading more data...');
                              loadMoreBookRequests();
                        }
                  });

                  function logout() {
                        if (confirm('Are you sure you want to logout?')) {
                              window.location.href = 'LogoutServlet';
                        }
                  }

                  function confirmApprove(requestId, bookId) {
                        console.log('Clicked approve for request:', requestId);
                        const formId = 'approve-form-' + requestId;
                        const form = document.getElementById(formId);
                        if (!form) {
                              console.error('Form not found:', formId);
                              return;
                        }

                        if (confirm('Are you sure you want to approve this request?')) {
                              form.submit();
                        }
                  }
// Add event delegation for approve buttons
                  document.getElementById('inventoryTableBody').addEventListener('click', function (e) {
                        if (e.target.closest('.approve-btn')) {
                              const btn = e.target.closest('.approve-btn');
                              const requestId = btn.dataset.requestId;
                              const bookId = btn.dataset.bookId;
                              if (!requestId || !bookId) {
                                    console.error('Missing data-* attributes on approve button');
                                    return;
                              }

                              if (confirm('Are you sure you want to approve this request?')) {
                                    const form = document.getElementById('approve-form-' + requestId);
                                    if (form) {
                                          form.submit();
                                    } else {
                                          console.error('Approve form not found for ID:', requestId);
                                    }
                              }
                        }
                  });

                  // Scroll to top functionality
                  window.onscroll = function () {
                        const scrollBtn = document.getElementById("scrollToTopBtn");
                        if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
                              scrollBtn.style.display = "block";
                        } else {
                              scrollBtn.style.display = "none";
                        }
                  };
                  function scrollToTop() {
                        document.body.scrollTop = 0;
                        document.documentElement.scrollTop = 0;
                  }

                  //set timeout for alert
                  setTimeout(() => {
                        const alerts = document.querySelectorAll('.alert');
                        alerts.forEach(alert => {
                              alert.classList.remove('show');
                              alert.classList.add('fade');
                              setTimeout(() => alert.remove(), 1000);
                        });
                  }, 2000);
            </script>
      </body>
</html>
