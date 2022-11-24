const { expect } = require("chai");
const { ethers } = require("hardhat");
const { setupAddresses, deployRareToken, getRareToken } = require("./utils");

let addrs;
let rareToken;

function increaseTime(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

describe("Set LossLess", function () {
  beforeEach(async function () {
    addrs = await setupAddresses();
    rareToken = await deployRareToken();
  });

  describe("Set LossLess Controller", () => {
    describe("when sender is not owner", () => {
      it("should revert", async () => {
        await expect(rareToken.connect(addrs.addr1).setLosslessController(addrs.losslessV2Controller)).to.be.revertedWith("Ownable: caller is not the owner")
      })
    })

    describe("when sender is owner", () => {
      it('should revert when setting to zero address', async () => {
          await expect(
            rareToken.connect(addrs.owner).setLosslessController('0x0000000000000000000000000000000000000000'),
          ).to.be.revertedWith('BridgeMintableToken: Controller cannot be zero address.');
        });
      it("should succeed", async () => {
          await rareToken.connect(addrs.owner).setLosslessController(addrs.losslessV2Controller)
          await increaseTime(3000)
          expect(await rareToken.lossless()).to.be.equal(addrs.losslessV2Controller)
      })
    })
  })

  describe("Set LossLess Admin", () => {
    describe("when sender is not owner", () => {
      it("should revert", async () => {
        await expect(rareToken.connect(addrs.addr1).setLosslessAdmin(addrs.losslessAdmin)).to.be.revertedWith("Ownable: caller is not the owner")
      })
    })

    describe("when sender is owner", () => {
      it("should succeed", async () => {
          await rareToken.connect(addrs.owner).setLosslessAdmin(addrs.losslessAdmin)
          await increaseTime(3000)
          expect(await rareToken.admin()).to.be.equal(addrs.losslessAdmin)
      })
    })
  })

  describe("Set Recovery Admin", () => {
    describe("when sender is not owner", () => {
      it("should revert", async () => {

        await expect(rareToken.connect(addrs.addr1).transferRecoveryAdminOwnership(addrs.recoveryAdmin.address, addrs.keyHash)).to.be.revertedWith("Ownable: caller is not the owner")
      })
    })
  
    describe("when sender is owner", () => {
      it("should succeed", async () => {
        await rareToken.connect(addrs.owner).transferRecoveryAdminOwnership(addrs.recoveryAdmin.address, addrs.keyHash);
        increaseTime(3000);
        await rareToken.connect(addrs.recoveryAdmin).acceptRecoveryAdminOwnership(addrs.key);
      })
    })
  })
  
});