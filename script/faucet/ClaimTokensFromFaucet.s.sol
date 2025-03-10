// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import { Script } from "forge-std/Script.sol";

import { IMonadexV1Faucet } from "@src/interfaces/faucet/IMonadexV1Faucet.sol";

import { MonadexV1Faucet } from "@src/faucet/MonadexV1Faucet.sol";

contract ClaimTokensFromFaucet is Script {
    MonadexV1Faucet public faucet;
    address public token;
    address public to;

    function setUp() public {
        faucet = MonadexV1Faucet(0x1E4dA2708afF7816aD0481BF427521E5fFD786a4);
        token = address(1);
        to = 0xE5261f469bAc513C0a0575A3b686847F48Bc6687;
    }

    function run() public {
        vm.startBroadcast();

        faucet.collectTokensFromFaucet(token, to);

        vm.stopBroadcast();
    }
}
