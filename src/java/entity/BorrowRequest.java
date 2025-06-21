package entity;

import java.sql.Date;

public class BorrowRequest {
    private int id;
    private int userId;
    private int bookId;
    private Date requestDate;
    private String status; // pending, approved, rejected

    public BorrowRequest() {
    }

    public BorrowRequest(int id, int userId, int bookId, Date requestDate, String status) {
        this.id = id;
        this.userId = userId;
        this.bookId = bookId;
        this.requestDate = requestDate;
        this.status = status;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public Date getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(Date requestDate) {
        this.requestDate = requestDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
} 