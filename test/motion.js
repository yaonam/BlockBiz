const { expect } = require("chai");
// const { ethers } = require("ethers");

describe("Motion contract", function () {
    let shares;

    beforeEach(async function () {
        // Get the ContractFactory and Signers here.
        BlockBiz = await ethers.getContractFactory("BlockBiz");
        Motion = await ethers.getContractFactory("Motion");
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

        shares = Number(100);
        hhBlockBiz = await BlockBiz.deploy("Hello", "hi", shares);
        hhBlockBiz2 = await BlockBiz.deploy("Hello", "hi", shares);
        hhMotion = await Motion.deploy();
    });
  
    describe("Proposal", function () {
        it("should create a new motion entry using specified token.", async function () {
            const tokenAddr = hhBlockBiz.address;
            const key = await hhMotion.createKey("Hello", tokenAddr);
            await hhMotion.proposeMotion(key,"Hello",tokenAddr);

            expect(await hhMotion.getName(key)).to.equal("Hello");
            expect(await hhMotion.getYays(key)).to.equal(0);
            expect(await hhMotion.getNays(key)).to.equal(0);
        });
    });

    describe("Voting", function () {
        it("should update the yays and nays count based on shares deposited by msg.sender.", async function () {
            const tokenAddr = hhBlockBiz.address;
            const key = await hhMotion.createKey("Hello", tokenAddr);
            const votes = 25;
            await hhMotion.proposeMotion(key,"Hello",tokenAddr);
            await hhBlockBiz.approve(hhMotion.address,votes);
            await hhMotion.vote(key,true,votes);
            
            expect(await hhMotion.getYays(key)).to.equal(25);
            expect(await hhMotion.getNays(key)).to.equal(0);
            expect(await hhBlockBiz.balanceOf(owner.address)).to.equal(75);
            expect(await hhBlockBiz.balanceOf(hhMotion.address)).to.equal(25);
        })
    })
});