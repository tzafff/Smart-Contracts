//SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

contract MappingsStructExample {

    struct Transaction {
        uint amount;
        uint timestamp;
    }

    struct Balance {
        uint totalBalance;
        uint numDeposits;
        mapping(uint => Transaction) deposits;
        uint numWithdrawals;
        mapping(uint => Transaction) withdrawals;
    }

    mapping(address => Balance) public balanceReceived;


    function getBalance(address _addr) public view returns(uint) {
        return balanceReceived[_addr].totalBalance;
    }

    function depositMoney() public payable {
        balanceReceived[msg.sender].totalBalance += msg.value;

        Transaction memory deposit = Transaction(msg.value, block.timestamp);
        balanceReceived[msg.sender].deposits[balanceReceived[msg.sender].numDeposits] = deposit;
        balanceReceived[msg.sender].numDeposits++;
    }

    function withdrawMoney(address payable _to, uint _amount) public  payable {
        balanceReceived[msg.sender].totalBalance -= _amount; //reduce the balance by the amount ot withdraw

        //record a new withdrawal
        Transaction memory withdrawal = Transaction(msg.value, block.timestamp);
        balanceReceived[msg.sender].withdrawals[balanceReceived[msg.sender].numWithdrawals] = withdrawal;
        balanceReceived[msg.sender].numWithdrawals++;

        //send the amount out.
        _to.transfer(_amount);

        //Update the _to Balance and num of deposits
        balanceReceived[_to].totalBalance+=_amount;
        balanceReceived[_to].deposits[balanceReceived[_to].numDeposits] = Transaction(_amount, block.timestamp);
        balanceReceived[_to].numDeposits++;
    }
}
