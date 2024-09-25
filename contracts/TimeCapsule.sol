// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimeCapsule {
    struct Capsule {
        string message;
        uint releaseTime;
        address owner;
        bool claimed;
    }

    Capsule[] public capsules;
    mapping(address => uint[]) public userCapsules;

    event CapsuleCreated(uint capsuleId, address owner, uint releaseTime);

    function createCapsule(string memory _message, uint _releaseTime) public {
        require(
            _releaseTime > block.timestamp,
            "Release time must be in the future."
        );

        capsules.push(
            Capsule({
                message: _message,
                releaseTime: _releaseTime,
                owner: msg.sender,
                claimed: false
            })
        );

        uint capsuleId = capsules.length - 1;
        userCapsules[msg.sender].push(capsuleId);
        emit CapsuleCreated(capsuleId, msg.sender, _releaseTime);
    }

    function retrieveCapsule(
        uint _capsuleId
    ) public view returns (string memory) {
        Capsule memory capsule = capsules[_capsuleId];
        require(capsule.owner == msg.sender, "You are not the owner.");
        require(
            block.timestamp >= capsule.releaseTime,
            "The capsule is not yet ready to be opened."
        );
        return capsule.message;
    }

    function getMyCapsules() public view returns (uint[] memory) {
        return userCapsules[msg.sender];
    }
}
