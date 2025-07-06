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
-- 7.
CREATE TABLE messages (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    subject NVARCHAR(255),
    message TEXT,
    status VARCHAR(20) DEFAULT 'unread',
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- 8. PASSWORD RESET TOKENS TABLE (Required for reset password functionality)
CREATE TABLE password_reset_tokens (
    id INT PRIMARY KEY identity(1,1),
    user_id INT NOT NULL,
    token VARCHAR(255) NOT NULL UNIQUE,
    expiration_time BIGINT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
GO

-- Xóa các objects cũ nếu có
DROP VIEW IF EXISTS vw_book_reviews_detail;
DROP TRIGGER IF EXISTS trg_UpdateReactionCounts;
DROP TRIGGER IF EXISTS trg_UpdateReviewTimestamp;
DROP TABLE IF EXISTS review_reactions;
DROP TABLE IF EXISTS book_reviews;
GO

-- Tạo bảng book_reviews để người dùng comment về sách
CREATE TABLE book_reviews (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5), -- Đánh giá từ 1-5 sao
    comment TEXT,
    review_date DATETIME DEFAULT GETDATE(),
    status VARCHAR(20) DEFAULT 'active', -- active/inactive/pending
    likes_count INT DEFAULT 0,
    dislikes_count INT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE NO ACTION,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE NO ACTION,
    -- Đảm bảo mỗi user chỉ có thể review 1 lần cho 1 cuốn sách
    CONSTRAINT UC_UserBook_Review UNIQUE (user_id, book_id)
);
GO

-- Trigger cập nhật updated_at khi có thay đổi
CREATE TRIGGER trg_UpdateReviewTimestamp
ON book_reviews
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE br
    SET updated_at = GETDATE()
    FROM book_reviews br
    INNER JOIN inserted i ON br.id = i.id;
END;
GO

-- Bảng phụ để lưu likes/dislikes của users cho reviews (optional)
CREATE TABLE review_reactions (
    id INT PRIMARY KEY IDENTITY(1,1),
    review_id INT NOT NULL,
    user_id INT NOT NULL,
    reaction_type VARCHAR(10) CHECK (reaction_type IN ('like', 'dislike')),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (review_id) REFERENCES book_reviews(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE NO ACTION,
    -- Đảm bảo mỗi user chỉ có thể react 1 lần cho 1 review
    CONSTRAINT UC_UserReview_Reaction UNIQUE (review_id, user_id)
);
GO

-- Trigger cập nhật likes_count và dislikes_count
CREATE TRIGGER trg_UpdateReactionCounts
ON review_reactions
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Cập nhật likes_count và dislikes_count
    UPDATE br
    SET 
        likes_count = (
            SELECT COUNT(*) 
            FROM review_reactions rr 
            WHERE rr.review_id = br.id AND rr.reaction_type = 'like'
        ),
        dislikes_count = (
            SELECT COUNT(*) 
            FROM review_reactions rr 
            WHERE rr.review_id = br.id AND rr.reaction_type = 'dislike'
        )
    FROM book_reviews br
    WHERE br.id IN (
        SELECT DISTINCT review_id FROM inserted
        UNION
        SELECT DISTINCT review_id FROM deleted
    );
END;
GO

-- View để hiển thị thông tin review chi tiết
CREATE VIEW vw_book_reviews_detail AS
SELECT 
    br.id,
    br.rating,
    br.comment,
    br.review_date,
    br.likes_count,
    br.dislikes_count,
    u.name as reviewer_name,
    u.email as reviewer_email,
    b.title as book_title,
    b.author as book_author,
    b.isbn
FROM book_reviews br
INNER JOIN users u ON br.user_id = u.id
INNER JOIN books b ON br.book_id = b.id
WHERE br.status = 'active'
AND u.status = 'active'
AND b.status = 'active';
GO

-- SELECT book_title, AVG(CAST(rating AS FLOAT)) as avg_rating FROM book_reviews br INNER JOIN books b ON br.book_id = b.id GROUP BY book_title;

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

-- Trigger tự động tạo fines khi status borrow_records chuyển thành 'overdue'
DROP TRIGGER IF EXISTS trg_AutoCreateFines;
GO

CREATE TRIGGER trg_AutoCreateFines
ON borrow_records
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Chỉ xử lý khi status thay đổi từ 'borrowed' thành 'overdue'
    IF UPDATE(status)
    BEGIN
        -- Tạo fines cho những borrow_records chuyển sang overdue
        INSERT INTO fines (borrow_id, fine_amount, paid_status)
        SELECT 
            i.id,
            CASE 
                WHEN DATEDIFF(DAY, i.due_date, GETDATE()) > 0 
                THEN DATEDIFF(DAY, i.due_date, GETDATE()) * 1.00  -- $1 per day
                ELSE 0.00
            END as fine_amount,
            'unpaid'
        FROM inserted i
        INNER JOIN deleted d ON i.id = d.id
        WHERE d.status = 'borrowed' 
          AND i.status = 'overdue'
          AND i.return_date IS NULL
          AND NOT EXISTS (
              SELECT 1 FROM fines f WHERE f.borrow_id = i.id
          );
    END;
END;
GO

-- Trigger cập nhật fine_amount khi có thay đổi
DROP TRIGGER IF EXISTS trg_UpdateFineAmount;
GO

CREATE TRIGGER trg_UpdateFineAmount
ON borrow_records
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Cập nhật fine_amount cho các borrow_records vẫn overdue
    UPDATE f
    SET fine_amount = CASE 
        WHEN DATEDIFF(DAY, i.due_date, GETDATE()) > 0 
        THEN DATEDIFF(DAY, i.due_date, GETDATE()) * 1.00
        ELSE 0.00
    END
    FROM fines f
    INNER JOIN inserted i ON f.borrow_id = i.id
    WHERE i.status = 'overdue'
      AND i.return_date IS NULL
      AND f.paid_status = 'unpaid';
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

-- Thêm một số sample data (sử dụng user_id có sẵn từ database)
INSERT INTO book_reviews (user_id, book_id, rating, comment, status) VALUES
(42, 1, 5, 'A masterpiece. I couldn’t put it down!', 'active'),
(50, 1, 4, 'Beautifully written and thought-provoking.', 'active'),
(54, 3, 5, 'Highly recommended for anyone who loves mystery novels.', 'active'),
(70, 2, 4, 'I liked some parts, but others were not as engaging.', 'active');


-- Thêm sample reactions
INSERT INTO review_reactions (review_id, user_id, reaction_type) VALUES
(1, 42, 'like'),
(2, 50, 'like'),
(3, 54, 'like'),
(4, 70, 'like');

