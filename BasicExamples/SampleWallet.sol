//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

/*
The SampleWallet contract allows for ownership transfer, setting allowances, and transferring ETH/wei etc:

Ownership can be transferred by designated guardians proposing a new owner.
The owner can set allowances for specific addresses to send ETH from the contract.
The owner can deny sending permissions for specific addresses.
Authorized addresses can transfer ETH from the contract to other addresses.
The owner can directly transfer ETH from the contract to other addresses.
The contract includes a fallback function to receive ETH.
The contract utilizes mappings and variables to track allowances, permissions, guardians, and the current owner.

*/


contract SampleWallet {

    address payable public owner;

    mapping(address => uint) public allowance;
    mapping(address => bool) public isAllowedToSend;

    mapping(address => bool) public guardian;
    address payable nextOwner;
    uint guardiansResetCount;
    uint public constant confirmationsFromGuardiansForReset = 3;

    constructor() {
        owner = payable(msg.sender);
    }

    function proposeNewOwner(address payable newOwner) public {
        require(guardian[msg.sender], "You are no guardian, aborting");
        if(nextOwner != newOwner) {
            nextOwner = newOwner;
            guardiansResetCount = 0;
        }

        guardiansResetCount++;

        if(guardiansResetCount >= confirmationsFromGuardiansForReset) {
            owner = nextOwner;
            nextOwner = payable(address(0));
        }
    }

    function setAllowance(address _from, uint _amount) public {
        require(msg.sender == owner, "You are not the owner, aborting!");
        allowance[_from] = _amount;
        isAllowedToSend[_from] = true;
    }

    function denySending(address _from) public {
        require(msg.sender == owner, "You are not the owner, aborting!");
        isAllowedToSend[_from] = false;
    }

    function transfer(address payable _to, uint _amount, bytes memory payload) public returns (bytes memory) {
        require(_amount <= address(this).balance, "Can't send more than the contract owns, aborting.");
        if(msg.sender != owner) {
            require(isAllowedToSend[msg.sender], "You are not allowed to send any transactions, aborting");
            require(allowance[msg.sender] >= _amount, "You are trying to send more than you are allowed to, aborting");
            allowance[msg.sender] -= _amount;

        }

        (bool success, bytes memory returnData) = _to.call{value: _amount}(payload);
        require(success, "Transaction failed, aborting");
        return returnData;
    }


    function transferToWallet(address payable _to, uint _amount) public {
        require(msg.sender == owner, "You are not the owner, aborting!");
        require(_amount <= address(this).balance, "Can't send more than the contract owns, aborting.");

        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Transfer failed, aborting");
    }

    receive() external payable {}
}
