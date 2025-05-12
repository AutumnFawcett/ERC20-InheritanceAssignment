// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import { ERC20 } from "./ERC20.sol"; // Access to Parent Contract ... inheritance
// ERC20 token with a built-in 1% transfer fee
contract ERC20WithFee is ERC20 {     // Child Contract
    address public feeCollector;     // Address that receives the 1% fee
// Constructor initializes the base ERC20 contract and stores feeCollector
    constructor(               // constructor must be built by using the same 4 arguments in the base ERC20.sol contract (parent contract)
        address _owner,        // parent argument
        string memory _name,   // parent argument
        string memory _symbol, // parent argument
        uint8 _decimals,       // parent argument
        address _feeCollector  // then add the new argument for collecting a 1% fee
    ) ERC20(_owner, _name, _symbol, _decimals) {
        feeCollector = _feeCollector;
    }
    // Override the transfer function to take a 1% fee
    function transfer(address to, uint256 value) public override returns (bool success) {
        require(value > 0, "Value must be greater than 0");

        uint256 fee = calculateFee(value);  // Calculate the 1% fee
        uint256 netAmount = value - fee;    // Calculate how much the recipient will actually get (99%)

        // Send 1% fee to feeCollector
        _transfer(msg.sender, feeCollector, fee);    // First, send the fee to the feeCollector address

        // Send 99% to recipient
        _transfer(msg.sender, to, netAmount);        // Then, send the rest to the intended recipient

        return true;
    }
    // Helper function to calculate 1% of any value
    function calculateFee(uint256 _value) internal pure returns (uint256) {
        return (_value * 1) / 100;
    }
}