// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {HOSPITAL} from "src/domain/Hospital.sol";
import {IHospital} from "src/interfaces/Hospital/IHospital.sol";
import {EHospital} from "src/interfaces/Hospital/EHospital.sol";

contract Hospital is IHospital, EHospital {
    HOSPITAL private hp;

    function createHospital() external override notOnlyManager {
        hp.hospitalID++;
        uint256 hospitalID_ = getHospitalID();

        hp.hospitals.push(hospitalID_);

        hp.managers[hospitalID_] = msg.sender;
        hp.isManagers[msg.sender] = true;

        emit CreateHospitalEvent(msg.sender, hospitalID_);
    }

    function getHospitalID() internal view returns(uint256) {
        return hp.hospitalID;
    }

    function getHospitals() external view returns(uint256[] memory) {
        return hp.hospitals;
    }

    function registerDoctor(uint256 hospitalID_, address doctor_) external override onlyManager(hospitalID_) {
        hp.doctors[hospitalID_].push(doctor_);

        hp.isDoctors[doctor_] = true;

        emit RegisterDoctorEvent(msg.sender, doctor_, hospitalID_);
    }

    function getDoctors(uint256 hospitalID_) external view onlyManager(hospitalID_) returns(address[] memory) {
        return hp.doctors[hospitalID_];
    }

    function registerNurse(uint256 hospitalID_, address nurse_) external override onlyManager(hospitalID_) {
        hp.nurses[hospitalID_].push(nurse_);

        hp.isNurses[nurse_] = true;

        emit RegisterNurseEvent(msg.sender, nurse_, hospitalID_);
    }

    function getNurses(uint256 hospitalID_) external view onlyManager(hospitalID_) returns(address[] memory) {
        return hp.nurses[hospitalID_];
    }

    function _isDoctor(address doctor_) internal view returns(bool) {
        return hp.isDoctors[doctor_];
    }

    modifier notOnlyManager() {
        require(!hp.isManagers[msg.sender], "Caller is already manager");
        _;
    }

    modifier onlyManager(uint256 hospitalID_) {
        require(hp.managers[hospitalID_] == msg.sender, "Caller is not a hospital manager");
        _;
    }
}
