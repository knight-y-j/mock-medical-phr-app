// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import {Medical} from "src/contracts/Medical.sol";

contract MedicalScript is Script {
    Medical md;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        md = new Medical();

        vm.stopBroadcast();
    }
}
