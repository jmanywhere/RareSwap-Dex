# Solidity API

## ERC2771Context

_Context variant with ERC2771 support._

### constructor

```solidity
constructor(address trustedForwarder) internal
```

### isTrustedForwarder

```solidity
function isTrustedForwarder(address forwarder) public view virtual returns (bool)
```

### _msgSender

```solidity
function _msgSender() internal view virtual returns (address sender)
```

### _msgData

```solidity
function _msgData() internal view virtual returns (bytes)
```

## IERC20

### Approval

```solidity
event Approval(address owner, address spender, uint256 value)
```

### Transfer

```solidity
event Transfer(address from, address to, uint256 value)
```

### name

```solidity
function name() external view returns (string)
```

### symbol

```solidity
function symbol() external view returns (string)
```

### decimals

```solidity
function decimals() external view returns (uint8)
```

### totalSupply

```solidity
function totalSupply() external view returns (uint256)
```

### balanceOf

```solidity
function balanceOf(address owner) external view returns (uint256)
```

### allowance

```solidity
function allowance(address owner, address spender) external view returns (uint256)
```

### approve

```solidity
function approve(address spender, uint256 value) external returns (bool)
```

### transfer

```solidity
function transfer(address to, uint256 value) external returns (bool)
```

### transferFrom

```solidity
function transferFrom(address from, address to, uint256 value) external returns (bool)
```

## IWETH

### balanceOf

```solidity
function balanceOf(address owner) external view returns (uint256)
```

### allowance

```solidity
function allowance(address owner, address spender) external view returns (uint256)
```

### deposit

```solidity
function deposit() external payable
```

### transfer

```solidity
function transfer(address to, uint256 value) external returns (bool)
```

### withdraw

```solidity
function withdraw(uint256) external
```

## Address

_Collection of functions related to the address type_

### isContract

```solidity
function isContract(address account) internal view returns (bool)
```

_Returns true if `account` is a contract.

[IMPORTANT]
====
It is unsafe to assume that an address for which this function returns
false is an externally-owned account (EOA) and not a contract.

Among others, `isContract` will return false for the following
types of addresses:

 - an externally-owned account
 - a contract in construction
 - an address where a contract will be created
 - an address where a contract lived, but was destroyed

Furthermore, `isContract` will also return true if the target contract within
the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
which only has an effect at the end of a transaction.
====

[IMPORTANT]
====
You shouldn't rely on `isContract` to protect against flash loan attacks!

Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
constructor.
====_

### sendValue

```solidity
function sendValue(address payable recipient, uint256 amount) internal
```

_Replacement for Solidity's `transfer`: sends `amount` wei to
`recipient`, forwarding all available gas and reverting on errors.

https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
of certain opcodes, possibly making contracts go over the 2300 gas limit
imposed by `transfer`, making them unable to receive funds via
`transfer`. {sendValue} removes this limitation.

https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].

IMPORTANT: because control is transferred to `recipient`, care must be
taken to not create reentrancy vulnerabilities. Consider using
{ReentrancyGuard} or the
https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern]._

### functionCall

```solidity
function functionCall(address target, bytes data) internal returns (bytes)
```

_Performs a Solidity function call using a low level `call`. A
plain `call` is an unsafe replacement for a function call: use this
function instead.

If `target` reverts with a revert reason, it is bubbled up by this
function (like regular Solidity function calls).

Returns the raw returned data. To convert to the expected return value,
use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].

Requirements:

- `target` must be a contract.
- calling `target` with `data` must not revert.

_Available since v3.1.__

### functionCall

```solidity
function functionCall(address target, bytes data, string errorMessage) internal returns (bytes)
```

_Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
`errorMessage` as a fallback revert reason when `target` reverts.

_Available since v3.1.__

### functionCallWithValue

```solidity
function functionCallWithValue(address target, bytes data, uint256 value) internal returns (bytes)
```

_Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
but also transferring `value` wei to `target`.

Requirements:

- the calling contract must have an ETH balance of at least `value`.
- the called Solidity function must be `payable`.

_Available since v3.1.__

### functionCallWithValue

```solidity
function functionCallWithValue(address target, bytes data, uint256 value, string errorMessage) internal returns (bytes)
```

_Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
with `errorMessage` as a fallback revert reason when `target` reverts.

_Available since v3.1.__

### functionStaticCall

```solidity
function functionStaticCall(address target, bytes data) internal view returns (bytes)
```

_Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
but performing a static call.

_Available since v3.3.__

### functionStaticCall

```solidity
function functionStaticCall(address target, bytes data, string errorMessage) internal view returns (bytes)
```

_Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
but performing a static call.

_Available since v3.3.__

### functionDelegateCall

```solidity
function functionDelegateCall(address target, bytes data) internal returns (bytes)
```

_Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
but performing a delegate call.

_Available since v3.4.__

### functionDelegateCall

```solidity
function functionDelegateCall(address target, bytes data, string errorMessage) internal returns (bytes)
```

_Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
but performing a delegate call.

_Available since v3.4.__

### verifyCallResultFromTarget

```solidity
function verifyCallResultFromTarget(address target, bool success, bytes returndata, string errorMessage) internal view returns (bytes)
```

_Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.

_Available since v4.8.__

### verifyCallResult

```solidity
function verifyCallResult(bool success, bytes returndata, string errorMessage) internal pure returns (bytes)
```

_Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
revert reason or using the provided one.

_Available since v4.3.__

## Ownable

### OwnershipTransferred

```solidity
event OwnershipTransferred(address previousOwner, address newOwner)
```

### constructor

```solidity
constructor() public
```

_Initializes the contract setting the deployer as the initial owner._

### owner

```solidity
function owner() public view returns (address)
```

_Returns the address of the current owner._

### onlyOwner

```solidity
modifier onlyOwner()
```

_Throws if called by any account other than the owner._

### renounceOwnership

```solidity
function renounceOwnership() public virtual
```

_Leaves the contract without owner. It will not be possible to call
`onlyOwner` functions anymore. Can only be called by the current owner.

NOTE: Renouncing ownership will leave the contract without an owner,
thereby removing any functionality that is only available to the owner._

### transferOwnership

```solidity
function transferOwnership(address newOwner) public virtual
```

_Transfers ownership of the contract to a new account (`newOwner`).
Can only be called by the current owner._

## IRARESwapFactory

### PairCreated

```solidity
event PairCreated(address token0, address token1, address pair, uint256)
```

### feeTo

```solidity
function feeTo() external view returns (address)
```

### feeToSetter

```solidity
function feeToSetter() external view returns (address)
```

### getPair

```solidity
function getPair(address tokenA, address tokenB) external view returns (address pair)
```

### allPairs

```solidity
function allPairs(uint256) external view returns (address pair)
```

### allPairsLength

```solidity
function allPairsLength() external view returns (uint256)
```

### pairExist

```solidity
function pairExist(address pair) external view returns (bool)
```

### createPair

```solidity
function createPair(address tokenA, address tokenB) external returns (address pair)
```

### setFeeTo

```solidity
function setFeeTo(address) external
```

### setFeeToSetter

```solidity
function setFeeToSetter(address) external
```

### routerInitialize

```solidity
function routerInitialize(address) external
```

### routerAddress

```solidity
function routerAddress() external view returns (address)
```

## IRARESwapPair

### Approval

```solidity
event Approval(address owner, address spender, uint256 value)
```

### Transfer

```solidity
event Transfer(address from, address to, uint256 value)
```

### baseToken

```solidity
function baseToken() external view returns (address)
```

### getTotalFee

```solidity
function getTotalFee() external view returns (uint256)
```

### name

```solidity
function name() external pure returns (string)
```

### symbol

```solidity
function symbol() external pure returns (string)
```

### decimals

```solidity
function decimals() external pure returns (uint8)
```

### totalSupply

```solidity
function totalSupply() external view returns (uint256)
```

### balanceOf

```solidity
function balanceOf(address owner) external view returns (uint256)
```

### allowance

```solidity
function allowance(address owner, address spender) external view returns (uint256)
```

### updateTotalFee

```solidity
function updateTotalFee(uint256 totalFee) external returns (bool)
```

### approve

```solidity
function approve(address spender, uint256 value) external returns (bool)
```

### transfer

```solidity
function transfer(address to, uint256 value) external returns (bool)
```

### transferFrom

```solidity
function transferFrom(address from, address to, uint256 value) external returns (bool)
```

### DOMAIN_SEPARATOR

```solidity
function DOMAIN_SEPARATOR() external view returns (bytes32)
```

### PERMIT_TYPEHASH

```solidity
function PERMIT_TYPEHASH() external pure returns (bytes32)
```

### nonces

```solidity
function nonces(address owner) external view returns (uint256)
```

### permit

```solidity
function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external
```

### Mint

```solidity
event Mint(address sender, uint256 amount0, uint256 amount1)
```

### Burn

```solidity
event Burn(address sender, uint256 amount0, uint256 amount1, address to)
```

### Swap

```solidity
event Swap(address sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address to)
```

### Sync

```solidity
event Sync(uint112 reserve0, uint112 reserve1)
```

### MINIMUM_LIQUIDITY

```solidity
function MINIMUM_LIQUIDITY() external pure returns (uint256)
```

### factory

```solidity
function factory() external view returns (address)
```

### token0

```solidity
function token0() external view returns (address)
```

### token1

```solidity
function token1() external view returns (address)
```

### getReserves

```solidity
function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast, address _baseToken)
```

### price0CumulativeLast

```solidity
function price0CumulativeLast() external view returns (uint256)
```

### price1CumulativeLast

```solidity
function price1CumulativeLast() external view returns (uint256)
```

### kLast

```solidity
function kLast() external view returns (uint256)
```

### mint

```solidity
function mint(address to) external returns (uint256 liquidity)
```

### burn

```solidity
function burn(address to) external returns (uint256 amount0, uint256 amount1)
```

### swap

```solidity
function swap(uint256 amount0Out, uint256 amount1Out, uint256 amount0Fee, uint256 amount1Fee, address to, bytes data) external
```

### skim

```solidity
function skim(address to) external
```

### sync

```solidity
function sync() external
```

### initialize

```solidity
function initialize(address, address) external
```

### setBaseToken

```solidity
function setBaseToken(address _baseToken) external
```

## IRARESwapRouter01

### factory

```solidity
function factory() external pure returns (address)
```

### WETH

```solidity
function WETH() external pure returns (address)
```

### addLiquidity

```solidity
function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB, uint256 liquidity)
```

### addLiquidityETH

```solidity
function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity)
```

### removeLiquidity

```solidity
function removeLiquidity(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB)
```

### removeLiquidityETH

```solidity
function removeLiquidityETH(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns (uint256 amountToken, uint256 amountETH)
```

### removeLiquidityWithPermit

```solidity
function removeLiquidityWithPermit(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountA, uint256 amountB)
```

### removeLiquidityETHWithPermit

```solidity
function removeLiquidityETHWithPermit(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountToken, uint256 amountETH)
```

### swapExactTokensForTokens

```solidity
function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) external returns (uint256[] amounts)
```

### swapTokensForExactTokens

```solidity
function swapTokensForExactTokens(uint256 amountOut, uint256 amountInMax, address[] path, address to, uint256 deadline) external returns (uint256[] amounts)
```

### swapExactETHForTokens

```solidity
function swapExactETHForTokens(uint256 amountOutMin, address[] path, address to, uint256 deadline) external payable returns (uint256[] amounts)
```

### swapTokensForExactETH

```solidity
function swapTokensForExactETH(uint256 amountOut, uint256 amountInMax, address[] path, address to, uint256 deadline) external returns (uint256[] amounts)
```

### swapExactTokensForETH

```solidity
function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) external returns (uint256[] amounts)
```

### swapETHForExactTokens

```solidity
function swapETHForExactTokens(uint256 amountOut, address[] path, address to, uint256 deadline) external payable returns (uint256[] amounts)
```

### quote

```solidity
function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external pure returns (uint256 amountB)
```

### getAmountOut

```solidity
function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountOut)
```

### getAmountIn

```solidity
function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountIn)
```

### getAmountsOut

```solidity
function getAmountsOut(uint256 amountIn, address[] path) external view returns (uint256[] amounts)
```

### getAmountsIn

```solidity
function getAmountsIn(uint256 amountOut, address[] path) external view returns (uint256[] amounts)
```

## IRARESwapRouter

### removeLiquidityETHSupportingFeeOnTransferTokens

```solidity
function removeLiquidityETHSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns (uint256 amountETH)
```

### removeLiquidityETHWithPermitSupportingFeeOnTransferTokens

```solidity
function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountETH)
```

### swapExactTokensForTokensSupportingFeeOnTransferTokens

```solidity
function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) external
```

### swapExactETHForTokensSupportingFeeOnTransferTokens

```solidity
function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin, address[] path, address to, uint256 deadline) external payable
```

### swapExactTokensForETHSupportingFeeOnTransferTokens

```solidity
function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) external
```

### pairFeeAddress

```solidity
function pairFeeAddress(address pair) external view returns (address)
```

### adminFee

```solidity
function adminFee() external view returns (uint256)
```

### feeAddressGet

```solidity
function feeAddressGet() external view returns (address)
```

## ILERC20

### name

```solidity
function name() external view returns (string)
```

### admin

```solidity
function admin() external view returns (address)
```

### getAdmin

```solidity
function getAdmin() external view returns (address)
```

### symbol

```solidity
function symbol() external view returns (string)
```

### decimals

```solidity
function decimals() external view returns (uint8)
```

### totalSupply

```solidity
function totalSupply() external view returns (uint256)
```

### balanceOf

```solidity
function balanceOf(address _account) external view returns (uint256)
```

### transfer

```solidity
function transfer(address _recipient, uint256 _amount) external returns (bool)
```

### allowance

```solidity
function allowance(address _owner, address _spender) external view returns (uint256)
```

### approve

```solidity
function approve(address _spender, uint256 _amount) external returns (bool)
```

### transferFrom

```solidity
function transferFrom(address _sender, address _recipient, uint256 _amount) external returns (bool)
```

### increaseAllowance

```solidity
function increaseAllowance(address _spender, uint256 _addedValue) external returns (bool)
```

### decreaseAllowance

```solidity
function decreaseAllowance(address _spender, uint256 _subtractedValue) external returns (bool)
```

### transferOutBlacklistedFunds

```solidity
function transferOutBlacklistedFunds(address[] _from) external
```

### setLosslessAdmin

```solidity
function setLosslessAdmin(address _newAdmin) external
```

### transferRecoveryAdminOwnership

```solidity
function transferRecoveryAdminOwnership(address _candidate, bytes32 _keyHash) external
```

### acceptRecoveryAdminOwnership

```solidity
function acceptRecoveryAdminOwnership(bytes _key) external
```

### proposeLosslessTurnOff

```solidity
function proposeLosslessTurnOff() external
```

### executeLosslessTurnOff

```solidity
function executeLosslessTurnOff() external
```

### executeLosslessTurnOn

```solidity
function executeLosslessTurnOn() external
```

### Transfer

```solidity
event Transfer(address _from, address _to, uint256 _value)
```

### Approval

```solidity
event Approval(address _owner, address _spender, uint256 _value)
```

### NewAdmin

```solidity
event NewAdmin(address _newAdmin)
```

### NewRecoveryAdminProposal

```solidity
event NewRecoveryAdminProposal(address _candidate)
```

### NewRecoveryAdmin

```solidity
event NewRecoveryAdmin(address _newAdmin)
```

### LosslessTurnOffProposal

```solidity
event LosslessTurnOffProposal(uint256 _turnOffDate)
```

### LosslessOff

```solidity
event LosslessOff()
```

### LosslessOn

```solidity
event LosslessOn()
```

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

### botsCantrade

```solidity
bool botsCantrade
```

### canTrade

```solidity
bool canTrade
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

### depWallet

```solidity
address depWallet
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
these will not be described as they are not part of the RAT token contract but rather the lossless protocol_

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

