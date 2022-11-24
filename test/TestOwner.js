const { expect } = require("chai");
const { ethers } = require("hardhat");
const { setupAddresses, deployRareToken, getRareToken } = require("./utils");

let addrs;
let rareToken;

function increaseTime(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

describe("Test Token Infomation", function () {
  beforeEach(async function () {
    addrs = await setupAddresses();
    rareToken = await deployRareToken();
  });

  describe("Enable Trading", () => {
    describe("when sender is not owner", () => {
      it("should revert", async () => {
        await expect(rareToken.connect(addrs.addr1).EnableTrading()).to.be.revertedWith("Ownable: caller is not the owner")
      })
    })

    describe("when sender is owner", () => {
      it("should succeed", async () => {
        await rareToken.connect(addrs.owner).EnableTrading()
        await increaseTime(3000)
        expect(await rareToken.canTrade()).to.be.equal(true)
      })
    })
  })

  describe("Set Max Wallet Amount", () => {
    describe("when sender is not owner", () => {
      it("should revert", async () => {
        await expect(rareToken.connect(addrs.addr1)._setmaxwalletamount(addrs.maxWalletAmount)).to.be.revertedWith("Ownable: caller is not the owner")
      })
    })

    describe("when sender is owner", () => {
      it("wallet amount should exceed 0.5% of the supply", async () => {
        expect(rareToken.connect(addrs.owner)._setmaxwalletamount(addrs.maxWalletAmount)).to.be.revertedWith("ERR: max wallet amount should exceed 0.5% of the supply")
      })
      it("should succeed", async () => {
        await rareToken.connect(addrs.owner)._setmaxwalletamount((addrs.maxWalletAmount * 2))
        increaseTime(3000)
        expect((await rareToken._maxWallet()) / 1000000000).to.be.equal((addrs.maxWalletAmount * 2))
      })
    })
  })

  describe("Set Max Tx Amount", () => {
    describe("when sender is not owner", () => {
      it("should revert", async () => {
        await expect(rareToken.connect(addrs.addr1).setmaxTxAmount(addrs.maxWalletAmount)).to.be.revertedWith("Ownable: caller is not the owner")
      })
    })

    describe("when sender is owner", () => {
      it("wallet amount should exceed 0.5% of the supply", async () => {
        expect(rareToken.connect(addrs.owner).setmaxTxAmount(addrs.maxWalletAmount)).to.be.revertedWith("ERR: max wallet amount should exceed 0.5% of the supply")
      })
      it("should succeed", async () => {
        await rareToken.connect(addrs.owner).setmaxTxAmount((addrs.maxWalletAmount * 2))
        increaseTime(3000)
        expect((await rareToken._maxTxAmount()) / 1000000000).to.be.equal((addrs.maxWalletAmount * 2))
      })
    })
  })

  describe("Add bot wallet", () => {
    describe("when sender is not owner", () => {
      it("should revert", async () => {
        await expect(rareToken.connect(addrs.addr1).addBotWallet(addrs.botWallet)).to.be.revertedWith("Ownable: caller is not the owner")
      })
    })

    describe("when sender is owner", () => {
      it("should succeed", async () => {
        await rareToken.connect(addrs.owner).addBotWallet(addrs.botWallet)
        await increaseTime(3000)
        expect(await rareToken.getBotWalletStatus(addrs.botWallet)).to.be.equal(true)
      })
    })
  })

  describe("Remove bot wallet", () => {
    describe("when sender is not owner", () => {
      it("should revert", async () => {
        await expect(rareToken.connect(addrs.addr1).removeBotWallet(addrs.botWallet)).to.be.revertedWith("Ownable: caller is not the owner")
      })
    })

    describe("when sender is owner", () => {
      it("should succeed", async () => {
        await rareToken.connect(addrs.owner).removeBotWallet(addrs.botWallet)
        await increaseTime(3000)
        expect(await rareToken.getBotWalletStatus(addrs.botWallet)).to.be.equal(false)
      })
    })
  })

  describe("Exclude From Fee", () => {
    describe("when sender is not owner", () => {
      it("should revert", async () => {
        await expect(rareToken.connect(addrs.addr1).excludeFromFee(addrs.marketingWallet)).to.be.revertedWith("Ownable: caller is not the owner")
      })
    })

    describe("when sender is owner", () => {
      it("should succeed", async () => {
        await rareToken.connect(addrs.owner).excludeFromFee(addrs.marketingWallet)
        await increaseTime(3000)
        expect(await rareToken.isExcludedFromFee(addrs.marketingWallet)).to.be.equal(true)
      })
    })
  })

  describe("Exclude From Reward", () => {
    describe("when sender is not owner", () => {
      it("should revert", async () => {
        await expect(rareToken.connect(addrs.addr1).excludeFromReward(addrs.marketingWallet)).to.be.revertedWith("Ownable: caller is not the owner")
      })
    })

    describe("when sender is owner", () => {
      it("should succeed", async () => {
        await rareToken.connect(addrs.owner).excludeFromReward(addrs.marketingWallet)
        await increaseTime(3000)
        expect(await rareToken.isExcludedFromReward(addrs.marketingWallet)).to.be.equal(true)
      })
    })
  })

  describe("Include In Fee", () => {
    describe("when sender is not owner", () => {
      it("should revert", async () => {
        await expect(rareToken.connect(addrs.addr1).includeInFee(addrs.marketingWallet)).to.be.revertedWith("Ownable: caller is not the owner")
      })
    })

    describe("when sender is owner", () => {
      it("should succeed", async () => {
        await rareToken.connect(addrs.owner).includeInFee(addrs.marketingWallet)
        await increaseTime(3000)
        expect(await rareToken.isExcludedFromFee(addrs.marketingWallet)).to.be.equal(false)
      })
    })
  })

  describe("Include In Reward", () => {
    describe("when sender is not owner", () => {
      it("should revert", async () => {
        await expect(rareToken.connect(addrs.addr1).includeInReward(addrs.marketingWallet)).to.be.revertedWith("Ownable: caller is not the owner")
      })
    })

    describe("when sender is owner", () => {
      it("should revert since account is already excluded", async () => {
        await expect(rareToken.connect(addrs.owner).includeInReward(addrs.marketingWallet)).to.be.revertedWith("Account is already excluded")
      })
    })
  })

  describe("Set Antiquities Wallet", () => {
    describe("when sender is not owner", () => {
      it("should revert", async () => {
        await expect(rareToken.connect(addrs.addr1).setAntiquitiesWallet(addrs.antiquitiesWallet)).to.be.revertedWith("Ownable: caller is not the owner")
      })
    })

    describe("when sender is owner", () => {
      it("should succeed", async () => {
        await rareToken.connect(addrs.owner).setAntiquitiesWallet(addrs.antiquitiesWallet)
        await increaseTime(3000)
        expect(await rareToken.antiquitiesWallet()).to.be.equal(addrs.antiquitiesWallet)
      })
    })
  })

  describe("Set Gas Wallet", () => {
    describe("when sender is not owner", () => {
      it("should revert", async () => {
        await expect(rareToken.connect(addrs.addr1).setGasWallet(addrs.gasWallet)).to.be.revertedWith("Ownable: caller is not the owner")
      })
    })

    describe("when sender is owner", () => {
      it("should succeed", async () => {
        await rareToken.connect(addrs.owner).setGasWallet(addrs.gasWallet)
        await increaseTime(3000)
        expect(await rareToken.gasWallet()).to.be.equal(addrs.gasWallet)
      })
    })
  })

  describe("Set Marketing Wallet", () => {
    describe("when sender is not owner", () => {
      it("should revert", async () => {
        await expect(rareToken.connect(addrs.addr1).setMarketingWallet(addrs.marketingWallet)).to.be.revertedWith("Ownable: caller is not the owner")
      })
    })

    describe("when sender is owner", () => {
      it("should succeed", async () => {
        await rareToken.connect(addrs.owner).setMarketingWallet(addrs.marketingWallet)
        await increaseTime(3000)
        expect(await rareToken.marketingWallet()).to.be.equal(addrs.marketingWallet)
      })
    })
  })
});
