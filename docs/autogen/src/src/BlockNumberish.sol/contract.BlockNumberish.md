# BlockNumberish
[Git Source](https://github.com/Uniswap/blocknumberish/blob/f283af28d1c7a6b2b4b86acd7d6a1a04c38ef8d4/src/BlockNumberish.sol)

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


### ARB_SEPOLIA_CHAIN_ID

```solidity
uint256 private constant ARB_SEPOLIA_CHAIN_ID = 421_614
```


### ROBINHOOD_CHAIN_ID

```solidity
uint256 private constant ROBINHOOD_CHAIN_ID = 4663
```


### ROBINHOOD_TESTNET_CHAIN_ID

```solidity
uint256 private constant ROBINHOOD_TESTNET_CHAIN_ID = 46_630
```


### UNICHAIN_CHAIN_ID

```solidity
uint256 private constant UNICHAIN_CHAIN_ID = 130
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


### UNICHAIN_FLASHBLOCK_NUMBER_SELECTOR
Function selector for getFlashblockNumber() from: https://github.com/Uniswap/flashblocks_number_contract/blob/a667d57f0055de80b9909c8837e872c4364853c3/src/IFlashblockNumber.sol#L70


```solidity
uint32 private constant UNICHAIN_FLASHBLOCK_NUMBER_SELECTOR = 0xe5b37c5d
```


### UNICHAIN_FLASHBLOCK_NUMBER_ADDRESS
Unichain flashblock number address


```solidity
address private constant UNICHAIN_FLASHBLOCK_NUMBER_ADDRESS = 0x3c3A8a41E095C76b03f79f70955fFf3b03cf753E
```


## Functions
### _getBlockNumberish

Internal view function to get the current block number.

Returns the Arbitrum block number on Arbitrum-based chains (Arbitrum One, Arbitrum Sepolia,
Robinhood, Robinhood testnet), standard block number elsewhere.


```solidity
function _getBlockNumberish() internal view returns (uint256 blockNumber);
```

### _getFlashblockNumberish

Internal view function to get the current flashblock number.

Returns Unichain flashblock number on Unichain, 0 elsewhere.


```solidity
function _getFlashblockNumberish() internal view returns (uint256 flashblockNumber);
```

