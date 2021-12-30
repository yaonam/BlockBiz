async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    console.log("Account balance:", (await deployer.getBalance()).toString());
  
    const BlockBiz = await ethers.getContractFactory("BlockBiz");
    const dBlockBiz = await BlockBiz.deploy("Hello","HI",1000000);
  
    console.log("BlockBiz address:", dBlockBiz.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });