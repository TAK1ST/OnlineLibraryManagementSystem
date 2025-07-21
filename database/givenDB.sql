-- Create the database
DROP DATABASE library_system
GO
CREATE DATABASE library_system;
GO
USE library_system;
GO
-- 1. USERS TABLE
CREATE TABLE users (
    id INT PRIMARY KEY identity(1,1),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role varchar(20),
    status varchar (20) DEFAULT 'active',   --active/inactive
	avatar varchar (100),
);
GO
-- 2. BOOKS TABLE
CREATE TABLE books (
    id INT PRIMARY KEY identity(1,1),
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) NOT NULL UNIQUE,
    category VARCHAR(50),
    published_year INT,
    total_copies INT DEFAULT 1,
    available_copies INT DEFAULT 1,
	image_url VARCHAR(255) DEFAULT NULL,
    status varchar(20) default 'active' -- active/inactive
);
GO
-- 3. BORROW RECORDS TABLE
CREATE TABLE borrow_records (
    id INT PRIMARY KEY identity(1,1),
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    borrow_date DATE,
    due_date DATE NOT NULL,
    return_date DATE DEFAULT NULL,
    status varchar(20)  DEFAULT 'borrowed',--('borrowed', 'returned', 'overdue')
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);
GO
-- 4. FINES TABLE
CREATE TABLE fines (
    id INT PRIMARY KEY identity(1,1),
    borrow_id INT NOT NULL,
    fine_amount DECIMAL(6, 2) DEFAULT 0.00,
    paid_status varchar(20) default 'unpaid' -- ('paid', 'unpaid') 
    FOREIGN KEY (borrow_id) REFERENCES borrow_records(id) ON DELETE CASCADE
);
GO
-- 5. BOOK REQUESTS TABLE (OPTIONAL)
CREATE TABLE book_requests (
    id INT PRIMARY KEY identity(1,1),
    user_id INT NOT NULL,
    book_id INT NOT NULL,
	quantity INT NOT NULL DEFAULT 1,
    request_date DATE ,
	request_type VARCHAR(20) NOT NULL DEFAULT 'borrow' CHECK (request_type IN ('borrow', 'return')),
    status varchar(20) default 'pending',-- 'approved', 'rejected' 
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);
GO
-- 6. SYSTEM CONFIGURATION TABLE
CREATE TABLE system_config (
    id INT PRIMARY KEY identity(1,1),
    config_key VARCHAR(50) NOT NULL UNIQUE,
    config_value VARCHAR(100) NOT NULL,
    description TEXT
);
GO
CREATE TABLE messages (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    subject NVARCHAR(255),
    message TEXT,
    status VARCHAR(20) DEFAULT 'unread',
    created_at DATETIME DEFAULT GETDATE()
);
GO
CREATE TABLE notifications (
    id INT PRIMARY KEY IDENTITY,
    user_id INT,
    message NVARCHAR(255),
    is_read BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE()
);
GO

--Trigger update overdue
DROP TRIGGER IF EXISTS trg_UpdateOverdueStatus;
GO

CREATE TRIGGER trg_UpdateOverdueStatus
ON borrow_records
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE br
    SET status = 'overdue'
    FROM borrow_records br
    INNER JOIN inserted i ON br.id = i.id
    WHERE br.return_date IS NULL 
      AND br.due_date < CAST(GETDATE() AS DATE)
      AND br.status = 'borrowed';
END;
GO

-- Users
INSERT INTO users (name, email, password, role, status) VALUES
('Admin User', 'admin@example.com', 'adminpassword', 'admin', 'active'),
('John Doe', 'john@example.com', 'password123', 'user', 'active'),
('Jane Smith', 'jane@example.com', 'password456', 'user', 'active');

-- Books
INSERT INTO books (title, author, isbn, category, published_year, total_copies, available_copies, image_url, status) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', '9780743273565', 'Fiction', 1925, 5, 5, 'https://example.com/gatsby.jpg', 'active'),
('To Kill a Mockingbird', 'Harper Lee', '9780446310789', 'Fiction', 1960, 3, 3, 'https://example.com/mockingbird.jpg', 'active'),
('1984', 'George Orwell', '9780451524935', 'Dystopian', 1949, 4, 4, 'https://example.com/1984.jpg', 'active'),
('Pride and Prejudice', 'Jane Austen', '9780141439518', 'Romance', 1813, 2, 2, 'https://example.com/pride.jpg', 'active'),
('The Catcher in the Rye', 'J.D. Salinger', '9780316769488', 'Fiction', 1951, 1, 1, 'https://example.com/catcher.jpg', 'active');

-- Borrow Records
INSERT INTO borrow_records (user_id, book_id, borrow_date, due_date, return_date, status) VALUES
(2, 3, '2025-06-01', '2025-06-15', NULL, 'borrowed'),  -- John mượn 1984, chưa trả
(3, 1, '2025-05-20', '2025-06-03', '2025-06-05', 'returned'),  -- Jane mượn The Great Gatsby, trả muộn
(3, 2, '2025-06-10', '2025-06-24', NULL, 'borrowed');  -- Jane mượn To Kill a Mockingbird, chưa trả

-- Fines
INSERT INTO fines (borrow_id, fine_amount, paid_status) VALUES
(2, 2.00, 'unpaid');  -- Fine cho Jane, trả muộn 2 ngày, $1/ngày

-- Book Requests (để khớp log: ID 2 approved borrow, ID 3 rejected return)
INSERT INTO book_requests (user_id, book_id, request_date, request_type, status) VALUES
(2, 4, '2025-06-20', 'borrow', 'approved'),  -- John mượn Pride and Prejudice, approved (ID 2)
(3, 2, '2025-06-22', 'return', 'rejected');  -- Jane trả To Kill a Mockingbird, rejected (ID 3)