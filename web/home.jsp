<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="listener.OnlineUserCounterListener" %>
<%@ page import="java.util.Set" %>
<%@ page import="util.ImageDisplayHelper" %>
<%@ page import="service.implement.OnlineUserManager" %>
<!DOCTYPE html>
<html>
      <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Thư viện trực tuyến</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css"/>
      </head>
      <body>
            <!-- Thanh điều hướng -->
            <nav class="navbar navbar-expand-lg navbar-dark">
                  <div class="container">
                        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
                              <i class="fas fa-book-reader me-2"></i>Online Library
                        </a>
                        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                              <span class="navbar-toggler-icon"></span>
                        </button>
                        <div class="collapse navbar-collapse" id="navbarNav">
                              <ul class="navbar-nav ms-auto">
                                    <c:if test="${empty sessionScope.loginedUser}">
                                          <li class="nav-item">
                                                <a class="nav-link" href="${pageContext.request.contextPath}/LoginServlet">
                                                      <i class="fas fa-sign-in-alt me-1"></i>Login
                                                </a>
                                          </li>
                                          <li class="nav-item">
                                                <a class="nav-link" href="${pageContext.request.contextPath}/RegisterServlet">
                                                      <i class="fas fa-user-plus me-1"></i>Register
                                                </a>
                                          </li>
                                    </c:if>
                                    <c:if test="${not empty sessionScope.loginedUser}">
                                          <li class="nav-item">
                                                <a class="nav-link" href="${pageContext.request.contextPath}/MyStorageServlet">
                                                      <i class="fas fa-book"></i> My Storage
                                                </a>
                                          </li>
                                          <li class="nav-item">
                                                <a class="nav-link" href="${pageContext.request.contextPath}/BorrowHistoryServlet">
                                                      <i class="fas fa-history me-1"></i>Borrowed History
                                                </a>
                                          </li>
                                          <li class="nav-item">
                                                <a class="nav-link" href="${pageContext.request.contextPath}/cart">
                                                      <i class="fas fa-shopping-cart me-1"></i>Cart
                                                </a>
                                          </li>
                                          <li class="nav-item dropdown">
                                                <a class="nav-link position-relative" href="#" id="notificationBell" role="button" data-bs-toggle="dropdown">
                                                      <i class="fas fa-bell"></i>
                                                      <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" id="notificationCount">0</span>
                                                </a>
                                                <ul class="dropdown-menu dropdown-menu-end p-2" aria-labelledby="notificationBell" style="width: 300px; max-height: 400px; overflow-y: auto;">
                                                      <li class="text-center text-muted">No notifications</li>
                                                </ul>
                                          </li>
                                          <li class="nav-item">
                                                <a class="nav-link" href="${pageContext.request.contextPath}/ChangeProfile">
                                                      <i class="fas fa-user me-1"></i>Hi, ${sessionScope.loginedUser.name}!
                                                </a>
                                          </li>
                                          <li class="nav-item">
                                                <a class="nav-link" href="${pageContext.request.contextPath}/LogoutServlet">
                                                      <i class="fas fa-sign-out-alt me-1"></i>Logout
                                                </a>
                                          </li>
                                    </c:if>
                              </ul>
                        </div>
                  </div>
            </nav>

            <!-- Phần Hero -->
            <div class="banner-container">
                  <div class="banner-slide" id="slide">
                        <div class="slide-item">
                              <img src="./hinh/OIP.jpg" alt="Ảnh 1">
                              <div class="caption">Welcome to the Online Library</div>
                        </div>
                        <!--                        <div class="slide-item">
                                                      <img src="./hinh/R.jpg" alt="Ảnh 2">
                                                      <div class="caption">Explore thousands of books and expand your knowledge</div>
                                                </div>
                                                <div class="slide-item">
                                                      <img src="./hinh/1.jpg" alt="Ảnh 3">
                                                      <div class="caption">Every book is a door – an online library that opens up the world for you.</div>
                                                </div>
                                                <div class="slide-item">
                                                      <img src="./hinh/4.jpg" alt="Ảnh 4">
                                                      <div class="caption">Every book is a door – an online library that opens up the world for you.</div>
                                                </div>-->
                  </div>
            </div>

            <!-- Phần tìm kiếm -->
            <section class="search-section">
                  <div class="container">
                        <form action="${pageContext.request.contextPath}/search" method="GET" class="row justify-content-center">
                              <div class="col-md-3 mb-3">
                                    <input type="text" name="title" class="form-control" placeholder="Title">
                              </div>
                              <div class="col-md-3 mb-3">
                                    <input type="text" name="author" class="form-control" placeholder="Author">
                              </div>
                              <div class="col-md-3 mb-3">
                                    <select name="category" class="form-select">
                                          <option value="">All category</option>
                                          <c:forEach items="${categories}" var="category">
                                                <option value="${category}" ${param.category eq category ? 'selected' : ''}>${category}</option>
                                          </c:forEach>
                                    </select>
                              </div>
                              <div class="col-md-2 mb-3">
                                    <button type="submit" class="btn btn-primary w-100 btn-search">
                                          <i class="fas fa-search me-2"></i>Find
                                    </button>
                              </div>
                        </form>
                  </div>
            </section>

            <!-- Sách mới -->
            <section class="new-books">
                  <div class="container">
                        <h2 class="section-title text-center">NEW BOOKS</h2>
                        <div class="row">
                              <c:forEach items="${newBooks}" var="book">
                                    <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                                          <div class="book-card card">
                                                <img src="<%= ImageDisplayHelper.getBookImageUrl((entity.Book) request.getAttribute("book")) %>" alt="${book.title}" style="max-width: 300px; max-height: 400px; object-fit: contain;">
                                                <div class="card-body">
                                                      <h5 class="card-title">${book.title}</h5>
                                                      <p class="card-text">
                                                            <small class="text-muted">
                                                                  <i class="fas fa-user me-1"></i>Author: ${book.author}
                                                            </small>
                                                      </p>
                                                      <p class="card-text">
                                                            <span class="badge bg-primary me-2">${book.category}</span>
                                                            <c:if test="${book.availableCopies > 0}">
                                                                  <span class="badge bg-success">
                                                                        <i class="fas fa-check me-1"></i>Still have books
                                                                  </span>
                                                            </c:if>
                                                            <c:if test="${book.availableCopies == 0}">
                                                                  <span class="badge bg-danger">
                                                                        <i class="fas fa-times me-1"></i>Out of book
                                                                  </span>
                                                            </c:if>
                                                      </p>
                                                      <p class="card-text">
                                                            <small class="text-muted">
                                                                  <i class="fas fa-book me-1"></i>Available: ${book.availableCopies}/${book.totalCopies}
                                                            </small>
                                                      </p>
                                                      <div class="d-grid gap-2">
                                                            <a href="${pageContext.request.contextPath}/bookdetail?id=${book.id}" 
                                                               class="btn btn-primary">
                                                                  <i class="fas fa-eye me-2"></i>See details
                                                            </a>
                                                            <c:if test="${not empty sessionScope.loginedUser && book.availableCopies > 0}">
                                                                  <button onclick="addToCart(${book.id})" class="btn btn-outline-primary">
                                                                        <i class="fas fa-cart-plus me-2"></i>Add to cart
                                                                  </button>
                                                            </c:if>
                                                      </div>
                                                </div>
                                          </div>
                                    </div>
                              </c:forEach>
                        </div>
                  </div>
            </section>

            <c:if test="${not empty recommendedBooks}">
                  <section class="new-books"> 
                        <div class="container">
                              <h2 class="section-title text-center">
                                    RECOMMEND BOOKS
                              </h2>
                              <div class="row">
                                    <c:forEach items="${recommendedBooks}" var="book">
                                          <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                                                <div class="book-card card"> <!-- Sử dụng cùng class với sách mới -->
                                                      <img src="https://via.placeholder.com/300x400?text=${book.title}&bg=16A085&color=FFFFFF" 
                                                           class="card-img-top" alt="${book.title}">
                                                      <div class="card-body">
                                                            <h5 class="card-title">${book.title}</h5>
                                                            <p class="card-text">
                                                                  <small class="text-muted">
                                                                        <i class="fas fa-user me-1"></i>Author: ${book.author}
                                                                  </small>
                                                            </p>
                                                            <p class="card-text">
                                                                  <span class="badge bg-primary me-2">${book.category}</span>
                                                                  <c:if test="${book.availableCopies > 0}">
                                                                        <span class="badge bg-success">
                                                                              <i class="fas fa-check me-1"></i>Still have books
                                                                        </span>
                                                                  </c:if>
                                                                  <c:if test="${book.availableCopies == 0}">
                                                                        <span class="badge bg-danger">
                                                                              <i class="fas fa-times me-1"></i>Out of book
                                                                        </span>
                                                                  </c:if>
                                                            </p>
                                                            <div class="d-grid gap-2">
                                                                  <a href="${pageContext.request.contextPath}/bookdetail?id=${book.id}" 
                                                                     class="btn btn-primary">
                                                                        <i class="fas fa-eye me-2"></i>See details
                                                                  </a>
                                                                  <c:if test="${not empty sessionScope.loginedUser && book.availableCopies > 0}">
                                                                        <button onclick="addToCart(${book.id})" class="btn btn-outline-primary">
                                                                              <i class="fas fa-cart-plus me-2"></i>Add to cart
                                                                        </button>
                                                                  </c:if>
                                                            </div>
                                                      </div>
                                                </div>
                                          </div>
                                    </c:forEach>
                              </div>
                        </div>
                        <!-- Button mở chat -->
                        <div class="chat-button-container">
                              <button onclick="toggleChat()">
                                    <span></span>
                                    <span>💬 Chat</span>
                              </button>
                        </div>

                        <!-- Enhanced Chat Box -->
                        <div id="chat-box" class="chat-box">
                              <h5>Send Message to Admin</h5>
                              <form method="post" action="SendMessageServlet">
                                    <input type="text" name="subject" placeholder="Subject" required>
                                    <textarea name="message" placeholder="Your message..." rows="4" required></textarea>
                                    <button type="submit">Send Message</button>
                              </form>
                        </div>

                  </section>

            </c:if>

            <c:if test="${not empty sessionScope.loginedUser}">
                  <a href="${pageContext.request.contextPath}/OnlineUserListServlet" class="online-counter">
                        <i class="fas fa-wifi"></i>Online: <%= OnlineUserCounterListener.getOnlineUsers() %> users
                  </a>
            </c:if>


            <!-- Footer -->
            <footer class="footer text-white pt-4 pb-3 mt-5" style="background-color: #2F4256; height: 100px; display: flex; flex-direction: column; justify-content: center; align-items: center;">
                  <div class="container text-center" style="padding-top: 30px">
                        <p class="mb-1">&copy; 2025 Group 7 - Library Management System</p>
                        <p class="mb-1">vdtuan245@gmail.com</p>
                        <div class="social-icons mt-2">
                              <a href="#" class="text-white me-3"><i class="bi bi-facebook"></i></a>
                              <a href="#" class="text-white me-3"><i class="bi bi-envelope-fill"></i></a>
                              <a href="#" class="text-white me-3"><i class="bi bi-github"></i></a>
                        </div>
                  </div>
            </footer>





            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                                    let currentSlide = 0;
                                    const totalSlides = 4;
                                    const slide = document.getElementById('slide');
                                    const indicators = document.querySelectorAll('.indicator');
                                    let autoSlideInterval;

                                    function updateSlide() {
                                          // Move slide
                                          slide.style.transform = `translateX(-${currentSlide * 25}%)`;

                                          // Update indicators
                                          indicators.forEach((indicator, index) => {
                                                indicator.classList.toggle('active', index === currentSlide);
                                          });
                                    }

                                    function changeSlide(direction) {
                                          currentSlide = (currentSlide + direction + totalSlides) % totalSlides;
                                          updateSlide();
                                          resetAutoSlide();
                                    }

                                    function goToSlide(index) {
                                          currentSlide = index;
                                          updateSlide();
                                          resetAutoSlide();
                                    }

                                    function nextSlide() {
                                          currentSlide = (currentSlide + 1) % totalSlides;
                                          updateSlide();
                                    }

                                    function startAutoSlide() {
                                          autoSlideInterval = setInterval(nextSlide, 4000);
                                    }

                                    function resetAutoSlide() {
                                          clearInterval(autoSlideInterval);
                                          startAutoSlide();
                                    }

                                    // Start auto slide when page loads
                                    document.addEventListener('DOMContentLoaded', function () {
                                          startAutoSlide();
                                    });

                                    // Pause auto slide when hovering
                                    const bannerContainer = document.querySelector('.banner-container');
                                    bannerContainer.addEventListener('mouseenter', () => {
                                          clearInterval(autoSlideInterval);
                                    });

                                    bannerContainer.addEventListener('mouseleave', () => {
                                          startAutoSlide();
                                    });
                                    function addToCart(bookId) {
                                          fetch('${pageContext.request.contextPath}/UpdateCartServlet?bookId=' + bookId + '&change=1')
                                                  .then(response => response.json())
                                                  .then(data => {
                                                        if (data.success) {
                                                              // Show success message with better styling
                                                              const alertDiv = document.createElement('div');
                                                              alertDiv.className = 'alert alert-success alert-dismissible fade show position-fixed';
                                                              alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
                                                              alertDiv.innerHTML = `
                                    <i class="fas fa-check-circle me-2"></i>Book added to cart successfully!
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                `;
                                                              document.body.appendChild(alertDiv);

                                                              // Auto remove after 3 seconds
                                                              setTimeout(() => {
                                                                    if (alertDiv.parentNode) {
                                                                          alertDiv.parentNode.removeChild(alertDiv);
                                                                    }
                                                              }, 3000);
                                                        } else {
                                                              // Show error message
                                                              const alertDiv = document.createElement('div');
                                                              alertDiv.className = 'alert alert-danger alert-dismissible fade show position-fixed';
                                                              alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
                                                              alertDiv.innerHTML = `
                                    <i class="fas fa-exclamation-circle me-2"></i>${data.message}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                `;
                                                              document.body.appendChild(alertDiv);

                                                              // Auto remove after 3 seconds
                                                              setTimeout(() => {
                                                                    if (alertDiv.parentNode) {
                                                                          alertDiv.parentNode.removeChild(alertDiv);
                                                                    }
                                                              }, 3000);
                                                        }
                                                  })
                                                  .catch(error => {
                                                        console.error('Error:', error);
                                                        alert('Có lỗi xảy ra, vui lòng thử lại!');
                                                  });
                                    }
                                    function toggleChat() {
                                          var chatBox = document.getElementById("chat-box");
                                          if (chatBox.classList.contains("show")) {
                                                chatBox.classList.remove("show");
                                                setTimeout(() => {
                                                      chatBox.style.display = "none";
                                                }, 300);
                                          } else {
                                                chatBox.style.display = "block";
                                                setTimeout(() => {
                                                      chatBox.classList.add("show");
                                                }, 10);
                                          }
                                    }
                                    document.getElementById('notificationBell').addEventListener('click', function () {
                                          fetch('${pageContext.request.contextPath}/NotificationServlet')
                                                  .then(response => response.json())
                                                  .then(data => {
                                                        const dropdown = document.querySelector('.dropdown-menu');
                                                        dropdown.innerHTML = '';

                                                        if (data.length === 0) {
                                                              dropdown.innerHTML = '<li class="text-center text-muted">No notifications</li>';
                                                        } else {
                                                              data.forEach(noti => {
                                                                    const li = document.createElement('li');
                                                                    li.classList.add('dropdown-item');

                                                                    let dateStr = 'N/A';
                                                                    try {
                                                                          const date = new Date(noti.createdAt);
                                                                          if (!isNaN(date.getTime())) {
                                                                                dateStr = date.toLocaleString('vi-VN');
                                                                          }
                                                                    } catch (e) {
                                                                          console.error('Invalid date:', noti.createdAt);
                                                                    }

                                                                    li.innerHTML = `
                        <div>
                            <small class="text-muted">${dateStr}</small><br>
                  ${noti.message}
                        </div>
                            `;
                                                                    dropdown.appendChild(li);
                                                              });


                                                              document.getElementById('notificationCount').textContent = data.length;
                                                        }
                                                  });
                                    });
            </script>
      </body>
</html>