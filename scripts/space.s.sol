// SPDX-License-Identifier: Commons-Clause-1.0
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
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

contract DeploySpace is Script{

    address governanceBeaconProxyfactory=0x03F7f254cC7442045cbBbC16b268cbF87608659D;
    MyGovernor governorModel1;
    address owner =0xcA836Ad7C68BE461164982d9CB3f8adc1eA2836F;
    ERC20GovernanceToken erc20GovernanceToken;
    address[] proposers; // Change size if needed
    address[] executors;


    function run() public {

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);


        ERC20Params memory erc20Params = ERC20Params({
            name: 'MyToken',
            symbol: 'MTK',
            initialOwner: owner,
            initialSupply: 10_000 * 10 ** 8,
            maxSupply: 1_000_000_000_000 * 10 ** 8
        });

        erc20GovernanceToken = new ERC20GovernanceToken(erc20Params);
        // console.log('34r');
        // Assign values to the arrays
        proposers.push(address(0xcA836Ad7C68BE461164982d9CB3f8adc1eA2836F)); // Example address
        proposers.push(address(0xcA836Ad7C68BE461164982d9CB3f8adc1eA2836F)); // Example address

        executors.push(address(0xcA836Ad7C68BE461164982d9CB3f8adc1eA2836F)); // Example address
        executors.push(address(0xcA836Ad7C68BE461164982d9CB3f8adc1eA2836F)); // Example address

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

        governorModel1 = MyGovernor(payable(GovernanceBeaconProxyFactory(governanceBeaconProxyfactory).createProxy(timelockParams, governorParams)));
        
        vm.stopBroadcast();

        console.log("Factory addressV2:", address(governanceBeaconProxyfactory));
    }

    ////source .env && forge script scripts/space.s.sol:DeploySpace --rpc-url $BASE_SEPOLIA_RPC_URL --broadcast --verify -vvvv



}