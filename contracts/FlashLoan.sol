// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
// import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

contract FlashLoan is FlashLoanSimpleReceiverBase, ReentrancyGuard {
    address payable public owner;
    
    constructor(address _addressProvider)
        FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) 
    {
        owner = payable(msg.sender);
    }

    function requestFlashLoan(uint256 _amount) external nonReentrant {
        address receiverAddress = address(this);
        address usdtAddress = msg.sender; // Replace with actual USDT address on the respective network
        bytes memory params = ""; // Optional parameters for custom logic
        uint16 referralCode = 0; // 

        // Triggering the flash loan
        POOL.flashLoanSimple(
            receiverAddress,
            usdtAddress,
            _amount,
            params,
            referralCode
        );
    }

    // This function is called by the Aave protocol after the flash loan is provided
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external nonReentrant returns (bool) {
        require(asset == msg.sender, "Invalid asset");

        // Example logic: Transfer USDT to a specified recipient
        address recipient = msg.sender;  // Replace with the address you want to send USDT to
        uint256 amountToSend = amount;  // Amount to send (same as borrowed)

        // Make sure the contract has enough USDT to send
        uint256 contractBalance = IERC20(asset).balanceOf(address(this));
        require(contractBalance >= amountToSend, "Insufficient balance");

        // Transfer USDT to the recipient
        IERC20(asset).transfer(recipient, amountToSend);

        // Repay the flash loan along with the premium
        uint256 totalAmount = amount + premium;
        IERC20(asset).approve(address(POOL), totalAmount);

        return true;
    }

    receive() external payable {}
}
