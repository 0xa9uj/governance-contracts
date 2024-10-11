// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {TimelockControllerUpgradeable} from "@openzeppelin/contracts-upgradeable/governance/extensions/GovernorTimelockControlUpgradeable.sol";

struct ERC20GovernorParams {
        string name;
        address token;
        TokenClockMode tokenClockMode;
        uint256 quorum;
        address initialOwner;
        TimelockControllerUpgradeable timelock;
    }

     struct TimelockParams {
        uint256 minDelay;
        address[] proposers;
        address[] executors;
    }

    struct TokenClockMode {
        uint48 initialVotingDelay;
        uint32 initialVotingPeriod;
        uint256 initialProposalThreshold;
    }