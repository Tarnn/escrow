require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config(); // If using .env

module.exports = {
  solidity: {
    compilers: [
      { version: "0.8.0" },  // For Escrow.sol
      { version: "0.8.28" }  // For Lock.sol or others
    ]
  },
  networks: {
    sepolia: {
      url: `https://sepolia.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts: [process.env.PRIVATE_KEY]
    }
  }
};