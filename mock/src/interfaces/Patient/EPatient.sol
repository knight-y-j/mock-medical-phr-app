// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface EPatient {
    event CreateHealthRecordEvent(address patient_);
    event UpdateHealthRecordEvent(address patient_);
    event GetHealthRecordEvent(address getter_, address patient_);
    event ApproveHealthRecordEvent(address indexed patient_, address indexed doctor_);
}
