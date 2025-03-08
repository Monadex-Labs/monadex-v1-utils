// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

interface IMonadexV1Multicall {
    struct Call {
        address target;
        bytes callData;
    }

    struct Result {
        bool success;
        bytes returnData;
    }

    error MonadexV1Multicall__CallFailed();

    function aggregate(
        Call[] memory _calls
    )
        external
        returns (uint256 blockNumber, bytes[] memory returnData);

    function blockAndAggregate(
        Call[] memory _calls
    )
        external
        returns (uint256 blockNumber, bytes32 blockHash, Result[] memory returnData);

    function tryAggregate(
        bool _requireSuccess,
        Call[] memory _calls
    )
        external
        returns (Result[] memory returnData);

    function tryBlockAndAggregate(
        bool _requireSuccess,
        Call[] memory _calls
    )
        external
        returns (uint256 blockNumber, bytes32 blockHash, Result[] memory returnData);

    function getBlockHash(uint256 _blockNumber) external view returns (bytes32 blockHash);

    function getBlockNumber() external view returns (uint256 blockNumber);

    function getCurrentBlockCoinbase() external view returns (address coinbase);

    function getCurrentBlockDifficulty() external view returns (uint256 difficulty);

    function getCurrentBlockGasLimit() external view returns (uint256 gaslimit);

    function getCurrentBlockTimestamp() external view returns (uint256 timestamp);

    function getEthBalance(address _addr) external view returns (uint256 balance);

    function getLastBlockHash() external view returns (bytes32 blockHash);
}
