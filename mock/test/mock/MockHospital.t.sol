// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {MockHospital} from "src/mock/MockMedical.sol";

contract TestMockHospital is Test {
    MockHospital mh;

    address hospitalManager;
    address hospitalDoctor;
    address hospitalNurse;
    uint256[] hospitalIDs;
    address[] hospitalDoctors;
    address[] hospitalNurses;

    function setUp() public {
        hospitalManager = makeAddr("Quees");
        hospitalDoctor = makeAddr("HumptyDumpty");
        hospitalNurse = makeAddr("Rabbit");

        mh = new MockHospital();

        vm.prank(hospitalManager);
        mh.createHospital();
    }

    function test_Success_MockHospital_createHospital() public {
        hospitalIDs = mh.getHospitals();

        for(uint256 i = 0; i < hospitalIDs.length;) {

            assertEq(hospitalIDs[i], 1);

            unchecked {
                i++;
            }
        }
    }

    function test_Fail_MockHospital_createHospital() public {
        vm.prank(hospitalManager);
        vm.expectRevert("Caller is already manager");
        mh.createHospital();
    }

    function test_Success_MockHospital_registDoctor() public {
        uint256 dummyID = 1;

        vm.prank(hospitalManager);
        mh.registerDoctor(dummyID, hospitalDoctor);

        vm.prank(hospitalManager);
        hospitalDoctors = mh.getDoctors(dummyID);

        for(uint256 i = 0; i < hospitalDoctors.length;) {

            assertEq(hospitalDoctors[i], hospitalDoctor);

            unchecked {
                i++;
            }
        }
    }

    function test_Fail_MockHospital_registDoctor() public {
        uint256 dummyID = 1;
        address dummyManager = makeAddr("King");

        vm.prank(dummyManager);
        vm.expectRevert("Caller is not a hospital manager");
        mh.registerDoctor(dummyID, hospitalDoctor);
    }

    function test_Success_MockHospital_registNurse() public {
        uint256 dummyID = 1;

        vm.prank(hospitalManager);
        mh.registerNurse(dummyID, hospitalNurse);

        vm.prank(hospitalManager);
        hospitalNurses = mh.getNurses(dummyID);

        for(uint256 i = 0; i < hospitalNurses.length;) {

            assertEq(hospitalNurses[i], hospitalNurse);

            unchecked {
                i++;
            }
        }
    }

    function test_Fail_MockHospital_registNurse() public {
        uint256 dummyID = 1;
        address dummyManager = makeAddr("King");

        vm.prank(dummyManager);
        vm.expectRevert("Caller is not a hospital manager");
        mh.registerNurse(dummyID, hospitalDoctor);
    }
}
