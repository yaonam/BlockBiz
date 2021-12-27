const { expect } = require("chai");

describe("BlockBiz contract", function () {
    let shares;

    beforeEach(async function () {
        // Get the ContractFactory and Signers here.
        BlockBiz = await ethers.getContractFactory("BlockBiz");
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

        shares = Number(100);
        hhBlockBiz = await BlockBiz.deploy("Hello", "hi", shares);
    });
  
    describe("Deployment", function () {

        it("should initialize with all shares held by sender.", async function () {
            expect(await hhBlockBiz.balanceOf(owner.address)).to.equal(shares);
        });

    });

    describe("Transactions", function () {
        it("should successfully transfer between accounts.", async function () {
            await hhBlockBiz.transfer(addr1.address, 50);
            expect(await hhBlockBiz.balanceOf(owner.address)).to.equal(50);
            expect(await hhBlockBiz.balanceOf(addr1.address)).to.equal(shares-50);
        });
    });
});