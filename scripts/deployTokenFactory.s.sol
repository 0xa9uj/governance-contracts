// SPDX-License-Identifier: Commons-Clause-1.0
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {GovernanceTokenFactory} from "../src/GovernanceTokenFactory.sol";
import {console} from "forge-std/console.sol";

contract DeployTokenFatory is Script{

    GovernanceTokenFactory governanceTokenfactory;

    function run() public{
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        governanceTokenfactory = new GovernanceTokenFactory();
        vm.stopBroadcast();

        console.log("Token Factory addressV2:", address(governanceTokenfactory));
    }

    ////source .env && forge script scripts/deployTokenFactory.s.sol:DeployTokenFatory --rpc-url $BASE_SEPOLIA_RPC_URL --broadcast --verify -vvvv



}