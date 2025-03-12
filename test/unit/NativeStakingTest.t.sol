// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {NativeStaking} from "src/NativeStaking.sol";

contract NativeStakingTest is Test {
    NativeStaking public nativeStaking;
    address public constant USER = address(1);
    address public constant USER2 = address(2);
    function setUp() external {
        nativeStaking = new NativeStaking();
        vm.deal(USER, 100 ether);
        vm.deal(USER2, 300 ether);
        vm.prank(USER2);
        nativeStaking.stake{value: 300 ether}();
    }

    function test_setUp() public view {
        console.log(address(nativeStaking));
    }

    function test_stake() public {
        uint256 USERBalanceBeforeStake = USER.balance;
        vm.prank(USER);
        nativeStaking.stake{value: 5 ether}();
        uint256 USERBalanceAfterStake = USER.balance;
        assertEq(USERBalanceBeforeStake - 5 ether, USERBalanceAfterStake);
    }

    function test_caculateReward() public {
        vm.prank(USER);
        nativeStaking.stake{value: 5 ether}();
        vm.warp(block.timestamp + 1 hours);
        vm.prank(USER);
        console.log(nativeStaking.caculateReward());
    }

    function test_unstake() public {
        uint256 USERBalanceBefore = USER.balance;
        vm.prank(USER);
        nativeStaking.stake{value: 5 ether}();
        vm.warp(block.timestamp + 1 hours);

        vm.prank(USER);
        uint256 reward = nativeStaking.caculateReward();

        vm.prank(USER);
        nativeStaking.unstake();

        uint256 USERBalanceAfter = USER.balance;
        assertEq(USERBalanceBefore + reward, USERBalanceAfter);
    }

    function test_claimRewards() public {
        uint256 USERBalanceBefore = USER.balance;
        vm.prank(USER);
        nativeStaking.stake{value: 5 ether}();
        vm.warp(block.timestamp + 1 hours);

        vm.prank(USER);
        uint256 reward = nativeStaking.caculateReward();
        console.log(reward);
        vm.prank(USER);
        nativeStaking.claimRewards();

        uint256 USERBalanceAfter = USER.balance;
        assertEq(USERBalanceBefore + reward - 5 ether, USERBalanceAfter);
    }
}