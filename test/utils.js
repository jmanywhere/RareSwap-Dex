const { ethers } = require("hardhat");

const walletC = '0x3f7308ecc28AFFD2698B00F0A0BfAFd6F5eAf0Ab';
const marketingWallet = '0x1626e068F452B018bC583590E67D6A0E5e8d2b5e'
const antiquitiesWallet = '0x4CcEE09FDd72c4CbAB6f4D27d2060375B27cD314'
const gasWallet = '0x1626e068F452B018bC583590E67D6A0E5e8d2b5e'
const rareRouter = '0x027bC3A29990aAED16F65a08C8cc3A92E0AFBAA4'
const weth = '0xae13d989dac2f0debff460ac112a837c89baa7cd'
const forwardWallet = '0xE041608922d06a4F26C0d4c27d8bCD01daf1f792'
const botWallet = '0x51EeAb5b780A6be4537eF76d829CC88E98Bc71e5'
const losslessV2Controller = '0x45dbfe06e2718309ced1d76264c630328B23325f'
const zeroAddress = '0x0000000000000000000000000000000000000000'
const losslessAdmin = '0x4CcEE09FDd72c4CbAB6f4D27d2060375B27cD314'
const keyHash = '0x69111cecadeb2df9a8e26fa95ee9b81606b9d4c9c0b6956fca7204f457ec1d19'
const key = '0x52617265416e746971756974696573546f6b656e41646d696e53656372657432303232'
let rareToken;
let accounts;
let owner, addr1, recoveryAdmin;
let maxWalletAmount = 2500000000

const setupAddresses = async () => {
    accounts = await ethers.getSigners()
    owner = accounts[0];
    addr1 = accounts[1];
    recoveryAdmin = accounts[2];

    return {
        marketingWallet,
        antiquitiesWallet,
        gasWallet,
        owner,
        addr1,
        walletC,
        forwardWallet,
        rareRouter,
        weth,
        maxWalletAmount,
        botWallet,
        losslessV2Controller,
        zeroAddress,
        losslessAdmin,
        recoveryAdmin,
        keyHash,
        key
    }
}

const deployRareToken = async () => {
    const rareContract = await ethers.getContractFactory("TheRareAntiquitiesTokenLtd")
    rareToken = await rareContract.deploy(marketingWallet, antiquitiesWallet, gasWallet, forwardWallet)
    return rareToken
}

const getRareToken = async () => {
    rareToken = await ethers.getContractAt("TheRareAntiquitiesTokenLtd", "0xaba4FfaD92DFB954020A2980CAD8Db9d9066585D")
    return rareToken
}

module.exports = {
    setupAddresses,
    deployRareToken,
    getRareToken,
}