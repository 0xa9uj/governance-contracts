// SPDX-License-Identifier: Commons-Clause-1.0
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {GovernanceBeaconProxyFactory} from "../src/GovernanceBeaconProxyFactory.sol";
import {MyGovernor} from "../src/governance/Governance.sol";
import {UpgradeableBeacon} from "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import {console} from "forge-std/console.sol";

contract DeployGovernanceModel is Script{

    GovernanceBeaconProxyFactory governanceBeaconProxyfactory;
    UpgradeableBeacon beacon;

    function run() public{
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        governanceBeaconProxyfactory = new GovernanceBeaconProxyFactory(address(new MyGovernor()));
        beacon = UpgradeableBeacon(governanceBeaconProxyfactory.beacon());
        vm.stopBroadcast();

        console.log("Factory addressV2:", address(governanceBeaconProxyfactory));
    }

    ////source .env && forge script scripts/deploy.s.sol:DeployGovernanceModel --rpc-url $BASE_SEPOLIA_RPC_URL --broadcast --verify -vvvv



}