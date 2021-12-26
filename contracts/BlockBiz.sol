/// @title Contract that handles equity ownership
/// @author Elim Poon
/// @notice My personal project

pragma solidity ^0.7.0;

import "hardhat/console.sol";

contract BlockBiz {    
    /// @dev Still in development

    string public companyName;
    mapping(address => uint) sharesHeldBy; 

    constructor(string memory _companyName, uint _initShares) public payable {
        companyName = _companyName;
        sharesHeldBy[msg.sender] = _initShares;
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }
}