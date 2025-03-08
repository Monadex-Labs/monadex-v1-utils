// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import { Script } from "forge-std/Script.sol";

import { MockFOTToken } from "@src/mocks/MockFOTToken.sol";

contract DeployWrappedMonad is Script {
    string public name;
    string public symbol;
    uint256 public fee;

    MockFOTToken public fotToken;

    function setUp() public {
        name = "Riptide";
        symbol = "RPT";
        fee = 1_000;
    }

    function run() public returns (MockFOTToken) {
        vm.broadcast();
        fotToken = new MockFOTToken(name, symbol, fee);

        return fotToken;
    }
}
