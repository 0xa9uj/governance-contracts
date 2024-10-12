// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { ERC20Upgradeable } from '@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol';
import { ERC20PermitUpgradeable } from
    '@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol';
import { ERC20VotesUpgradeable } from
    '@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20VotesUpgradeable.sol';
import { OwnableUpgradeable } from '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';
import { Initializable } from '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';
import { UUPSUpgradeable } from '@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol';
import { NoncesUpgradeable } from '@openzeppelin/contracts-upgradeable/utils/NoncesUpgradeable.sol';
import { ERC20Params } from '../common/data.sol';
import { CommonErrors } from '../common/errors.sol';

contract UpgradeableERC20GovernanceToken is
    Initializable,
    ERC20Upgradeable,
    ERC20PermitUpgradeable,
    ERC20VotesUpgradeable,
    OwnableUpgradeable,
    UUPSUpgradeable
{
    // using validERC20Params for ERC20Params;

    uint public MAX_SUPPLY;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(ERC20Params calldata _erc20Params) public initializer {
        // _erc20Params.isInvalid();
        __ERC20_init(_erc20Params.name, _erc20Params.symbol);
        __ERC20Permit_init(_erc20Params.name);
        __ERC20Votes_init();
        __Ownable_init(_erc20Params.initialOwner);
        __UUPSUpgradeable_init();
        MAX_SUPPLY = _erc20Params.maxSupply;
    }

    function nonces(address owner) public view override(ERC20PermitUpgradeable, NoncesUpgradeable) returns (uint) {
        return super.nonces(owner);
    }

    function mint(address to, uint amount) external onlyOwner {
        if (totalSupply() + amount > MAX_SUPPLY) revert CommonErrors.MaxSupplyReached();
        super._mint(to, amount);
    }

    function burn(address account, uint amount) external {
        super._burn(account, amount);
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner { }

    function _update(
        address from,
        address to,
        uint amount
    )
        internal
        override(ERC20Upgradeable, ERC20VotesUpgradeable)
    {
        super._update(from, to, amount);
    }
}
