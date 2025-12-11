# BlockNumberish
[Git Source](https://github.com/Uniswap/blocknumberish/blob/f76ef9d804165d834a74481b798de1c33775c5eb/src/BlockNumberish.sol)

**Title:**
BlockNumberish
A helper contract to get the current block number on different chains
inspired by https://github.com/ProjectOpenSea/tstorish/blob/main/src/Tstorish.sol


## State Variables
### _getBlockNumberish
Internal view function to get the current block number.

Returns Arbitrum block number on Arbitrum One, standard block number elsewhere.


```solidity
function() view returns (uint256) internal immutable _getBlockNumberish
```


### ARB_CHAIN_ID

```solidity
uint256 private constant ARB_CHAIN_ID = 42_161
```


### ARB_SYS_ADDRESS

```solidity
address private constant ARB_SYS_ADDRESS = 0x0000000000000000000000000000000000000064
```


## Functions
### constructor


```solidity
constructor() ;
```

### _getBlockNumberSyscall

Private function to get the block number on arbitrum


```solidity
function _getBlockNumberSyscall() private view returns (uint256);
```

### _getBlockNumber

Private function to get the block number using the opcode


```solidity
function _getBlockNumber() private view returns (uint256);
```

