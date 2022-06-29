// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8;

import '@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol';
import './BaseController.sol';
import './interfaces/ILProtectionNFTInterface.sol';

contract ILProtectionNFT is ILProtectionNFTInterface, BaseController, ERC721EnumerableUpgradeable {
  bytes32 public constant MINTER_ROLE = keccak256('MINTER_ROLE');

  uint256 public override tokenIdCounter;
  mapping(uint256 => ProtectionNFTDetails) private protections;

  function initialize(
    address _owner,
    string calldata _name,
    string calldata _symbol
  ) external initializer {
    BaseController.initialize(_owner);

    ERC721Upgradeable.__ERC721_init(_name, _symbol);
  }

  function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override(ERC721EnumerableUpgradeable, AccessControlUpgradeable)
    returns (bool)
  {
    return ERC721Upgradeable.supportsInterface(interfaceId) || AccessControlUpgradeable.supportsInterface(interfaceId);
  }

  function mint(
    address _owner,
    uint256 _protectionStartTimestamp,
    uint256 _protectionEndTimestamp,
    uint256 _premiumCostUSD,
    uint256 _lpTokensWorthAtBuyTimeUSD,
    string calldata _token1Symbol,
    string calldata _token2Symbol,
    uint256 _policyPeriod
  ) external override onlyRole(MINTER_ROLE) {
    protections[tokenIdCounter] = ProtectionNFTDetails({
      id: tokenIdCounter,
      owner: _owner,
      protectionStartTimestamp: _protectionStartTimestamp,
      protectionEndTimestamp: _protectionEndTimestamp,
      premiumCostUSD: _premiumCostUSD,
      lpTokensWorthAtBuyTimeUSD: _lpTokensWorthAtBuyTimeUSD,
      token1Symbol: _token1Symbol,
      token2Symbol: _token2Symbol,
      policyPeriod: _policyPeriod
    });

    _mint(_owner, tokenIdCounter);

    emit ProtectionMint(
      tokenIdCounter,
      _owner,
      _protectionStartTimestamp,
      _protectionEndTimestamp,
      _premiumCostUSD,
      _lpTokensWorthAtBuyTimeUSD,
      _token1Symbol,
      _token2Symbol,
      _policyPeriod
    );

    tokenIdCounter++;
  }

  function getProtectionDetailsByOwnerAndIndex(address _owner, uint256 _index)
    public
    view
    override
    returns (ProtectionNFTDetails memory)
  {
    uint256 protectionId = tokenOfOwnerByIndex(_owner, _index);

    return protections[protectionId];
  }

  function getOwnerProtections(address _owner) external view override returns (ProtectionNFTDetails[] memory) {
    uint256 balance = balanceOf(_owner);

    require(balance > 0, 'Owner has no protections');

    ProtectionNFTDetails[] memory retProtections = new ProtectionNFTDetails[](balance);

    for (uint256 i; i < balance; i++) {
      retProtections[i] = getProtectionDetailsByOwnerAndIndex(_owner, i);
    }

    return retProtections;
  }

  function getProtectionDetails(uint256 _id) external view override returns (ProtectionNFTDetails memory) {
    require(_exists(_id), 'Non existing protection id');

    return protections[_id];
  }
}
