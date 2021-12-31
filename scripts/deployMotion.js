async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);  
    console.log("Account balance:", (await deployer.getBalance()).toString());
  
    const Motion = await ethers.getContractFactory("Motion");
    const overrides = {
        gasPrice: Number(1500000000), // One Gwei
        // nonce: 4
    }
    const dMotion = await Motion.deploy(overrides);
  
    console.log("Motion deployed at address:", dMotion.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });