// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8;

import 'prb-math/contracts/PRBMathUD60x18.sol';

struct PremiumParams {
  uint256 A;
  uint256 X0;
  uint256 C;
}

library PremiumCalculator {
  using PRBMathUD60x18 for uint256;

  function calculatePremium(
    uint256 lpTokensWorthAtBuyTimeUSD,
    uint256 collateral,
    uint256 liquidity,
    PremiumParams memory premiumParams,
    uint256 cvi
  ) internal pure returns (uint256) {
    uint256 P = PRBMathUD60x18.exp(collateral.div(liquidity));

    uint256 xt = cvi;
    uint256 x0 = premiumParams.X0;

    if (cvi < premiumParams.X0) {
      xt = premiumParams.X0;
      x0 = cvi;
    }

    return lpTokensWorthAtBuyTimeUSD.mul((premiumParams.A.mul((xt - x0).powu(2)) + premiumParams.C).mul(P));
  }
}
