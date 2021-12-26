/// @title Contract that handles business equity related functions
/// @author Elim Poon
/// @notice My personal project

pragma solidity ^0.8.0;

import "./IERC20.sol";
import "hardhat/console.sol";

contract BlockBiz {
    /// @dev Still in development

    string private companyName;
    mapping(address => uint) private sharesHeldBy;

    event NewBlockBizCreated(string, uint);

    /// @notice Creates the BlockBiz instance with the company name and initial no. of shares
    constructor(string memory _companyName, uint _initShares) {
        companyName = _companyName;
        sharesHeldBy[msg.sender] = _initShares;

        emit NewBlockBizCreated(_companyName, _initShares);
    }

    /// @return the company's assets (crypto balance)
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    /// @return the no. of shares held by msg.sender
    function getSharesHeldBy(address _shareholder) public view returns(uint) {
        return sharesHeldBy[_shareholder];
    }
}