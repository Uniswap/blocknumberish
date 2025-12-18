// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @notice Minimal interface for interacting with Arbitrum system contracts
 */
interface IArbSys {
    /**
     * @notice Get Arbitrum block number (distinct from L1 block number; Arbitrum genesis block has block number 0)
     * @return block number as int
     */
    function arbBlockNumber() external view returns (uint256);
}

/// Mock Arbitrum syscall contract
contract MockArbSys is IArbSys {
    uint256 _blockNumber;

    /// @dev helper function to set the block number
    function setBlockNumber(uint256 blockNumber) external {
        _blockNumber = blockNumber;
    }

    /// @notice returns the block number
    function arbBlockNumber() external view returns (uint256) {
        return _blockNumber;
    }
}
