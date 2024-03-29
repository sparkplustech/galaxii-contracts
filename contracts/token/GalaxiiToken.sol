// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

interface IHRC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IHRC20Metadata is IHRC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

 
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
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
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

abstract contract Pausable is Context {
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state.
     */
    constructor () {
        _paused = false;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view virtual returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        require(!paused(), "Pausable: paused");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        require(paused(), "Pausable: not paused");
        _;
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

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
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
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
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
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
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
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
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}
 
contract Galaxii is Context, IHRC20, IHRC20Metadata, Ownable, Pausable {
    using SafeMath for uint256;
    using Address for address;

    mapping (address => uint256) private _rOwned;
    mapping (address => uint256) private _tOwned;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private pausedAddress;
    mapping (address => bool) private _isExcluded;
    mapping (address => bool) private _isExcludedFromDexFee;
    mapping (address => bool) private _isIncludedInFee; // Tax Flag
    address[] private _excluded;
   
    uint256 private constant MAX = ~uint256(0);
    uint256 private constant initialSupply = 777 * 10**6 * 10**18;   // initial supply
    uint256 private _tTotal = 400 * 10**6 * 10**18;   // supply after deflation
    uint256 private _rTotal = (MAX - (MAX % _tTotal));
    uint256 private _tFeeTotal;

    string private constant _name = "Galaxii";
    string private constant _symbol = "GAL";
    uint8 private constant _decimals = 18;
    
    uint256 public taxFee = 25;
    uint256 private previousTaxFee = taxFee;

    
    uint256 public transactionBurn = 25;
    uint256 private previousTransactionBurn = transactionBurn;

    uint256 public rewardFee = 25;
    uint256 private previousrewardFee = rewardFee;

    uint256 public DAOFee = 25;
    uint256 private previousDAOFee = DAOFee;

    bool public enableFee = true;
    bool private inSwapAndLiquify;
    bool public swapAndLiquifyEnabled = true;
 
    uint256 private _amount_burnt;
    uint256 public liquidityFeeBalance;
    uint256 public constant liquidityFeeToSell = 10000 * 10**18;

    address public rewardWallet;
    address public DAOWallet;
    address public mintCallerWallet;


    event FeeEnable(bool enableFee);
    event SetMaxTxPercent(uint256 maxPercent);
    event SetRewardAddress(address indexed rewarrdAddress);
    event SetrewardFeePercent(uint256 chartyFeePercent);
    event SetBurnPercent(uint256 burnPercent);
    event SetTaxFeePercent(uint256 taxFeePercent);
    event SetLiquidityFeePercent(uint256 liquidityFeePercent);
    event ExcludeFromFee(address indexed account, bool includeInFee);
    event IncludeInFee(address indexed account, bool includeInFee);
    event ExcludeFromDexFee(address indexed account, bool includeInDexFee);
    event IncludeInDexFee(address indexed account, bool includeInDexFee);
    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event SetMintCallerAddress(address mintCallerWallet);
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiqudity
    );
    event ExternalTokenTransfered(address indexed externalAddress,address indexed toAddress, uint amount);
    event EthFromContractTransferred(uint amount);
    event LiquidityAddedFromSwap(uint amountToken,uint amountEth,uint liquidity);

    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    modifier onlyMintCaller() {
        require(mintCallerWallet == _msgSender(), "Caller is not the Mintcaller");
        _;
    }
    

    constructor (address _rewardWallet, address _DAOWallet, address _mintCallerWallet) {
        require ( _rewardWallet != address ( 0 ) , "Galaxii: _rewardWallet is a zero address") ;
        require ( _DAOWallet != address ( 0 ) , "Galaxii: _DAOWallet is a zero address") ;
        require ( _mintCallerWallet != address ( 0 ) , "Galaxii: _mintCallerWallet is a zero address") ;
        
        _rOwned[_msgSender()] = _rTotal;
        rewardWallet = _rewardWallet;
        DAOWallet = _DAOWallet;
        mintCallerWallet= _mintCallerWallet;
        emit Transfer(address(0), _msgSender(), initialSupply);

        tokenDeflation();       
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() external view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() external view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {HRC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IHRC20-balanceOf} and {IHRC20-transfer}.
     */
    function decimals() external view virtual override returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IHRC20-totalSupply}.
     */
    function totalSupply() external view virtual override returns (uint256) {
        return _tTotal - _amount_burnt;
    }

    /**
     * @dev See {IHRC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        if (_isExcluded[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
    }

    /**
     * @dev See {IHRC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) external virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IHRC20-allowance}.
     */
    function allowance(address owner, address spender) external view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IHRC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) external virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IHRC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {HRC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "HRC20: transfer amount exceeds allowance");
        _approve(sender, _msgSender(), currentAllowance - amount);

        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IHRC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IHRC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "HRC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Pause `contract` - pause events.
     *
     * See {HRC20Pausable-_pause}.
     */
    function pauseContract() external virtual onlyOwner {
        _pause();
    }
    
    /**
     * @dev Pause `contract` - pause events.
     *
     * See {HRC20Pausable-_pause}.
     */
    function unPauseContract() external virtual onlyOwner {
        _unpause();
    }

    /**
     * @dev Pause `contract` - pause events.
     *
     * See {HRC20Pausable-_pause}.
     */
    function pauseAddress(address account) external virtual onlyOwner {
        excludeFromReward(account);
        pausedAddress[account] = true;
    }
    
    /**
     * @dev Pause `contract` - pause events.
     *
     * See {HRC20Pausable-_pause}.
     */
    function unPauseAddress(address account) external virtual onlyOwner {
        includeInReward(account);
        pausedAddress[account] = false;
    }
    
    /**
     * @dev Returns true if the address is paused, and false otherwise.
     */
    function isAddressPaused(address account) external view virtual returns (bool) {
        return pausedAddress[account];
    }

    function tokenDeflation() internal {
        uint256 deflationAmount = initialSupply * 40 / 100;
        emit Transfer(_msgSender(), address(0), deflationAmount);
    }

    function totalFees() external view returns (uint256) {
        return _tFeeTotal;
    }

    function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
        require(rAmount <= _rTotal, "Amount must be less than total reflections");
        uint256 currentRate =  getRate();
        return rAmount.div(currentRate);
    }

    function excludeFromReward(address account) public onlyOwner {
        require(!_isExcluded[account], "Account is already excluded");
        if(_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcluded[account] = true;
        _excluded.push(account);
    }

    function includeInReward(address account) public onlyOwner {
        require(_isExcluded[account], "Account is not excluded");
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_excluded[i] == account) {
                _excluded[i] = _excluded[_excluded.length - 1];
                _tOwned[account] = 0;
                _isExcluded[account] = false;
                _excluded.pop();
                break;
            }
        }
    }

    function isExcludedFromReward(address account) external view returns (bool) {
        return _isExcluded[account];
    }
    
    function excludeFromDexFee(address account) external onlyOwner {
        _isExcludedFromDexFee[account] = true;
        emit ExcludeFromDexFee(account, true);
    }
    
    function includeInDexFee(address account) external onlyOwner {
        _isExcludedFromDexFee[account] = false;
        emit IncludeInDexFee(account, false);
    }

    function isExcludedFromDexFee(address account) external view returns(bool) {
        return _isExcludedFromDexFee[account];
    }

    function excludeFromFee(address account) external onlyOwner {
        _isIncludedInFee[account] = false;
        emit ExcludeFromFee(account, false);
    }
    
    function includeInFee(address account) external onlyOwner {
        _isIncludedInFee[account] = true;
        emit IncludeInFee(account, true);
    }

    function isIncludedInFee(address account) external view returns(bool) {
        return _isIncludedInFee[account];
    }
    
    function setTaxFeePercent(uint256 fee) external onlyOwner {
        require((fee  + transactionBurn + rewardFee + DAOFee) < 100, "Total fees should be less than 100%");
        taxFee = fee;
        emit SetTaxFeePercent(taxFee);
    }

 
    function setBurnPercent(uint256 burn_percentage) external onlyOwner {
        require((taxFee  + burn_percentage + rewardFee + DAOFee) < 100, "Total fees should be less than 100%");
        transactionBurn = burn_percentage;
        emit SetBurnPercent(burn_percentage);
    }

    function setrewardFeePercent(uint256 fee) external onlyOwner {
        require((taxFee  + transactionBurn + fee + DAOFee) < 100, "Total fees should be less than 100%");
        rewardFee = fee;
        emit SetrewardFeePercent(rewardFee);
    }

    function setDAOFeePercent(uint256 fee) external onlyOwner {
        require((taxFee  + transactionBurn + rewardFee + fee) < 100, "Total fees should be less than 100%");
        DAOFee = fee;
        emit SetrewardFeePercent(DAOFee);
    }

    function updaterewardWallet(address _rewardWallet) external onlyOwner {
        require(_rewardWallet != address(0), "HRC20: Reward address cannot be a zero address");
        rewardWallet = _rewardWallet;
        emit SetRewardAddress(_rewardWallet);
    }

    function updatemintcallerWallet(address _mintCallerWallet) external onlyOwner {
        require(_mintCallerWallet != address(0), "HRC20: Mintcaller address cannot be a zero address");
        mintCallerWallet = _mintCallerWallet;
        emit SetMintCallerAddress(_mintCallerWallet);
    }

    function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
        swapAndLiquifyEnabled = _enabled;
        emit SwapAndLiquifyEnabledUpdated(_enabled);
    }

    function setEnableFee(bool enableTax) external onlyOwner {
        enableFee = enableTax;
        emit FeeEnable(enableTax);
    }

    function takeReflectionFee(uint256 rFee, uint256 tFee) internal {
        _rTotal = _rTotal.sub(rFee);
        _tFeeTotal = _tFeeTotal.add(tFee);
    }

    function getTValues(uint256 amount) internal view returns (uint256, uint256, uint256, uint256, uint256) {
        uint256 tAmount = amount;
        uint256 tFee = calculateTaxFee(tAmount);
         uint256 trewardFee = calculaterewardFee(tAmount);
        uint256 tWelfareFee = calculateDAOFee(tAmount);
        uint256 tBurn = calculateTransactionBurn(tAmount);
        {
            uint256 amt = tAmount;
            uint256 tTransferAmount = amt.sub(tFee).sub(tBurn).sub(trewardFee).sub(tWelfareFee);
            return (tTransferAmount, tFee, tBurn, trewardFee, tWelfareFee);
        }
    }

    function getRValues(uint256 amount, uint256 tFee, uint256 tBurn, uint256 trewardFee, uint256 tWelfareFee) internal view returns (uint256, uint256, uint256) {
        uint256 currentRate = getRate();
        uint256 tAmount = amount;
        uint256 rAmount = tAmount.mul(currentRate);
        uint256 rFee = tFee.mul(currentRate);
        uint256 rrewardFee = trewardFee.mul(currentRate);
        uint256 rWelfareFee = tWelfareFee.mul(currentRate);
        uint256 rBurn = tBurn.mul(currentRate);
        {
            uint256 amt = rAmount;
            uint256 rTransferAmount = amt.sub(rFee).sub(rBurn).sub(rrewardFee).sub(rWelfareFee);
            return (rAmount, rTransferAmount, rFee);
        }
    }

    function getRate() internal view returns(uint256) {
        (uint256 rSupply, uint256 tSupply) = getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function getCurrentSupply() internal view returns(uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;      
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
            rSupply = rSupply.sub(_rOwned[_excluded[i]]);
            tSupply = tSupply.sub(_tOwned[_excluded[i]]);
        }
        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }

    function takerewardFee(address sender, uint256 trewardFee) internal {
        uint256 currentRate =  getRate();
        uint256 rrewardFee = trewardFee.mul(currentRate);
        _rOwned[rewardWallet] = _rOwned[rewardWallet].add(rrewardFee);
        if(_isExcluded[rewardWallet])
            _tOwned[rewardWallet] = _tOwned[rewardWallet].add(trewardFee);
        
        if(trewardFee > 0) emit Transfer(sender, rewardWallet, trewardFee);
    }

    function takeDAOFee(address sender, uint256 tWelfareFee) internal {
        uint256 currentRate =  getRate();
        uint256 rWelfareFee = tWelfareFee.mul(currentRate);
        _rOwned[DAOWallet] = _rOwned[DAOWallet].add(rWelfareFee);
        if(_isExcluded[DAOWallet])
            _tOwned[DAOWallet] = _tOwned[DAOWallet].add(tWelfareFee);
        
        if(tWelfareFee > 0) emit Transfer(sender, DAOWallet, tWelfareFee);
    }

    function takeLiquidityFee(address sender, uint256 tLiquidity) internal {
        uint256 currentRate =  getRate();
        uint256 rLiquidity = tLiquidity.mul(currentRate);
        liquidityFeeBalance += tLiquidity;
        _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
        if(_isExcluded[address(this)])
            _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
        
        if(tLiquidity > 0) emit Transfer(sender, address(this), tLiquidity);
    }
    
    function calculateTaxFee(uint256 _amount) internal view returns (uint256) {
        return _amount.mul(taxFee).div(
            10**2
        );
    }


    function calculateTransactionBurn(uint256 _amount) internal view returns (uint256) {
        return _amount.mul(transactionBurn).div(
            10**2
        );
    }

    function calculaterewardFee(uint256 _amount) internal view returns (uint256) {
        return _amount.mul(rewardFee).div(
            10**2
        );
    }

    function calculateDAOFee(uint256 _amount) internal view returns (uint256) {
        return _amount.mul(DAOFee).div(
            10**2
        );
    }
    
    function removeAllFee() internal {
        if(taxFee == 0&& transactionBurn == 0 && rewardFee == 0 && DAOFee == 0) return;
        
        previousTaxFee = taxFee;
         previousTransactionBurn = transactionBurn;
        previousrewardFee = rewardFee;
        previousDAOFee = DAOFee;
        
        taxFee = 0;
        transactionBurn = 0;
        rewardFee = 0;
        DAOFee = 0;
    }
 
    function restoreAllFee() internal {
        taxFee = previousTaxFee;
        transactionBurn = previousTransactionBurn;
        rewardFee = previousrewardFee;
        DAOFee = previousDAOFee;
    }

    //to recieve ETH from uniswapV2Router when swaping
    receive() external payable {}

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "HRC20: approve from the zero address");
        require(spender != address(0), "HRC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal {
        require(from != address(0), "HRC20: transfer from the zero address");
        require(to != address(0), "HRC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        
        _beforeTokenTransfer(from, to);
        
        uint256 senderBalance = balanceOf(from);
        require(senderBalance >= amount, "HRC20: transfer amount exceeds balance");

        //indicates if fee should be deducted from transfer
        bool takeFee = false;
        
        //if any account belongs to _isIncludedInFee account then take fee
        //else remove fee
        // if(enableFee && (_isIncludedInFee[from] || _isIncludedInFee[to])){
        //     if((from == uniswapV2Pair && _isExcludedFromDexFee[to]) || (to == uniswapV2Pair && _isExcludedFromDexFee[from])) takeFee = false;
        //     else takeFee = true;
        // }
          
         //transfer amount, it will take tax, burn and charity amount
        _tokenTransfer(from,to,amount,takeFee);
    }

    function DistributeMint(address from,
        address to,
        uint256 amount) onlyMintCaller public{
        _tokenTransfer(from,to,amount,true);
    }

    //this method is responsible for taking all fee, if takeFee is true
    function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) internal {
        if(!takeFee)
            removeAllFee();
        
        if (_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferFromExcluded(sender, recipient, amount);
        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
            _transferToExcluded(sender, recipient, amount);
        } else if (_isExcluded[sender] && _isExcluded[recipient]) {
            _transferBothExcluded(sender, recipient, amount);
        } else {
            _transferStandard(sender, recipient, amount);
        }
        
        if(!takeFee)
            restoreAllFee();
    }
  
    function _transferStandard(address sender, address recipient, uint256 tAmount) internal {
        (uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 trewardFee, uint256 tWelfareFee) = getTValues(tAmount);
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = getRValues(tAmount, tFee, tBurn, trewardFee, tWelfareFee);

        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        takeReflectionFee(rFee, tFee);
        takerewardFee(sender, trewardFee);
        takeDAOFee(sender, tWelfareFee);
        if(tBurn > 0) {
            _amount_burnt += tBurn;
            emit Transfer(sender, address(0), tBurn);
        }
        emit Transfer(sender, recipient, tTransferAmount);
    }
    
    function _transferBothExcluded(address sender, address recipient, uint256 tAmount) internal {
        (uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 trewardFee, uint256 tWelfareFee) = getTValues(tAmount);
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = getRValues(tAmount, tFee,  tBurn, trewardFee, tWelfareFee);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
        takeReflectionFee(rFee, tFee);
        takerewardFee(sender, trewardFee);
        takeDAOFee(sender, tWelfareFee);
        if(tBurn > 0) {
            _amount_burnt += tBurn;
            emit Transfer(sender, address(0), tBurn);
        }
        emit Transfer(sender, recipient, tTransferAmount);
    }
    
    function _transferToExcluded(address sender, address recipient, uint256 tAmount) internal {
        (uint256 tTransferAmount, uint256 tFee,  uint256 tBurn, uint256 trewardFee, uint256 tWelfareFee) = getTValues(tAmount);
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = getRValues(tAmount, tFee, tBurn, trewardFee, tWelfareFee);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
        takeReflectionFee(rFee, tFee);
        takerewardFee(sender, trewardFee);
        takeDAOFee(sender, tWelfareFee);
        if(tBurn > 0) {
            _amount_burnt += tBurn;
            emit Transfer(sender, address(0), tBurn);
        }
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _transferFromExcluded(address sender, address recipient, uint256 tAmount) internal {
        (uint256 tTransferAmount, uint256 tFee,  uint256 tBurn, uint256 trewardFee, uint256 tWelfareFee) = getTValues(tAmount);
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = getRValues(tAmount, tFee, tBurn, trewardFee, tWelfareFee);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
        takeReflectionFee(rFee, tFee);
        takerewardFee(sender, trewardFee);
        takeDAOFee(sender, tWelfareFee);
        if(tBurn > 0) {
            _amount_burnt += tBurn;
            emit Transfer(sender, address(0), tBurn);
        }
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function withdrawToken(address _tokenContract, uint256 _amount) external onlyOwner {
        require(_tokenContract != address(0), "Address cant be zero address");
        IHRC20 tokenContract = IHRC20(_tokenContract);
        tokenContract.transfer(msg.sender, _amount);
        emit ExternalTokenTransfered(_tokenContract, msg.sender, _amount);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function withdrawEthFromContract(uint256 amount) public onlyOwner {
        require(amount <= getBalance());
        address payable _owner = payable(owner());
        _owner.transfer(amount);
        emit EthFromContractTransferred(amount);
    }
    
    function _beforeTokenTransfer(address from, address to) internal virtual { 
        require(!paused(), "HRC20Pausable: token transfer while contract paused");
        require(!pausedAddress[from], "HRC20Pausable: token transfer while from-address paused");
        require(!pausedAddress[to], "HRC20Pausable: token transfer while to-address paused");
    }
}