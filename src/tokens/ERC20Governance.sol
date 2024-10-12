// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20Params} from "../common/data.sol";
import {CommonErrors, validERC20Params} from "../common/errors.sol";

contract ERC20GovernanceToken is ERC20, ERC20Permit, ERC20Votes, Ownable {
    using validERC20Params for ERC20Params;

    uint256 public immutable MAX_SUPPLY;

    constructor(ERC20Params memory _erc20Params)
        ERC20(_erc20Params.name, _erc20Params.symbol)
        ERC20Permit(_erc20Params.name)
        Ownable(_erc20Params.initialOwner)
    {
        _erc20Params.isInvalid();
        MAX_SUPPLY = _erc20Params.maxSupply;
    }

    function mint(address to, uint256 amount) external onlyOwner {
        if (totalSupply() + amount > MAX_SUPPLY) revert CommonErrors.MaxSupplyReached();
        super._mint(to, amount);
    }

    function burn(address account, uint256 amount) public {
        super._burn(account, amount);
    }

    function nonces(address owner) public view override(ERC20Permit, Nonces) returns (uint256) {
        return super.nonces(owner);
    }

    function _update(address from, address to, uint256 amount) internal override(ERC20, ERC20Votes) {
        super._update(from, to, amount);
    }
}
