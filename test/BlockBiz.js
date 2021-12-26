const { expect } = require("chai");

describe("Token contract", function () {
  it("Deployment should assign the total supply of tokens to the owner", async function () {
    const [owner, addr1, addr2] = await ethers.getSigners();

    const BlockBiz = await ethers.getContractFactory("BlockBiz");

    const hardhatBlockBiz = await BlockBiz.deploy();

    const ownerBalance = await hardhatBlockBiz.getBalance(owner.address);
  });
});