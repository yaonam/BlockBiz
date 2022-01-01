# BlockBiz

BlockBiz is a universal token-based voting system. Users can create motions and deposit their tokens to vote. When enough votes are accumulated (1/2 of totalSupply for now), users can close the motion and retrieve their tokens.

### Rinkeby Testnet Deployment
BlockBiz("BlockBiz", "BB", 1000000000) Address: 0x92F57C4b19D1946d746Df6D00C137781506E8619
### Ropsten Testnet Deployment

BlockBiz("Hello","HI",1000000) Address: 0xefeD3Ba4D7df45D4f3B6cabF0Ba21Aa83b1276C1

BlockBiz("BlockBiz","BB",1000000) Address: 0xCF3542Fd45BDF91d30D266b2a60d90e03cBdDDfB

Motion() Address: 0x547ccbb93bB0C6411Bb56FD5838D4173BA415024

## Installation

### Navigate to project directory.

Install OpenZeppelin/contracts

```
npm install @openzeppelin/contracts
```
Install dotenv
```
npm install dotenv --save
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

```js
// 0. Set variables
// Input token address
tokenAddr = "0x000000000123hello";
// Create name for the motion
name = "Hello";
// Decide number of votes/tokens
votes = 0;
// Record your account nonce (not fully implemented yet)
nonce = 0;

// 1. Create a key (hhMotion is contract abstraction)
key = await hhMotion.createKey(name, tokenAddr);

// 2. Propose the motion
await hhMotion.proposeMotion(key,name,tokenAddr);

// 3. Set allowance of tokens to contract (hhBlockBiz is token abstraction)
await hhBlockBiz.approve(hhMotion.address,votes);

// 4. Create signed message offchain
msgHash = await hhMotion.getMsgHash(key,true,votes,nonce);
signedMsg = await owner.signMessage(ethers.utils.arrayify(msgHash));

// 5. Submit vote
await hhMotion.vote(key,true,votes,nonce,signedMsg);

// 6. End motion
await hhMotion.countVote(key);

// 7. Retrieve deposited tokens
await hhMotion.returnTokens(key);
```

## Local testing

```
// Create local blockchain
npx hardhat node

// Deploy contracts
npx hardhat run --network localhost scripts/deploy.js

// Open console
npx hardhat console --network localhost
```