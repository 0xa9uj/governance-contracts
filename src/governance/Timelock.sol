// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { TimelockControllerUpgradeable } from
    '@openzeppelin/contracts-upgradeable/governance/TimelockControllerUpgradeable.sol';
import { Initializable } from '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';
import { OwnableUpgradeable } from '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';
import { TimelockParams } from '../common/data.sol';
import { validTimelockParams } from '../common/errors.sol';
import { UUPSUpgradeable } from '@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol';

contract Timelock is Initializable, TimelockControllerUpgradeable, OwnableUpgradeable, UUPSUpgradeable {
    using validTimelockParams for TimelockParams;
    /// @custom:oz-upgrades-unsafe-allow constructor

    constructor() {
        _disableInitializers();
    }

    function initialize(TimelockParams memory _timelock) public initializer {
        // _timelock.isInvalid();
        __TimelockController_init(_timelock.minDelay, _timelock.proposers, _timelock.executors, _timelock.admin);
        __Ownable_init(_timelock.admin);
        //proxy init
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner { }
}
