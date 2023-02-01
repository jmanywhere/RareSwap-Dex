const { expect } = require("chai");
const { ethers } = require("hardhat");
const { setupAddresses, deployRareToken, getRareToken } = require("./utils");

let addrs;
let rareToken;
let canTrade;

function increaseTime(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

describe("Test Transactions", function () {
  beforeEach(async function () {
    addrs = await setupAddresses();
    rareToken = await deployRareToken();

    canTrade = await rareToken.canTrade();
    if (!canTrade) {
        await rareToken.connect(addrs.owner).EnableTrading();
    }
  });

  it("Check the reflection function through transactions", async function () {

    let tAmount = 100000000000000
    let tAmount1 = 10000000000000
   
    // Transfer 100000 tokens from owner to addr1
    await rareToken.transfer(addrs.addr1.address, tAmount, {from: addrs.owner.address, gasLimit: 210000});
    await increaseTime(4000)
    const balanceB = await rareToken.balanceOf(addrs.addr1.address);
    console.log('balanceB: ', balanceB)
    // Transfer 10000 tokens from addr1 to walletC
    // We use .connect(signer) to send a transaction from another account
    await rareToken.connect(addrs.addr1).transfer(addrs.walletC, tAmount1, {from: addrs.addr1.address, gasLimit: 210000});
    await increaseTime(3500);

    expect(await rareToken.balanceOf(addrs.addr1.address)).to.equal(90000000018000);
  });

  it(`Add liquidity , Check Swap and Fees test.`, async function () {
    const rareSwapInstance = await ethers.getContractAt("IRARESwapRouter", addrs.rareRouter)
    const wethInstance = await ethers.getContractAt("IWETH", addrs.weth)
    await rareSwapInstance.addLiquidityETH(rareToken.address, '100000000000000000000', '90000000000000000000', '90000000000000000', owner.address, 1679226554, {value: '100000000000000000'})
    
    const beforeMarketingBalance = (await wethInstance.balanceOf(marketingWallet)).toNumber()
    const beforeAntiquitiesBalance = (await wethInstance.balanceOf(antiquitiesWallet)).toNumber()
    const beforeGasBalance = (await wethInstance.balanceOf(gasWallet)).toNumber()

    await rareSwapInstance.swapTokensForExactETH("100000000000000", "1000000000000000000", [rareToken.address,addrs.weth], owner.address, 1679226554)
    await increaseTime(4000);

    const marketingBalance = (await wethInstance.balanceOf(marketingWallet)).toNumber()
    expect(marketingBalance - beforeMarketingBalance).to.eq(2000000000000)

    const antiquitiesBalance = (await wethInstance.balanceOf(antiquitiesWallet)).toNumber()
    expect(antiquitiesBalance - beforeAntiquitiesBalance).to.eq(3000000000000)

    const gasBalance = (await wethInstance.balanceOf(gasWallet)).toNumber()
    expect(gasBalance - beforeGasBalance).to.eq(1000000000000)
  });
})