// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { WrappedMonad } from "../src/mocks/WrappedMonad.sol";
import { Script } from "forge-std/Script.sol";

contract DeployWrappedMonad is Script {
    WrappedMonad public wmnd;

    function run() public {
        vm.broadcast();
        wmnd = new WrappedMonad();
    }
}
