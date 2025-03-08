// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import { IMonadexV1Multicall } from "@src/interfaces/multicall/IMonadexV1Multicall.sol";

/// @title MonadexV1Multicall.
/// @author Monadex Labs -- mgnfy-view.
/// @notice Aggregate results from multiple read-only function calls. Inspired
/// by Makerdao's multicall2 contract.
contract MonadexV1Multicall is IMonadexV1Multicall {
    function aggregate(Call[] memory _calls) external returns (uint256, bytes[] memory) {
        uint256 blockNumber = block.number;
        bytes[] memory returnData = new bytes[](_calls.length);

        for (uint256 i = 0; i < _calls.length; i++) {
            (bool success, bytes memory ret) = _calls[i].target.call(_calls[i].callData);
            if (!success) revert MonadexV1Multicall__CallFailed();
            returnData[i] = ret;
        }

        return (blockNumber, returnData);
    }

    function blockAndAggregate(
        Call[] memory _calls
    )
        external
        returns (uint256, bytes32, Result[] memory)
    {
        return tryBlockAndAggregate(true, _calls);
    }

    function tryAggregate(
        bool _requireSuccess,
        Call[] memory _calls
    )
        public
        returns (Result[] memory)
    {
        Result[] memory returnData = new Result[](_calls.length);

        for (uint256 i = 0; i < _calls.length; i++) {
            (bool success, bytes memory ret) = _calls[i].target.call(_calls[i].callData);

            if (_requireSuccess) {
                if (!success) revert MonadexV1Multicall__CallFailed();
            }

            returnData[i] = Result(success, ret);
        }

        return returnData;
    }

    function tryBlockAndAggregate(
        bool _requireSuccess,
        Call[] memory _calls
    )
        public
        returns (uint256, bytes32, Result[] memory)
    {
        return (block.number, blockhash(block.number), tryAggregate(_requireSuccess, _calls));
    }

    function getBlockHash(uint256 _blockNumber) external view returns (bytes32) {
        return blockhash(_blockNumber);
    }

    function getBlockNumber() external view returns (uint256) {
        return block.number;
    }

    function getCurrentBlockCoinbase() external view returns (address) {
        return block.coinbase;
    }

    function getCurrentBlockDifficulty() external view returns (uint256) {
        return block.prevrandao;
    }

    function getCurrentBlockGasLimit() external view returns (uint256) {
        return block.gaslimit;
    }

    function getCurrentBlockTimestamp() external view returns (uint256) {
        return block.timestamp;
    }

    function getEthBalance(address _addr) external view returns (uint256) {
        return _addr.balance;
    }

    function getLastBlockHash() external view returns (bytes32) {
        return blockhash(block.number - 1);
    }
}
