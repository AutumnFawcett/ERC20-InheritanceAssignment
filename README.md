# ERC20-InheritanceAssignment
This is my ZTM Inheritance Assignment. In this lesson I learned about Inheritance and how I can use a Parent & Child contract. Below is the breakdown of my code.

### Assignment:   

1. Write a contract that inherits from our ERC20 contract. But it should override the transfer function with a new transfer function that takes a 1% fee, just like in the previous exercise.  

2. Now re-use the original transfer function to transfer the 1% fee as well as the remaining 99%.

## 📄 ERC20 Token with Fee – Solidity Smart Contract  
### This inheritance project includes two Solidity contracts:   

1. ```ERC20.sol```: A custom ERC20 token implementation (Parent).  

2. ```ERC20WithFee.sol```: An extension of the token that deducts a 1% fee from transfers (Child).

## 🔧 Contract: ERC20.sol  
This is a simplified custom version of the ERC20 token standard. 

### 🔍 Code Breakdown 

#### ✍️ Solidity Best Practices
```
// SPDX-License-Identifier: MIT
```
- Declares the license type. Required by Solidity.
```
  pragma solidity 0.8.26;
```
- Sets the Solidity compiler version to ```0.8.26```.
  
<br>

  #### 📝 Begining of Smart Contract
  ```
  contract ERC20 {
  ```
- Begins the definition of the ```ERC20``` smart contract.

 <br>

#### 🔐 Access Control Modifier  
```
modifier onlyOwner {
    require(msg.sender == owner, "Not owner");
    _;
}
```
- Restricts function execution to the contract owner.

 <br>
  
#### 📣 Events
```
event Transfer(address indexed from, address indexed to, uint256 value);
event Approval(address indexed owner, address indexed spender, uint256 value);
```
- ```Transfer```: Emitted when tokens move between addresses.
- ```Approval```: Emitted when a user allows another address to spend their tokens.

<br>

#### 🧾 Token Variables
```
string public name;
string public symbol;
uint8 public immutable decimals;
uint256 public totalSupply;
```
- Basic metadata: token name, symbol, decimals, and total supply.

```
address public owner;
```
- Stores the owner address who can mint/burn tokens.

<br> 

#### 📊 Token Storage
```
mapping (address => uint256) public balanceOf;
mapping (address => mapping(address => uint256)) public allowance;
```
- ```balanceOf```: Tracks how many tokens each address has.
- ```allowance```: Tracks how many tokens a user is allowed to spend on another's behalf.

<br>

#### 🏗️ Constructor
```
constructor(address _owner, string memory _name, string memory _symbol, uint8 _decimals) {
    ...
}
```
- Initializes the token’s name, symbol, decimals, and owner.

<br>

#### 🔁 Transfer
```
function transfer(address to, uint256 value) public virtual returns (bool) {
    return _transfer(msg.sender, to, value);
}
```
- Sends tokens from the caller to another address.

 <br>

 #### 🏭 Mint & Burn
 ```
function _mint(address to, uint256 value) internal { ... }
function mint(address to, uint256 value) external onlyOwner { ... }
```
- ```_mint```: Internally adds new tokens.
- ```mint```: Callable by the owner to create new tokens.

```
function _burn(address from, uint256 value) internal { ... }
function burn(address from, uint256 value) external onlyOwner { ... }
```
- ```_burn```: Internally destroys tokens.
- ```burn```: Callable by the owner to remove tokens from circulation.

<br>

#### 💳 transferFrom
```
function transferFrom(address from, address to, uint256 value) external returns (bool) { ... }
```
- Allows an approved account to transfer tokens on behalf of the token owner.

<br>

#### 🔄 Internal Transfer Logic
```
function _transfer(address from, address to, uint256 value) internal returns (bool) { ... }
```
- Core logic that adjusts balances and emits the ```Transfer``` event.

<br>

#### ✅ Approve Spending
```
function approve(address spender, uint256 value) external returns (bool) { ... }
```
- Lets a user approve another address to spend tokens on their behalf.  

<br>

### 💸 Contract: ERC20WithFee.sol  
This contract inherits from ERC20.sol and adds a 1% fee to each transfer.  

### 🔍 Code Breakdown  

#### 📂 Begining of Import Contract
```
import { ERC20 } from "./ERC20.sol";
```
- Imports the base ERC20 contract for reuse.

<br>

#### 🏗️ Constructor
```
constructor(..., address _feeCollector) ERC20(...) {
    feeCollector = _feeCollector;
}
```
- Passes necessary parameters to the base constructor and stores the ```feeCollector``` address.

<br>

#### 🔁 Overridden transfer With Fee
```
function transfer(address to, uint256 value) public override returns (bool success) { ... }
```
- Overrides the base ```transfer``` function to:
  - Deduct a 1% fee.
  - Send the fee to ```feeCollector```.
  - Send the remaining 99% to the recipient.

<br>

#### 🧮 Fee Calculation Helper
```
function calculateFee(uint256 _value) internal pure returns (uint256) {
    return (_value * 1) / 100;
}
```
- Simple function to calculate 1% of any given value.

<br>

### 🧪 Example Transfer with Fee
- Sender wants to send ```1000``` tokens:
  - ```10``` tokens (1%) go to the ```feeCollector```.
  - ```990``` tokens go to the actual recipient.



  
