// SPDX-License-Identifier: Commons-Clause-1.0
pragma solidity ^0.8.13;

import { Test } from 'forge-std/Test.sol';
import { GovernanceBeaconProxyFactory } from '../src/GovernanceBeaconProxyFactory.sol';
import { MyGovernor } from '../src/governance/Governance.sol';
import { UpgradeableBeacon } from '@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';
import { GovernorParams } from '../src/common/data.sol';
import { ERC20GovernanceToken } from '../src/tokens/ERC20Governance.sol';
import { ERC20Params } from '../src/common/data.sol';
import { TimelockParams } from '../src/common/data.sol';
import { TokenClockMode } from '../src/common/data.sol';
import { Timelock } from '../src/governance/Timelock.sol';
import { console } from 'forge-std/console.sol';

contract Testfactory is Test {
    GovernanceBeaconProxyFactory governanceBeaconProxyfactory;
    UpgradeableBeacon beacon;

    function setUp() public {
        governanceBeaconProxyfactory = new GovernanceBeaconProxyFactory(address(new MyGovernor()));
        beacon = UpgradeableBeacon(governanceBeaconProxyfactory.beacon());
    }

    // function testDeployProxy() public {
    //     governanceBeaconProxyfactory.createProxy();
    // }
}
