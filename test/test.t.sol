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

contract MockERC20GovernanceToken is ERC20GovernanceToken {
    constructor(ERC20Params memory _erc20Params) ERC20GovernanceToken(_erc20Params) { }
}

contract TestGovernanceERC20 is Test {
    MockERC20GovernanceToken erc20GovernanceToken;
    GovernanceBeaconProxyFactory governanceBeaconProxyfactory;
    MyGovernor governorModel1;
    MyGovernor governorModel2;
    UpgradeableBeacon beacon;
    address owner = address(1);
    // address erc20GovernanceToken = address(34);

    address[] proposers; // Change size if needed
    address[] executors;

    function setUp() public {
        ERC20Params memory erc20Params = ERC20Params({
            name: 'MyToken',
            symbol: 'MTK',
            initialOwner: owner,
            initialSupply: 10_000 * 10 ** 8,
            maxSupply: 1_000_000_000_000 * 10 ** 8
        });

        erc20GovernanceToken = new MockERC20GovernanceToken(erc20Params);
        console.log('34r');
        // Assign values to the arrays
        proposers.push(address(0x0000000000000000000000000000000000000017)); // Example address
        proposers.push(address(0x0000000000000000000000000000000000000023)); // Example address

        executors.push(address(0x0000000000000000000000000000000000000031)); // Example address
        executors.push(address(0x0000000000000000000000000000000000000045)); // Example address

        // Initialize TimelockParams with custom values
        TimelockParams memory timelockParams = TimelockParams({
            admin: owner,
            minDelay: 600, // Minimum delay for timelock (in seconds // List of addresses allowed to execute
            proposers: proposers,
            executors: executors
        });

        // timelockController = new MockTimeLock(timelockParams);

        // Initialize TokenClockMode with custom values
        TokenClockMode memory tokenClockMode = TokenClockMode({
            initialVotingDelay: 100, // Example value in seconds or blocks
            initialVotingPeriod: 2000, // Example value in blocks
            initialProposalThreshold: 500 // Example value in tokens
         });

        // Initialize GovernorParams with custom values
        GovernorParams memory governorParams = GovernorParams({
            name: 'MyGovernor', // Custom governor name
            token: address(erc20GovernanceToken), // Address of the voting token (IVotes)
            tokenClockMode: tokenClockMode, // The token clock mode initialized above
            quorum: 5, // Quorum value (e.g., number of tokens required for quorum)
            initialOwner: address(owner) // Address of the initial owner of the governo/
         });

        governanceBeaconProxyfactory = new GovernanceBeaconProxyFactory(address(new MyGovernor()));
        governorModel1 = MyGovernor(payable(governanceBeaconProxyfactory.createProxy(timelockParams, governorParams)));
        beacon = UpgradeableBeacon(governanceBeaconProxyfactory.beacon());
    }

    function testInitialization() public view {
        assertEq(governorModel1.votingDelay(), 100, 'Initialization Failed');
        // assertEq(governorModel2.votingPeriod(),2000,"Initialization Failed");
    }
}
