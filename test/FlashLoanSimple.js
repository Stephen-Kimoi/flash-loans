const { expect, assert } = require("chai");
const hre = require("hardhat");

const { DAI, DAI_WHALE, POOL_ADDRESS_PROVIDER } = require("../config");

describe("Flash loans", function () {
  it("Should take a flash loan and be able to return it", async function() {
    const FlashLoanExample = await hre.ethers.getContractFactory("FlashloanExample"); 
    const flashLoanExample = await FlashLoanExample.deploy(POOL_ADDRESS_PROVIDER); 
    
    await flashLoanExample.deployed(); 

    // Fetching DAI smart contract 
    const token = await hre.ethers.getContractAt("IERC20", DAI); 
    
    // Move 2000 DAI from DAI_WHALE to our contract by impersonating them
    const BALANCE_AMOUNT_DAI = ethers.utils.parseEther("2000"); 
    await hre.network.provider.request({
        method: "hardhat_impersonateAccount", 
        params: [DAI_WHALE]
    })
    const signer = await hre.ethers.getSigner(DAI_WHALE); 
    
    // Sends our contract 2000 DAI from DAI WHALE
    await token.connect(signer).transfer(flashLoanExample.address, BALANCE_AMOUNT_DAI); 
    
    // Request and execute a flash loan of 10,000 DAI from Aave 
    const txn = await flashLoanExample.createFlashLoan(DAI, 1000); 
    await txn.wait(); 

    // Checking contract remaining DAI balance to see how much is left
    const remainingBalance = await token.balanceOf(flashLoanExample.address); 

    // Remaning balance should be less than 2000 DAI since we had to pay premium 
    expect(remainingBalance.lt(BALANCE_AMOUNT_DAI)).to.equal(true); 
  }); 
}); 