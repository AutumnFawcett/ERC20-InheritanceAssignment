//SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// Basic ERC20 token implementation
contract ERC20 {    // Parent Contract 
    modifier onlyOwner { // Modifier that restricts access to only the contract owner
        require(msg.sender == owner, "Not owner");
        _;
    }

    // Events to track token transfers and approvals
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // Token metadata
    string public name;
    string public symbol;
    uint8 public immutable decimals;
    uint256 public totalSupply;  // Total Supply of Tokens minted                
    address public owner;    // Owner of the contract (usually who can mint or burn tokens)

    mapping (address => uint256) public balanceOf;   // Tracks balances of each account
    mapping (address => mapping(address => uint256)) public allowance; // Tracks how much one account is allowed to spend on behalf of another
    // Constructor runs once when the contract is deployed
    constructor(address _owner, string memory _name, string memory _symbol, uint8 _decimals){
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        owner = _owner;
    }
    // Transfers tokens from sender to another address
    function transfer(address to, uint256 value) public virtual returns (bool) {
        return _transfer(msg.sender, to, value);
    }
    // Internal mint function - creates new tokens and sends them to an address
    function _mint(address to, uint256 value) internal {
        balanceOf[to] += value;
        totalSupply += value;
        emit Transfer(address(0), to, value); // Emit event to show tokens were minted 
    }
    // External mint function restricted to the owner
    function mint(address to, uint256 value) external onlyOwner {
        _mint(to, value);
    }
    // Internal burn function - destroys tokens from an address
    function _burn(address from, uint256 value) internal {
        balanceOf[from] -= value;
        totalSupply -= value;
    }
    // External burn function restricted to the owner
    function burn(address from, uint256 value) external onlyOwner {
        _burn(from, value);
    }
    // Allows someone to spend tokens on behalf of another, using allowance
    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        require(allowance[from][msg.sender] >= value, "ERC20: Insufficient Allowance");
        allowance[from][msg.sender] -= value;
        emit Approval(from, msg.sender, allowance[from][msg.sender]);  // Show remaining allowance
        return _transfer(from, to, value);
    }
    // Internal transfer logic - handles balance changes and event
    function _transfer(address from, address to, uint256 value) internal returns (bool) {
        require(balanceOf[from] >= value, "ERC20: Insufficient sender balance");

        balanceOf[from] -= value;
        balanceOf[to] += value;

        emit Transfer(from, to, value);
        return true;
    }
    // Allows a user to give permission to another account to spend their tokens
    function approve(address spender, uint256 value) external returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
}