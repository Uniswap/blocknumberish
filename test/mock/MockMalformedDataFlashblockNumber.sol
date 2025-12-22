// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title MockMalformedDataFlashblockNumber
/// @notice Mock implementation for testing
contract MockMalformedDataFlashblockNumber {
    /// @notice returns less than 32 bytes
    function getFlashblockNumber() external pure returns (uint128) {
        return uint128(0x1234567890abcdef);
    }
}
