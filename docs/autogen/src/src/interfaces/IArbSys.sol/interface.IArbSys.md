# IArbSys
[Git Source](https://github.com/Uniswap/blocknumberish/blob/f76ef9d804165d834a74481b798de1c33775c5eb/src/interfaces/IArbSys.sol)

Minimal interface for interacting with Arbitrum system contracts


## Functions
### arbBlockNumber

Get Arbitrum block number (distinct from L1 block number; Arbitrum genesis block has block number 0)


```solidity
function arbBlockNumber() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|block number as int|


