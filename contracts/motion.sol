// SPDX-License-Identifier: unlicensed

/// @title Contract that handles motion proposal and voting
/// @author Elim Poon
/// @notice My personal project

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Motion{
    // string private description;
    enum MotionState{ongoing, passed, rejected}
    struct Vote {
        address token;
        uint yay;
        uint nay;
        MotionState state;
    }
    mapping (string => Vote) motions;

    event MotionProposed(string indexed _description);
    event VotesCounted(string indexed _description, uint _yay, uint _nay);
    event MotionPassed(string indexed _description, bool _motionPassed);

    function proposeMotion(string memory _description, address _token) external {
        MotionState state = MotionState.ongoing;
        Vote memory vote = Vote(_token, 0, 0, state);
        motions[_description] = vote;

        emit MotionProposed(_description);
    }
}