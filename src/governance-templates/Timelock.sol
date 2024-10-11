// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/governance/TimelockControllerUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {TimelockParams} from "./common/data.sol";

contract Timelock is Initializable, TimelockControllerUpgradeable, OwnableUpgradeable{

 /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(TimelockParams calldata _timelock)
        initializer public
    {
        __TimelockController_init(_timelock.minDelay, _timelock.proposers, _timelock.executors, _timelock.admin);
        //proxy init
    }

    // function _authorizeUpgrade(address newImplementation)
    //     internal
    //     onlyOwner
    //     override
    // {}
}