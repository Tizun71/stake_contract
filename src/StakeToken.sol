// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

error TransferFailed();
error NeedsMoreThanZero();
contract StakeToken is ReentrancyGuard{
    IERC20 public stakingToken;

    struct Staker {
        uint256 amountStaked;
        uint256 lastStakeTime;
    }

    mapping(address => Staker) public stakers;
    uint256 public constant REWARD_RATE = 2;

    constructor(address s_Token){
        stakingToken = IERC20(s_Token);
    }

    //Core
    function stake(uint256 amount) external{
        if (amount <= 0){
            revert NeedsMoreThanZero();
        }

        bool success = stakingToken.transferFrom(msg.sender, address(this), amount);

        if (!success){
            revert TransferFailed();
        }

        if (stakers[msg.sender].amountStaked > 0){
            claimRewards();
        }

        stakers[msg.sender].amountStaked += amount;
        stakers[msg.sender].lastStakeTime = block.timestamp;
    }

    function unstake() external {
        uint256 amount = stakers[msg.sender].amountStaked;
        if (amount <= 0){
            revert NeedsMoreThanZero();
        }

        claimRewards();
        stakers[msg.sender].amountStaked = 0;

        bool success = stakingToken.transfer(msg.sender, amount);

        if (!success){
            revert TransferFailed();
        }
    }

    function claimRewards() public{
        if (stakers[msg.sender].amountStaked < 0){
            revert NeedsMoreThanZero();
        }
        
        uint256 timeElapsed = block.timestamp - stakers[msg.sender].lastStakeTime;
        uint256 reward = timeElapsed * REWARD_RATE / 1000;
        
        bool success = stakingToken.transfer(msg.sender, reward);
        if (!success) {
            revert TransferFailed(); 
        }
        stakers[msg.sender].lastStakeTime = block.timestamp;
    }
}