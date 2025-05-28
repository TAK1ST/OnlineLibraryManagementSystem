-- Create the database
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
    status varchar (20) DEFAULT 'active'   --active/inactive
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
    request_date DATE ,
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
-- Insert default configuration values
INSERT INTO system_config (config_key, config_value, description) VALUES
('overdue_fine_per_day', '0.50', 'Fine amount per day for overdue books (in dollars)'),
('default_borrow_duration_days', '14', 'Default number of days a book can be borrowed'),
('unit_price_per_book', '10.00', 'Default unit price used for book replacement or reference');
GO
INSERT INTO users (name, email, password, role, status) VALUES
('Alice Admin', 'alice.admin@example.com', 'admin123', 'admin', 'active'),
('Thi No', 'No@example.com', 'no123', 'user', 'active'),
('Emma Reader', 'emma.user@example.com', 'user123', 'user', 'active'),
('Noah Reader', 'noah.user@example.com', 'user456', 'user', 'active'),
('Olivia Reader', 'olivia.user@example.com', 'user789', 'user', 'blocked');
GO
INSERT INTO books (title, author, isbn, category, published_year, total_copies, available_copies) VALUES
('Effective Java', 'Joshua Bloch', '9780134685991', 'Programming', 2018, 5, 3),
('Clean Code', 'Robert C. Martin', '9780132350884', 'Software Engineering', 2008, 4, 4),
('Java: The Complete Reference', 'Herbert Schildt', '9781260440232', 'Programming', 2020, 6, 5),
('Design Patterns', 'Erich Gamma', '9780201633610', 'Architecture', 1994, 3, 2),
('Head First Java', 'Kathy Sierra', '9780596009205', 'Beginner', 2005, 2, 1);
GO
INSERT INTO borrow_records (user_id, book_id, borrow_date, due_date, return_date, status) VALUES
(3, 1, '2025-04-25', '2025-05-09', NULL, 'borrowed'),
(4, 2, '2025-04-20', '2025-05-04', '2025-05-03', 'returned'),
(5, 3, '2025-04-10', '2025-04-24', NULL, 'overdue'),
(3, 4, '2025-04-15', '2025-04-29', '2025-05-01', 'returned'),
(4, 5, '2025-05-01', '2025-05-15', NULL, 'borrowed');
GO
INSERT INTO fines (borrow_id, fine_amount, paid_status) VALUES
(3, 5.00, 'unpaid'),
(4, 1.00, 'paid'),
(1, 0.00, 'paid'),
(5, 0.00, 'unpaid'),
(2, 0.00, 'paid');
GO
INSERT INTO book_requests (user_id, book_id, request_date, status) VALUES
(3, 1, '2025-05-01', 'pending'),
(4, 2, '2025-04-30', 'approved'),
(5, 3, '2025-04-28', 'rejected'),
(3, 5, '2025-05-05', 'pending'),
(4, 4, '2025-04-27', 'approved');
GO
