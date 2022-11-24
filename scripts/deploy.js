// This is a script for deploying your contracts. You can adapt it to deploy
// yours, or create new ones.

const path = require("path");

async function main() {
  // This is just a convenience check
  if (network.name === "hardhat") {
    console.warn(
      "You are trying to deploy a contract to the Hardhat Network, which" +
        "gets automatically created and destroyed every time. Use the Hardhat" +
        " option '--network localhost'"
    );
  }

  // ethers is available in the global scope
  const [deployer] = await ethers.getSigners();
  console.log(
    "Deploying the contracts with the account:",
    await deployer.getAddress()
  );

  console.log("Account balance:", (await deployer.getBalance()).toString());

  const Token = await ethers.getContractFactory("TheRareAntiquitiesTokenLtd");
  const token = await Token.deploy("0x2B60d7683d4eD48A93B2cEF198959fFC956Fa452", "0x4CcEE09FDd72c4CbAB6f4D27d2060375B27cD314", "0x1626e068F452B018bC583590E67D6A0E5e8d2b5e", "0xE041608922d06a4F26C0d4c27d8bCD01daf1f792");
  await token.deployed();

  console.log("Token address:", token.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
