/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

/**
 *
 * @author asus
 */
public class Fine {
    private int id;
    private int borrowId;
    private BorrowRecord borrowRecord;
    private Long fineAmount;
    private String paidStatus;

      public Fine() {
      }

      public Fine(int id, int borrowId, BorrowRecord borrowRecord, Long fineAmount, String paidStatus) {
            this.id = id;
            this.borrowId = borrowId;
            this.borrowRecord = borrowRecord;
            this.fineAmount = fineAmount;
            this.paidStatus = paidStatus;
      }

      public int getId() {
            return id;
      }

      public void setId(int id) {
            this.id = id;
      }

      public BorrowRecord getBorrowRecord() {
            return borrowRecord;
      }

      public void setBorrowRecord(BorrowRecord borrowRecord) {
            this.borrowRecord = borrowRecord;
      }

      public Long getFineAmount() {
            return fineAmount;
      }

      public void setFineAmount(Long fineAmount) {
            this.fineAmount = fineAmount;
      }

      public String getPaidStatus() {
            return paidStatus;
      }

      public void setPaidStatus(String paidStatus) {
            this.paidStatus = paidStatus;
      }

    public int getBorrowId() {
        return borrowId;
    }

    public void setBorrowId(int borrowId) {
        this.borrowId = borrowId;
    }


}
