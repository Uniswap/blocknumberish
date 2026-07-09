// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {BlockNumberish} from '../src/BlockNumberish.sol';
import {IArbSys, MockArbSys} from './mock/MockArbSys.sol';
import {IFlashblockNumber, MockFlashblockNumber} from './mock/MockFlashblockNumber.sol';
import {MockMalformedDataArbSys} from './mock/MockMalformedDataArbSys.sol';
import {MockMalformedDataFlashblockNumber} from './mock/MockMalformedDataFlashblockNumber.sol';
import {Test} from 'forge-std/Test.sol';

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

    function getFlashblockNumberish() public view returns (uint256 flashblockNumber, uint256 gasUsed) {
        uint256 gasLeft = gasleft();
        _getFlashblockNumberish();
        gasUsed = gasLeft - gasleft();
        flashblockNumber = _getFlashblockNumberish();
    }
}

contract BlockNumberishTest is Test {
    MockBlockNumberish public blockNumberish;
    MockArbSys public mockArbSys;
    MockFlashblockNumber public mockFlashblockNumber;

    address private constant ARB_SYS_ADDRESS = 0x0000000000000000000000000000000000000064;
    address private constant UNICHAIN_FLASHBLOCK_NUMBER_ADDRESS = 0x3c3A8a41E095C76b03f79f70955fFf3b03cf753E;

    function setUp() public {
        // Leave address(100) empty by default so instances deployed here take the standard block.number path.
        blockNumberish = new MockBlockNumberish();
        vm.snapshotValue('bytecode size', type(BlockNumberish).creationCode.length);
        vm.etch(UNICHAIN_FLASHBLOCK_NUMBER_ADDRESS, address(new MockFlashblockNumber()).code);
        mockFlashblockNumber = MockFlashblockNumber(UNICHAIN_FLASHBLOCK_NUMBER_ADDRESS);
    }

    /// @dev Deploy the ArbSys mock to address(100) so a freshly constructed contract detects the precompile.
    function _deployArbitrum() internal returns (MockBlockNumberish deployed) {
        vm.etch(ARB_SYS_ADDRESS, address(new MockArbSys()).code);
        mockArbSys = MockArbSys(ARB_SYS_ADDRESS);
        deployed = new MockBlockNumberish();
    }

    function test_BytecodeSize() public {
        vm.snapshotValue('bytecode size', type(BlockNumberish).creationCode.length);
    }

    /// forge-config: default.isolate = true
    /// forge-config: ci.isolate = true
    function test_ArbitrumBlockNumber_gas() public {
        blockNumberish = _deployArbitrum();
        mockArbSys.setBlockNumber(1);

        vm.expectCall(ARB_SYS_ADDRESS, abi.encodeWithSelector(IArbSys.arbBlockNumber.selector));
        (, uint256 gasUsed) = blockNumberish.getBlockNumberish();
        vm.snapshotValue('arbitrum getBlockNumberish gas', gasUsed);
    }

    /// forge-config: default.isolate = true
    /// forge-config: ci.isolate = true
    function test_UnichainFlashblockNumberish_gas() public {
        vm.chainId(130);
        blockNumberish = new MockBlockNumberish();
        mockFlashblockNumber.setFlashblockNumber(1);
        vm.expectCall(
            UNICHAIN_FLASHBLOCK_NUMBER_ADDRESS, abi.encodeWithSelector(IFlashblockNumber.getFlashblockNumber.selector)
        );
        (, uint256 gasUsed) = blockNumberish.getFlashblockNumberish();
        vm.snapshotValue('unichain getFlashblockNumberish gas', gasUsed);
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
    function test_StandardFlashblockNumber_gas() public {
        blockNumberish = new MockBlockNumberish();
        (, uint256 gasUsed) = blockNumberish.getFlashblockNumberish();
        vm.snapshotValue('standard getFlashblockNumberish gas', gasUsed);
    }

    /// forge-config: default.isolate = true
    /// forge-config: ci.isolate = true
    function test_BlockNumber_gas() public {
        blockNumberish = new MockBlockNumberish();
        (, uint256 gasUsed) = blockNumberish.getBlockNumber();
        vm.snapshotValue('block.number gas', gasUsed);
    }

    /******************************
              Fuzz tests
     ******************************/

    /// @dev Detection is based on the ArbSys precompile at address(100), so this path covers all
    /// Arbitrum and Orbit chains (Arbitrum One, Arbitrum Sepolia, Robinhood, etc.) regardless of chain ID.
    function test_ArbitrumBlockNumber(uint64 _blockNumber) public {
        blockNumberish = _deployArbitrum();
        mockArbSys.setBlockNumber(_blockNumber);

        vm.expectCall(ARB_SYS_ADDRESS, abi.encodeWithSelector(IArbSys.arbBlockNumber.selector));
        (uint256 blockNumber,) = blockNumberish.getBlockNumberish();
        assertEq(blockNumber, _blockNumber);
    }

    function test_UnichainFlashblockNumber(uint64 _flashblockNumber) public {
        vm.chainId(130);
        blockNumberish = new MockBlockNumberish();
        mockFlashblockNumber.setFlashblockNumber(_flashblockNumber);
        vm.expectCall(
            UNICHAIN_FLASHBLOCK_NUMBER_ADDRESS, abi.encodeWithSelector(IFlashblockNumber.getFlashblockNumber.selector)
        );
        (uint256 flashblockNumber,) = blockNumberish.getFlashblockNumberish();
        assertEq(flashblockNumber, _flashblockNumber);
    }

    /// @dev A contract deployed where address(100) is empty must never take the ArbSys path.
    function test_StandardBlockNumber(uint64 _blockNumber) public {
        blockNumberish = new MockBlockNumberish();

        vm.roll(_blockNumber);
        (uint256 blockNumber,) = blockNumberish.getBlockNumberish();
        assertEq(blockNumber, _blockNumber);
    }

    function test_RevertsOnEmptyArbSysAddress() public {
        // Detect the precompile at construction, then clear it so the call hits an empty address.
        blockNumberish = _deployArbitrum();
        vm.etch(ARB_SYS_ADDRESS, bytes(''));

        vm.expectRevert();
        blockNumberish.getBlockNumberish();
    }

    function test_RevertsOnEmptyUnichainFlashblockNumberAddress() public {
        vm.chainId(130);
        blockNumberish = new MockBlockNumberish();
        vm.etch(UNICHAIN_FLASHBLOCK_NUMBER_ADDRESS, bytes(''));

        vm.expectRevert();
        blockNumberish.getFlashblockNumberish();
    }

    function test_RevertsOnMaliciousArbSysAddress() public {
        // Detect the precompile at construction, then replace it with code returning malformed data.
        blockNumberish = _deployArbitrum();
        vm.etch(ARB_SYS_ADDRESS, type(MockMalformedDataArbSys).creationCode);

        vm.expectRevert();
        blockNumberish.getBlockNumberish();
    }

    function test_RevertsOnMaliciousUnichainFlashblockNumberAddress() public {
        vm.chainId(130);
        blockNumberish = new MockBlockNumberish();
        vm.etch(UNICHAIN_FLASHBLOCK_NUMBER_ADDRESS, type(MockMalformedDataFlashblockNumber).creationCode);

        vm.expectRevert();
        blockNumberish.getFlashblockNumberish();
    }
}
