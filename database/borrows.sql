CREATE TABLE Borrows (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    borrow_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'BORROWED',
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (book_id) REFERENCES Books(id)
);

-- 添加索引以提高查询性能
CREATE INDEX idx_user_id ON Borrows(user_id);
CREATE INDEX idx_book_id ON Borrows(book_id);
CREATE INDEX idx_status ON Borrows(status);

-- 添加约束确保status只能是特定的值
ALTER TABLE Borrows
ADD CONSTRAINT CHK_Status 
CHECK (status IN ('BORROWED', 'RETURNED', 'OVERDUE')); 