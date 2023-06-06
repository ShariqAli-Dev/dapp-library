// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BookBorrowingSystem {
    struct Book {
        uint256 id;
        string title;
        string author;
        bool isAvailable;
    }

    struct User {
        address userAddress;
        uint256[] borrowedBooks;
    }

    mapping(uint256 => Book) private books;
    mapping(address => User) private users;

    uint256 private nextBookId;

    // Event emitted when a book is borrowed
    event BookBorrowed(uint256 indexed bookId, address indexed user);

    // Event emitted when a book is returned
    event BookReturned(uint256 indexed bookId, address indexed user);

    constructor() {
        nextBookId = 1;
    }

    function addBook(string memory title, string memory author) external {
        books[nextBookId] = Book(nextBookId, title, author, true);
        nextBookId++;
    }

    function borrowBook(uint256 bookId) external {
        require(
            users[msg.sender].borrowedBooks.length < 3,
            "Book limit reached"
        );
        require(books[bookId].isAvailable, "Book is not available");

        users[msg.sender].borrowedBooks.push(bookId);
        books[bookId].isAvailable = false;

        emit BookBorrowed(bookId, msg.sender);
    }

    function returnBook(uint256 bookId) external {
        require(
            !books[bookId].isAvailable,
            "Book is already returned or not borrowed"
        );

        bool found = false;
        uint256[] storage borrowedBooks = users[msg.sender].borrowedBooks;
        for (uint256 i = 0; i < borrowedBooks.length; i++) {
            if (borrowedBooks[i] == bookId) {
                found = true;
                borrowedBooks[i] = borrowedBooks[borrowedBooks.length - 1];
                borrowedBooks.pop();
                break;
            }
        }

        require(found, "Book not borrowed by the user");

        books[bookId].isAvailable = true;

        emit BookReturned(bookId, msg.sender);
    }

    function getBook(
        uint256 bookId
    )
        external
        view
        returns (string memory title, string memory author, bool isAvailable)
    {
        Book storage book = books[bookId];
        return (book.title, book.author, book.isAvailable);
    }

    function getUserBooks() external view returns (uint256[] memory) {
        return users[msg.sender].borrowedBooks;
    }
}
