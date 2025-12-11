// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title BlockNumberish
/// A helper contract to get the current block number on different chains
/// inspired by https://github.com/ProjectOpenSea/tstorish/blob/main/src/Tstorish.sol
contract BlockNumberish {
    /// @notice Internal view function to get the current block number.
    /// @dev Returns Arbitrum block number on Arbitrum One, standard block number elsewhere.
    function() view returns (uint256) internal immutable _getBlockNumberish;

    // Arbitrum One chain ID.
    uint256 private constant ARB_CHAIN_ID = 42_161;

    // Arbitrum system contract address for block number queries.
    address private constant ARB_SYS_ADDRESS = 0x0000000000000000000000000000000000000064;

    constructor() {
        // Set the function to use based on chainid
        if (block.chainid == ARB_CHAIN_ID) {
            _getBlockNumberish = _getBlockNumberSyscall;
        } else {
            _getBlockNumberish = _getBlockNumber;
        }
    }

    /// @dev Private function to get the block number on arbitrum
    function _getBlockNumberSyscall() private view returns (uint256 blockNumber) {
        assembly {
            // Store the function selector for arbBlockNumber() (0xa3b1b31d) at memory position 0
            // from: https://github.com/OffchainLabs/nitro-precompile-interfaces/blob/f49a4889b486fd804a7901203f5f663cfd1581c8/ArbSys.sol#L17
            mstore(0x00, 0xa3b1b31d00000000000000000000000000000000000000000000000000000000)

            // staticcall(gas, address, argsOffset, argsSize, retOffset, retSize)
            if iszero(staticcall(gas(), 0x0000000000000000000000000000000000000064, 0x00, 0x04, 0x00, 0x20)) {
                revert(0, 0)
            }

            // Load the stored block number from memory
            blockNumber := mload(0x00)
        }
    }

    /// @dev Private function to get the block number using the opcode
    function _getBlockNumber() private view returns (uint256) {
        return block.number;
    }
}
