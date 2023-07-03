//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;


/*
Deploy the Sender contract
fund the Sender contract with some 100 wei (hit transact to let it go to the receive function)
Deploy the ReceiverNoAction and copy the contract address
Send 10 wei to the ReceiverNoAction wiht withdrawTransfer. It works, because the function receive in ReceiverNoAction doesn't do anything and doesn't use up more than 2300 gas
Send 10 wei to the ReceiverNoAction with withdrawSend. It also works, because the function still does not need more than 2300 gas.
Deploy the ReceiverAction Smart contract and copy the contract address
Send 10 Wei to the ReceiverAction with withdrawTransfer. It fails, because the contract tries to write a storage variable which costs too much gas.
Send 10 Wei to the ReceiverAction with withdrawSend. The transaction doesn't fail, but it also doesn't work, which leaves you now in an odd state. 👈🏻 That's the Problem right here.
*/

contract Sender {
    receive() external payable {}

    function withdrawTransfer(address payable _to) public {
        _to.transfer(10);
    }

    function withdrawSend(address payable _to) public {
        bool sentSuccessful = _to.send(10);
    }
}

contract ReceiverNoAction {

    function balance() public view returns(uint) {
        return address(this).balance;
    }

    receive() external payable {}
}

contract ReceiverAction {
    uint public balanceReceived;

    function balance() public view returns(uint) {
        return address(this).balance;
    }

    receive() external payable {
        balanceReceived += msg.value;
    }
}
