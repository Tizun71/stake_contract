// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

error TransferFailed();
error NeedsMoreThanZero();

event Staked(address staker, uint256 amount);
event Unstaked(address staker, uint256 amount);
event ClaimRewards(address staker, uint256 amount);

contract NativeStaking is ReentrancyGuard {
    struct Staker {
        uint256 amountStaked;
        uint256 lastStakeTime;
    }

    mapping(address => Staker) public stakers;
    uint256 public constant REWARD_RATE = 2;

    constructor() {}

    // Core
    function stake() external payable {
        if (msg.value == 0) {
            revert NeedsMoreThanZero();
        }

        if (stakers[msg.sender].amountStaked > 0) {
            stakers[msg.sender].amountStaked += caculateReward();
        }

        stakers[msg.sender].lastStakeTime = block.timestamp;

        stakers[msg.sender].amountStaked += msg.value;

        emit Staked(msg.sender, msg.value);
    }

    function unstake() external nonReentrant {
        uint256 amount = stakers[msg.sender].amountStaked + caculateReward();
        stakers[msg.sender].lastStakeTime = block.timestamp;
        if (amount == 0) {
            revert NeedsMoreThanZero();
        }

        stakers[msg.sender].amountStaked = 0;

        (bool success, ) = msg.sender.call{value: amount}("");
        if (!success) {
            revert TransferFailed();
        }

        emit Unstaked(msg.sender, amount);
    }

    function claimRewards() external nonReentrant {
        uint256 amount = caculateReward();
        stakers[msg.sender].lastStakeTime = block.timestamp;
        if (amount == 0) {
            revert NeedsMoreThanZero();
        }

        (bool success, ) = msg.sender.call{value: amount}("");
        if (!success) {
            revert TransferFailed();
        }

        emit ClaimRewards(msg.sender, amount);
    }
    
    function caculateReward() public view returns (uint256){
        uint256 timeElapsed = block.timestamp - stakers[msg.sender].lastStakeTime;
        uint256 reward = (timeElapsed * REWARD_RATE * stakers[msg.sender].amountStaked) / 1000 / 1 days;
        return reward;
    }
}