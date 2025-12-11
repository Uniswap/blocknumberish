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


contract MockBlockNumberish is BlockNumberish {
    function getBlockNumberish() public view returns (uint256) {
        return _getBlockNumberish();
    }
}

contract BlockNumberishTest is Test {
    MockBlockNumberish public blockNumberish;
    MockArbSys public mockArbSys;

    address private constant ARB_SYS_ADDRESS = 0x0000000000000000000000000000000000000064;

    function setUp() public {
        blockNumberish = new MockBlockNumberish();
        // etch MockArbSys to address(100)
        vm.etch(ARB_SYS_ADDRESS, address(new MockArbSys()).code);
        mockArbSys = MockArbSys(ARB_SYS_ADDRESS);
    }

    function test_ArbitrumBlockNumber_gas() public {
        vm.chainId(42_161);
        blockNumberish = new MockBlockNumberish();
        mockArbSys.setBlockNumber(1);

        vm.expectCall(ARB_SYS_ADDRESS, abi.encodeWithSelector(IArbSys.arbBlockNumber.selector));
        blockNumberish.getBlockNumberish();
        vm.snapshotGasLastCall('arbitrumBlockNumber_gas');
    }

    function test_StandardBlockNumber_gas() public {
        blockNumberish = new MockBlockNumberish();
        vm.roll(1);
        blockNumberish.getBlockNumberish();
        vm.snapshotGasLastCall('blockNumber_gas');
    }

    /// forge-config: default.isolate = true
    /// forge-config: ci.isolate = true
    function test_ArbitrumBlockNumber(uint64 _blockNumber) public {
        vm.chainId(42_161);
        blockNumberish = new MockBlockNumberish();
        mockArbSys.setBlockNumber(_blockNumber);

        vm.expectCall(ARB_SYS_ADDRESS, abi.encodeWithSelector(IArbSys.arbBlockNumber.selector));
        uint256 blockNumber = blockNumberish.getBlockNumberish();
        assertEq(blockNumber, _blockNumber);
    }

    /// forge-config: default.isolate = true
    /// forge-config: ci.isolate = true
    function test_StandardBlockNumber(uint64 _blockNumber) public {
        blockNumberish = new MockBlockNumberish();

        vm.roll(_blockNumber);
        uint256 blockNumber = blockNumberish.getBlockNumberish();
        assertEq(blockNumber, _blockNumber);
    }
}
