# BlockBiz

BlockBiz is a universal token-based voting system. Users can create motions and deposit their tokens to vote. When enough votes are accumulated (1/2 of totalSupply for now), users can close the motion and retrieve their tokens.

## Installation

### Navigate to project directory.

Install OpenZeppelin/contracts

```
npm install @openzeppelin/contracts
```

### [Optional?] For development purposes:

Install Hardhat
```
npm install --save-dev hardhat
```
Instsall Waffle and Chai
```
npm install --save-dev @nomiclabs/hardhat-ethers ethers @nomiclabs/hardhat-waffle ethereum-waffle chai
```

## Usage

```JavaScript
tokenAddr = <Address of ERC20 token>;

// Create a key
key = await hhMotion.createKey(<Name of motion>, tokenAddr);

// Propose the motion
await hhMotion.proposeMotion(key,<Name of motion>,tokenAddr);

// Set allowance of tokens to contract
await hhBlockBiz.approve(hhMotion.address,<Number of votes>);

// Create signed message offchain
msgHash = await hhMotion.getMsgHash(key,true,<Number of votes>,<Nonce>);
signedMsg = await owner.signMessage(ethers.utils.arrayify(msgHash));

// Submit vote
await hhMotion.vote(key,true,<Number of votes>,<Nonce>,signedMsg);

// End motion
await hhMotion.countVote(key);

// Retrieve deposited tokens
await hhMotion.returnTokens(key);
```