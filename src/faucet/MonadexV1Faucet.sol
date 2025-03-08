// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import { AccessControl } from "@openzeppelin/access/AccessControl.sol";

import { IERC20MintableAndUri } from "@src/interfaces/faucet/IERC20MintableAndUri.sol";
import { IMonadexV1Faucet } from "@src/interfaces/faucet/IMonadexV1Faucet.sol";

import { ERC20MintableAndUri } from "@src/faucet/ERC20MintableAndUri.sol";

/// @title MonadexV1Faucet.
/// @author Monadex Labs -- mgnfy-view.
/// @notice A simple faucet implementation which allows faucet managers to create new tokens
/// and their respective faucets with custom drip rates.
contract MonadexV1Faucet is AccessControl, IMonadexV1Faucet {
    bytes32 public constant FAUCET_MANAGER_ROLE = keccak256("FAUCET_MANAGER_ROLE");

    mapping(bytes32 faucetTokenMetadataHash => bool used) private s_faucetTokenMetadataHash;
    mapping(address token => FaucetDetails faucetDetails) private s_faucetDetails;
    mapping(address user => mapping(address token => uint256 lastCollectedAt)) private
        s_faucetUserData;
    address[] private s_allTokens;

    /// @notice Provides the default admin role and faucet manger role to the deployer.
    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);

        _setRoleAdmin(FAUCET_MANAGER_ROLE, DEFAULT_ADMIN_ROLE);
        _grantRole(FAUCET_MANAGER_ROLE, msg.sender);
    }

    /// @notice Allows faucet managers to create new tokens with custom parameters.
    /// @param _faucetDetails The faucet details which includes token metadata and drip rate.
    function createFaucet(
        FaucetDetails memory _faucetDetails
    )
        external
        onlyRole(FAUCET_MANAGER_ROLE)
    {
        bytes32 faucetTokenMetadataHash =
            _getFaucetTokenMetadataHash(_faucetDetails.tokenName, _faucetDetails.tokenSymbol);
        if (
            s_faucetTokenMetadataHash[faucetTokenMetadataHash] || _faucetDetails.interval == 0
                || _faucetDetails.amountToEmitAtEachInterval == 0
        ) revert IMonadexV1Faucet__InvalidFaucetCreationParams();

        ERC20MintableAndUri token = new ERC20MintableAndUri(
            _faucetDetails.tokenName, _faucetDetails.tokenSymbol, _faucetDetails.uri
        );
        s_faucetDetails[address(token)] = _faucetDetails;
        s_faucetTokenMetadataHash[faucetTokenMetadataHash] = true;
        s_allTokens.push(address(token));

        emit FaucetCreated(msg.sender, _faucetDetails);
    }

    /// @notice Allows anyone to collect tokens from the faucet if they are eligibile (i.e., enough time
    /// has passed since their last collection).
    /// @param _token The token to collect.
    /// @param _to The address to direct the tokens to.
    function collectTokensFromFaucet(address _token, address _to) external {
        FaucetDetails memory faucetDetails = s_faucetDetails[_token];
        if (faucetDetails.interval == 0) revert IMonadexV1Faucet__InvalidFaucet();

        bool eligible = isEligibleToCollect(msg.sender, _token);
        if (!eligible) revert IMonadexV1Faucet__NotEligibleToCollectFromFaucet();

        s_faucetUserData[msg.sender][_token] = block.timestamp;
        IERC20MintableAndUri(_token).mint(_to, faucetDetails.amountToEmitAtEachInterval);

        emit CollectedTokensFromFaucet(
            msg.sender, _token, faucetDetails.amountToEmitAtEachInterval, _to
        );
    }

    /// @notice Allows faucet mangers to update the drip rate of a token faucet.
    /// @param _token The token's address.
    /// @param _interval The interval after which faucet drips the base amount.
    /// @param _amountToEmitAtEachInterval The amount of tokens to emit each interval.
    function updateFaucet(
        address _token,
        uint256 _interval,
        uint256 _amountToEmitAtEachInterval
    )
        external
        onlyRole(FAUCET_MANAGER_ROLE)
    {
        if (_interval == 0 || _amountToEmitAtEachInterval == 0) {
            revert IMonadexV1Faucet__InvalidFaucetUpdateParams();
        }

        FaucetDetails memory faucetDetails = s_faucetDetails[_token];
        if (faucetDetails.interval == 0) revert IMonadexV1Faucet__InvalidFaucet();
        s_faucetDetails[_token].interval = _interval;
        s_faucetDetails[_token].amountToEmitAtEachInterval = _amountToEmitAtEachInterval;

        emit FaucetUpdated(msg.sender, _interval, _amountToEmitAtEachInterval);
    }

    /// @notice Hashes the abi encoded hashes of token name and symbol.
    /// @param _name The token name.
    /// @param _symbol The token symbol.
    /// @return The token metadata hash.
    function _getFaucetTokenMetadataHash(
        string memory _name,
        string memory _symbol
    )
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encode(keccak256(bytes(_name)), keccak256(bytes(_symbol))));
    }

    /// @notice Gets the faucet details for a token.
    /// @param _token The token's address.
    /// @return The faucet details.
    function getFaucetDetails(address _token) external view returns (FaucetDetails memory) {
        return s_faucetDetails[_token];
    }

    /// @notice Gets all the token faucets created so far.
    /// @return A list of token faucets created so far.
    function getAllTokens() external view returns (address[] memory) {
        return s_allTokens;
    }

    /// @notice Checks if the given user is eligible to collect tokens from the faucet or not.
    /// @param _user The user's address.
    /// @param _token The token's address.
    /// @return A boolean indicating eligibility.
    function isEligibleToCollect(address _user, address _token) public view returns (bool) {
        FaucetDetails memory faucetDetails = s_faucetDetails[_token];
        uint256 lastCollectedAt = s_faucetUserData[_user][_token];

        bool eligible;
        if (lastCollectedAt == 0 && faucetDetails.interval != 0) {
            eligible = true;
        } else if (block.timestamp - lastCollectedAt >= faucetDetails.interval) {
            eligible = true;
        }

        return eligible;
    }
}
