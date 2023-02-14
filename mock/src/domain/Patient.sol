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
