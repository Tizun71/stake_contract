// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Test, console} from "forge-std/Test.sol";
import {StakeToken} from "src/StakeToken.sol";

contract StakeTokenTest is Test {
    StakeToken public stakeToken;
    IERC20 tizunToken = IERC20(payable(0x5FbDB2315678afecb367f032d93F642f64180aa3));
    address public constant HOST = address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
    address public constant USER_Tizun = address(0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
    
    function setUp() external{
        stakeToken = new StakeToken(0x5FbDB2315678afecb367f032d93F642f64180aa3);
        vm.startPrank(HOST);
        tizunToken.approve(address(stakeToken), 100);
        stakeToken.stake(100);
        vm.stopPrank();
    }

    function test_setUp() public view {
        console.log(address(stakeToken));
    }

    function test_stake() public {
        uint256 STAKE_AMOUNT = 5;
        console.log("User: Tizun");
        vm.startPrank(USER_Tizun);
        uint256 balanceBeforeStake = tizunToken.balanceOf(USER_Tizun);
        console.log("balance before stake: " , balanceBeforeStake);
        tizunToken.approve(address(stakeToken), STAKE_AMOUNT);
        stakeToken.stake(STAKE_AMOUNT);
        uint256 balanceAfterStake = tizunToken.balanceOf(USER_Tizun);
        console.log("balance after stake: " , balanceAfterStake);
        vm.stopPrank();
        assertEq(balanceBeforeStake - STAKE_AMOUNT, balanceAfterStake);
    }

    function test_unstake() public {
        uint256 STAKE_AMOUNT = 5;
        uint256 TIMELOCK_DURATION = 1 hours;
        vm.startPrank(USER_Tizun);
        tizunToken.approve(address(stakeToken), STAKE_AMOUNT);
        stakeToken.stake(STAKE_AMOUNT);
        uint256 balanceBeforeUnstake = tizunToken.balanceOf(USER_Tizun);
        console.log("balance before unstake: " , balanceBeforeUnstake);
        vm.warp(block.timestamp + TIMELOCK_DURATION);
        stakeToken.unstake();
        uint256 balanceAfterUnstake = tizunToken.balanceOf(USER_Tizun);
        console.log("balance after unstake: " , balanceAfterUnstake);
        vm.stopPrank();
    }

    function test_claimRewards() public {
        uint256 STAKE_AMOUNT = 5;
        uint256 TIMELOCK_DURATION = 1 hours;
        vm.startPrank(USER_Tizun);
        tizunToken.approve(address(stakeToken), STAKE_AMOUNT);
        stakeToken.stake(STAKE_AMOUNT);
        uint256 balanceBeforeClaimed = tizunToken.balanceOf(USER_Tizun);
        console.log("balance before claim reward: " , balanceBeforeClaimed);
        vm.warp(block.timestamp + TIMELOCK_DURATION);
        stakeToken.claimRewards();
        uint256 balanceAfterClaimed = tizunToken.balanceOf(USER_Tizun);
        console.log("balance after claim reward: " , balanceAfterClaimed);
        vm.stopPrank();
    }
}