// SPDX-License-Identifier: MIT

/// @title Contract that handles business equity using ERC20 standard
/// @author Elim Poon
/// @notice My personal project

pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./safemath.sol";
import "hardhat/console.sol";

contract BlockBiz {
    /// @dev Still in development

    string private companyName;
    uint private companyShares;
    mapping(address => uint) private sharesHeldBy;

    event NewBlockBizCreated(string, uint);

    /// @notice Creates the BlockBiz instance with the company name and initial no. of shares
    constructor(string memory _companyName, uint _initShares) {
        companyName = _companyName;
        companyShares = _initShares;
        sharesHeldBy[msg.sender] = companyShares;

        emit NewBlockBizCreated(_companyName, _initShares);
    }

    /// @return the company's assets (crypto balance)
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function totalSupply() external view returns (uint256) {
        return companyShares;
    }

    /// @return the no. of shares held by shareholder
    function balanceOf(address _shareholder) external view returns (uint256) {
        return sharesHeldBy[_shareholder];
    }

    function transfer(address _recipient, uint256 _shares) external returns (bool) {
        require(sharesHeldBy[msg.sender] >= _shares);

        sharesHeldBy[msg.sender] -= _shares;
        sharesHeldBy[_recipient] += _shares;

        return true;
    }
}