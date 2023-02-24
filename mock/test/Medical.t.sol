// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {Medical} from "src/contracts/Medical.sol";
import {HEALTH_RECORD, BLOOD_TYPE} from "src/domain/Patient.sol";

contract TestMedical is Test {
    Medical md;

    address hospitalManager;
    address hospitalDoctor;
    address hospitalNurse;
    address patient;
    uint256 hospitalID;
    uint256[] hospitalIDs;
    address[] hospitalDoctors;
    address[] hospitalNurses;

    HEALTH_RECORD record =
        HEALTH_RECORD({
            name: "Jabberwock",
            age: 1,
            blood: BLOOD_TYPE.O,
            updatedAt: block.timestamp
        });

    function setUp() public {
        hospitalManager = makeAddr("Quees");
        hospitalDoctor = makeAddr("HumptyDumpty");
        hospitalNurse = makeAddr("Rabbit");
        patient = makeAddr("Jabberwock");

        md = new Medical();

        vm.prank(hospitalManager);
        md.createHospital();

        hospitalID = 1;

        vm.prank(hospitalManager);
        md.registerDoctor(hospitalID, hospitalDoctor);

        vm.prank(hospitalManager);
        md.registerNurse(hospitalID, hospitalNurse);

        vm.prank(patient);
        md.createHealtRecord(record);
    }

    /**
     * @dev Medical
     * - MockMedical contract
     */

    function test_Success_MockMedical_transferFrom() public {
        HEALTH_RECORD memory gotRecord;

        vm.prank(patient);
        md.transferFrom(hospitalDoctor);

        vm.prank(hospitalDoctor);
        gotRecord = md.getHealthRecord(address(patient));

        assertEq(gotRecord.name, record.name);
    }

    function test_Fail_MockMedical_transferFrom() public {
        address dummyDoctor = makeAddr("King");

        vm.prank(patient);
        vm.expectRevert("Transfer address is not a doctor");
        md.transferFrom(dummyDoctor);
    }

    function test_Fail_MockMedical_transferFrom_getHealthRecord() public {
        address dummyDoctor = makeAddr("King");
        HEALTH_RECORD memory gotRecord;

        vm.prank(patient);
        md.transferFrom(hospitalDoctor);

        vm.prank(dummyDoctor);
        vm.expectRevert("Caller is not a approver");
        gotRecord = md.getHealthRecord(address(patient));
    }

    /**
     * @dev Patient
     * - MockPatient contraact
     */

    function test_Success_MockPatient_createHealthRecord() public {
        HEALTH_RECORD memory gotRecord;

        vm.prank(patient);
        gotRecord = md.getHealthRecord();

        assertEq(gotRecord.name, record.name);
    }

    function test_Fail_MockPatient_createHealthRecord() public {
        vm.prank(patient);
        vm.expectRevert("Caller is already patient");
        md.createHealtRecord(record);
    }

    function test_Fail_MockPatient_getHealthRecord() public {
        HEALTH_RECORD memory gotRecord;
        address dummyPatient = makeAddr("King");

        vm.prank(dummyPatient);
        vm.expectRevert("Caller is not a patient");
        gotRecord = md.getHealthRecord();
    }

    function test_Success_MockPatient_updateHealthRecord() public {
        HEALTH_RECORD memory gotRecord;
        HEALTH_RECORD memory _record = HEALTH_RECORD({
            name: "Jabberwock",
            age: 2,
            blood: BLOOD_TYPE.A,
            updatedAt: block.timestamp
        });

        vm.prank(patient);
        md.updateHealthRecord(_record);

        vm.prank(patient);
        gotRecord = md.getHealthRecord();

        assertEq(gotRecord.age, _record.age);
    }

    function test_Fail_MockPatient_updateHealthRecord() public {
        address dummyPatient = makeAddr("King");
        HEALTH_RECORD memory _record = HEALTH_RECORD({
            name: "Jabberwock",
            age: 2,
            blood: BLOOD_TYPE.A,
            updatedAt: block.timestamp
        });

        vm.prank(dummyPatient);
        vm.expectRevert("Caller is not a patient");
        md.updateHealthRecord(_record);
    }

    /**
     * @dev Hospital
     * - MockHospital contract
     */

    function test_Success_MockHospital_createHospital() public {
        hospitalIDs = md.getHospitals();

        for (uint256 i = 0; i < hospitalIDs.length; ) {
            assertEq(hospitalIDs[i], 1);

            unchecked {
                i++;
            }
        }
    }

    function test_Fail_MockHospital_createHospital() public {
        vm.prank(hospitalManager);
        vm.expectRevert("Caller is already manager");
        md.createHospital();
    }

    function test_Success_MockHospital_registDoctor() public {
        uint256 dummyID = 1;

        vm.prank(hospitalManager);
        md.registerDoctor(dummyID, hospitalDoctor);

        vm.prank(hospitalManager);
        hospitalDoctors = md.getDoctors(dummyID);

        for (uint256 i = 0; i < hospitalDoctors.length; ) {
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
        md.registerDoctor(dummyID, hospitalDoctor);
    }

    function test_Success_MockHospital_registNurse() public {
        uint256 dummyID = 1;

        vm.prank(hospitalManager);
        md.registerNurse(dummyID, hospitalNurse);

        vm.prank(hospitalManager);
        hospitalNurses = md.getNurses(dummyID);

        for (uint256 i = 0; i < hospitalNurses.length; ) {
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
        md.registerNurse(dummyID, hospitalDoctor);
    }
}
