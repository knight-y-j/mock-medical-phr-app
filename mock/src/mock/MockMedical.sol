// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

struct PATIENT {
    mapping(address => bool) isPatients;
    mapping(address => HEALTH_RECORD) healthRecords;
    mapping(address => mapping(address => bool)) isApprovers;
}

struct HEALTH_RECORD {
        string name;
        uint8 age;
        BLOOD_TYPE blood;
}

enum BLOOD_TYPE {
    O,
    A,
    B,
    AB
}

interface IMockPatient {
    function createHealtRecord(HEALTH_RECORD memory healthRecord_) external;
    function getHealthRecord() external returns(HEALTH_RECORD memory);
    function getHealthRecord(address patient_) external returns(HEALTH_RECORD memory);
}

interface EMockPatient {
    event CreateHealthRecordEvent(address patient_);
    event UpdateHealthRecordEvent(address patient_);
    event GetHealthRecordEvent(address getter_, address patient_);
    event ApproveHealthRecordEvent(address indexed patient_, address indexed doctor_);
}

contract MockPatient is IMockPatient, EMockPatient {
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

struct HOSPITAL {
    uint256 hospitalID;
    uint256[] hospitals;
    mapping(uint256 => address) managers;
    mapping(address => bool) isManagers;
    mapping(uint256 => address[]) doctors;
    mapping(address => bool) isDoctors;
    mapping(uint256 => address[]) nurses;
    mapping(address => bool) isNurses;
}

interface IMockHospital {
    function createHospital() external;
    function registerDoctor(uint256 hospitalID_, address doctor_) external;
    function registerNurse(uint256 hospitalID_, address nurse_) external;
}

interface EMockHospital {
    event CreateHospitalEvent(address indexed manager_, uint256 hospitalID_);
    event RegisterDoctorEvent(address indexed manager_, address indexed doctor_, uint256 hospitalID_);
    event RegisterNurseEvent(address indexed manager_, address indexed nurse_, uint256 hospitalID_);
}

contract MockHospital is IMockHospital, EMockHospital {
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


interface EMockMedical {
    event TransferFromHealthRecordEvent(address indexed patient_, address indexed doctor_);
}

interface IMockMedical {
    function transferFrom(address doctor_) external;
}

contract MockMedical is MockHospital, MockPatient, EMockMedical {

    function transferFrom(address doctor_) external onlyPatinet {
        require(_isDoctor(doctor_), "Transfer address is not a doctor");

        _approve(doctor_);

        emit TransferFromHealthRecordEvent(msg.sender, doctor_);
    }
}
