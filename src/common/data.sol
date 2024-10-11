// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {TimelockControllerUpgradeable} from
    "@openzeppelin/contracts-upgradeable/governance/extensions/GovernorTimelockControlUpgradeable.sol";
import {IVotes} from "@openzeppelin/contracts/governance/utils/IVotes.sol";

struct ERC20GovernorParams {
    string name;
    IVotes token;
    TokenClockMode tokenClockMode;
    uint256 quorum;
    address initialOwner;
    TimelockControllerUpgradeable timelock;
}

struct TimelockParams {
    address admin;
    uint256 minDelay;
    address[] proposers;
    address[] executors;
}

struct TokenClockMode {
    uint48 initialVotingDelay;
    uint32 initialVotingPeriod;
    uint256 initialProposalThreshold;
}

struct ERC20Params {
    string name;
    string symbol;
    address initialOwner;
    uint256 initialSupply;
    uint256 maxSupply;
}

struct ERC721Params {
    string name;
    string symbol;
    address initialOwner;
    uint256 maxSupply;
}
