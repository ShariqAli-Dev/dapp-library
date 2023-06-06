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
}
