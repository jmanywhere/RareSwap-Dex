# Hardhat Test

## Environment

### Requirement

Due to the use of Lossless and a Dex, tests have been run utilizing readily available contracts on ETH Mainnet.
**RareSwapFactory:** `0x3c34473c1175A7B4eAa697356d6a6dc2618D273F`
**RareSwapRouter:** `0x027bC3A29990aAED16F65a08C8cc3A92E0AFBAA4`
**LosslessV3Controller:** `0xe91D7cEBcE484070fc70777cB04F7e2EfAe31DB4` (Proxy)

### Config

Run a hardhat network node forking ETH
`npx hardhat node --fork https://eth.public-rpc.com`
Then tests can be run normally:
`npx hardhat test`
