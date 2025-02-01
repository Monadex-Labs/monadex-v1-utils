// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { Script } from "forge-std/Script.sol";

import { MonadexV1Faucet } from "../src/faucet/MonadexV1Faucet.sol";

contract DeployMonadexV1Faucet is Script {
    MonadexV1Faucet public faucet;

    function run() public {
        vm.broadcast();
        faucet = new MonadexV1Faucet();
    }
}
