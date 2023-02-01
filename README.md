# Hardhat Test

## Environment

### Requirement

Due to the use of Lossless and a Dex, tests have been run utilizing readily available contracts on BSC Mainnet.
**RareSwapRouter:** 0x027bC3A29990aAED16F65a08C8cc3A92E0AFBAA4
**Lossless:** 0xDBB5125CEEaf7233768c84A5dF570AeECF0b4634
RareSwapRouter is hardcoded

### Config

Run a hardhat network node forking BSC
`npx hardhat node --fork https://bscrpc.com`
Then tests can be run normally:
`npx hardhat test`
