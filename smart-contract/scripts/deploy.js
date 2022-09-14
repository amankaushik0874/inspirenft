const hre = require("hardhat");
const { ethers, upgrades } = require("hardhat");

// Deploy Proxy Combatible New Contract
async function main() {
  const INFT2 = await hre.ethers.getContractFactory("InspireNFT2");
  const lock = await hre.upgrades.deployProxy(
    INFT2,
    { kind: "uups" },
    { initializer: "initialize" }
  );
  console.log("Deployed to: ", lock.address);
}

// Deploy Proxy
// const PROXY = "CONTRACT_ADDRESS_WE_GOT_BEFORE";
// async function main() {
//   const INFT2 = await hre.ethers.getContractFactory("InspireNFT2");
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
