// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { IWrappedMonad } from "../interfaces/IWrappedMonad.sol";

/// @title WrappedMonad.
/// @author Monadex Labs -- mgnfy-view.
/// @notice A mock contract for the wrapped monad token on Monad chain, equivalent to
/// the wrapped ETH token on Ethereum.
contract WrappedMonad {
    string private constant s_name = "Wrapped Monad";
    string private constant s_symbol = "WMND";
    uint8 private constant s_decimals = 18;

    event Approval(address indexed src, address indexed guy, uint256 wad);
    event Transfer(address indexed src, address indexed dst, uint256 wad);
    event Deposit(address indexed dst, uint256 wad);
    event Withdrawal(address indexed src, uint256 wad);

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    /// @notice Allows the deployer to deposit native monad to receive wrapped
    /// monad tokens.
    constructor() payable {
        deposit();
    }

    /// @notice Allows a user to withdraw their native monad tokens
    /// by burning their wrapped monad tokens.
    /// @param _wad The amount of wrapped monad tokens to withdraw.
    function withdraw(uint256 _wad) external {
        require(balanceOf[msg.sender] >= _wad);
        balanceOf[msg.sender] -= _wad;
        payable(msg.sender).transfer(_wad);

        emit Withdrawal(msg.sender, _wad);
    }

    /// @notice Gets the total amount of wrapped monad tokens minted
    /// so far.
    /// @return The token's total supply.
    function totalSupply() external view returns (uint256) {
        return address(this).balance;
    }

    /// @notice Allows the spender to spend tokens on behlaf of the allowance provider.
    /// @param _guy The spender of the allownace.
    /// @param _wad The provided allowance.
    /// @return A boolean indicating whether the approval succeeded or not.
    function approve(address _guy, uint256 _wad) external returns (bool) {
        allowance[msg.sender][_guy] = _wad;

        emit Approval(msg.sender, _guy, _wad);

        return true;
    }

    /// @notice Allows the user to transfer tokens to another user.
    /// @param _dst The recipient of the tokens.
    /// @param _wad The amount of tokens to send.
    /// @return A boolean indicating whether the transfer succeeded or not.
    function transfer(address _dst, uint256 _wad) external returns (bool) {
        return transferFrom(msg.sender, _dst, _wad);
    }

    /// @notice Allows the deployer to deposit native monad to receive wrapped
    /// monad tokens.
    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;

        emit Deposit(msg.sender, msg.value);
    }

    /// @notice Allows the owner/allowed spender to transfer tokens.
    /// @param src The sender of the tokens.
    /// @param _dst The recipient of the tokens.
    /// @param _wad The amount of tokens to send.
    /// @return A boolean indicating whether the transfer succeeded or not.
    function transferFrom(address src, address _dst, uint256 _wad) public returns (bool) {
        require(balanceOf[src] >= _wad);

        if (src != msg.sender && allowance[src][msg.sender] != 0) {
            require(allowance[src][msg.sender] >= _wad);
            allowance[src][msg.sender] -= _wad;
        }

        balanceOf[src] -= _wad;
        balanceOf[_dst] += _wad;

        emit Transfer(src, _dst, _wad);

        return true;
    }

    /// @notice Gets the name of the the token.
    /// @return The token name.
    function name() external pure returns (string memory) {
        return s_name;
    }

    /// @notice Gets the symbol of the the token.
    /// @return The token symbol.
    function symbol() external pure returns (string memory) {
        return s_symbol;
    }

    /// @notice Gets the decimals of the the token.
    /// @return The token's decimals.
    function decimals() external pure returns (uint256) {
        return s_decimals;
    }
}
