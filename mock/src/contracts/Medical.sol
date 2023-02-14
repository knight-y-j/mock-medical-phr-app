// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Hospital} from "src/contracts/Hospital.sol";
import {Patient} from "src/contracts/Patient.sol";


interface EMedical {
    event TransferFromHealthRecordEvent(address indexed patient_, address indexed doctor_);
}

interface IMedical {
    function transferFrom(address doctor_) external;
}

contract Medical is Hospital, Patient, IMedical, EMedical {

    function transferFrom(address doctor_) external onlyPatinet {
        require(_isDoctor(doctor_), "Transfer address is not a doctor");

        _approve(doctor_);

        emit TransferFromHealthRecordEvent(msg.sender, doctor_);
    }
}
