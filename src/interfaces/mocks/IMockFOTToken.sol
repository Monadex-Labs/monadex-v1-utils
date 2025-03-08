// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

interface IMockFOTToken {
    event FeeSet(uint256 indexed newFee);

    error MockFOTToken__InvalidFee(uint256 newFee);

    function setFee(uint256 _newFee) external;
    function getFee() external view returns (uint256);
}
