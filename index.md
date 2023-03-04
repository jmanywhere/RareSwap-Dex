# Solidity API
This is the current flow of the smart contract.
![Smart Contract Flow](./flow.png "Flow").
## TheRareAntiquitiesTokenLtd

### FEE_ROLE

```solidity
bytes32 FEE_ROLE
```

### WALLET_ROLE

```solidity
bytes32 WALLET_ROLE
```

### LOSSLESS_ROLE

```solidity
bytes32 LOSSLESS_ROLE
```

### MAX_ROLE

```solidity
bytes32 MAX_ROLE
```

### BOT_ROLE

```solidity
bytes32 BOT_ROLE
```

### Log

```solidity
event Log(string, uint256)
```

### AuditLog

```solidity
event AuditLog(string, address)
```

### WETH

```solidity
address WETH
```

### marketingWallet

```solidity
address marketingWallet
```

### antiquitiesWallet

```solidity
address antiquitiesWallet
```

### gasWallet

```solidity
address gasWallet
```

### depWallet

```solidity
address depWallet
```

### botsCantrade

```solidity
bool botsCantrade
```

### canTrade

```solidity
bool canTrade
```

### name

```solidity
string name
```

### symbol

```solidity
string symbol
```

### decimals

```solidity
uint8 decimals
```

### _totalTax

```solidity
uint256 _totalTax
```

### rareSwapRouter

```solidity
contract IRARESwapRouter rareSwapRouter
```

### rareSwapPair

```solidity
address rareSwapPair
```

### _maxTxAmount

```solidity
uint256 _maxTxAmount
```

### _maxWallet

```solidity
uint256 _maxWallet
```

### admin

```solidity
address admin
```

Lossless Compliance

### recoveryAdmin

```solidity
address recoveryAdmin
```

### timelockPeriod

```solidity
uint256 timelockPeriod
```

### losslessTurnOffTimestamp

```solidity
uint256 losslessTurnOffTimestamp
```

### isLosslessOn

```solidity
bool isLosslessOn
```

### lossless

```solidity
contract ILssController lossless
```

### onlyExchange

```solidity
modifier onlyExchange()
```

### constructor

```solidity
constructor(address _marketingWallet, address _antiquitiesWallet, address _gasWallet, address _trustedForwarder, address[] adminRoles) public
```

### setMaxWalletAmount

```solidity
function setMaxWalletAmount(uint256 amount) external
```

set the Maximum amount of tokens that can be held in a wallet

_only owner can call this function, minimum limit is 0.5% of the total supply_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount | uint256 | the amount of tokens in gwei |

### totalSupply

```solidity
function totalSupply() public view returns (uint256)
```

ERC20 implementation of total Circulating supply of the token

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | _tTotal total supply of the token |

### balanceOf

```solidity
function balanceOf(address account) public view returns (uint256)
```

ERC20 implementation of user's balance

_if the address is excluded from reward, it returns the balance of the user without any reflections accounted for_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| account | address | the address of the user to check |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | balance of the user |

### transfer

```solidity
function transfer(address recipient, uint256 amount) public returns (bool)
```

ERC20 implementation of transfer function

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| recipient | address | the address of the recipient |
| amount | uint256 | the amount of tokens to transfer |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | true if the transfer is successful |

### allowance

```solidity
function allowance(address _owner, address spender) public view returns (uint256)
```

ERC20 implementation of allowance function

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _owner | address | the address of the owner |
| spender | address | the address of the spender |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | amount of tokens that the spender is allowed to spend |

### approve

```solidity
function approve(address spender, uint256 amount) public returns (bool)
```

ERC20 implementation of approve function

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| spender | address | the address of the spender |
| amount | uint256 | the amount of tokens to approve |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | true if the approval is successful |

### transferFrom

```solidity
function transferFrom(address sender, address recipient, uint256 amount) public returns (bool)
```

ERC20 implementation of transferFrom function

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| sender | address | the address of the sender |
| recipient | address | the address of the recipient |
| amount | uint256 | the amount of tokens to transfer |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | true if the transfer is successful |

### increaseAllowance

```solidity
function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool)
```

ERC20 implementation of increaseAllowance function

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| spender | address | the address of the spender |
| addedValue | uint256 | the amount of tokens to increase the allowance by |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | true if the increase is successful |

### decreaseAllowance

```solidity
function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool)
```

ERC20 implementation of decreaseAllowance function

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| spender | address | the address of the spender |
| subtractedValue | uint256 | the amount of tokens to decrease the allowance by |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | true if the decrease is successful |

### isExcludedFromReward

```solidity
function isExcludedFromReward(address account) public view returns (bool)
```

function that determines if an address is excluded from reward

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| account | address | the address to check |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | true if the address is excluded from reward |

### totalFees

```solidity
function totalFees() public view returns (uint256)
```

function that returns the amount collected in fees

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | the amount collected in fees |

### deliver

```solidity
function deliver(uint256 tAmount) public
```

this works similar to burn function

_although this function does not reduce the total supply, it reduces the reflection of the sender and the total to be distributed_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tAmount | uint256 | the amount of tokens to deliver |

### reflectionFromToken

```solidity
function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns (uint256)
```

calcualtes the reflection amount from a given token amount

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tAmount | uint256 | the amount of tokens to calculate the reflection amount from |
| deductTransferFee | bool | true if the transfer fee should be deducted |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | the reflection amount |

### tokenFromReflection

```solidity
function tokenFromReflection(uint256 rAmount) public view returns (uint256)
```

calculates the token amount from a given reflection amount

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| rAmount | uint256 | the amount of reflections to calculate the token amount from |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | the token amount |

### excludeFromReward

```solidity
function excludeFromReward(address account) public
```

excludes an address from reward

_this function can only be called by the owner and the variables for excluded amounts are updated_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| account | address | the address to exclude from reward |

### _updatePairsFee

```solidity
function _updatePairsFee(uint256 fee) internal
```

updates the Fees set up in the DEX pairs

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| fee | uint256 | the new fee amount to update |

### excludeFromFee

```solidity
function excludeFromFee(address account) public
```

excludes and address from transfer fees

_this function can only be called by the owner_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| account | address | the address to exclude from transfer fees |

### includeInFee

```solidity
function includeInFee(address account) public
```

includes an address in transfer fees

_this function can only be called by the owner_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| account | address | the address to include in transfer fees |

### setMarketingWallet

```solidity
function setMarketingWallet(address walletAddress) public
```

sets the marketing wallet address

_this function can only be called by the owner_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| walletAddress | address | the address of the new marketing wallet |

### setAntiquitiesWallet

```solidity
function setAntiquitiesWallet(address walletAddress) public
```

sets the antiquities Wallet address

_this function can only be called by the owner_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| walletAddress | address | the address of the new antiquities wallet |

### setGasWallet

```solidity
function setGasWallet(address walletAddress) public
```

sets the gas Wallet address

_this function can only be called by the owner_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| walletAddress | address | the address of the new gas wallet |

### setMaxTxAmount

```solidity
function setMaxTxAmount(uint256 amount) external
```

sets the Maximum transaction token transfer limit

_this function can only be called by the owner, the amount must be greater than 0.5% of the total supply_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount | uint256 | the amount of tokens to set the maximum transaction limit to |

### clearStuckBalance

```solidity
function clearStuckBalance() public
```

sends any stuck ETH balance to the marketing wallet

_No matter who calls this function, it always is allocated to marketing wallet_

### _msgSender

```solidity
function _msgSender() internal view returns (address)
```

implementation of Context msgSender

_this is mostly for the lossless and gasless stuff_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address | the sender of the transaction |

### _msgData

```solidity
function _msgData() internal view returns (bytes)
```

implementation of Context msgData

_this is mostly for the lossless and gasless stuff_

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes | the data of the transaction |

### claimERCtokens

```solidity
function claimERCtokens(contract IERC20 tokenAddress) external
```

claim ERC20 tokens sent to this contract

_no matter who calls this function, funds are always sent to marketing wallet_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenAddress | contract IERC20 | the address of the ERC20 token to claim |

### addBotWallet

```solidity
function addBotWallet(address botwallet) external
```

add a bot wallet to stop from trading and selling

_this function can only be called by the owner_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| botwallet | address | the address of the bot wallet to add |

### removeBotWallet

```solidity
function removeBotWallet(address botwallet) external
```

remove a wallet from being a bot

_this function can only be called by the owner_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| botwallet | address | the address of the bot wallet to remove |

### getBotWalletStatus

```solidity
function getBotWalletStatus(address botwallet) public view returns (bool)
```

check if a wallet is a bot

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| botwallet | address | the address of the bot wallet to check |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | true if the wallet is a bot, false otherwise |

### enableTrading

```solidity
function enableTrading() external
```

Enables trading for the contract

_this function can only be called by the owner and once called, trading cannot be stopped_

### setFees

```solidity
function setFees(uint256 _reflectionTaxBPS, uint256 _marketingTaxBPS, uint256 _antiquitiesTaxBPS, uint256 _gasTaxBPS) public
```

Set the new tax amounts

_this function can only be called by the owner, max totalTax is 15%, marketing + antiquities + gas tax must be over 1%_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _reflectionTaxBPS | uint256 | the amount of tax to be taken for reflections |
| _marketingTaxBPS | uint256 | the amount of tax to be taken for marketing |
| _antiquitiesTaxBPS | uint256 | the amount of tax to be taken for antiquities |
| _gasTaxBPS | uint256 | the amount of tax to be taken for gas |

### receive

```solidity
receive() external payable
```

### isExcludedFromFee

```solidity
function isExcludedFromFee(address account) public view returns (bool)
```

checks the exclusion status of an account

### depositLPFee

```solidity
function depositLPFee(uint256 amount, address token) public
```

transfers tokens from the exchange to the tax receiving wallets

_token is only on ERC20_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| amount | uint256 | the amount of tokens to transfer |
| token | address | the token to transfer |

### lssTransfer

```solidity
modifier lssTransfer(address recipient, uint256 amount)
```

Lossless Compliance

_due to the nature of the implementation of lossless protocol, we need to add the following modifiers to the functions that transfer tokens
these will not be described as they are not part of the RAT token contract but rather the lossless protoco._

### lssTransferFrom

```solidity
modifier lssTransferFrom(address sender, address recipient, uint256 amount)
```

### onlyRecoveryAdmin

```solidity
modifier onlyRecoveryAdmin()
```

### setLosslessController

```solidity
function setLosslessController(address _controller) public
```

Function to set the lossless controller

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _controller | address | Lossless controller address |

### setLosslessAdmin

```solidity
function setLosslessAdmin(address newAdmin) external
```

Function to set the lossless admin that interacts with controller

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newAdmin | address | address of the new admin |

### transferRecoveryAdminOwnership

```solidity
function transferRecoveryAdminOwnership(address candidate, bytes32 keyHash) external
```

Function to propose a new recovery admin

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| candidate | address | new admin proposed address |
| keyHash | bytes32 | Key to accept |

### acceptRecoveryAdminOwnership

```solidity
function acceptRecoveryAdminOwnership(bytes key) external
```

Function to accept the admin proposal

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| key | bytes | Key to accept |

### transferOutBlacklistedFunds

```solidity
function transferOutBlacklistedFunds(address[] from) external
```

Function to retrieve the funds of a blacklisted address.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| from | address[] | Array of addresses corresponding to a report and a second report |

### proposeLosslessTurnOff

```solidity
function proposeLosslessTurnOff() external
```

Function to propose turning off everything related to lossless

### executeLosslessTurnOff

```solidity
function executeLosslessTurnOff() external
```

Function to execute lossless turn off after a period of time

### executeLosslessTurnOn

```solidity
function executeLosslessTurnOn() external
```

Function to turn on everything related to lossless

### getAdmin

```solidity
function getAdmin() external view returns (address)
```

## ILssController

### beforeTransfer

```solidity
function beforeTransfer(address _msgSender, address _recipient, uint256 _amount) external
```

### beforeTransferFrom

```solidity
function beforeTransferFrom(address _msgSender, address _sender, address _recipient, uint256 _amount) external
```

### beforeMint

```solidity
function beforeMint(address _to, uint256 _amount) external
```

### beforeBurn

```solidity
function beforeBurn(address _account, uint256 _amount) external
```

