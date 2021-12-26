// SPDX-License-Identifier: MIT

/// @title Contract that handles business equity using ERC20 standard
/// @author Elim Poon
/// @notice My personal project

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./safemath.sol";
import "hardhat/console.sol";

contract BlockBiz is ERC20 {
    /// @dev Still in development

    string private companyName;
    event NewBlockBizCreated(string, uint);

    /// @notice Creates the BlockBiz instance with the company name and initial no. of shares
    constructor(string memory name_, string memory symbol_, uint _initShares) ERC20(name_, symbol_) {
        companyName = name_;
        _mint(msg.sender, _initShares);

        emit NewBlockBizCreated(name_, _initShares);
    }
}