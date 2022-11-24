require("@nomicfoundation/hardhat-toolbox");
require('hardhat-contract-sizer');

// The next line is part of the sample project, you don't need it in your
// project. It imports a Hardhat task definition, that can be used for
// testing the frontend.
// require("./tasks/faucet");
const dotenv = require("dotenv")

dotenv.config();

const privateKeys = process.env.PRIVATE_KEY.split(" ") ;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    compilers: [
      {
        version: '0.8.9',
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
          evmVersion: 'berlin',
        },
      },
    ],
  },
  networks: {
    hardhat: {
      chainId: 1337 // We set 1337 to make interacting with MetaMask simpler
    },
    goerli: {
      url: "https://rpc.ankr.com/eth_goerli",
      chainId: 5,
      accounts: privateKeys,
      gas: "auto",
    },
    testnet: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545",
      chainId: 97,
      accounts: privateKeys,
    }
  },
};
