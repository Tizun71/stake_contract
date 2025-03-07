// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script} from "forge-std/Script.sol";
import {StakeToken} from "src/StakeToken.sol";

contract DeployStakeToken is Script {
    function run() external returns (StakeToken){
        uint privateKey = vm.envUint("DEV_PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        StakeToken stakeToken = new StakeToken(vm.envAddress("TOKEN_URL"));
        vm.stopBroadcast();
        return stakeToken;
    }
}