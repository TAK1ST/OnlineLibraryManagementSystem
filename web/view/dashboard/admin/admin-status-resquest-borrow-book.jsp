<%-- Document : admin-box-add-book-manager 
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
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css" />
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/container.css" />
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css" />
            <link rel="stylesheet"
                  href="${pageContext.request.contextPath}/css/admin-status-resquest-borrow-book.css" />

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
                              Search Request Book
                        </h2>
                        <form action="statusrequestborrowbook" method="GET">
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
                                                <optgroup label="Borrow Requests">
                                                      <option value="pending_borrow" ${param.searchStatus == 'pending_borrow' ? 'selected' : ''}>
                                                            Pending Borrow
                                                      </option>
                                                      <option value="approved_borrow" ${param.searchStatus == 'approved_borrow' ? 'selected' : ''}>
                                                            Approved Borrow (Ready to Process)
                                                      </option>
                                                      <option value="completed_borrow" ${param.searchStatus == 'completed_borrow' ? 'selected' : ''}>
                                                            Completed Borrow
                                                      </option>
                                                </optgroup>
                                                <optgroup label="Return Requests">
                                                      <option value="pending_return" ${param.searchStatus == 'pending_return' ? 'selected' : ''}>
                                                            Pending Return
                                                      </option>
                                                      <option value="approved_return" ${param.searchStatus == 'approved_return' ? 'selected' : ''}>
                                                            Approved Return
                                                      </option>
                                                      <option value="completed_return" ${param.searchStatus == 'completed_return' ? 'selected' : ''}>
                                                            Completed Return
                                                      </option>
                                                </optgroup>
                                                <optgroup label="Other Status">
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
                                    <th>Username</th>
                                    <th>Status Request</th>
                                    <th style="border-top-right-radius: 20px;">Action</th>
                              </tr>
                        </thead>
                        <tbody id="inventoryTableBody">
                              <jsp:include page="/view/dashboard/admin/book-request-list-fragment.jsp"/>
                        </tbody>
                  </table>
            </div>
            <jsp:include page="/view/dashboard/admin/modal-overdue-fine.jsp"/>
            <jsp:include page="/view/dashboard/admin/modal-success.jsp"/>
            <jsp:include page="/view/dashboard/admin/modal-out-of-stock.jsp"/>
            <jsp:include page="/view/dashboard/admin/motal-confirm-borrow.jsp"/>


            <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
            <script>
                              function handleApprove(button) {
                                    const status = button.getAttribute('data-status');
                                    const fine = parseFloat(button.getAttribute('data-fine')) || 0;
                                    const requestId = button.getAttribute('data-request-id');
                                    const requestType = button.getAttribute('data-type') || 'borrow';

                                    const formHtml = `
                                          <form action="statusrequestborrowbook" method="POST" style="display:inline;">
                                              <input type="hidden" name="requestId" value="${requestId}">
                                              <input type="hidden" name="action" value="approve">
                                              <button type="submit" class="btn btn-primary">
                                                  <i class="fas fa-check me-2"></i>Confirm Approve
                                              </button>
                                          </form>
                                      `;

                                    if (status === 'pending_return' && fine > 0) {
                                          document.getElementById('fineAmount').textContent = fine.toLocaleString() + ' VND';
                                          document.getElementById('overdueApproveFormContainer').innerHTML = formHtml;
                                          const overdueModal = new bootstrap.Modal(document.getElementById('overdueModal'));
                                          overdueModal.show();
                                    } else {
                                          document.getElementById('approveFormContainer').innerHTML = formHtml;
                                          const approveModal = new bootstrap.Modal(document.getElementById('approveModal'));
                                          approveModal.show();
                                    }
                              }

                              function handleReject(button) {
                                    if (confirm('Are you sure you want to reject this request?')) {
                                          const requestId = button.getAttribute('data-request-id');
                                          const form = document.getElementById(`reject-form-${requestId}`);
                                          form.submit();
                                    }
                              }

                              function handleBorrow(button) {
                                    const requestId = button.getAttribute('data-request-id');
                                    const formHtml = `
                                    <form action="statusrequestborrowbook" method="POST" style="display:inline;">
                                        <input type="hidden" name="requestId" value="${requestId}">
                                        <input type="hidden" name="action" value="borrow">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-book me-2"></i>Confirm Process Borrow
                                        </button>
                                    </form>
                                `;
                                    document.getElementById('borrowFormContainer').innerHTML = formHtml;
                                    const borrowModal = new bootstrap.Modal(document.getElementById('borrowModal'));
                                    borrowModal.show();
                              }

                              let offset = ${requestScope.offset != null ? requestScope.offset : 0};
                              let isLoading = false;
                              let hasMoreData = true;
                              let searchTitle = "${param.searchTitle != null ? param.searchTitle : ''}";
                              let searchStatus = "${param.searchStatus != null ? param.searchStatus : ''}";
                              let isSearchMode = false;
                              let currentRequestId = null;

                              function updateSearchMode() {
                                    isSearchMode = (searchTitle.trim() !== '' || searchStatus.trim() !== '');
                              }

                              updateSearchMode();

                              document.addEventListener('DOMContentLoaded', function () {
                                    const confirmApproveBtn = document.getElementById('confirmApprove');
                                    if (confirmApproveBtn) {
                                          confirmApproveBtn.addEventListener('click', function () {
                                                console.log('Confirm approve clicked, currentRequestId:', currentRequestId);

                                                if (!currentRequestId) {
                                                      alert('No request selected!');
                                                      return;
                                                }

                                                const form = document.getElementById(`approve-form-${currentRequestId}`);
                                                if (!form) {
                                                      alert('Form not found!');
                                                      console.error('Form not found for ID:', `approve-form-${currentRequestId}`);
                                                      return;
                                                }

                                                // Disable button to prevent double click
                                                confirmApproveBtn.disabled = true;
                                                confirmApproveBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';

                                                const formData = new FormData(form);

                                                fetch(form.action, {
                                                      method: 'POST',
                                                      body: formData
                                                }).then(response => {
                                                      if (response.ok) {
                                                            // Close approve modal
                                                            const approveModal = bootstrap.Modal.getInstance(document.getElementById('approveModal'));
                                                            if (approveModal) {
                                                                  approveModal.hide();
                                                            }

                                                            // Show success modal
                                                            const successModal = new bootstrap.Modal(document.getElementById('successModal'));
                                                            successModal.show();

                                                            // Reload page when success modal is closed
                                                            document.getElementById('successModal').addEventListener('hidden.bs.modal', function () {
                                                                  window.location.reload();
                                                            }, {once: true});
                                                      } else {
                                                            throw new Error('Approve failed');
                                                      }
                                                }).catch(error => {
                                                      console.error('Error:', error);
                                                      // Re-enable button
                                                      confirmApproveBtn.disabled = false;
                                                      confirmApproveBtn.innerHTML = 'Confirm';

                                                      // Fallback to normal form submission
                                                      form.submit();
                                                });
                                          });
                                    }

                                    const confirmOverdueApproveBtn = document.getElementById('confirmOverdueApprove');
                                    if (confirmOverdueApproveBtn) {
                                          confirmOverdueApproveBtn.addEventListener('click', function () {
                                                console.log('Confirm overdue approve clicked, currentRequestId:', currentRequestId);

                                                if (!currentRequestId) {
                                                      alert('No request selected!');
                                                      return;
                                                }

                                                const form = document.getElementById(`approve-form-${currentRequestId}`);
                                                if (!form) {
                                                      alert('Form not found!');
                                                      console.error('Form not found for ID:', `approve-form-${currentRequestId}`);
                                                      return;
                                                }

                                                // Disable button to prevent double click
                                                confirmOverdueApproveBtn.disabled = true;
                                                confirmOverdueApproveBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';

                                                const formData = new FormData(form);

                                                fetch(form.action, {
                                                      method: 'POST',
                                                      body: formData
                                                }).then(response => {
                                                      if (response.ok) {
                                                            // Close overdue modal
                                                            const overdueModal = bootstrap.Modal.getInstance(document.getElementById('overdueModal'));
                                                            if (overdueModal) {
                                                                  overdueModal.hide();
                                                            }

                                                            // Show success modal
                                                            const successModal = new bootstrap.Modal(document.getElementById('successModal'));
                                                            successModal.show();

                                                            // Reload page when success modal is closed
                                                            document.getElementById('successModal').addEventListener('hidden.bs.modal', function () {
                                                                  window.location.reload();
                                                            }, {once: true});
                                                      } else {
                                                            throw new Error('Approve failed');
                                                      }
                                                }).catch(error => {
                                                      console.error('Error:', error);
                                                      // Re-enable button
                                                      confirmOverdueApproveBtn.disabled = false;
                                                      confirmOverdueApproveBtn.innerHTML = 'Confirm Approve';

                                                      // Fallback to normal form submission
                                                      form.submit();
                                                });
                                          });
                                    }

                                    // Reset currentRequestId when modals are hidden
                                    document.getElementById('approveModal').addEventListener('hidden.bs.modal', function () {
                                          currentRequestId = null;
                                    });

                                    document.getElementById('overdueModal').addEventListener('hidden.bs.modal', function () {
                                          currentRequestId = null;
                                    });
                              });

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
                                    if (searchTitle && searchTitle.trim() !== '') {
                                          url += '&searchTitle=' + encodeURIComponent(searchTitle);
                                    }
                                    if (searchStatus && searchStatus.trim() !== '') {
                                          url += '&searchStatus=' + encodeURIComponent(searchStatus);
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
                                                                      '<tr><td colspan="5" class="empty-state"><i class="fas fa-book"></i><p>No request book</p></td></tr>';
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
                                                  console.error('Error loading book requests: ', error);
                                                  isLoading = false;
                                                  document.getElementById('loading').style.display = 'none';
                                            });
                              }

// Event listener for search button
                              document.getElementById('searchBtn').addEventListener('click', function (e) {
                                    e.preventDefault();
                                    searchTitle = document.getElementById('searchTitle').value.trim();
                                    searchStatus = document.getElementById('searchStatus').value.trim();
                                    offset = 0;
                                    hasMoreData = true;
                                    updateSearchMode();
                                    document.getElementById('inventoryTableBody').innerHTML = '';
                                    loadMoreBookRequests();
                              });

// Logout function
                              function logout() {
                                    if (confirm('Are you sure you want to logout?')) {
                                          window.location.href = 'logout';
                                    }
                              }
            </script>
      </body>
</html>