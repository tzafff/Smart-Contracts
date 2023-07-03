//SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;


contract WillThrow {
    function aFunction() public pure {
        //require(false, "Error message");
        assert(false);
        //revert NotAllowedError("You are not allowed")
    }
}

contract ErrorHandling {
    event ErrorLogging(string reason);
    event ErrorLogCode(uint code);
    function catchError() public {
        WillThrow will = new WillThrow();
        try will.aFunction() {
            //here we could do something if it works
        }  catch Error(string memory reason) {
            emit ErrorLogging(reason);
        } catch Panic(uint errorCode){
            emit ErrorLogCode(errorCode);
        }
    }
}