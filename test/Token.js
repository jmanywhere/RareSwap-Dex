// This is an example test file. Hardhat will run every *.js file in `test/`,
// so feel free to add new ones.

// Hardhat tests are normally written with Mocha and Chai.

// We import Chai to use its asserting functions here.
const { expect } = require("chai");

// We use `loadFixture` to share common setups (or fixtures) between tests.
// Using this simplifies your tests and makes them run faster, by taking
// advantage or Hardhat Network's snapshot functionality.
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { ethers } = require("hardhat");

const walletC = '0x3f7308ecc28AFFD2698B00F0A0BfAFd6F5eAf0Ab';
const marketingWallet = '0x2B60d7683d4eD48A93B2cEF198959fFC956Fa452'
const antiquitiesWallet = '0x4CcEE09FDd72c4CbAB6f4D27d2060375B27cD314'
const gasWallet = '0x1626e068F452B018bC583590E67D6A0E5e8d2b5e'
let canTrade = false;
let deployed = false;
let rareToken;
let accounts;
let owner, addr1;

function timeout(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
// `describe` is a Mocha function that allows you to organize your tests.
// Having your tests organized makes debugging them easier. All Mocha
// functions are available in the global scope.
//
// `describe` receives the name of a section of your test suite, and a
// callback. The callback must define the tests of that section. This callback
// can't be an async function.
describe("TheRareAntiquitiesTokenLtd contract", function () {
  // We define a fixture to reuse the same setup in every test. We use
  // loadFixture to run this setup once, snapshot that state, and reset Hardhat
  // Network to that snapshot in every test.
  beforeEach(async function () {
    const Token = await ethers.getContractFactory("TheRareAntiquitiesTokenLtd");
    accounts = await ethers.getSigners();
    owner = accounts[0];
    addr1 = accounts[1];
    if (!deployed) {
      rareToken = await Token.deploy("0x2B60d7683d4eD48A93B2cEF198959fFC956Fa452", "0x4CcEE09FDd72c4CbAB6f4D27d2060375B27cD314", "0x1626e068F452B018bC583590E67D6A0E5e8d2b5e");
      await rareToken.deployed();
      deployed = true;
    }

    // rareToken = await ethers.getContractAt("TheRareAntiquitiesTokenLtd", "0xc50D5be3A5c18534ad87b26c414B26839797bDC4");
    canTrade = await rareToken.canTrade();
  });

  // You can nest describe calls to create subsections.
    it("Should set the right owner", async function () {
      expect(await rareToken.owner()).to.equal(owner.address);
    });

    it("Should assign the total supply of tokens to the owner", async function () {
      const ownerBalance = await rareToken.balanceOf(owner.address);
      expect(await rareToken.totalSupply()).to.equal(ownerBalance);
    });

    it("Check the reflection function through transactions", async function () {

      if (!canTrade) {
        await rareToken.EnableTrading({from: owner.address})
      }

      let tAmount = 100000000000000
      let tAmount1 = 10000000000000
     
      // Transfer 100000 tokens from owner to addr1
      await rareToken.transfer(addr1.address, tAmount, {from: owner.address, gasLimit: 210000});
      await timeout(4000)
      const balanceB = await rareToken.balanceOf(addr1.address);
      console.log('balanceB: ', balanceB)
      // Transfer 10000 tokens from addr1 to walletC
      // We use .connect(signer) to send a transaction from another account
      await rareToken.connect(addr1).transfer(walletC, tAmount1, {from: addr1.address, gasLimit: 210000});
      await timeout(3500);

      expect(await rareToken.balanceOf(addr1.address)).to.equal(90000000018000);
    });

    it(`Add liquidity , Check Swap and Fees test.`, async function () {
      const rareSwapInstance = await ethers.getContractAt("IRARESwapRouter", "0x25bFB54D3476bfcee2da42894957e8e52Fed35fD")
      const wethInstance = await ethers.getContractAt("IWETH", "0xae13d989dac2f0debff460ac112a837c89baa7cd")
      // await rareSwapInstance.addLiquidityETH("0x0F6308c4f81716085c07CA68307b0C26e6a043Db", '100000000000000000000', '90000000000000000000', '90000000000000000', owner.address, 1667748824, {value: '100000000000000000'})
      
      const beforeMarketingBalance = (await wethInstance.balanceOf(marketingWallet)).toNumber()
      const beforeAntiquitiesBalance = (await wethInstance.balanceOf(antiquitiesWallet)).toNumber()
      const beforeGasBalance = (await wethInstance.balanceOf(gasWallet)).toNumber()

      await rareSwapInstance.swapTokensForExactETH("100000000000000", "1000000000000000000", ["0x0F6308c4f81716085c07CA68307b0C26e6a043Db","0xae13d989dac2f0debff460ac112a837c89baa7cd"], owner.address, 1667748824)
      await timeout(4000);

      const marketingBalance = (await wethInstance.balanceOf(marketingWallet)).toNumber()
      expect(marketingBalance - beforeMarketingBalance).to.eq(2000000000000)
  
      const antiquitiesBalance = (await wethInstance.balanceOf(antiquitiesWallet)).toNumber()
      expect(antiquitiesBalance - beforeAntiquitiesBalance).to.eq(3000000000000)
  
      const gasBalance = (await wethInstance.balanceOf(gasWallet)).toNumber()
      expect(gasBalance - beforeGasBalance).to.eq(1000000000000)
    });
});
