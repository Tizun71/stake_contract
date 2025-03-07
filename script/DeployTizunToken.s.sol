// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script} from "forge-std/Script.sol";
import {TizunToken} from "src/TizunToken.sol";

contract DeployTizunToken is Script {
    function run() external {
        uint privateKey = vm.envUint("DEV_PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        new TizunToken();
        vm.stopBroadcast();
    }
}