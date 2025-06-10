package entity;

import java.sql.Date;

public class BorrowRequest {
    private int id;
    private int userId;
    private int bookId;
    private Date requestDate;
    private Date dueDate;
    private String status; // pending, approved, rejected, returned
    private String note;

    public BorrowRequest() {
    }

    public BorrowRequest(int id, int userId, int bookId, Date requestDate, Date dueDate, String status, String note) {
        this.id = id;
        this.userId = userId;
        this.bookId = bookId;
        this.requestDate = requestDate;
        this.dueDate = dueDate;
        this.status = status;
        this.note = note;
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

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
} 