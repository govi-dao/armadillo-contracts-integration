// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8;

import './interfaces/ILProtectionConfigInterface.sol';
import './BaseController.sol';

contract ILProtectionConfig is ILProtectionConfigInterface, BaseController {
  bytes32 public constant PROTECTION_CONTROLLER_ROLE = keccak256('PROTECTION_CONTROLLER_ROLE');

  uint16 unused_1;
  uint16 public override maxILProtected;
  uint16 public override expectedLPTokensValueGrowth;
  bool public override buyILProtectionEnabled;
  uint16 public override fee;
  uint256[] public policyPeriods;
  uint256 public override minAmountToBePaid;

  function initialize(
    address _owner,
    uint256 _minAmountToBePaid,
    uint16 _maxILProtected,
    bool _buyILProtectionEnabled,
    uint16 _fee,
    uint16 _expectedLPTokensValueGrowth,
    uint256[] calldata _policyPeriods
  ) external initializer {
    validateInitParams(_maxILProtected, _fee, _expectedLPTokensValueGrowth, _policyPeriods);

    BaseController.initialize(_owner);

    minAmountToBePaid = _minAmountToBePaid;
    maxILProtected = _maxILProtected;
    buyILProtectionEnabled = _buyILProtectionEnabled;
    fee = _fee;
    expectedLPTokensValueGrowth = _expectedLPTokensValueGrowth;
    policyPeriods = _policyPeriods;
  }

  function setMinAmountToBePaid(uint256 _minAmountToBePaid) external override onlyAdmin {
    emit MinAmountToBePaidChanged(minAmountToBePaid, _minAmountToBePaid);

    minAmountToBePaid = _minAmountToBePaid;
  }

  function setMaxILProtected(uint16 _maxILProtected) external override onlyRole(PROTECTION_CONTROLLER_ROLE) {
    validateParamRange(_maxILProtected);

    emit MaxILProtectedChanged(maxILProtected, _maxILProtected);

    maxILProtected = _maxILProtected;
  }

  function setBuyILProtectionEnabled(bool _isEnabled) external override onlyAdmin {
    require(buyILProtectionEnabled != _isEnabled, 'Setting buyILProtectionEnabled to same value');

    emit BuyILProtectionEnabledChanged(buyILProtectionEnabled, _isEnabled);

    buyILProtectionEnabled = _isEnabled;
  }

  function setFee(uint16 _fee) external override onlyAdmin {
    validateParamRange(_fee);

    emit FeeChanged(fee, _fee);

    fee = _fee;
  }

  function setPolicyPeriodsInSeconds(uint256[] calldata _policyPeriods) external override onlyAdmin {
    require(_policyPeriods.length > 0, 'Policy periods array is empty');

    for (uint256 i; i < _policyPeriods.length; i++) {
      require(_policyPeriods[i] != 0, 'Policy period cannot be 0');
    }

    emit PolicyPeriodChanged(policyPeriods, _policyPeriods);

    policyPeriods = _policyPeriods;
  }

  function setExpectedLPTokensValueGrowth(uint16 _expectedLPTokensValueGrowth) external override onlyAdmin {
    require(_expectedLPTokensValueGrowth > 0, 'expectedLPTokensValueGrowth must be > 0');

    emit ExpectedLPTokensValueGrowthChanged(expectedLPTokensValueGrowth, _expectedLPTokensValueGrowth);

    expectedLPTokensValueGrowth = _expectedLPTokensValueGrowth;
  }

  function getPolicyPeriodsInSeconds() external view override returns (uint256[] memory) {
    return policyPeriods;
  }

  function policyPeriodExists(uint256 _policyPeriod) external view override returns (bool) {
    for (uint256 i; i < policyPeriods.length; i++) {
      if (_policyPeriod == policyPeriods[i]) {
        return true;
      }
    }

    return false;
  }

  function validateInitParams(
    uint16 _maxILProtected,
    uint16 _fee,
    uint16 _expectedLPTokensValueGrowth,
    uint256[] calldata _policyPeriods
  ) internal pure {
    validateParamRange(_maxILProtected);
    validateParamRange(_fee);

    require(_expectedLPTokensValueGrowth > 0, 'expectedLPTokensValueGrowth should be larger then 0');
    require(_policyPeriods.length > 0, 'Policy periods array is empty');
  }

  function validateParamRange(uint16 param) internal pure {
    require(param <= MAX_PRECISION, 'Param is out of range');
  }
}
