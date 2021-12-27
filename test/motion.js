const { expect } = require("chai");
// const { ethers } = require("ethers");

describe("Motion contract", function () {
    let shares;
    let tokenAddr;
    let key;

    before(async function () {
        BlockBiz = await ethers.getContractFactory("BlockBiz");
        Motion = await ethers.getContractFactory("Motion");
    })
    
    beforeEach(async function () {
        // Get the ContractFactory and Signers here.
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

        shares = Number(100);
        hhBlockBiz = await BlockBiz.deploy("Hello", "hi", shares);
        hhBlockBiz2 = await BlockBiz.deploy("Hello", "hi", shares);
        hhMotion = await Motion.deploy();
        
        tokenAddr = hhBlockBiz.address;
        key = await hhMotion.createKey("Hello", tokenAddr);
        await hhMotion.proposeMotion(key,"Hello",tokenAddr);
    });
  
    describe("Proposal", function () {
        it("should create a new motion entry using specified token.", async function () {
            expect(await hhMotion.getName(key)).to.equal("Hello");
            expect(await hhMotion.getYays(key)).to.equal(0);
            expect(await hhMotion.getNays(key)).to.equal(0);
        });
    });

    describe("Voting", function () {
        it("should update the yays and nays count based on shares deposited by msg.sender.", async function () {
            const votes = 25;
            await hhBlockBiz.approve(hhMotion.address,votes);
            await hhMotion.vote(key,true,votes);
            
            expect(await hhMotion.getYays(key)).to.equal(25);
            expect(await hhMotion.getNays(key)).to.equal(0);
            expect(await hhBlockBiz.balanceOf(owner.address)).to.equal(75);
            expect(await hhBlockBiz.balanceOf(hhMotion.address)).to.equal(25);
        })
        it("should complete when required votes are reached.", async function () {
            const votes = 75;
            await hhBlockBiz.approve(hhMotion.address,votes);
            await hhMotion.vote(key,true,votes);
            await hhMotion.countVote(key);
            
            expect(await hhMotion.isCompleted(key)).to.equal(true);
        })
        it("should return tokens when motion completed.", async function () {
            const votes = 75;
            await hhBlockBiz.approve(hhMotion.address,votes);
            await hhMotion.vote(key,true,votes);
            await hhMotion.countVote(key);
            await hhMotion.returnTokens(key);
            
            expect(await hhBlockBiz.balanceOf(owner.address)).to.equal(100);
            expect(await hhBlockBiz.balanceOf(hhMotion.address)).to.equal(0);
        })
    })
});