import { expect } from "chai";
import  hre, { ethers } from 'hardhat';
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";


describe("Token contract", function () {
    async function deployTokenFixture() {
      const [owner, user1, user2, user3, marketing, antiques, gas, trusted, recoveryAdmin] = await ethers.getSigners();
        const Token = await ethers.getContractFactory("TheRareAntiquitiesTokenLtd", owner);
        const token = await Token.deploy(marketing.address, antiques.address, gas.address, trusted.address);
        await token.deployed();
        const losslessV2Controller = '0xe91D7cEBcE484070fc70777cB04F7e2EfAe31DB4'
        const losslessAdmin = '0x4CcEE09FDd72c4CbAB6f4D27d2060375B27cD314'
        const keyHash = '0x69111cecadeb2df9a8e26fa95ee9b81606b9d4c9c0b6956fca7204f457ec1d19'
        const key = '0x52617265416e746971756974696573546f6b656e41646d696e53656372657432303232'
        const botWallet = '0x51EeAb5b780A6be4537eF76d829CC88E98Bc71e5'
        const maxAmount = ethers.utils.parseUnits("2500000000", "wei")

        await token.connect(owner).transfer(user1.address, ethers.utils.parseUnits("5000", "gwei"))

        return { token, owner, user1, user2, user3, marketing, antiques, gas, trusted, recoveryAdmin, losslessV2Controller, losslessAdmin, keyHash, key, maxAmount, botWallet };
    }

    describe("Deployment", function () {
        it("Should set the right owner", async function () {
            const { token, owner } = await loadFixture(deployTokenFixture);
            expect(await token.owner()).to.equal(owner.address);
        });
    });

    describe("Set LossLess", function () {
    
      describe("Set LossLess Controller", () => {
        
        describe("when sender is not owner", () => {
          it("should revert", async () => {
            const { token, user1, losslessV2Controller } = await loadFixture(deployTokenFixture);
            await expect(token.connect(user1).setLosslessController(losslessV2Controller)).to.be.revertedWith("Ownable: caller is not the owner")
          })
        })
    
        describe("when sender is owner", () => {
          it('should revert when setting to zero address', async () => {
            const { token, owner } = await loadFixture(deployTokenFixture);
            await expect(
                token.connect(owner).setLosslessController('0x0000000000000000000000000000000000000000'),
              ).to.be.revertedWith('BridgeMintableToken: Controller cannot be zero address.');
            });
          it("should succeed", async () => {
            const { token, owner, losslessV2Controller } = await loadFixture(deployTokenFixture);
            await token.connect(owner).setLosslessController(losslessV2Controller)
              expect(await token.lossless()).to.be.equal(losslessV2Controller)
          })
        })
      })
    
      describe("Set LossLess Admin", () => {

        
        describe("when sender is not owner", () => {
          it("should revert", async () => {
            const { token, losslessAdmin, user1,  } = await loadFixture(deployTokenFixture);
            await expect(token.connect(user1).setLosslessAdmin(losslessAdmin)).to.be.revertedWith("Ownable: caller is not the owner")
          })
        })
    
        describe("when sender is owner", () => {
          it("should succeed", async () => {
            const { token, owner, losslessAdmin } = await loadFixture(deployTokenFixture);
            await token.connect(owner).setLosslessAdmin(losslessAdmin)
              expect(await token.admin()).to.be.equal(losslessAdmin)
          })
        })
      })
    
      describe("Set Recovery Admin", () => {

        describe("when sender is not owner", () => {
          it("should revert", async () => {
            const { token, user1, recoveryAdmin, keyHash } = await loadFixture(deployTokenFixture);
    
            await expect(token.connect(user1).transferRecoveryAdminOwnership(recoveryAdmin.address, keyHash)).to.be.revertedWith("Ownable: caller is not the owner")
          })
        })
      
        describe("when sender is owner", () => {
          it("should succeed", async () => {
            const { token, owner, recoveryAdmin, keyHash, key} = await loadFixture(deployTokenFixture);
            await token.connect(owner).transferRecoveryAdminOwnership(recoveryAdmin.address, keyHash);
            await token.connect(recoveryAdmin).acceptRecoveryAdminOwnership(key);
          })
        })
      })
      
    })

    describe("Token Owner Functions", function () {
    
      describe("Enable Trading", () => {
        describe("when sender is not owner", () => {
          it("should revert", async () => {
            const { token, user1 } = await loadFixture(deployTokenFixture);
            await expect(token.connect(user1).EnableTrading()).to.be.revertedWith("Ownable: caller is not the owner")
          })
        })
    
        describe("when sender is owner", () => {
          it("should succeed", async () => {
            const { token, owner } = await loadFixture(deployTokenFixture);
            await token.connect(owner).EnableTrading()
            expect(await token.canTrade()).to.be.equal(true)
          })
        })
      })
    
      describe("Set Max Wallet Amount", () => {
        describe("when sender is not owner", () => {
          it("should revert", async () => {
            const { token, user1, maxAmount } = await loadFixture(deployTokenFixture);
            await expect(token.connect(user1).setMaxWalletAmount(maxAmount)).to.be.revertedWith("Ownable: caller is not the owner")
          })
        })
    
        describe("when sender is owner", () => {
          it("wallet amount should exceed 0.5% of the supply", async () => {
            const { token, owner, maxAmount } = await loadFixture(deployTokenFixture);
            expect(token.connect(owner).setMaxWalletAmount(maxAmount)).to.be.revertedWith("ERR: max wallet amount should exceed 0.5% of the supply")
          })
          it("should succeed", async () => {
            const { token, owner, maxAmount } = await loadFixture(deployTokenFixture);
            await token.connect(owner).setMaxWalletAmount((maxAmount.mul(2)))
            expect(await token._maxWallet()).to.be.equal(maxAmount.mul(2).mul(10**9))
          })
        })
      })
    
      describe("Set Max Tx Amount", () => {
        describe("when sender is not owner", () => {
          it("should revert", async () => {
            const { token, user1, maxAmount } = await loadFixture(deployTokenFixture);
            await expect(token.connect(user1).setMaxTxAmount(maxAmount)).to.be.revertedWith("Ownable: caller is not the owner")
          })
        })
    
        describe("when sender is owner", () => {
          it("wallet amount should exceed 0.5% of the supply", async () => {
            const { token, owner, maxAmount } = await loadFixture(deployTokenFixture);
            expect(token.connect(owner).setMaxTxAmount(maxAmount)).to.be.revertedWith("ERR: max wallet amount should exceed 0.5% of the supply")
          })
          it("should succeed", async () => {
            const { token, owner, maxAmount } = await loadFixture(deployTokenFixture);
            await token.connect(owner).setMaxTxAmount(maxAmount.mul(2))
            expect(await token._maxTxAmount()).to.be.equal(maxAmount.mul(2).mul(10**9))
          })
        })
      })
    
      describe("Add bot wallet", () => {
        describe("when sender is not owner", () => {
          it("should revert", async () => {
            const { token, user1, botWallet } = await loadFixture(deployTokenFixture);
            await expect(token.connect(user1).addBotWallet(botWallet)).to.be.revertedWith("Ownable: caller is not the owner")
          })
        })
    
        describe("when sender is owner", () => {
          it("should succeed", async () => {
            const { token, owner, botWallet } = await loadFixture(deployTokenFixture);
            await token.connect(owner).addBotWallet(botWallet)
            expect(await token.getBotWalletStatus(botWallet)).to.be.equal(true)
          })
        })
      })
    
      describe("Remove bot wallet", () => {
        describe("when sender is not owner", () => {
          it("should revert", async () => {
            const { token, user1, botWallet } = await loadFixture(deployTokenFixture);
            await expect(token.connect(user1).removeBotWallet(botWallet)).to.be.revertedWith("Ownable: caller is not the owner")
          })
        })
    
        describe("when sender is owner", () => {
          it("should succeed", async () => {
            const { token, owner, botWallet } = await loadFixture(deployTokenFixture);
            await token.connect(owner).removeBotWallet(botWallet)
            expect(await token.getBotWalletStatus(botWallet)).to.be.equal(false)
          })
        })
      })
    
      describe("Exclude From Fee", () => {
        describe("when sender is not owner", () => {
          it("should revert", async () => {
            const { token, user1, user2 } = await loadFixture(deployTokenFixture);
            await expect(token.connect(user1).excludeFromFee(user2.address)).to.be.revertedWith("Ownable: caller is not the owner")
          })
        })
    
        describe("when sender is owner", () => {
          it("should succeed", async () => {
            const { token, owner, user2 } = await loadFixture(deployTokenFixture);
            await token.connect(owner).excludeFromFee(user2.address)
            expect(await token.isExcludedFromFee(user2.address)).to.be.equal(true)
          })
        })
      })
    
      describe("Exclude From Reward", () => {
        describe("when sender is not owner", () => {
          it("should revert", async () => {
            const { token, user1, marketing } = await loadFixture(deployTokenFixture);
            await expect(token.connect(user1).excludeFromReward(marketing.address)).to.be.revertedWith("Ownable: caller is not the owner")
          })
        })
    
        describe("when sender is owner", () => {
          it("should succeed", async () => {
            const { token, owner, marketing } = await loadFixture(deployTokenFixture);
            await token.connect(owner).excludeFromReward(marketing.address)
            expect(await token.isExcludedFromReward(marketing.address)).to.be.equal(true)
          })
        })
      })
    
      describe("Include In Fee", () => {
        describe("when sender is not owner", () => {
          it("should revert", async () => {
            const { token, user1, marketing } = await loadFixture(deployTokenFixture);
            await expect(token.connect(user1).includeInFee(marketing.address)).to.be.revertedWith("Ownable: caller is not the owner")
          })
        })
    
        describe("when sender is owner", () => {
          it("should succeed", async () => {
            const { token, owner, marketing } = await loadFixture(deployTokenFixture);
            await token.connect(owner).includeInFee(marketing.address)
            expect(await token.isExcludedFromFee(marketing.address)).to.be.equal(false)
          })
        })
      })
    
      describe("Set Antiquities Wallet", () => {
        describe("when sender is not owner", () => {
          it("should revert", async () => {
            const { token, user1, antiques } = await loadFixture(deployTokenFixture);
            await expect(token.connect(user1).setAntiquitiesWallet(antiques.address)).to.be.revertedWith("Ownable: caller is not the owner")
          })
        })
    
        describe("when sender is owner", () => {
          it("should succeed", async () => {
            const { token, owner, antiques } = await loadFixture(deployTokenFixture);
            await token.connect(owner).setAntiquitiesWallet(antiques.address)
            expect(await token.antiquitiesWallet()).to.be.equal(antiques.address)
          })
        })
      })
    
      describe("Set Gas Wallet", () => {
        describe("when sender is not owner", () => {
          it("should revert", async () => {
            const { token, user1, gas } = await loadFixture(deployTokenFixture);
            await expect(token.connect(user1).setGasWallet(gas.address)).to.be.revertedWith("Ownable: caller is not the owner")
          })
        })
    
        describe("when sender is owner", () => {
          it("should succeed", async () => {
            const { token, owner, gas } = await loadFixture(deployTokenFixture);
            await token.connect(owner).setGasWallet(gas.address)
            expect(await token.gasWallet()).to.be.equal(gas.address)
          })
        })
      })
    
      describe("Set Marketing Wallet", () => {
        describe("when sender is not owner", () => {
          it("should revert", async () => {
            const { token, user1, marketing } = await loadFixture(deployTokenFixture);
            await expect(token.connect(user1).setMarketingWallet(marketing.address)).to.be.revertedWith("Ownable: caller is not the owner")
          })
        })
    
        describe("when sender is owner", () => {
          it("should succeed", async () => {
            const { token, owner, marketing } = await loadFixture(deployTokenFixture);
            await token.connect(owner).setMarketingWallet(marketing.address)
            expect(await token.marketingWallet()).to.be.equal(marketing.address)
          })
        })
      })
    })
    describe("Token Transactions", () => {
      describe("Transfer", () => {
        let transferAmount = ethers.utils.parseUnits("1000", "gwei")
        let totalTransferred = transferAmount.mul(99).div(100)

        it("should fail if trading is not enabled", async () => {
          const { token, user1, user2 } = await loadFixture(deployTokenFixture);
          await expect(token.connect(user1).transfer(user2.address, transferAmount)).to.be.revertedWith("Trade disabled");
        })

        describe("when sender is excluded from fee", () => {

          it("should succeed", async () => {
            const { token, owner, user1, user2 } = await loadFixture(deployTokenFixture);
            await token.connect(owner).EnableTrading()
            await token.connect(owner).excludeFromFee(user1.address)
            await token.connect(user1).transfer(user2.address, transferAmount)
            expect(await token.balanceOf(user2.address)).to.be.equal(transferAmount)
          })
        })
    
        describe("when sender is not excluded from fee", () => {
          it("should succeed, sender has a bit more due to reflections", async () => {
            const { token, owner, user1, user2 } = await loadFixture(deployTokenFixture);
            await token.connect(owner).EnableTrading()
            await token.connect(user1).transfer(user2.address, transferAmount)
            expect(await token.balanceOf(user1.address)).to.be.greaterThan(transferAmount.mul(4))
            expect(await token.balanceOf(user2.address)).to.be.greaterThan(totalTransferred)
          })
        })
        describe("when sender is excluded from reward", () => {
          it("should succeed to send funds to non excluded and non excluded should have a bit more due to reflections", async () => {
            const { token, owner, user1, user2 } = await loadFixture(deployTokenFixture);
            await token.connect(owner).EnableTrading()
            await token.connect(owner).excludeFromReward(user1.address);
            await token.connect(user1).transfer(user2.address, transferAmount);
            expect(await token.balanceOf(user2.address)).to.be.greaterThan(totalTransferred);
            expect(await token.balanceOf(user1.address)).to.be.equal(transferAmount.mul(4));
          })
          it("should succeed to send funds to excluded", async () => {
            const { token, owner, user1, user2 } = await loadFixture(deployTokenFixture);
            await token.connect(owner).EnableTrading()
            await token.connect(owner).excludeFromReward(user1.address);
            await token.connect(owner).excludeFromReward(user2.address);
            await token.connect(user1).transfer(user2.address, transferAmount);
            expect(await token.balanceOf(user2.address)).to.be.equal(totalTransferred);
            expect(await token.balanceOf(user1.address)).to.be.equal(transferAmount.mul(4));
          })
        })

        describe("when sender is not excluded from reward", () => {
          it("should succeed to send funds to non excluded and both should have a bit more due to reflections", async () => {
            const { token,owner, user1, user2 } = await loadFixture(deployTokenFixture);
            await token.connect(owner).EnableTrading()
            await token.connect(user1).transfer(user2.address, transferAmount);
            expect(await token.balanceOf(user2.address)).to.be.greaterThan(totalTransferred);
            expect(await token.balanceOf(user1.address)).to.be.greaterThan(transferAmount.mul(4));
          })
          it("should succeed to send funds to excluded and non excluded should have a bit more due to reflections", async () => {
            const { token, owner, user1, user2 } = await loadFixture(deployTokenFixture);
            await token.connect(owner).EnableTrading()
            await token.connect(owner).excludeFromReward(user2.address);
            await token.connect(user1).transfer(user2.address, transferAmount);
            expect(await token.balanceOf(user2.address)).to.be.equal(totalTransferred);
            expect(await token.balanceOf(user1.address)).to.be.greaterThan(transferAmount.mul(4));
          })

        })

      })
    })
});
