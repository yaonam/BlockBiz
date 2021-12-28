// SPDX-License-Identifier: unlicensed

/// @title Contract that handles business equity using ERC20 standard
/// @author Elim Poon
/// @notice My personal project

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BlockBiz is ERC20{
    /// @dev Still in development

    // // Create struct array to hold shares offered for sale
    // struct Listings {
    //     address shareholder;
    //     uint price;
    // }
    // Listings[] public listings;

    event NewBlockBizCreated(string, uint);

    /// @notice Creates the BlockBiz instance with the company name and initial no. of shares
    constructor(string memory name_, string memory symbol_, uint _initShares) ERC20(name_, symbol_) {
        _mint(msg.sender, _initShares);

        emit NewBlockBizCreated(name_, _initShares);
    }

    //function raiseCapital();
}