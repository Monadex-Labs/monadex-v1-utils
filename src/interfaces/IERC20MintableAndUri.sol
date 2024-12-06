// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

interface IERC20MintableAndUri {
    function mint(address _to, uint256 _amount) external;

    function setUri(string memory _newUri) external;

    function uri() external view returns (string memory);
}
