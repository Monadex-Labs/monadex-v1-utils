// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

interface IMonadexV1Faucet {
    struct FaucetDetails {
        string tokenName;
        string tokenSymbol;
        uint256 decimals;
        string uri;
        uint256 interval;
        uint256 amountToEmitAtEachInterval;
    }

    event FaucetCreated(address indexed by, FaucetDetails indexed faucetDetails);
    event CollectedTokensFromFaucet(
        address by, address indexed token, uint256 indexed amount, address indexed receiver
    );
    event FaucetUpdated(
        address indexed by,
        uint256 indexed newInterval,
        uint256 indexed newAmountToCollectEachInterval
    );

    error IMonadexV1Faucet__InvalidFaucetCreationParams();
    error IMonadexV1Faucet__InvalidFaucet();
    error IMonadexV1Faucet__NotEligibleToCollectFromFaucet();
    error IMonadexV1Faucet__InvalidFaucetUpdateParams();

    function createFaucet(FaucetDetails memory _faucetDetails) external;

    function collectTokensFromFaucet(address _token, address _to) external;

    function updateFaucet(
        address _token,
        uint256 _interval,
        uint256 _amountToEmitAtEachInterval
    )
        external;

    function getFaucetDetails(address _token) external view returns (FaucetDetails memory);

    function getAllTokens() external view returns (address[] memory);

    function isEligibleToCollect(address _user, address _token) external view returns (bool);
}
