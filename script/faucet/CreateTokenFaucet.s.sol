// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { Script } from "forge-std/Script.sol";

import { IMonadexV1Faucet } from "@src/interfaces/IMonadexV1Faucet.sol";

import { MonadexV1Faucet } from "@src/faucet/MonadexV1Faucet.sol";

contract CreateTokenFaucet is Script {
    MonadexV1Faucet public faucet;

    function setUp() public {
        faucet = MonadexV1Faucet(0x1E4dA2708afF7816aD0481BF427521E5fFD786a4);
    }

    function run() public {
        vm.startBroadcast();

        faucet.createFaucet(
            IMonadexV1Faucet.FaucetDetails({
                tokenName: "Moyaki",
                tokenSymbol: "MYK",
                decimals: 18,
                uri: "https://cdn.myanimelist.net/s/common/userimages/4633bdc3-c290-402b-88e4-18d51e38b5b2_225w?s=414ab6e6aafa99b3241edf07e4f0a8b6/",
                interval: 1 days,
                amountToEmitAtEachInterval: 100e18
            })
        );

        vm.stopBroadcast();
    }
}
