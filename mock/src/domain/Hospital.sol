// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

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
