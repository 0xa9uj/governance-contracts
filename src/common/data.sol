// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { TimelockControllerUpgradeable } from
    '@openzeppelin/contracts-upgradeable/governance/TimelockControllerUpgradeable.sol';
import { IVotes } from '@openzeppelin/contracts/governance/utils/IVotes.sol';

struct GovernorParams {
    string name;
    address token; // IVotes
    TokenClockMode tokenClockMode;
    uint quorum;
    address initialOwner;
}
// TimelockControllerUpgradeable timelock; //TimelockControllerUpgradeable

struct TimelockParams {
    address admin;
    uint minDelay;
    address[] proposers;
    address[] executors;
}

struct TokenClockMode {
    uint48 initialVotingDelay;
    uint32 initialVotingPeriod;
    uint initialProposalThreshold;
}

struct ERC20Params {
    string name;
    string symbol;
    address initialOwner;
    uint initialSupply;
    uint maxSupply;
}

struct ERC721Params {
    string name;
    string symbol;
    address initialOwner;
    uint maxSupply;
}
