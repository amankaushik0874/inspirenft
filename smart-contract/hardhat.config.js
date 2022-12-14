require("@nomiclabs/hardhat-waffle");
require("dotenv").config({ path: ".env" });
require("@nomiclabs/hardhat-etherscan");
require("@openzeppelin/hardhat-upgrades");

const ALCHEMY_API_KEY_URL =
  "https://polygon-mumbai.g.alchemy.com/v2/xYH_BwbJrrVxOyOFTeWXM-uVxLAwgRm7";
const GOERLI_API_KEY_URL =
  "https://eth-goerli.g.alchemy.com/v2/bApN3E_MfNWZsFkCZXPjUVRosgfzJRuf";

//Account 2
// const POLYGON_PRIVATE_KEY =
//   "3db95bb42e74c264ff3b959390db82d7e6242e3dc5bb2203406baa9330a5a8e2";
// Account 3
const POLYGON_PRIVATE_KEY =
  "0ecf4b37c5fb21a21a408aa32895abd5d9660feca9a8f061119e16bc6b5f99a0";

const POLYGONSCAN_API_KEY = "VQIIQT7JH36G8G6B1F5TBUWWACZR5QGPR3";
const GOERLI_API_KEY = "UZYB6UD7TDABBSSAFHFXC3VCFU87SSJ7V1";

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
