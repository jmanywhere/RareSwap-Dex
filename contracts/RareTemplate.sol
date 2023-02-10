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

    function isTrustedForwarder(
        address forwarder
    ) public view virtual returns (bool) {
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

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

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

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

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
    function functionCall(
        address target,
        bytes memory data
    ) internal returns (bytes memory) {
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
    function functionStaticCall(
        address target,
        bytes memory data
    ) internal view returns (bytes memory) {
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
    function functionDelegateCall(
        address target,
        bytes memory data
    ) internal returns (bytes memory) {
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

    function _revert(
        bytes memory returndata,
        string memory errorMessage
    ) private pure {
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

    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function pairExist(address pair) external view returns (bool);

    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);

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

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

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

    function burn(
        address to
    ) external returns (uint256 amount0, uint256 amount1);

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
    ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);

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
        returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);

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

    function getAmountsOut(
        uint256 amountIn,
        address[] calldata path
    ) external view returns (uint256[] memory amounts);

    function getAmountsIn(
        uint256 amountOut,
        address[] calldata path
    ) external view returns (uint256[] memory amounts);
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

    function transfer(
        address _recipient,
        uint256 _amount
    ) external returns (bool);

    function allowance(
        address _owner,
        address _spender
    ) external view returns (uint256);

    function approve(address _spender, uint256 _amount) external returns (bool);

    function transferFrom(
        address _sender,
        address _recipient,
        uint256 _amount
    ) external returns (bool);

    function increaseAllowance(
        address _spender,
        uint256 _addedValue
    ) external returns (bool);

    function decreaseAllowance(
        address _spender,
        uint256 _subtractedValue
    ) external returns (bool);

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
    struct RoleData {
        mapping(address => bool) members; //
        uint totalMembers; // tracks total number of members with this role
    }
    // Roles
    // Roles can only be added by members of the same role
    // Owner can set the role, ONLY when the role is not setup
    mapping(bytes32 => RoleData) private _roles;
    bytes32 public constant FEE_ROLE = keccak256("FEE");
    bytes32 public constant WALLET_ROLE = keccak256("WALLET");
    bytes32 public constant LOSSLESS_ROLE = keccak256("LOSSLESS");
    bytes32 public constant MAX_ROLE = keccak256("MAX");
    bytes32 public constant BOT_ROLE = keccak256("BOT");

    using Address for address;

    mapping(address => uint256) private _rOwned;
    mapping(address => uint256) private _tOwned;
    mapping(address => mapping(address => uint256)) private _allowances;
    event Log(string, uint256);
    event AuditLog(string, address);
    address public immutable WETH;

    mapping(address => bool) private _isExcludedFromFee;

    mapping(address => bool) private _isExcluded;

    // Exclusion amounts
    uint private excludedT;
    uint private excludedR;

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
    bool public isLosslessOn = false;
    ILssController public lossless;

    event RoleGranted(
        bytes32 indexed role,
        address indexed account,
        address indexed granter
    );
    event RoleRevoked(
        bytes32 indexed role,
        address indexed account,
        address indexed granter
    );

    modifier onlyExchange() {
        bool isPair = false;
        if (msg.sender == rareSwapPair) isPair = true;

        require(
            msg.sender == address(rareSwapRouter) || isPair,
            "RARE: NOT_ALLOWED"
        );
        _;
    }

    modifier onlyRole(bytes32 role, bool setup) {
        if (setup) {
            require(
                hasRole(role, _msgSender()) || _msgSender() == owner(),
                "RARE: NOT_ALLOWED"
            );
        } else require(hasRole(role, _msgSender()), "RARE: NOT_ALLOWED");
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

        // Setup router
        rareSwapRouter = IRARESwapRouter(
            0x027bC3A29990aAED16F65a08C8cc3A92E0AFBAA4
        );
        WETH = rareSwapRouter.WETH();
        // Create the pair
        rareSwapPair = IRARESwapFactory(rareSwapRouter.factory()).createPair(
            address(this),
            WETH
        );
        // Set base token in the pair as WETH, which acts as the tax token
        IRARESwapPair(rareSwapPair).setBaseToken(WETH);
        require(
            IRARESwapPair(rareSwapPair).updateTotalFee(
                _marketingFee + _antiquitiesFee + _gasFee
            ),
            "FEE_UPDATE_FAILED"
        );

        depWallet = 0x611980Ea951D956Bd04C39A5A176EaB35EB93982;
        //exclude owner and this contract from fee
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[depWallet] = true;
        _isExcludedFromFee[gasWallet] = true;
        _isExcludedFromFee[marketingWallet] = true;
        _isExcludedFromFee[antiquitiesWallet] = true;

        excludeFromReward(address(this));
        excludeFromReward(depWallet);
        excludeFromReward(gasWallet);
        excludeFromReward(marketingWallet);
        excludeFromReward(antiquitiesWallet);
        excludeFromReward(rareSwapPair);
        excludeFromReward(address(rareSwapRouter));

        emit Transfer(address(0), _msgSender(), _tTotal);
    }

    /// @notice set the Maximum amount of tokens that can be held in a wallet
    /// @param amount the amount of tokens in gwei
    /// @dev only owner can call this function, minimum limit is 0.5% of the total supply
    function setMaxWalletAmount(
        uint256 amount
    ) external onlyRole(MAX_ROLE, false) {
        require(
            amount > 2_500_000_000,
            "ERR: max wallet amount should exceed 0.5% of the supply"
        );
        _maxWallet = amount * 10 ** 9;
        emit Log("New max wallet amount:", amount);
    }

    /// @notice ERC20 implementation of total Circulating supply of the token
    /// @return _tTotal total supply of the token
    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    /// @notice ERC20 implementation of user's balance
    /// @param account the address of the user to check
    /// @return balance of the user
    /// @dev if the address is excluded from reward, it returns the balance of the user without any reflections accounted for
    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcluded[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
    }

    /// @notice ERC20 implementation of transfer function
    /// @param recipient the address of the recipient
    /// @param amount the amount of tokens to transfer
    /// @return true if the transfer is successful
    function transfer(
        address recipient,
        uint256 amount
    ) public override lssTransfer(recipient, amount) returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /// @notice ERC20 implementation of allowance function
    /// @param _owner the address of the owner
    /// @param spender the address of the spender
    /// @return amount of tokens that the spender is allowed to spend
    function allowance(
        address _owner,
        address spender
    ) public view override returns (uint256) {
        return _allowances[_owner][spender];
    }

    /// @notice ERC20 implementation of approve function
    /// @param spender the address of the spender
    /// @param amount the amount of tokens to approve
    /// @return true if the approval is successful
    function approve(
        address spender,
        uint256 amount
    ) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /// @notice ERC20 implementation of transferFrom function
    /// @param sender the address of the sender
    /// @param recipient the address of the recipient
    /// @param amount the amount of tokens to transfer
    /// @return true if the transfer is successful
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

    /// @notice ERC20 implementation of increaseAllowance function
    /// @param spender the address of the spender
    /// @param addedValue the amount of tokens to increase the allowance by
    /// @return true if the increase is successful
    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) public virtual returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender] + addedValue
        );
        return true;
    }

    /// @notice ERC20 implementation of decreaseAllowance function
    /// @param spender the address of the spender
    /// @param subtractedValue the amount of tokens to decrease the allowance by
    /// @return true if the decrease is successful
    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) public virtual returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender] - subtractedValue
        );
        return true;
    }

    /// @notice function that determines if an address is excluded from reward
    /// @param account the address to check
    /// @return true if the address is excluded from reward
    function isExcludedFromReward(address account) public view returns (bool) {
        return _isExcluded[account];
    }

    /// @notice function that returns the amount collected in fees
    /// @return the amount collected in fees
    function totalFees() public view returns (uint256) {
        return _tFeeTotal;
    }

    /// @notice this works similar to burn function
    /// @param tAmount the amount of tokens to deliver
    /// @dev although this function does not reduce the total supply, it reduces the reflection of the sender and the total to be distributed
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

    /// @notice calcualtes the reflection amount from a given token amount
    /// @param tAmount the amount of tokens to calculate the reflection amount from
    /// @param deductTransferFee true if the transfer fee should be deducted
    /// @return the reflection amount
    function reflectionFromToken(
        uint256 tAmount,
        bool deductTransferFee
    ) public view returns (uint256) {
        require(tAmount <= _tTotal, "Amount must be less than supply");
        (uint256 rAmount, uint256 rTransferAmount, , , ) = _getValues(tAmount);
        return deductTransferFee ? rTransferAmount : rAmount;
    }

    /// @notice calculates the token amount from a given reflection amount
    /// @param rAmount the amount of reflections to calculate the token amount from
    /// @return the token amount
    function tokenFromReflection(
        uint256 rAmount
    ) public view returns (uint256) {
        require(
            rAmount <= _rTotal,
            "Amount must be less than total reflections"
        );
        uint256 currentRate = _getRate();
        return rAmount / currentRate;
    }

    /// @notice excludes an address from reward
    /// @param account the address to exclude from reward
    /// @dev this function can only be called by the owner and the variables for excluded amounts are updated
    function excludeFromReward(address account) public onlyOwner {
        // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
        require(!_isExcluded[account], "Account is already excluded");
        if (_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcluded[account] = true;
        excludedT += _tOwned[account];
        excludedR += _rOwned[account];
    }

    /// @notice updates the Fees set up in the DEX pairs
    /// @param fee the new fee amount to update
    function _updatePairsFee(uint256 fee) internal {
        require(
            IRARESwapPair(rareSwapPair).updateTotalFee(fee),
            "FEE_UPDATE_FAILED"
        );
    }

    /// @notice excludes and address from transfer fees
    /// @param account the address to exclude from transfer fees
    /// @dev this function can only be called by the owner
    function excludeFromFee(address account) public onlyRole(FEE_ROLE, false) {
        require(account != address(0), "excludeFromFee: ZERO");
        require(!_isExcludedFromFee[account], "Account is already excluded");
        _isExcludedFromFee[account] = true;
        emit AuditLog("We have Updated the excludeFromFee:", account);
    }

    /// @notice includes an address in transfer fees
    /// @param account the address to include in transfer fees
    /// @dev this function can only be called by the owner
    function includeInFee(address account) public onlyRole(FEE_ROLE, false) {
        require(account != address(0), "includeInFee: ZERO");
        require(_isExcludedFromFee[account], "Account is already included");
        _isExcludedFromFee[account] = false;
        emit AuditLog("We have Updated the includeInFee:", account);
    }

    /// @notice sets the marketing wallet address
    /// @param walletAddress the address of the new marketing wallet
    /// @dev this function can only be called by the owner
    function setMarketingWallet(
        address walletAddress
    ) public onlyRole(WALLET_ROLE, false) {
        require(walletAddress != address(0), "includeInFee: ZERO");
        marketingWallet = walletAddress;
        emit AuditLog("We have Updated the setMarketingWallet:", walletAddress);
    }

    /// @notice sets the antiquities Wallet address
    /// @param walletAddress the address of the new antiquities wallet
    /// @dev this function can only be called by the owner
    function setAntiquitiesWallet(
        address walletAddress
    ) public onlyRole(WALLET_ROLE, false) {
        require(walletAddress != address(0), "includeInFee: ZERO");
        antiquitiesWallet = walletAddress;
        emit AuditLog(
            "We have Updated the setAntiquitiesWallet:",
            walletAddress
        );
    }

    /// @notice sets the gas Wallet address
    /// @param walletAddress the address of the new gas wallet
    /// @dev this function can only be called by the owner
    function setGasWallet(
        address walletAddress
    ) public onlyRole(WALLET_ROLE, false) {
        require(walletAddress != address(0), "includeInFee: ZERO");
        gasWallet = walletAddress;
        emit AuditLog("We have Updated the gasWallet:", walletAddress);
    }

    /// @notice sets the Maximum transaction token transfer limit
    /// @param amount the amount of tokens to set the maximum transaction limit to
    /// @dev this function can only be called by the owner, the amount must be greater than 0.5% of the total supply
    function setMaxTxAmount(uint256 amount) external onlyRole(MAX_ROLE, false) {
        require(
            amount >= 2_500_000_000,
            "ERR: max tx amount should exceed 0.5% of the supply"
        );
        _maxTxAmount = amount * 10 ** 9;
        emit Log("New Max Transfer Amount:", amount);
    }

    /// @notice sends any stuck ETH balance to the marketing wallet
    /// @dev No matter who calls this function, it always is allocated to marketing wallet
    function clearStuckBalance() public {
        uint256 balance = address(this).balance;
        (bool succ, ) = payable(marketingWallet).call{value: balance}("");
        require(succ, "Transfer failed.");
    }

    /// @notice implementation of Context msgSender
    /// @return the sender of the transaction
    /// @dev this is mostly for the lossless and gasless stuff
    function _msgSender()
        internal
        view
        override(Context, ERC2771Context)
        returns (address)
    {
        return ERC2771Context._msgSender();
    }

    /// @notice implementation of Context msgData
    /// @return the data of the transaction
    /// @dev this is mostly for the lossless and gasless stuff
    function _msgData()
        internal
        view
        override(Context, ERC2771Context)
        returns (bytes calldata)
    {
        return ERC2771Context._msgData();
    }

    /// @notice claim ERC20 tokens sent to this contract
    /// @param tokenAddress the address of the ERC20 token to claim
    /// @dev no matter who calls this function, funds are always sent to marketing wallet
    function claimERCtokens(IERC20 tokenAddress) external {
        bool succ = tokenAddress.transfer(
            marketingWallet,
            tokenAddress.balanceOf(address(this))
        );
        require(succ, "Transfer failed.");
    }

    /// @notice add a bot wallet to stop from trading and selling
    /// @param botwallet the address of the bot wallet to add
    /// @dev this function can only be called by the owner
    function addBotWallet(
        address botwallet
    ) external onlyRole(BOT_ROLE, false) {
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

    /// @notice remove a wallet from being a bot
    /// @param botwallet the address of the bot wallet to remove
    /// @dev this function can only be called by the owner
    function removeBotWallet(
        address botwallet
    ) external onlyRole(BOT_ROLE, false) {
        botWallets[botwallet] = false;
    }

    /// @notice check if a wallet is a bot
    /// @param botwallet the address of the bot wallet to check
    /// @return true if the wallet is a bot, false otherwise
    function getBotWalletStatus(address botwallet) public view returns (bool) {
        return botWallets[botwallet];
    }

    /// @notice Enables trading for the contract
    /// @dev this function can only be called by the owner and once called, trading cannot be stopped
    function enableTrading() external onlyOwner {
        canTrade = true;
    }

    /// @notice Set the new tax amounts
    /// @param _reflectionTaxBPS the amount of tax to be taken for reflections
    /// @param _marketingTaxBPS the amount of tax to be taken for marketing
    /// @param _antiquitiesTaxBPS the amount of tax to be taken for antiquities
    /// @param _gasTaxBPS the amount of tax to be taken for gas
    /// @dev this function can only be called by the owner, max totalTax is 15%, marketing + antiquities + gas tax must be over 1%
    function setFees(
        uint256 _reflectionTaxBPS,
        uint256 _marketingTaxBPS,
        uint256 _antiquitiesTaxBPS,
        uint256 _gasTaxBPS
    ) public onlyRole(FEE_ROLE, false) {
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

    /// @notice distributes reflection fee
    /// @param rFee the fee to be distributed
    /// @param tFee the fee to be added to the counter
    function _reflectFee(uint256 rFee, uint256 tFee) private {
        _rTotal = _rTotal - rFee;
        _tFeeTotal = _tFeeTotal + tFee;
    }

    /// @notice calculates the transfer values
    /// @param tAmount the amount of tokens to be transferred
    /// @return rAmount the total amount of reflections to be transferred
    /// @return rTransferAmount the amount of reflections to be transferred after tax
    /// @return rFee the tax fee to be reflected
    /// @return tTransferAmount the amount of tokens to be transferred after tax
    /// @return tFee the amount of tokens to be taxed
    function _getValues(
        uint256 tAmount
    )
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

    /// @notice calculates the tax fee
    /// @param tAmount the amount of tokens to be taxed
    /// @return tFee the amount of tokens to be taxed
    /// @return tTransferAmount the amount of tokens to be transferred after tax
    function _getTValues(
        uint256 tAmount
    ) private view returns (uint256 tFee, uint256 tTransferAmount) {
        tFee = calculateTaxFee(tAmount);
        tTransferAmount = tAmount - tFee;
    }

    /// @notice calculates the reflection coefficient and fee
    /// @param tAmount the amount of tokens to be taxed
    /// @param tFee the amount of tokens to be taxed in total
    /// @param currentRate the current rate of reflections
    /// @return rAmount the total amount of reflections to be transferred
    /// @return rTransferAmount the amount of reflections to be transferred after tax
    /// @return rFee the tax fee to be reflected
    function _getRValues(
        uint256 tAmount,
        uint256 tFee,
        uint256 currentRate
    )
        private
        pure
        returns (uint256 rAmount, uint256 rTransferAmount, uint256 rFee)
    {
        rAmount = tAmount * currentRate;
        rFee = tFee * currentRate;
        rTransferAmount = rAmount - rFee;
    }

    /// @notice calculates the current reflection rate
    /// @return the current reflection rate based on the supply of reflections and tokens
    function _getRate() private view returns (uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply / tSupply;
    }

    /// @notice calculates the current supply of reflections and tokens
    /// @return rSupply the current supply of reflections
    /// @return tSupply the current supply of tokens
    /// @dev this function removes all excluded value amounts from the supply
    function _getCurrentSupply() private view returns (uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;
        if (excludedR > rSupply || excludedT > tSupply)
            return (_rTotal, _tTotal);

        rSupply = rSupply - excludedR;
        tSupply = tSupply - excludedT;

        if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }

    /// @notice calculates the tax fee
    /// @param _amount the amount of tokens to be taxed
    /// @return the amount of tokens to be taxed
    function calculateTaxFee(uint256 _amount) private view returns (uint256) {
        return (_amount * _taxFee) / 10 ** 4;
    }

    /// @notice remove all fees
    function removeAllFee() private {
        if (_taxFee == 0) return;
        _previousTaxFee = _taxFee;
        _taxFee = 0;
    }

    /// @notice restore all fees
    function restoreAllFee() private {
        _taxFee = _previousTaxFee;
    }

    /// @notice checks the exclusion status of an account
    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    /// @notice Sets the allowance to a specific value
    /// @param _owner the owner of the allowance
    /// @param spender the spender of the allowance
    /// @param amount the amount of allowance
    function _approve(address _owner, address spender, uint256 amount) private {
        require(_owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[_owner][spender] = amount;
        emit Approval(_owner, spender, amount);
    }

    /// @notice transfers tokens from one account to another
    /// @param from the account to transfer from
    /// @param to the account to transfer to
    /// @param amount the amount of tokens to transfer
    /// @dev this is the first step where all checks occur before transfer is executed
    function _transfer(address from, address to, uint256 amount) private {
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

    /// @notice transfers tokens from one account to another checks for bots and calculates trade amounts and tax fees
    /// @param sender the account to transfer from
    /// @param recipient the account to transfer to
    /// @param amount the amount of tokens to transfer
    /// @param takeFee indicates if fee should be deducted from transfer
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
                    _tOwned[recipient] += tTransferAmount;
                } else {
                    excludedR -= rAmount;
                    excludedT -= tTransferAmount;
                }
            } else {
                if (toExcluded) {
                    _tOwned[recipient] += tTransferAmount;
                    excludedR += rAmount;
                    excludedT += tTransferAmount;
                }
            }
            _reflectFee(rFee, tFee);
            emit Transfer(sender, recipient, tTransferAmount);
        }
        if (!takeFee) restoreAllFee();
    }

    /// @notice transfers tokens from the exchange to the tax receiving wallets
    /// @param amount the amount of tokens to transfer
    /// @param token the token to transfer
    /// @dev token is only on ERC20
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
    /// @dev due to the nature of the implementation of lossless protocol, we need to add the following modifiers to the functions that transfer tokens
    /// @dev these will not be described as they are not part of the RAT token contract but rather the lossless protocol

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
    function setLosslessController(
        address _controller
    ) public onlyRole(LOSSLESS_ROLE, false) {
        require(
            _controller != address(0),
            "BridgeMintableToken: Controller cannot be zero address."
        );
        require(
            _controller != address(lossless),
            "BridgeMintableToken: Cannot set same address."
        );

        lossless = ILssController(_controller);
        if (!isLosslessOn) isLosslessOn = true;
    }

    /**
     * @notice  Function to set the lossless admin that interacts with controller
     *
     * @param   newAdmin address of the new admin
     */
    function setLosslessAdmin(
        address newAdmin
    ) external onlyRole(LOSSLESS_ROLE, false) {
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
    function transferRecoveryAdminOwnership(
        address candidate,
        bytes32 keyHash
    ) external onlyRole(LOSSLESS_ROLE, false) {
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
            // Use internal transfer function to avoid lossless checks and remove fees on this transfer
            _tokenTransfer(fromAddress, address(lossless), fromBalance, false);
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

    /// ---------------------- ///
    ///          ROLES         ///
    /// ---------------------- ///

    ///@notice check if account has a role
    ///@param role the role to check
    ///@param account the address to check
    ///@return true if account has role
    function hasRole(bytes32 role, address account) public view returns (bool) {
        return _roles[role].members[account];
    }

    ///@notice grant role to an address
    ///@param role the role to grant
    ///@param account the address to grant the role to
    function grantRole(
        bytes32 role,
        address account
    ) public onlyRole(role, true) {
        require(account != _msgSender(), "SELF_GRANT");
        if (!hasRole(role, account)) {
            _roles[role].members[account] = true;
            _roles[role].totalMembers++;
            emit RoleGranted(role, account, _msgSender());
        }
    }

    /// @notice revoke role from an address
    /// @param role the role to revoke
    /// @param account the address to revoke the role from
    function revokeRole(
        bytes32 role,
        address account
    ) public onlyRole(role, true) {
        require(account != _msgSender(), "SELF_REVOKE");
        _revokeRole(role, account);
    }

    /// @notice renounce role from an address
    /// @param role the role to renounce
    function renounceRole(bytes32 role) public {
        _revokeRole(role, _msgSender());
    }

    function _revokeRole(bytes32 role, address account) internal {
        if (hasRole(role, account)) {
            _roles[role].members[account] = false;
            _roles[role].totalMembers--;
            emit RoleRevoked(role, account, _msgSender());
        }
    }

    /// @notice get the amount of members of a role
    /// @param role the role to get the amount of members
    /// @return the amount of members of the role
    function getRoleMemberAmount(bytes32 role) public view returns (uint256) {
        return _roles[role].totalMembers;
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
