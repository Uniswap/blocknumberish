// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title BlockNumberish
/// A helper contract to get the current block number on different chains
/// inspired by https://github.com/ProjectOpenSea/tstorish/blob/main/src/Tstorish.sol
/// @custom:security-contact security@uniswap.org
contract BlockNumberish {
    // Arbitrum One chain ID.
    uint256 private constant ARB_CHAIN_ID = 42_161;
    /// @dev Function selector for arbBlockNumber() from: https://github.com/OffchainLabs/nitro-precompile-interfaces/blob/f49a4889b486fd804a7901203f5f663cfd1581c8/ArbSys.sol#L17
    uint32 private constant ARB_SYS_SELECTOR = 0xa3b1b31d;
    /// @dev Arbitrum system contract address (address(100))
    uint8 private constant ARB_SYS_ADDRESS = 0x64;

    /// @notice Internal view function to get the current block number.
    /// @dev Returns Arbitrum block number on Arbitrum One, standard block number elsewhere.
    function _getBlockNumberish() internal view returns (uint256 blockNumber) {
        if (block.chainid == ARB_CHAIN_ID) {
            assembly {
                mstore(0x00, ARB_SYS_SELECTOR)
                // staticcall(gas, address, argsOffset, argsSize, retOffset, retSize)
                let success := staticcall(gas(), ARB_SYS_ADDRESS, 0x1c, 0x04, 0x00, 0x20)
                // revert if the call fails from OOG or returns malformed data
                if or(iszero(success), iszero(eq(returndatasize(), 0x20))) {
                    revert(0, 0)
                }

                // load the stored block number from memory
                blockNumber := mload(0x00)
            }
        } else {
            blockNumber = block.number;
        }
    }
}
