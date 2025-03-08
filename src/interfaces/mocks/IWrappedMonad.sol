// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

interface IWrappedMonad {
    function withdraw(uint256 _wad) external;

    function totalSupply() external;

    function approve(address _guy, uint256 _wad) external;

    function transfer(address _dst, uint256 _wad) external;

    function deposit() external;

    function transferFrom(address src, address _dst, uint256 _wad) external;

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint256);
}
