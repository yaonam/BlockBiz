async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);  
    console.log("Account balance:", (await deployer.getBalance()).toString());
  
    const BlockBiz = await ethers.getContractFactory("BlockBiz");
    const overrides = {
        // gasPrice: Number(1000000000), // One Gwei
        // nonce: 2
    }
    const dBlockBiz = await BlockBiz.deploy("BlockBiz","BB",1000000000,overrides);
  
    console.log("BlockBiz address:", dBlockBiz.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });