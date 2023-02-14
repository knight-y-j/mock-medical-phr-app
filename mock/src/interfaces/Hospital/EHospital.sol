// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface EHospital {
    event CreateHospitalEvent(address indexed manager_, uint256 hospitalID_);
    event RegisterDoctorEvent(address indexed manager_, address indexed doctor_, uint256 hospitalID_);
    event RegisterNurseEvent(address indexed manager_, address indexed nurse_, uint256 hospitalID_);
}
