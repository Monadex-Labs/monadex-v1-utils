// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { WMND } from "../src/mocks/WMND.sol";
import { Script } from "forge-std/Script.sol";

contract DeployWMND is Script {
    WMND public wmnd;

    function run() public {
        vm.broadcast();
        wmnd = new WMND();
    }
}
