import { expect } from "chai";
import  hre, { ethers } from 'hardhat';
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";

describe("Token contract", function () {
    async function deployTokenFixture() {
      const [owner, user1, user2, marketing, antiques, gas, trusted] = await ethers.getSigners();
        const Token = await ethers.getContractFactory("TheRareAntiquitiesTokenLtd", owner);
        const token = await Token.deploy(marketing.address, antiques.address, gas.address, trusted.address);
        await token.deployed();
        return { token, owner, user1, user2, marketing, antiques, gas, trusted };
    }

    describe("Deployment", function () {
        it("Should set the right owner", async function () {
            const { token, owner } = await loadFixture(deployTokenFixture);
            expect(await token.owner()).to.equal(owner.address);
        });
    });
});
