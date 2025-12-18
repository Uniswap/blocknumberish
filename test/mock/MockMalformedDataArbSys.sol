// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title MockMalformedDataArbSys
/// @notice Mock implementation for testing and gas metering
contract MockMalformedDataArbSys {
    /// @notice returns less than 32 bytes
    function arbBlockNumber() external pure returns (uint128) {
        return uint128(0x1234567890abcdef);
    }
}
