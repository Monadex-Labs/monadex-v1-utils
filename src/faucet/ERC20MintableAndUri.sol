// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { Ownable } from "@openzeppelin/access/Ownable.sol";
import { ERC20 } from "@openzeppelin/token/ERC20/ERC20.sol";

import { IERC20MintableAndUri } from "../interfaces/IERC20MintableAndUri.sol";

/// @title ERC20MintableAndUri.
/// @author Monadex Labs -- mgnfy-view.
/// @notice A modified ERC20 contract which allows setting a uri, has no
/// supply cap and allows the owner to mint as many tokens to any address desired.
contract ERC20MintableAndUri is Ownable, ERC20, IERC20MintableAndUri {
    string private s_uri;

    event UriSet(string indexed newUri);

    /// @notice Sets the token metadata and owner.
    /// @param _name The name of the token.
    /// @param _symbol The symbol of the token.
    constructor(
        string memory _name,
        string memory _symbol,
        string memory _uri
    )
        Ownable(msg.sender)
        ERC20(_name, _symbol)
    {
        s_uri = _uri;
    }

    /// @notice Allows the owner to mint arbitrary amount of tokens to a given address.
    /// @param _to The recipient of the tokens.
    /// @param _amount The amount of tokens to mint.
    function mint(address _to, uint256 _amount) external onlyOwner {
        _mint(_to, _amount);
    }

    /// @notice Allows the owner to set the new uri for the token.
    /// @param _newUri The new uri for the token.
    function setUri(string memory _newUri) external onlyOwner {
        s_uri = _newUri;

        emit UriSet(_newUri);
    }

    /// @notice Gets the token uri.
    /// @return The token uri.
    function uri() external view returns (string memory) {
        return s_uri;
    }
}
