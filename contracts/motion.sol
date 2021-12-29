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
    mapping(bytes32 => mapping(address => uint)) private voters; // Track voters and deposited tokens

    event MotionCreated(bytes32 indexed key);

    function createKey(string memory _name, address _tokenAddr) external view returns (bytes32) {
        return keccak256(abi.encodePacked(block.timestamp,_name,_tokenAddr,msg.sender));
    }

    function proposeMotion(bytes32 _key, string memory _name, address _tokenAddr) external {
        motions[_key] = MotionInfo(_name, _tokenAddr, 0, 0, MotionState.ongoing); // Instantiate motion
        
        emit MotionCreated(_key);
    }

    function getSignedMsgHash(
        bytes32 _key, 
        bool _for, 
        uint _tokens, 
        uint _nonce
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(
            "\x19Ethereum Signed Message:\n32",
            keccak256(abi.encodePacked(_key, _for, _tokens, _nonce))));
    }

    function vote(bytes32 _key, bool _for, uint _tokens, bytes memory signature, uint _nonce) external {
        MotionInfo storage motionInfo = motions[_key];
        require(motionInfo.state == MotionState.ongoing, "Motion: Motion has already been completed");
        require(verify(msg.sender, _key, _for, _tokens, _nonce, signature), "Motion: Invalid signature");
        
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
        require(motionInfo.state == MotionState.ongoing, "Motion: Motion has already been completed");
        
        uint requiredVotes = ERC20(motionInfo.tokenAddr).totalSupply()/2;
        if (motionInfo.yays >= requiredVotes) { // Motion passed
            motionInfo.state = MotionState.passed;
        } else if (motionInfo.nays >= requiredVotes) { // Motion rejected
            motionInfo.state = MotionState.rejected;
        }
    }

    function returnTokens(bytes32 _key) external {
        MotionInfo memory motionInfo = motions[_key];
        require(motionInfo.state != MotionState.ongoing, "Motion: Motion still in process");
        
        ERC20(motionInfo.tokenAddr).transfer(msg.sender, voters[_key][msg.sender]); // Transfer back the tokens
        voters[_key][msg.sender] = 0;
    }

    function verify(
        address _signer,
        bytes32 _key,
        bool _for,
        uint _tokens,
        uint _nonce,
        bytes memory signature
    ) internal pure returns (bool) {
        bytes32 ethSignedMessageHash = getSignedMsgHash(_key, _for, _tokens, _nonce);

        return recoverSigner(ethSignedMessageHash, signature) == _signer;
    }

    function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature) internal pure returns (address) {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);

        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function splitSignature(bytes memory sig) internal pure
        returns (
            bytes32 r,
            bytes32 s,
            uint8 v
        )
    {
        require(sig.length == 65, "invalid signature length");

        assembly {
            /*
            First 32 bytes stores the length of the signature

            add(sig, 32) = pointer of sig + 32
            effectively, skips first 32 bytes of signature

            mload(p) loads next 32 bytes starting at the memory address p into memory
            */

            // first 32 bytes, after the length prefix
            r := mload(add(sig, 32))
            // second 32 bytes
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }

        // implicitly return (r, s, v)
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