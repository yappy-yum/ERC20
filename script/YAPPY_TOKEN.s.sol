// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {YAPPY_TOKEN} from "../src/YAPPY_TOKEN.sol";

contract DeployYAPPY_TOKEN is Script {
    
    uint public constant INITIAL_SUPPLY = 100 ether;
    
    function run() external returns (YAPPY_TOKEN) {
        // owner of this ERC20 token: address(123)
        vm.deal(address(123), 0 ether);
        
        vm.startBroadcast(address(123));
        YAPPY_TOKEN yappy = new YAPPY_TOKEN(INITIAL_SUPPLY);
        vm.stopBroadcast();

        return yappy;
    }
}