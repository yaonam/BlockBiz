const { expect } = require("chai");

describe("Motion contract", function () {
    let shares;
    let tokenAddr;
    let key;
    let votes;
    let signedMsg;

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
        hhMotion = await Motion.deploy();
        tokenAddr = hhBlockBiz.address;

        // Create motion
        key = await hhMotion.createKey("Hello", tokenAddr);
        await hhMotion.proposeMotion(key,"Hello",tokenAddr);

        // For voting
        votes = 75;
        await hhBlockBiz.approve(hhMotion.address,votes);
        msgHash = await hhMotion.getMsgHash(key,true,75,1);
        signedMsg = await owner.signMessage(ethers.utils.arrayify(msgHash));
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
            await hhMotion.vote(key,true,votes,1,signedMsg);
            
            expect(await hhMotion.getYays(key)).to.equal(75);
            expect(await hhMotion.getNays(key)).to.equal(0);
            expect(await hhBlockBiz.balanceOf(owner.address)).to.equal(25);
            expect(await hhBlockBiz.balanceOf(hhMotion.address)).to.equal(75);
        })
        it("should complete when required votes are reached.", async function () {
            await hhMotion.vote(key,true,votes,1,signedMsg);
            await hhMotion.countVote(key);
            
            expect(await hhMotion.isCompleted(key)).to.equal(true);
        })
        it("should return tokens when motion completed.", async function () {
            await hhMotion.vote(key,true,votes,1,signedMsg);
            await hhMotion.countVote(key);
            await hhMotion.returnTokens(key);
            
            expect(await hhBlockBiz.balanceOf(owner.address)).to.equal(100);
            expect(await hhBlockBiz.balanceOf(hhMotion.address)).to.equal(0);
        })
    })
});