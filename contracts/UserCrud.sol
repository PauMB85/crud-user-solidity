// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract UserCrud {
    struct User {
        uint256 id;
        string name;
        uint256 age;
        bool isActive;
    }

    mapping(uint256 => User) private users;
    uint256 private nextId = 0;

    // eventos

    event UserCreated(uint256 indexed id, string name, uint256 age);
    event UserUpdated(uint256 indexed id, string name, uint256 age);
    event UserDeleted(uint256 indexed id);

    // funciones

    modifier userValidation(uint256 _id) {
        require(_id < nextId, "El usuario no existe");
        require(users[_id].isActive == true, "El usuario esta inactivo");
        _;
    }

    function createUser(string memory _name, uint8 _age) public {
        users[nextId] = User(nextId, _name, _age, true);
        emit UserCreated(nextId, _name, _age);
        nextId++;
    }

    function readUserById(
        uint256 _id
    ) public view userValidation(_id) returns (User memory) {
        return users[_id];
    }

    function updateUserById(
        uint256 _id,
        string memory _name,
        uint256 _age
    ) public userValidation(_id) {
        User storage user = users[_id];
        user.name = _name;
        user.age = _age;
        emit UserUpdated(_id, _name, _age);
    }

    function deleteUserById(uint256 _id) public userValidation(_id) {
        User storage user = users[_id];
        user.isActive = false;
        emit UserDeleted(_id);
    }

    /**
    Esta función se puede obtimizar, por ejemplo:
    - Haciendo un single-pass de todos los usuarios activos.
    - teniendo una lista paralela de user activos y otra de inactivos.

    Solo se ha creado asi para fines educativos
     */
    function getAllActiveUsers() public view returns (User[] memory) {
        uint256 activeAccounts = 0;

        for (uint256 i = 0; i < nextId; i++) {
            if (users[i].isActive == true) {
                activeAccounts++;
            }
        }

        User[] memory usersActive = new User[](activeAccounts);
        uint256 index = 0;
        for (uint256 i = 0; i < nextId; i++) {
            if (users[i].isActive == true) {
                usersActive[index] = users[i];
                index++;
            }
        }
        return usersActive;
    }
}
