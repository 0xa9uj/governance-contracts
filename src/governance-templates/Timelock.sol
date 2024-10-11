// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts-upgradeable/governance/TimelockControllerUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {Timelock} from "./common/data.sol";

contract Timelock is Initializable, TimelockControllerUpgradeable, OwnableUpgradeable{

 /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(Timelock calldata _timelock)
        initializer public
    {
        __TimelockController_init(_timelock.minDelay, _timelock.proposers, _timelock.executors);
        __Ownable_init(_governorParams.initialOwner);
        //proxy init
    }

    // function _authorizeUpgrade(address newImplementation)
    //     internal
    //     onlyOwner
    //     override
    // {}
}