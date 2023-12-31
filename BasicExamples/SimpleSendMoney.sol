//SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

contract MappingsStructExample {

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function sendMoney() public payable {

    }

    function withdrawAllMoney(address payable _to) public {
        _to.transfer(address(this).balance);
    }
}
