# 📚 Online Library Management System

A **Java Web Application** designed to manage a simple online library. The system provides functionality for guests, users, and administrators to interact with books—search, borrow, return, and manage inventory. Developed as part of the Java Web Workshop (SUMMER25).

## 🎯 Objective

Design and implement a fully functional online library system that supports book management, borrowing, and user account operations for both users and admins.

---

## 🔑 Core Features

### 👥 Guest
- 🏠 View Home page with latest books *(Workshop 1)*
- 🔍 Search books by title, author, or category *(Workshop 1)*
- 📄 View book details *(Workshop 2)*
- 📝 Register an account *(Workshop 2)*

### 👤 Registered User
- 🔐 Login/Logout *(Workshop 1)*
- 👤 Change profile info *(Workshop 1)*
- 🔍 Search for books *(Workshop 2)*
- 📘 View availability of books *(Workshop 2)*
- 📥 Request to borrow/return books *(Assignment)*
- 🕓 View borrow history *(Assignment)*

### 🛠 Admin
- 🔐 Admin login/logout *(Workshop 1)*
- ⚙️ Setup system configurations:
  - Overdue fines
  - Book return deadlines
  - Borrowing unit price *(Workshop 1)*
- ➕ Add/Edit/Remove books *(Workshop 2)*
- ✅ Approve/Reject borrow/return requests & calculate fines *(Assignment)*
- 🔍 Search users by email & enable/disable accounts *(Workshop 2)*
- ⏰ View list of overdue books *(Assignment)*
- 📦 Update book inventory *(Assignment)*
- 📊 View system statistics *(Assignment)*

---

## 🗂️ Statistics Page Includes:
- Total Books
- Total Users
- Currently Borrowed Books
- Most Borrowed Books (Top 5)
- Monthly Borrowing Stats (Bar Chart)
- Average Borrow Duration

---

## 🧩 Tech Stack
- **Java EE** with **Servlets/JSP**
- **JDBC** for database connectivity
- **SQL Server** for persistent storage
- **HTML/CSS/JS** for frontend

---



## 🗃️ Database Overview

The database includes tables for:
- Users
- Books
- Borrow Records
- Admin Settings
- System Stats


## 🧠 How to Run
1. Clone this repo:
   ```bash
   git clone https://github.com/your-repo/library-management-system.git
2. Add DBConnection.java file in src/java/utils with block code below:
   ```java
   public class DBConnection_example {
    private static final String DB_NAME = "YOUR_DB_NAME";                      //Input your database name
    private static final String DB_USER_NAME = "YOUR_DB_USER_NAME";            //Input your user's database 
    private static final String DB_PASSWORD = "YOUR_DB_PASSWORD";              //Input your password
    
    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Connection conn = null;
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = "jdbc:sqlserver://localhost:1433;databaseName=" + DB_NAME;
        conn = DriverManager.getConnection(url, DB_USER_NAME, DB_PASSWORD);
        return conn;
   }}
3. Build and run the project.
