require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("@openzeppelin/hardhat-upgrades");

module.exports = {
  defaultNetwork: "testnet",
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545",
    },
    hardhat: {},
    testnet: {
      url: "https://api.harmony.one",
      accounts: [
        `0x1a7ab01d299e0c0933cba7047392d46dcdb4af9749e1fdc6070e9fed5dc27c71`, //owner
      ],
    },
  },
  etherscan: {
    apiKey: "R241G15DMJRXV5F9FEHWT5UJJYI4CPZ3Z3",
  },
  solidity: {
    version: "0.8.13",
    settings: {
      optimizer: {
        enabled: false,
        runs: 200,
      },
    },
  },
};
