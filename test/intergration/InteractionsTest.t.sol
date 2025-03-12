// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {DeployStakeToken} from "script/DeployStakeToken.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {StakeToken} from "src/StakeToken.sol";
import {StakeInteraction} from "script/Interactions.s.sol";
import {UnstakeInteraction} from "script/Interactions.s.sol";

contract InteractionTest is Test {
    IERC20 public stakeToken;
    StakeInteraction public stakeToContract;
    UnstakeInteraction public unstakeToContract;
    address public user;

    function setUp() external {
        DeployStakeToken deployer = new DeployStakeToken();
        stakeToken = IERC20(address(deployer.run()));

        stakeToContract = new StakeInteraction();
        unstakeToContract = new UnstakeInteraction();

        user = address(this);

        deal(address(stakeToken), user, 1000 * 10**18);
    }

    function test_stake_and_unstake() public {
        uint256 initialBalance = stakeToken.balanceOf(user);
        console.log("Initial Balance:", initialBalance);

        stakeToken.approve(address(stakeToContract), 10);

        // stake
        stakeToContract.stakeToContract(address(stakeToken));
        uint256 afterStakeBalance = stakeToken.balanceOf(user);
        console.log("Balance after staking:", afterStakeBalance);
        assert(afterStakeBalance < initialBalance);

        // Unstake
        unstakeToContract.unstakeFromContract(address(stakeToken));
        uint256 finalBalance = stakeToken.balanceOf(user);
        console.log("Final Balance:", finalBalance);
        assertEq(finalBalance, initialBalance);
    }
}
