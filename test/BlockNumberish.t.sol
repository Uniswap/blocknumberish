// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {BlockNumberish} from '../src/BlockNumberish.sol';
import {MockArbSys} from './mock/MockArbSys.sol';
import {Test} from 'forge-std/Test.sol';

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

/// @title MockBlockNumberish
/// @notice Mock implementation for testing and gas metering
contract MockBlockNumberish is BlockNumberish {
    function getBlockNumberish() public view returns (uint256 blockNumber, uint256 gasUsed) {
        uint256 gasLeft = gasleft();
        _getBlockNumberish();
        gasUsed = gasLeft - gasleft();
        blockNumber = _getBlockNumberish();
    }

    function getBlockNumber() public view returns (uint256 blockNumber, uint256 gasUsed) {
        uint256 gasLeft = gasleft();
        block.number;
        gasUsed = gasLeft - gasleft();
        blockNumber = block.number;
    }
}

contract BlockNumberishTest is Test {
    MockBlockNumberish public blockNumberish;
    MockArbSys public mockArbSys;

    address private constant ARB_SYS_ADDRESS = 0x0000000000000000000000000000000000000064;

    function setUp() public {
        blockNumberish = new MockBlockNumberish();
        vm.snapshotValue('bytecode size', type(BlockNumberish).creationCode.length);
        // etch MockArbSys to address(100)
        vm.etch(ARB_SYS_ADDRESS, address(new MockArbSys()).code);
        mockArbSys = MockArbSys(ARB_SYS_ADDRESS);
    }

    /// forge-config: default.isolate = true
    /// forge-config: ci.isolate = true
    function test_ArbitrumBlockNumber_gas() public {
        vm.chainId(42_161);
        blockNumberish = new MockBlockNumberish();
        mockArbSys.setBlockNumber(1);

        vm.expectCall(ARB_SYS_ADDRESS, abi.encodeWithSelector(IArbSys.arbBlockNumber.selector));
        (, uint256 gasUsed) = blockNumberish.getBlockNumberish();
        vm.snapshotValue('arbitrum getBlockNumberish gas', gasUsed);
    }

    /// forge-config: default.isolate = true
    /// forge-config: ci.isolate = true
    function test_StandardBlockNumber_gas() public {
        blockNumberish = new MockBlockNumberish();
        vm.roll(1);
        (, uint256 gasUsed) = blockNumberish.getBlockNumberish();
        vm.snapshotValue('standard getBlockNumberish gas', gasUsed);
    }

    /// forge-config: default.isolate = true
    /// forge-config: ci.isolate = true
    function test_BlockNumber_gas() public {
        blockNumberish = new MockBlockNumberish();
        (, uint256 gasUsed) = blockNumberish.getBlockNumber();
        vm.snapshotValue('block.number gas', gasUsed);
    }

    function test_ArbitrumBlockNumber(uint64 _blockNumber) public {
        vm.chainId(42_161);
        blockNumberish = new MockBlockNumberish();
        mockArbSys.setBlockNumber(_blockNumber);

        vm.expectCall(ARB_SYS_ADDRESS, abi.encodeWithSelector(IArbSys.arbBlockNumber.selector));
        (uint256 blockNumber,) = blockNumberish.getBlockNumberish();
        assertEq(blockNumber, _blockNumber);
    }

    function test_StandardBlockNumber(uint64 _blockNumber) public {
        blockNumberish = new MockBlockNumberish();

        vm.roll(_blockNumber);
        (uint256 blockNumber,) = blockNumberish.getBlockNumberish();
        assertEq(blockNumber, _blockNumber);
    }

    function test_RevertsOnEmptyArbSysAddress() public {
        vm.chainId(42_161);
        blockNumberish = new MockBlockNumberish();
        vm.etch(ARB_SYS_ADDRESS, bytes(''));

        vm.expectRevert();
        blockNumberish.getBlockNumberish();
    }
}
