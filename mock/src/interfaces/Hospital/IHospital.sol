// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IHospital {
    function createHospital() external;
    function registerDoctor(uint256 hospitalID_, address doctor_) external;
    function registerNurse(uint256 hospitalID_, address nurse_) external;
}
