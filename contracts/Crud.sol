// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

contract Crud {
    struct User {
        uint id;
        string name;
    }

    User[] public users;
    uint public nextId;

    function createUser(string memory _name) public returns (User memory) {
        users.push(User(nextId, _name));
        nextId++;
        return users[users.length - 1];
    }

    function findUser(uint _id) public view returns (User memory) {
        for (uint i = 0; i < users.length; i++) {
            if (users[i].id == _id) {
                return users[i];
            }
        }
        revert("user not found");
    }

    function updateUser(
        uint _id,
        string memory _name
    ) public returns (User memory) {
        users[_id].name = _name;
        return users[_id];
    }

    function deleteUser(uint _id) public {
        delete users[_id];
    }

    function getUsers() public view returns (User[] memory) {
        return users;
    }
}
