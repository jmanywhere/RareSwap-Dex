/*
    Website: 
    Contract Name: Rare Dex Swap
    Instagram:
    Twitter: 
    Telegram: 
    Contract Version: 0.1
    removed safemath
    fixed storage
    fixed swc


*/
//SPDX-License-Identifier: UNLICENSED

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Context.sol

// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity 0.8.17;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/metatx/ERC2771Context.sol

// OpenZeppelin Contracts (last updated v4.7.0) (metatx/ERC2771Context.sol)

/**
 * @dev Context variant with ERC2771 support.
 */
abstract contract ERC2771Context is Context {
    /// @custom:oz-upgrades-unsafe-allow state-variable-immutable
    address private immutable _trustedForwarder;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor(address trustedForwarder) {
        _trustedForwarder = trustedForwarder;
    }

    function isTrustedForwarder(address forwarder)
        public
        view
        virtual
        returns (bool)
    {
        return forwarder == _trustedForwarder;
    }

    function _msgSender()
        internal
        view
        virtual
        override
        returns (address sender)
    {
        if (isTrustedForwarder(msg.sender)) {
            // The assembly code is more direct than the Solidity version using `abi.decode`.
            /// @solidity memory-safe-assembly
            assembly {
                sender := shr(96, calldataload(sub(calldatasize(), 20)))
            }
        } else {
            return super._msgSender();
        }
    }

    function _msgData()
        internal
        view
        virtual
        override
        returns (bytes calldata)
    {
        if (isTrustedForwarder(msg.sender)) {
            return msg.data[:msg.data.length - 20];
        } else {
            return super._msgData();
        }
    }
}

interface IERC20 {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}

interface IWETH {
    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function deposit() external payable;

    function transfer(address to, uint256 value) external returns (bool);

    function withdraw(uint256) external;
}

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     *
     * Furthermore, `isContract` will also return true if the target contract within
     * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
     * which only has an effect at the end of a transaction.
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return
            functionCallWithValue(
                target,
                data,
                0,
                "Address: low-level call failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return
            verifyCallResultFromTarget(
                target,
                success,
                returndata,
                errorMessage
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data)
        internal
        view
        returns (bytes memory)
    {
        return
            functionStaticCall(
                target,
                data,
                "Address: low-level static call failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return
            verifyCallResultFromTarget(
                target,
                success,
                returndata,
                errorMessage
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return
            functionDelegateCall(
                target,
                data,
                "Address: low-level delegate call failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return
            verifyCallResultFromTarget(
                target,
                success,
                returndata,
                errorMessage
            );
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage)
        private
        pure
    {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IRARESwapFactory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function pairExist(address pair) external view returns (bool);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;

    function routerInitialize(address) external;

    function routerAddress() external view returns (address);
}

interface IRARESwapPair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function baseToken() external view returns (address);

    function getTotalFee() external view returns (uint256);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function updateTotalFee(uint256 totalFee) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast,
            address _baseToken
        );

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to)
        external
        returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        uint256 amount0Fee,
        uint256 amount1Fee,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;

    function setBaseToken(address _baseToken) external;
}

interface IRARESwapRouter01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

interface IRARESwapRouter is IRARESwapRouter01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function pairFeeAddress(address pair) external view returns (address);

    function adminFee() external view returns (uint256);

    function feeAddressGet() external view returns (address);
}

interface ILERC20 {
    function name() external view returns (string memory);

    function admin() external view returns (address);

    function getAdmin() external view returns (address);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address _account) external view returns (uint256);

    function transfer(address _recipient, uint256 _amount)
        external
        returns (bool);

    function allowance(address _owner, address _spender)
        external
        view
        returns (uint256);

    function approve(address _spender, uint256 _amount) external returns (bool);

    function transferFrom(
        address _sender,
        address _recipient,
        uint256 _amount
    ) external returns (bool);

    function increaseAllowance(address _spender, uint256 _addedValue)
        external
        returns (bool);

    function decreaseAllowance(address _spender, uint256 _subtractedValue)
        external
        returns (bool);

    function transferOutBlacklistedFunds(address[] calldata _from) external;

    function setLosslessAdmin(address _newAdmin) external;

    function transferRecoveryAdminOwnership(
        address _candidate,
        bytes32 _keyHash
    ) external;

    function acceptRecoveryAdminOwnership(bytes memory _key) external;

    function proposeLosslessTurnOff() external;

    function executeLosslessTurnOff() external;

    function executeLosslessTurnOn() external;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
    event NewAdmin(address indexed _newAdmin);
    event NewRecoveryAdminProposal(address indexed _candidate);
    event NewRecoveryAdmin(address indexed _newAdmin);
    event LosslessTurnOffProposal(uint256 _turnOffDate);
    event LosslessOff();
    event LosslessOn();
}

contract TheRareAntiquitiesTokenLtd is ERC2771Context, ILERC20, Ownable {
    using Address for address;

    mapping(address => uint256) private _rOwned;
    mapping(address => uint256) private _tOwned;
    mapping(address => mapping(address => uint256)) private _allowances;
    event Log(string, uint256);
    event AuditLog(string, address);
    address public immutable WETH;

    mapping(address => bool) private _isExcludedFromFee;

    mapping(address => bool) private _isExcluded;
    address[] private _excluded;

    mapping(address => bool) private botWallets;
    bool public botsCantrade = false;

    bool public canTrade = false;

    uint256 private constant MAX = ~uint256(0);
    uint256 private _tTotal = 500_000_000_000 gwei;
    uint256 private _rTotal = (MAX - (MAX % _tTotal));
    uint256 private _tFeeTotal;
    address public marketingWallet; // marketing wallet address
    address public antiquitiesWallet; // antiquities Wallet address
    address public gasWallet; // gas Wallet address

    string public constant name = "The Rare Antiquities Token";
    string public constant symbol = "TRAT";
    uint8 public constant decimals = 9;

    uint256 private _taxFee = 100; // reflection tax in BPS
    uint256 private _previousTaxFee = _taxFee;

    uint256 private _liquidityFee; // liquidity tax in BPS
    uint256 private _previousLiquidityFee = _liquidityFee;

    uint256 private _marketingFee = 200; // marketing tax in BPS | 200 = 2%
    uint256 private _antiquitiesFee = 300; // antiquities tax in BPS
    uint256 private _gasFee = 100; // gas tax in BPS

    uint256 public _totalTax =
        _taxFee + _marketingFee + _antiquitiesFee + _gasFee;

    IRARESwapRouter public immutable rareSwapRouter;
    address public immutable rareSwapPair;
    address public immutable depWallet;

    uint256 public _maxTxAmount = 500_000_000_000 gwei; // total supply by default, can be changed at will
    uint256 public _maxWallet = 5_000_000_000 gwei; // 1% max wallet by default, can be changed at will

    /// Lossless Compliance
    address public admin;
    address public recoveryAdmin;
    address private recoveryAdminCandidate;
    bytes32 private recoveryAdminKeyHash;
    uint256 public timelockPeriod = 30 days;
    uint256 public losslessTurnOffTimestamp;
    bool public isLosslessOn = true;
    ILssController public lossless;

    modifier onlyExchange() {
        bool isPair = false;
        if (msg.sender == rareSwapPair) isPair = true;

        require(
            msg.sender == address(rareSwapRouter) || isPair,
            "RARE: NOT_ALLOWED"
        );
        _;
    }

    constructor(
        address _marketingWallet,
        address _antiquitiesWallet,
        address _gasWallet,
        address _trustedForwarder
    ) ERC2771Context(_trustedForwarder) {
        _rOwned[_msgSender()] = _rTotal;
        _tOwned[_msgSender()] = _tTotal;

        marketingWallet = _marketingWallet;
        antiquitiesWallet = _antiquitiesWallet;
        gasWallet = _gasWallet;

        // This is for BSC - double check the address since this one may not be the correct one
        rareSwapRouter = IRARESwapRouter(
            0x027bC3A29990aAED16F65a08C8cc3A92E0AFBAA4
        ); //RareSwap Router 0x027bC3A29990aAED16F65a08C8cc3A92E0AFBAA4
        WETH = rareSwapRouter.WETH();

        // Create a uniswap pair for this new token

        rareSwapPair = IRARESwapFactory(rareSwapRouter.factory()).createPair(
            address(this),
            WETH
        );

        lossless = ILssController(0xDBB5125CEEaf7233768c84A5dF570AeECF0b4634); // BSC Controller

        // Set base token in the pair as WETH, which acts as the tax token
        //IRARESwapPair(rareSwapPair).setBaseToken(WETH);
        //IRARESwapPair(rareSwapPair).updateTotalFee(_marketingFee + _antiquitiesFee + _gasFee);

        //_approve(_msgSender(), address(rareSwapRouter), _tTotal);

        depWallet = 0x611980Ea951D956Bd04C39A5A176EaB35EB93982;
        //exclude owner and this contract from fee
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[depWallet] = true;

        emit Transfer(address(0), _msgSender(), _tTotal);
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcluded[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        lssTransfer(recipient, amount)
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address _owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[_owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    )
        public
        override
        lssTransferFrom(sender, recipient, amount)
        returns (bool)
    {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()] - amount
        );
        return true;
    }

    //ERC 20 Standard increase Allowance
    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender] + addedValue
        );
        return true;
    }

    //ERC 20 Standard decrease Allowance
    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender] - subtractedValue
        );
        return true;
    }

    function isExcludedFromReward(address account) public view returns (bool) {
        return _isExcluded[account];
    }

    function totalFees() public view returns (uint256) {
        return _tFeeTotal;
    }

    function deliver(uint256 tAmount) public {
        address sender = _msgSender();
        require(
            !_isExcluded[sender],
            "Excluded addresses cannot call this function"
        );
        (uint256 rAmount, , , , ) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender] - rAmount;
        _rTotal = _rTotal - rAmount;
        _tFeeTotal = _tFeeTotal + tAmount;
    }

    function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
        public
        view
        returns (uint256)
    {
        require(tAmount <= _tTotal, "Amount must be less than supply");
        (uint256 rAmount, uint256 rTransferAmount, , , ) = _getValues(tAmount);
        return deductTransferFee ? rTransferAmount : rAmount;
    }

    function tokenFromReflection(uint256 rAmount)
        public
        view
        returns (uint256)
    {
        require(
            rAmount <= _rTotal,
            "Amount must be less than total reflections"
        );
        uint256 currentRate = _getRate();
        return rAmount / currentRate;
    }

    function excludeFromReward(address account) public onlyOwner {
        // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
        require(!_isExcluded[account], "Account is already excluded");
        if (_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcluded[account] = true;
        _excluded.push(account);
    }

    // function includeInReward(address account) external onlyOwner {
    //     require(_isExcluded[account], "Account is already excluded");
    //     for (uint256 i = 0; i < _excluded.length; i++) {
    //         if (_excluded[i] == account) {
    //             _excluded[i] = _excluded[_excluded.length - 1];
    //             _tOwned[account] = 0;
    //             _isExcluded[account] = false;
    //             _excluded.pop();
    //             break;
    //         }
    //     }
    // }

    function _updatePairsFee(uint256 fee) internal {
        IRARESwapPair(rareSwapPair).updateTotalFee(fee);
    }

    function excludeFromFee(address account) public onlyOwner {
        require(account != address(0), "excludeFromFee: ZERO");
        require(!_isExcludedFromFee[account], "Account is already excluded");
        _isExcludedFromFee[account] = true;
        emit AuditLog("We have Updated the excludeFromFee:", account);
    }

    function includeInFee(address account) public onlyOwner {
        require(account != address(0), "includeInFee: ZERO");
        require(_isExcludedFromFee[account], "Account is already included");
        _isExcludedFromFee[account] = false;
        emit AuditLog("We have Updated the includeInFee:", account);
    }

    function setMarketingWallet(address walletAddress) public onlyOwner {
        require(walletAddress != address(0), "includeInFee: ZERO");
        marketingWallet = walletAddress;
        emit AuditLog("We have Updated the setMarketingWallet:", walletAddress);
    }

    function setAntiquitiesWallet(address walletAddress) public onlyOwner {
        require(walletAddress != address(0), "includeInFee: ZERO");
        antiquitiesWallet = walletAddress;
        emit AuditLog(
            "We have Updated the setAntiquitiesWallet:",
            walletAddress
        );
    }

    function setGasWallet(address walletAddress) public onlyOwner {
        require(walletAddress != address(0), "includeInFee: ZERO");
        gasWallet = walletAddress;
        emit AuditLog("We have Updated the gasWallet:", walletAddress);
    }

    function _setMaxWalletAmount(uint256 amount) external onlyOwner {
        require(
            amount >= 2500000000,
            "ERR: max wallet amount should exceed 0.5% of the supply"
        );
        _maxWallet = amount * 10**9;

        emit Log("We have set a new max wallet amount:", amount);
    }

    function setMaxTxAmount(uint256 amount) external onlyOwner {
        require(
            amount >= 2500000000,
            "ERR: max tx amount should exceed 0.5% of the supply"
        );
        _maxTxAmount = amount * 10**9;
        emit Log("We have changed the Max Transfer Amount:", amount);
    }

    function clearStuckBalance() public {
        uint256 balance = address(this).balance;
        (bool succ, ) = payable(marketingWallet).call{value: balance}("");
        require(succ, "Transfer failed.");
    }

    function _msgSender()
        internal
        view
        override(Context, ERC2771Context)
        returns (address)
    {
        return ERC2771Context._msgSender();
    }

    function _msgData()
        internal
        view
        override(Context, ERC2771Context)
        returns (bytes calldata)
    {
        return ERC2771Context._msgData();
    }

    function claimERCtokens(IERC20 tokenAddress) external {
        bool succ = tokenAddress.transfer(
            marketingWallet,
            tokenAddress.balanceOf(address(this))
        );
        require(succ, "Transfer failed.");
    }

    function addBotWallet(address botwallet) external onlyOwner {
        require(botwallet != rareSwapPair, "Cannot add pair as a bot");
        require(botwallet != address(this), "Cannot add CA as a bot");
        if (owner() != address(0))
            require(botwallet != owner(), "Owner not bot");
        require(botwallet != depWallet, "Dep not bot");
        require(botwallet != marketingWallet, "Dep not bot");
        require(botwallet != antiquitiesWallet, "Dep not bot");
        require(botwallet != gasWallet, "Dep not bot");
        botWallets[botwallet] = true;
    }

    function removeBotWallet(address botwallet) external onlyOwner {
        botWallets[botwallet] = false;
    }

    function getBotWalletStatus(address botwallet) public view returns (bool) {
        return botWallets[botwallet];
    }

    function EnableTrading() external onlyOwner {
        canTrade = true;
    }

    function setFees(
        uint256 _reflectionTaxBPS,
        uint256 _marketingTaxBPS,
        uint256 _antiquitiesTaxBPS,
        uint256 _gasTaxBPS
    ) public onlyOwner {
        _taxFee = _reflectionTaxBPS;
        _marketingFee = _marketingTaxBPS;
        _antiquitiesFee = _antiquitiesTaxBPS;
        _gasFee = _gasTaxBPS;

        _totalTax = _taxFee + _marketingFee + _antiquitiesFee + _gasFee;
        require(_totalTax <= 1500, "total tax cannot exceed 15%");
        require(
            (_marketingFee + _antiquitiesFee + _gasFee) >= 100,
            "ERR: marketing + antiquities + gas tax must be over 1%"
        );

        _updatePairsFee(_marketingFee + _antiquitiesFee + _gasFee);
    }

    //to recieve ETH from uniswapV2Router when swaping
    receive() external payable {}

    function _reflectFee(uint256 rFee, uint256 tFee) private {
        _rTotal = _rTotal - rFee;
        _tFeeTotal = _tFeeTotal + tFee;
    }

    function _getValues(uint256 tAmount)
        private
        view
        returns (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 rFee,
            uint256 tTransferAmount,
            uint256 tFee
        )
    {
        (tFee, tTransferAmount) = _getTValues(tAmount);
        (rAmount, rTransferAmount, rFee) = _getRValues(
            tAmount,
            tFee,
            _getRate()
        );
        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
    }

    function _getTValues(uint256 tAmount)
        private
        view
        returns (uint256 tFee, uint256 tTransferAmount)
    {
        tFee = calculateTaxFee(tAmount);
        tTransferAmount = tAmount - tFee;
    }

    function _getRValues(
        uint256 tAmount,
        uint256 tFee,
        uint256 currentRate
    )
        private
        pure
        returns (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 rFee
        )
    {
        rAmount = tAmount * currentRate;
        rFee = tFee * currentRate;
        rTransferAmount = rAmount - rFee;
    }

    function _getRate() private view returns (uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply / tSupply;
    }

    function _getCurrentSupply() private view returns (uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (
                _rOwned[_excluded[i]] > rSupply ||
                _tOwned[_excluded[i]] > tSupply
            ) return (_rTotal, _tTotal);
            rSupply = rSupply - _rOwned[_excluded[i]];
            tSupply = tSupply - _tOwned[_excluded[i]];
        }
        if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }

    function calculateTaxFee(uint256 _amount) private view returns (uint256) {
        return (_amount * _taxFee) / 10**4;
    }

    function removeAllFee() private {
        if (_taxFee == 0) return;
        _previousTaxFee = _taxFee;
        _taxFee = 0;
    }

    function restoreAllFee() private {
        _taxFee = _previousTaxFee;
    }

    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    function _approve(
        address _owner,
        address spender,
        uint256 amount
    ) private {
        require(_owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[_owner][spender] = amount;
        emit Approval(_owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        if (from != owner() && to != owner())
            require(
                amount <= _maxTxAmount,
                "Transfer amount exceeds the maxTxAmount."
            );

        if (from == rareSwapPair && to != depWallet) {
            require(balanceOf(to) + amount <= _maxWallet, "check max wallet");
        }

        //indicates if fee should be deducted from transfer
        bool takeFee = true;

        //if any account belongs to _isExcludedFromFee account then remove the fee
        if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
            takeFee = false;
        }

        //transfer amount, it will take tax, burn, liquidity fee
        _tokenTransfer(from, to, amount, takeFee);
    }

    //this method is responsible for taking all fee, if takeFee is true
    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 amount,
        bool takeFee
    ) private {
        if (!canTrade) {
            require(sender == owner(), "Trade disabled"); // only owner allowed to trade or add liquidity
        }

        if (botWallets[sender] || botWallets[recipient]) {
            require(botsCantrade, "bots arent allowed to trade");
        }

        if (!takeFee) removeAllFee();

        bool fromExcluded = _isExcluded[sender];
        bool toExcluded = _isExcluded[recipient];

        {
            (
                uint256 rAmount,
                uint256 rTransferAmount,
                uint256 rFee,
                uint256 tTransferAmount,
                uint256 tFee
            ) = _getValues(amount);

            _rOwned[sender] -= rAmount;
            _rOwned[recipient] += rTransferAmount;

            if (fromExcluded) {
                _tOwned[sender] -= amount;
                if (toExcluded) {
                    _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
                }
            } else {
                if (toExcluded)
                    _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
            }
            _reflectFee(rFee, tFee);
            emit Transfer(sender, recipient, tTransferAmount);
        }
        if (!takeFee) restoreAllFee();
    }

    function _transferBothExcluded(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 rFee,
            uint256 tTransferAmount,
            uint256 tFee
        ) = _getValues(tAmount);
        _tOwned[sender] = _tOwned[sender] - tAmount;
        _rOwned[sender] = _rOwned[sender] - rAmount;
        _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
        _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
        _reflectFee(rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function depositLPFee(uint256 amount, address token) public onlyExchange {
        uint256 allowanceT = IERC20(token).allowance(msg.sender, address(this));

        if (allowanceT >= amount) {
            IERC20(token).transferFrom(msg.sender, address(this), amount); // _marketingFee + _antiquitiesFee antiquitiesWallet + _gasFee gasWallet
            // calculate individual tax amount
            uint256 marketingAmount = (amount * _marketingFee) /
                (_marketingFee + _antiquitiesFee + _gasFee);
            uint256 antiquitiesAmount = (amount * _antiquitiesFee) /
                (_marketingFee + _antiquitiesFee + _gasFee);
            uint256 gasAmount = amount - marketingAmount - antiquitiesAmount;
            // send WETH to respective wallet
            IERC20(token).transfer(marketingWallet, marketingAmount);
            IERC20(token).transfer(antiquitiesWallet, antiquitiesAmount);
            IERC20(token).transfer(gasWallet, gasAmount);
        }
    }

    /// Lossless Compliance

    modifier lssTransfer(address recipient, uint256 amount) {
        if (isLosslessOn) {
            lossless.beforeTransfer(_msgSender(), recipient, amount);
        }
        _;
    }

    modifier lssTransferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) {
        if (isLosslessOn) {
            lossless.beforeTransferFrom(
                _msgSender(),
                sender,
                recipient,
                amount
            );
        }
        _;
    }

    modifier onlyRecoveryAdmin() {
        require(
            _msgSender() == recoveryAdmin,
            "LERC20: Must be recovery admin"
        );
        _;
    }

    /**
     * @notice  Function to set the lossless controller
     *
     * @param   _controller Lossless controller address
     */
    function setLosslessController(address _controller) public onlyOwner {
        require(
            _controller != address(0),
            "BridgeMintableToken: Controller cannot be zero address."
        );
        require(
            _controller != address(lossless),
            "BridgeMintableToken: Cannot set same address."
        );

        lossless = ILssController(_controller);
    }

    /**
     * @notice  Function to set the lossless admin that interacts with controller
     *
     * @param   newAdmin address of the new admin
     */
    function setLosslessAdmin(address newAdmin) external onlyOwner {
        require(newAdmin != admin, "LERC20: Cannot set same address");
        admin = newAdmin;
        emit NewAdmin(newAdmin);
    }

    /**
     * @notice  Function to propose a new recovery admin
     *
     * @param   candidate new admin proposed address
     * @param   keyHash Key to accept
     */
    function transferRecoveryAdminOwnership(address candidate, bytes32 keyHash)
        external
        onlyOwner
    {
        recoveryAdminCandidate = candidate;
        recoveryAdminKeyHash = keyHash;
        emit NewRecoveryAdminProposal(candidate);
    }

    /**
     * @notice  Function to accept the admin proposal
     * @param   key Key to accept
     */
    function acceptRecoveryAdminOwnership(bytes memory key) external {
        require(
            _msgSender() == recoveryAdminCandidate,
            "LERC20: Must be canditate"
        );
        require(keccak256(key) == recoveryAdminKeyHash, "LERC20: Invalid key");
        recoveryAdmin = recoveryAdminCandidate;
        recoveryAdminCandidate = address(0);
        emit NewRecoveryAdmin(recoveryAdmin);
    }

    /**
     * @notice  Function to retrieve the funds of a blacklisted address.
     *
     * @param   from Array of addresses corresponding to a report and a second report
     */
    function transferOutBlacklistedFunds(address[] calldata from) external {
        require(
            _msgSender() == address(lossless),
            "LERC20: Only lossless contract"
        );

        uint256 fromLength = from.length;

        for (uint256 i = 0; i < fromLength; i++) {
            address fromAddress = from[i];
            uint256 fromBalance = balanceOf(fromAddress);
            _transferBothExcluded(fromAddress, address(lossless), fromBalance);
        }
    }

    /**
     * @notice  Function to propose turning off everything related to lossless
     */
    function proposeLosslessTurnOff() external onlyRecoveryAdmin {
        require(
            losslessTurnOffTimestamp == 0,
            "LERC20: TurnOff already proposed"
        );
        require(isLosslessOn, "LERC20: Lossless already off");
        losslessTurnOffTimestamp = block.timestamp + timelockPeriod;
        emit LosslessTurnOffProposal(losslessTurnOffTimestamp);
    }

    /**
     * @notice  Function to execute lossless turn off after a period of time
     */
    function executeLosslessTurnOff() external onlyRecoveryAdmin {
        require(losslessTurnOffTimestamp != 0, "LERC20: TurnOff not proposed");
        require(
            losslessTurnOffTimestamp <= block.timestamp,
            "LERC20: Time lock in progress"
        );
        isLosslessOn = false;
        losslessTurnOffTimestamp = 0;
        emit LosslessOff();
    }

    /**
     * @notice  Function to turn on everything related to lossless
     */
    function executeLosslessTurnOn() external onlyRecoveryAdmin {
        require(!isLosslessOn, "LERC20: Lossless already on");
        losslessTurnOffTimestamp = 0;
        isLosslessOn = true;
        emit LosslessOn();
    }

    function getAdmin() external view returns (address) {
        return admin;
    }
}

interface ILssController {
    function beforeTransfer(
        address _msgSender,
        address _recipient,
        uint256 _amount
    ) external;

    function beforeTransferFrom(
        address _msgSender,
        address _sender,
        address _recipient,
        uint256 _amount
    ) external;

    function beforeMint(address _to, uint256 _amount) external;

    function beforeBurn(address _account, uint256 _amount) external;
}
