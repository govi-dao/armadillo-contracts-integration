// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

import './IBaseController.sol';

interface ILiquidityController is IBaseController {
  event LiquidityAdded(address indexed from, uint256 amount, uint256 updatedTotalLiquidity);
  event LiquidityWithdrawn(address indexed to, uint256 amount, uint256 updatedTotalLiquidity);
  event LiquidityTokenChanged(IERC20 prevValue, IERC20 newValue);

  function addLiquidity(address _from, uint256 _amount) external;

  function withdrawLiquidity(uint256 _amount, address _to) external;

  function setLiquidityToken(IERC20 _token) external;

  function liquidityToken() external view returns (IERC20);

  function liquidityTokenDecimals() external view returns (uint8);

  function liquidity() external view returns (uint256);
}
