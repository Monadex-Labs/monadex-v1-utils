// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract MonadexV1Multicall {
    struct Call {
        address target;
        uint256 gasLimit;
        bytes callData;
    }

    struct Result {
        bool success;
        uint256 gasUsed;
        bytes returnData;
    }

    function getCurrentBlockTimestamp() public view returns (uint256 timestamp) {
        timestamp = block.timestamp;
    }

    function getEthBalance(address _addr) public view returns (uint256 balance) {
        balance = _addr.balance;
    }

    function multicall(Call[] memory _calls)
        public
        returns (uint256 blockNumber, Result[] memory returnData)
    {
        blockNumber = block.number;
        returnData = new Result[](_calls.length);

        for (uint256 i = 0; i < _calls.length; i++) {
            (address target, uint256 gasLimit, bytes memory callData) =
                (_calls[i].target, _calls[i].gasLimit, _calls[i].callData);
            uint256 gasLeftBefore = gasleft();
            (bool success, bytes memory ret) = target.call{ gas: gasLimit }(callData);
            uint256 gasUsed = gasLeftBefore - gasleft();
            returnData[i] = Result(success, gasUsed, ret);
        }
    }
}
