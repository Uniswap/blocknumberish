// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IFlashblockNumber {
    /**
     * @notice Get Unichain flashblock number
     * @return block number as int
     */
    function getFlashblockNumber() external view returns (uint256);
}

/// Mock Unichain flashblock number contract
contract MockFlashblockNumber is IFlashblockNumber {
    uint256 _flashblockNumber;

    /// @dev helper function to set the flashblock number
    function setFlashblockNumber(uint256 flashblockNumber) external {
        _flashblockNumber = flashblockNumber;
    }

    /// @notice returns the flashblock number
    function getFlashblockNumber() external view returns (uint256) {
        return _flashblockNumber;
    }
}
