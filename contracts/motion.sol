// SPDX-License-Identifier: unlicensed

/// @title Contract that handles motion proposal and voting
/// @author Elim Poon
/// @notice My personal project

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Motion{
    // string private description;
    enum MotionState{ongoing, passed, rejected}
    struct MotionInfo {
        string name;
        ERC20 votingToken;
        uint yays;
        uint nays;
        MotionState state;
    }

    mapping (bytes32 => MotionInfo) private motions;

    event MotionProposed(string indexed _name, bytes32 indexed key);

    function proposeMotion(string memory _name, address _token) external returns (bytes32){
        bytes32 key = keccak256(abi.encodePacked(block.timestamp, _name, msg.sender)); // Create key for motion identification
        motions[key] = MotionInfo(_name, ERC20(_token), 0, 0, MotionState.ongoing); // Instatiate motion

        emit MotionProposed(_name, key);
        return key;
    }

    // function getMotionInfo(uint _key) external view returns (MotionInfo memory){
    //     return motions[_key];
    // }

    function getYays(bytes32 _key) external view returns (uint) {
        return motions[_key].yays;
    }

    // function getNays(uint _key) external view returns (uint) {
    //     return motions[_key].nays;
    // }

    function vote(bytes32 _key, bool _for) external payable {
        if (_for) { // Vote yay
            motions[_key].yays += 1;
        } else { // Vote nay
            motions[_key].nays += 1;
        }
    }
}