// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {HEALTH_RECORD} from "src/domain/Patient.sol";

interface IPatient {
    function createHealtRecord(HEALTH_RECORD memory healthRecord_) external;
    function getHealthRecord() external returns(HEALTH_RECORD memory);
    function getHealthRecord(address patient_) external returns(HEALTH_RECORD memory);
}
