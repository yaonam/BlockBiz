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
            const key = (await hhMotion.proposeMotion("Hello", tokenAddr)).hash;
            console.log(key);
            expect(await hhMotion.getYays(key)).to.equal(0);
        });

    });
});