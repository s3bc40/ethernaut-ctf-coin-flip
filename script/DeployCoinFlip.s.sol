// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {CoinFlip} from "src/CoinFlip.sol";

contract DeployCoinFlip is Script {
    uint256 public constant SEPOLIA_ETH_CHAIN_ID = 11155111;
    uint256 public constant LOCAL_CHAIN_ID = 31337; // ANVIL

    function run() public {
        console.log("Deploying CoinFlip");
        deployCoinFlip();
        console.log("CoinFlip deployed");
    }

    function deployCoinFlip() public returns (CoinFlip) {
        vm.startBroadcast();
        CoinFlip coinFlip = new CoinFlip();
        vm.stopBroadcast();

        return coinFlip;
    }
}
