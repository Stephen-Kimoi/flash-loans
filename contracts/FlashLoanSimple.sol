// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FlashloanExample is FlashLoanSimpleReceiverBase {
    event Log(address asset, uint val); 

    constructor (IPoolAddressesProvider provider) {
        FlashLoanSimpleReceiverBase(provider); 
    }

    function createFlashLoan(address set, uint amount)  external {
        address receiver = address(this); 
        bytes memory params = ""; 
        uint16 referralCode = 0; 
        
        POOL.flashLoanSimple(receiver, asset, amount, params, referralCode);
    }
}