/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import java.math.BigDecimal;
import java.sql.Date;

/**
 * Entity class representing an overdue book with complete information
 * @author CAU_TU
 */
public class OverdueBook {
    
    // Borrow record information
    private int borrowId;
    private Date borrowDate;
    private Date dueDate;
    private Date returnDate;
    private String borrowStatus;
    
    // User information
    private int userId;
    private String userName;
    private String userEmail;
    private String userRole;
    private String userStatus;
    
    // Book information
    private int bookId;
    private String bookTitle;
    private String bookAuthor;
    private String bookIsbn;
    private String bookCategory;
    
    // Overdue and fine information
    private int overdueDays;
    private BigDecimal fineAmount;
    private String paidStatus;

    // Default constructor
    public OverdueBook() {
    }

    // Constructor with basic information
    public OverdueBook(int borrowId, String userName, String bookTitle, Date borrowDate, 
                      Date dueDate, int overdueDays, BigDecimal fineAmount, String paidStatus) {
        this.borrowId = borrowId;
        this.userName = userName;
        this.bookTitle = bookTitle;
        this.borrowDate = borrowDate;
        this.dueDate = dueDate;
        this.overdueDays = overdueDays;
        this.fineAmount = fineAmount;
        this.paidStatus = paidStatus;
    }

    // Getters and Setters for Borrow Record
    public int getBorrowId() {
        return borrowId;
    }

    public void setBorrowId(int borrowId) {
        this.borrowId = borrowId;
    }

    public Date getBorrowDate() {
        return borrowDate;
    }

    public void setBorrowDate(Date borrowDate) {
        this.borrowDate = borrowDate;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public Date getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(Date returnDate) {
        this.returnDate = returnDate;
    }

    public String getBorrowStatus() {
        return borrowStatus;
    }

    public void setBorrowStatus(String borrowStatus) {
        this.borrowStatus = borrowStatus;
    }

    // Getters and Setters for User Information
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getUserRole() {
        return userRole;
    }

    public void setUserRole(String userRole) {
        this.userRole = userRole;
    }

    public String getUserStatus() {
        return userStatus;
    }

    public void setUserStatus(String userStatus) {
        this.userStatus = userStatus;
    }

    // Getters and Setters for Book Information
    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public String getBookTitle() {
        return bookTitle;
    }

    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
    }

    public String getBookAuthor() {
        return bookAuthor;
    }

    public void setBookAuthor(String bookAuthor) {
        this.bookAuthor = bookAuthor;
    }

    public String getBookIsbn() {
        return bookIsbn;
    }

    public void setBookIsbn(String bookIsbn) {
        this.bookIsbn = bookIsbn;
    }

    public String getBookCategory() {
        return bookCategory;
    }

    public void setBookCategory(String bookCategory) {
        this.bookCategory = bookCategory;
    }

    // Getters and Setters for Overdue and Fine Information
    public int getOverdueDays() {
        return overdueDays;
    }

    public void setOverdueDays(int overdueDays) {
        this.overdueDays = overdueDays;
    }

    public BigDecimal getFineAmount() {
        return fineAmount;
    }

    public void setFineAmount(BigDecimal fineAmount) {
        this.fineAmount = fineAmount;
    }

    public String getPaidStatus() {
        return paidStatus;
    }

    public void setPaidStatus(String paidStatus) {
        this.paidStatus = paidStatus;
    }

    // Utility methods
    @Override
    public String toString() {
        return "OverdueBook{" +
                "borrowId=" + borrowId +
                ", userName='" + userName + '\'' +
                ", bookTitle='" + bookTitle + '\'' +
                ", dueDate=" + dueDate +
                ", overdueDays=" + overdueDays +
                ", fineAmount=" + fineAmount +
                ", paidStatus='" + paidStatus + '\'' +
                '}';
    }

    /**
     * Check if the fine has been paid
     * @return true if fine is paid, false otherwise
     */
    public boolean isFinePaid() {
        return "paid".equalsIgnoreCase(paidStatus);
    }

    /**
     * Get formatted fine amount as string
     * @return formatted fine amount
     */
    public String getFormattedFineAmount() {
        if (fineAmount == null) {
            return "0.00";
        }
        return String.format("%.2f", fineAmount);
    }
}