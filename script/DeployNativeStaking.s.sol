// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script} from "forge-std/Script.sol";
import {NativeStaking} from "src/NativeStaking.sol";

contract DeployNativeStaking is Script {
    function run() external returns (NativeStaking){
        uint privateKey = vm.envUint("DEV_PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        NativeStaking nativeStaking = new NativeStaking();
        vm.stopBroadcast();
        return nativeStaking;
    }
}