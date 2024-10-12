// SPDX-License-Identifier: Commons-Clause-1.0
pragma solidity ^0.8.13;

import { GovernorParams, TimelockParams } from '../common/data.sol';

interface IGovernor {
    function initialize(GovernorParams memory _govParam, address timeLock) external;
}

interface ITimelock {
    function initialize(TimelockParams memory _timelockParams) external;
}
