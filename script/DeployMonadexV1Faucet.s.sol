// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { MonadexV1Faucet } from "../src/faucet/MonadexV1Faucet.sol";
import { Script } from "forge-std/Script.sol";

contract DeployMonadexV1Faucet is Script {
    MonadexV1Faucet public faucet;

    function run() public {
        vm.broadcast();
        faucet = new MonadexV1Faucet();
    }
}
