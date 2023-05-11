require("@nomiclabs/hardhat-waffle");
require("dotenv").config({ path: ".env" });
require("@nomiclabs/hardhat-etherscan");
require("@openzeppelin/hardhat-upgrades");

module.exports = {
  solidity: {
    version: "0.8.4",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    hardhat: {},
    mumbai: {
      url: ALCHEMY_API_KEY_URL,
      accounts: [`0x${POLYGON_PRIVATE_KEY}`],
    },
    goerli: {
      url: GOERLI_API_KEY_URL,
      accounts: [`0x${POLYGON_PRIVATE_KEY}`],
    },
  },
  etherscan: {
    apiKey: POLYGONSCAN_API_KEY,
    // apiKey: GOERLI_API_KEY,
  },
};
