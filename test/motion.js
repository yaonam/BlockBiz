const { expect } = require("chai");
const Web3 = require("web3");

describe("Motion contract", function () {
    let shares;
    let tokenAddr;
    let key;
    let staticKey;
    let staticSig;

    before(async function () {
        BlockBiz = await ethers.getContractFactory("BlockBiz");
        Motion = await ethers.getContractFactory("Motion");
        // staticKey = "0xdb5d809640af22006bc130470ec6c0ed7d7e04ec172e748c1d7e4c4eb8cf80c9";
        // staticSig = "0xbb5ffb2ebb33180e3fb53f093ec9ba20fd5720b18b4bba775455045f9e57be61";
    })
    
    beforeEach(async function () {
        // Get the ContractFactory and Signers here.
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

        shares = Number(100);
        hhBlockBiz = await BlockBiz.deploy("Hello", "hi", shares);
        hhBlockBiz2 = await BlockBiz.deploy("Hello", "hi", shares);
        hhMotion = await Motion.deploy();
        tokenAddr = hhBlockBiz.address;

        // // For voting using static vars
        // await hhMotion.proposeMotion(staticKey, "Hello", tokenAddr);
    });
  
    describe("Proposal", function () {
        it("should create a new motion entry using specified token.", async function () {
            key = await hhMotion.createKey("Hello", tokenAddr);
            await hhMotion.proposeMotion(key,"Hello",tokenAddr);

            expect(await hhMotion.getName(key)).to.equal("Hello");
            expect(await hhMotion.getYays(key)).to.equal(0);
            expect(await hhMotion.getNays(key)).to.equal(0);
        });
    });

    // describe("Voting", function () {
    //     it("should update the yays and nays count based on shares deposited by msg.sender.", async function () {
    //         const votes = 75;
    //         await hhBlockBiz.approve(hhMotion.address,votes);
    //         await hhMotion.vote(staticKey,true,votes,staticSig,1);
            
    //         expect(await hhMotion.getYays(staticKey)).to.equal(75);
    //         expect(await hhMotion.getNays(staticKey)).to.equal(0);
    //         expect(await hhBlockBiz.balanceOf(owner.address)).to.equal(25);
    //         expect(await hhBlockBiz.balanceOf(hhMotion.address)).to.equal(75);
    //     })
    //     it("should complete when required votes are reached.", async function () {
    //         const votes = 75;
    //         await hhBlockBiz.approve(hhMotion.address,votes);
    //         await hhMotion.vote(staticKey,true,votes,staticSig,1);
    //         await hhMotion.countVote(staticKey);
            
    //         expect(await hhMotion.isCompleted(staticKey)).to.equal(true);
    //     })
    //     it("should return tokens when motion completed.", async function () {
    //         const votes = 75;
    //         await hhBlockBiz.approve(hhMotion.address,votes);
    //         await hhMotion.vote(staticKey,true,votes,staticSig,1);
    //         await hhMotion.countVote(staticKey);
    //         await hhMotion.returnTokens(staticKey);
            
    //         expect(await hhBlockBiz.balanceOf(owner.address)).to.equal(100);
    //         expect(await hhBlockBiz.balanceOf(hhMotion.address)).to.equal(0);
    //     })
    // })
});