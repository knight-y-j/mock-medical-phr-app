// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {MockMedical, MockPatient, MockHospital} from "src/mock/MockMedical.sol";

contract TestMockMedical is Test {
    MockMedical md;
    MockPatient mp;
    MockHospital mh;

    function setUp() public {
        mp = new MockPatient();
        mh = new MockHospital();
        md = new MockMedical();
    }
}
