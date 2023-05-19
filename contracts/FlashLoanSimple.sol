// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0; 

import "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FlashloanExample {
    address payable owner; 
    event Log(address asset, uint val); 

    constructor (address provider) {
        // FlashLoanSimpleReceiverBase(IPoolAddressesProvider(provider));
        FlashLoanSimpleReceiverBase(provider); 
    }

    function createFlashLoan(address asset, uint amount)  external {
        address receiver = address(this); 
        bytes memory params = ""; 
        uint16 referralCode = 0; 
        
        // FlashLoanSimpleReceiverBase.POOL.flashLoanSimple(receiver, asset, amount, params, referralCode);
        FlashLoanSimpleReceiverBase.POOL.flashLoanSimple(receiver, asset, amount, params, referralCode);
    }

    function executeOperation(
        address asset, 
        uint256 amount, 
        uint256 premium, 
        address initiator, 
        bytes calldata params
    ) external returns (bool) {
        uint256 amountOwing = amount+ premium; 
        IERC20(asset).approve(address(FlashLoanSimpleReceiverBase.POOL), amountOwing);
        emit Log(asset, amountOwing); 
        return true; 
    }

    receive() external payable {}
}