package entity;

public class CartItem {
    private int id;
    private int userId;
    private int bookId;
    private String bookTitle;
    private String bookAuthor;
    private String addedDate;
    private Book book;
    private int quantity;

    public CartItem() {
    }

    // Constructor for database loading
    public CartItem(int id, int userId, int bookId, String bookTitle, String bookAuthor, String addedDate) {
        this.id = id;
        this.userId = userId;
        this.bookId = bookId;
        this.bookTitle = bookTitle;
        this.bookAuthor = bookAuthor;
        this.addedDate = addedDate;
        this.quantity = 1;
    }

    // Constructor for cart operations
    public CartItem(Book book, int quantity) {
        this.book = book;
        this.bookId = book.getId();
        this.bookTitle = book.getTitle();
        this.bookAuthor = book.getAuthor();
        this.quantity = quantity;
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

    public String getAddedDate() {
        return addedDate;
    }

    public void setAddedDate(String addedDate) {
        this.addedDate = addedDate;
    }

    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
        if (book != null) {
            this.bookId = book.getId();
            this.bookTitle = book.getTitle();
            this.bookAuthor = book.getAuthor();
        }
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public void incrementQuantity() {
        if (this.book != null && this.quantity < book.getAvailableCopies()) {
            this.quantity++;
        }
    }

    public void decrementQuantity() {
        if (this.quantity > 1) {
            this.quantity--;
        }
    }
} 