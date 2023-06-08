// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Strings.sol";

contract Library {
    struct Book {
        uint256 id;
        string name;
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

    event BookBorrowed(uint256 indexed bookId, address indexed user);
    event BookReturned(uint256 indexed bookId, address indexed user);

    constructor() {
        nextBookId = 1;
        for (uint256 i = 0; i < 4; i++) {
            books[nextBookId] = Book(
                nextBookId,
                string.concat("Book ", Strings.toString(nextBookId)),
                string.concat("Author ", Strings.toString(nextBookId)),
                true
            );
            nextBookId++;
        }
    }

    function addBook(string memory _name, string memory _author) external {
        Book memory newBook = Book(nextBookId, _name, _author, true);
        books[nextBookId] = newBook;
        nextBookId++;
    }

    function borrowBook(uint256 _bookId, address _userAddress) external {
        require(
            users[msg.sender].borrowedBooks.length < 3,
            "Book limit reached"
        );
        require(books[_bookId].isAvailable, "Book is not available");

        users[_userAddress].borrowedBooks.push(_bookId);
        books[_bookId].isAvailable = false;

        emit BookBorrowed(_bookId, _userAddress);
    }

    function returnBook(uint256 _bookId) external {
        require(
            !books[_bookId].isAvailable,
            "Book is already retuned or not borrowed"
        );

        uint256[] storage borrowedBooks = users[msg.sender].borrowedBooks;
        bool found = false;
        for (uint256 i = 0; i < borrowedBooks.length; i++) {
            if (borrowedBooks[i] == _bookId) {
                found = true;
                borrowedBooks[i] = borrowedBooks[borrowedBooks.length - 1];
                borrowedBooks.pop();
                break;
            }
        }

        require(found, "Book not borrowed by the user");

        books[_bookId].isAvailable = true;

        emit BookReturned(_bookId, msg.sender);
    }

    function getBook(uint256 _bookId) external view returns (Book memory) {
        return books[_bookId];
    }

    function getUserBook(
        address _userAddress
    ) external view returns (uint256[] memory) {
        return users[_userAddress].borrowedBooks;
    }
}
