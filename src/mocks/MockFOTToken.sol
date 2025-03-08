// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import { IMockFOTToken } from "@src/interfaces/mocks/IMockFOTToken.sol";

/// @title MockFOTToken.
/// @author Monadex Labs -- mgnfy-view.
/// @notice A mock fee on transfer token contract where the fee can be changed anytime by
/// the admin.
contract MockFOTToken is ERC20, Ownable, IMockFOTToken {
    /// @dev Basis points.
    uint256 private constant BPS = 10_000;

    /// @dev The fee charged on each transfer (in bps).
    uint256 private s_fee;

    /// @notice Initializes the contract.
    /// @param _name The token name.
    /// @param _symbol The token symbol.
    /// @param _fee The fee charged on each transfer (in bps).
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _fee
    )
        ERC20(_name, _symbol)
        Ownable(msg.sender)
    {
        if (_fee >= BPS) revert MockFOTToken__InvalidFee(_fee);

        s_fee = _fee;
    }

    /// @notice Allows the admin to set the new fee.
    /// @param _newFee The new fee value in bps to be charged on each transfer.
    function setFee(uint256 _newFee) external {
        if (_newFee >= BPS) revert MockFOTToken__InvalidFee(_newFee);

        s_fee = _newFee;

        emit FeeSet(_newFee);
    }

    /// @notice Allows the admin to mint tokens to an arbitrary address.
    /// @param _to The address to mint tokens to.
    /// @param _amount The amount of tokens to mint.
    function mint(address _to, uint256 _amount) external onlyOwner {
        _mint(_to, _amount);
    }

    function _update(address _from, address _to, uint256 _value) internal override {
        uint256 feeAmount = _getFeeAmount(_value);

        super._update(_from, owner(), feeAmount);
        super._update(_from, _to, _value - feeAmount);
    }

    function _getFeeAmount(uint256 _amount) internal view returns (uint256) {
        return (_amount * s_fee) / BPS;
    }

    /// @notice Gets the fee value in bps to be charged on each transfer.
    function getFee() external view returns (uint256) {
        return s_fee;
    }
}
