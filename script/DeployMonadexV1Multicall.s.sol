// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { Script } from "forge-std/Script.sol";

import { MonadexV1Multicall } from "../src/multicall/MonadexV1Multicall.sol";

contract DeployMonadexV1Multicall is Script {
    MonadexV1Multicall public multicall;

    function run() public {
        vm.broadcast();
        multicall = new MonadexV1Multicall();
    }
}
