// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8;

library MathUtils {
  function ratio(
    uint256 numerator,
    uint256 denominator,
    uint8 precision
  ) internal pure returns (uint256 quotient) {
    uint256 _numerator = numerator * 10**(precision + 1);

    // with rounding of last digit
    uint256 _quotient = ((_numerator / denominator) + 5) / 10;
    return (_quotient);
  }
}
