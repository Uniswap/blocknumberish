# BlockNumberish
[Git Source](https://github.com/Uniswap/blocknumberish/blob/0b18ce67ad9539f3099722b781328b80c9890ad9/src/BlockNumberish.sol)

**Title:**
BlockNumberish
A helper contract to get the current block number on different chains
inspired by https://github.com/ProjectOpenSea/tstorish/blob/main/src/Tstorish.sol

**Note:**
security-contact: security@uniswap.org


## State Variables
### ARB_CHAIN_ID

```solidity
uint256 private constant ARB_CHAIN_ID = 42_161
```


### ARB_SYS_SELECTOR
Function selector for arbBlockNumber() from: https://github.com/OffchainLabs/nitro-precompile-interfaces/blob/f49a4889b486fd804a7901203f5f663cfd1581c8/ArbSys.sol#L17


```solidity
uint32 private constant ARB_SYS_SELECTOR = 0xa3b1b31d
```


### ARB_SYS_ADDRESS
Arbitrum system contract address (address(100))


```solidity
uint8 private constant ARB_SYS_ADDRESS = 0x64
```


## Functions
### _getBlockNumberish

Internal view function to get the current block number.

Returns Arbitrum block number on Arbitrum One, standard block number elsewhere.


```solidity
function _getBlockNumberish() internal view returns (uint256 blockNumber);
```

