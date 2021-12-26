const { expect } = require("chai");

describe("BlockBiz contract", function () {
  it("should initialize with all shares held by sender.", async function () {
    const [owner, addr1, addr2] = await ethers.getSigners();

    const BlockBiz = await ethers.getContractFactory("BlockBiz");

    const shares = Number(100);

    const hardhatBlockBiz = await BlockBiz.deploy("Hello", shares);

    expect(await hardhatBlockBiz.getBalance()).to.equal(shares);
  });
});