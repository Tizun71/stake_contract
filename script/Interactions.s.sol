// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {StakeToken} from "src/StakeToken.sol";

contract StakeInteraction is Script {
    function stakeToContract(address stakeContractAddress) public {
        vm.startBroadcast();
        StakeToken(stakeContractAddress).stake(3);
        vm.stopBroadcast();

        console.log("Stake to contract success!");
    }
    function run() external {
        address contractAddress = DevOpsTools.get_most_recent_deployment("StakeToken", block.chainid);
        stakeToContract(contractAddress);
    }
}

contract UnstakeInteraction is Script {
    function unstakeFromContract(address stakeContractAddress) public {
        vm.startBroadcast();
        StakeToken(stakeContractAddress).unstake();
        vm.stopBroadcast();

        console.log("Unstake from contract success!");
    }
    function run() external {
        address contractAddress = DevOpsTools.get_most_recent_deployment("StakeToken", block.chainid);
        unstakeFromContract(contractAddress);
    }
}