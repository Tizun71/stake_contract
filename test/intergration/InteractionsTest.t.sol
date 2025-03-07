// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;
import {Test, console} from "forge-std/Test.sol";
import {DeployStakeToken} from "script/DeployStakeToken.s.sol";
import {StakeToken} from "src/StakeToken.sol";
import {StakeInteraction} from "script/Interactions.s.sol";
import {UnstakeInteraction} from "script/Interactions.s.sol";
contract InteractionTest is Test {
    StakeToken public stakeToken;
    StakeInteraction public _stakeToContract;
    UnstakeInteraction public _unstakeToContract;

    function setUp() external {
        DeployStakeToken deployer = new DeployStakeToken();

        stakeToken = deployer.run();
        _stakeToContract = new StakeInteraction();
        _unstakeToContract = new UnstakeInteraction();
    }

    function test_stake_and_unstake() public {
        uint256 initialBalance = stakeToken.balanceOf(address(this));

        _stakeToContract.stakeToContract(address(stakeToken));

        uint256 afterStakeBalance = stakeToken.balanceOf(address(this));
        assert(afterStakeBalance < initialBalance);

        _unstakeToContract.unstakeFromContract(address(stakeToken));

        uint256 finalBalance = stakeToken.balanceOf(address(this));
        assertEq(finalBalance, initialBalance);
    }
}