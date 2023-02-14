// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {MockPatient, HEALTH_RECORD, BLOOD_TYPE} from "src/mock/MockMedical.sol";

contract TestMockMedical is Test {
    MockPatient mp;

    address patient;

    HEALTH_RECORD record = HEALTH_RECORD({
        name: "Jabberwock",
        age: 1,
        blood: BLOOD_TYPE.O
    });

    function setUp() public {
        patient = makeAddr("Jabberwock");

        mp = new MockPatient();

        vm.prank(patient);
        mp.createHealtRecord(record);
    }

    /**
     * @dev Patient
     * - MockPatient contraact
    */

    function test_Success_MockPatient_createHealthRecord() public {
        HEALTH_RECORD memory gotRecord;

        vm.prank(patient);
        gotRecord = mp.getHealthRecord();

        assertEq(gotRecord.name, record.name);
    }

    function test_Fail_MockPatient_createHealthRecord() public {
        vm.prank(patient);
        vm.expectRevert("Caller is already patient");
        mp.createHealtRecord(record);
    }

    function test_Fail_MockPatient_getHealthRecord() public {
        HEALTH_RECORD memory gotRecord;
        address dummyPatient = makeAddr("King");

        vm.prank(dummyPatient);
        vm.expectRevert("Caller is not a patient");
        gotRecord = mp.getHealthRecord();
    }

    function test_Success_MockPatient_updateHealthRecord() public {
        HEALTH_RECORD memory gotRecord;
        HEALTH_RECORD memory _record = HEALTH_RECORD({
            name: "Jabberwock",
            age: 2,
            blood: BLOOD_TYPE.A
        });

        vm.prank(patient);
        mp.updateHealthRecord(_record);

        vm.prank(patient);
        gotRecord = mp.getHealthRecord();

        assertEq(gotRecord.age, _record.age);
    }

    function test_Fail_MockPatient_updateHealthRecord() public {
        address dummyPatient = makeAddr("King");
        HEALTH_RECORD memory _record = HEALTH_RECORD({
            name: "Jabberwock",
            age: 2,
            blood: BLOOD_TYPE.A
        });

        vm.prank(dummyPatient);
        vm.expectRevert("Caller is not a patient");
        mp.updateHealthRecord(_record);
    }
}
