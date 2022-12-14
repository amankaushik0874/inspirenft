const hre = require("hardhat");
const { ethers, upgrades } = require("hardhat");

// Deploy Proxy Combatible New Contract
async function main() {
  const INFT2 = await hre.ethers.getContractFactory("InspireNFT");
  const lock = await hre.upgrades.deployProxy(
    INFT2,
    { kind: "uups" },
    { initializer: "initialize" }
  );
  console.log("Deployed to: ", lock.address);
}

// Deploy Proxy
// const PROXY = "0xd5dF5BBcDD3467f5F65EEfBd62f8dB182Eb907E5";
// async function main() {
//   const INFT2 = await hre.ethers.getContractFactory("InspireNFT");
//   await hre.upgrades.upgradeProxy(PROXY, INFT2);
//   console.log("Updated");
// }

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
