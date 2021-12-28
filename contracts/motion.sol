// SPDX-License-Identifier: unlicensed

/// @title Contract that handles motion proposal and voting
/// @author Elim Poon
/// @notice My personal project

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "hardhat/console.sol";

contract Motion{
    using SafeMath for uint;

    enum MotionState{ongoing, passed, rejected}
    struct MotionInfo {
        string name;
        address tokenAddr;
        uint yays;
        uint nays;
        MotionState state;        
    }

    mapping(bytes32 => MotionInfo) private motions; // Track motions
    mapping(bytes32 => mapping(address => uint)) private voters; // Track voters

    event MotionCreated(bytes32 indexed key);

    function createKey(string memory _name, address _tokenAddr) external view returns (bytes32) {
        return keccak256(abi.encodePacked(block.timestamp,_name,_tokenAddr,msg.sender));
    }

    function proposeMotion(bytes32 _key, string memory _name, address _tokenAddr) external {
        motions[_key] = MotionInfo(_name, _tokenAddr, 0, 0, MotionState.ongoing); // Instantiate motion
        
        emit MotionCreated(_key);
    }

    function vote(bytes32 _key, bool _for, uint _tokens) external {
        MotionInfo storage motionInfo = motions[_key];
        require(motionInfo.state == MotionState.ongoing, "Motion has already been completed");
        ERC20(motionInfo.tokenAddr).transferFrom(msg.sender, address(this), _tokens); // Deposit tokens from voter
        voters[_key][msg.sender] = voters[_key][msg.sender].add(_tokens); // Record tokens deposited

        if (_for) { // Vote yay
            motionInfo.yays = motionInfo.yays.add(_tokens);
        } else { // Vote nay
            motionInfo.nays = motionInfo.nays.add(_tokens);
        }
    }

    function countVote(bytes32 _key) external {
        MotionInfo storage motionInfo = motions[_key];
        require(motionInfo.state == MotionState.ongoing, "Motion has already been completed");
        uint requiredVotes = ERC20(motionInfo.tokenAddr).totalSupply()/2;
        if (motionInfo.yays >= requiredVotes) { // Motion passed
            motionInfo.state = MotionState.passed;
        } else if (motionInfo.nays >= requiredVotes) { // Motion rejected
            motionInfo.state = MotionState.rejected;
        }
    }

    function returnTokens(bytes32 _key) external {
        MotionInfo memory motionInfo = motions[_key];
        require(motionInfo.state != MotionState.ongoing, "Motion still in process");
        ERC20(motionInfo.tokenAddr).transfer(msg.sender, voters[_key][msg.sender]); // Transfer back the tokens
        voters[_key][msg.sender] = 0;
    }
    
    function getName(bytes32 _key) external view returns (string memory) {
        return motions[_key].name;
    }

    function getYays(bytes32 _key) external view returns (uint) {
        return motions[_key].yays;
    }

    function getNays(bytes32 _key) external view returns (uint) {
        return motions[_key].nays;
    }

    function isCompleted(bytes32 _key) external view returns (bool) {
        return (motions[_key].state != MotionState.ongoing);
    }
}