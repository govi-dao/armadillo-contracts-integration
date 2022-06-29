// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8;

interface ILProtectionConfigInterface {
  event MinAmountToBePaidChanged(uint256 prevValue, uint256 newValue);
  event MaxILProtectedChanged(uint16 prevValue, uint16 newValue);
  event BuyILProtectionEnabledChanged(bool prevValue, bool newValue);
  event PolicyPeriodChanged(uint256[] prevValue, uint256[] newValue);
  event FeeChanged(uint16 prevValue, uint16 newValue);
  event ExpectedLPTokensValueGrowthChanged(uint16 prevValue, uint16 newValue);

  function setMinAmountToBePaid(uint256 _minAmountToBePaid) external;

  function setMaxILProtected(uint16 _maxILProtected) external;

  function setBuyILProtectionEnabled(bool _isEnabled) external;

  function setFee(uint16 _fee) external;

  function setPolicyPeriodsInSeconds(uint256[] calldata _policyPeriods) external;

  function setExpectedLPTokensValueGrowth(uint16 _expectedLPTokensValueGrowth) external;

  function minAmountToBePaid() external view returns (uint256);

  function maxILProtected() external view returns (uint16);

  function buyILProtectionEnabled() external view returns (bool);

  function fee() external view returns (uint16);

  function expectedLPTokensValueGrowth() external view returns (uint16);

  function getPolicyPeriodsInSeconds() external view returns (uint256[] memory);

  function policyPeriodExists(uint256 _policyPeriod) external view returns (bool);
}
