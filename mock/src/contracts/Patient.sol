// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {PATIENT, HEALTH_RECORD} from "src/domain/Patient.sol";
import {IPatient} from "src/interfaces/Patient/IPatient.sol";
import {EPatient} from "src/interfaces/Patient/EPatient.sol";

contract Patient is IPatient, EPatient {
    PATIENT private pt;

    function createHealtRecord(HEALTH_RECORD memory healthRecord_) external override notOnlyPatinet {
        pt.isPatients[msg.sender] = true;
        pt.healthRecords[msg.sender] = healthRecord_;

        emit CreateHealthRecordEvent(msg.sender);
    }

    function updateHealthRecord(HEALTH_RECORD memory healthRecord_) external onlyPatinet {
        pt.healthRecords[msg.sender] = healthRecord_;

        emit UpdateHealthRecordEvent(msg.sender);
    }

    function getHealthRecord() external override onlyPatinet returns(HEALTH_RECORD memory) {
        return _getHealthRecord(msg.sender);
    }

    function getHealthRecord(address patient_) external override onlyApprover(patient_) returns(HEALTH_RECORD memory) {
        return _getHealthRecord(patient_);
    }

    function _getHealthRecord(address patient_) internal returns(HEALTH_RECORD memory) {
        emit GetHealthRecordEvent(msg.sender, patient_);

        return pt.healthRecords[patient_];
    }

    function _approve(address doctor_) internal {
        pt.isApprovers[msg.sender][doctor_] = true;

        emit ApproveHealthRecordEvent(msg.sender, doctor_);
    }

    function _isPatient(address patient_) internal view returns(bool) {
        return pt.isPatients[patient_];
    }

    modifier onlyPatinet() {
        require(_isPatient(msg.sender), "Caller is not a patient");
        _;
    }

    modifier notOnlyPatinet() {
        require(!_isPatient(msg.sender), "Caller is already patient");
        _;
    }

    modifier onlyApprover(address patient_) {
        require(pt.isApprovers[patient_][msg.sender], "Caller is not a approver");
        _;
    }
}
