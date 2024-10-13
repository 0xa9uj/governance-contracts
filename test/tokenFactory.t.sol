// SPDX-License-Identifier: Commons-Clause-1.0
pragma solidity ^0.8.13;

import { Test } from 'forge-std/Test.sol';
import { GovernanceTokenFactory } from '../src/GovernanceTokenFactory.sol';
import { ERC20GovernanceTokenUpgradeable } from '../src/tokens/ERC20GovernanceUpgradeable.sol';
import { ERC20Params } from '../src/common/data.sol';
import { ERC20GovernanceToken } from '../src/tokens/ERC20Governance.sol';

contract TestTokenFactory is Test {
    GovernanceTokenFactory governanceTokenFactory;
    ERC20GovernanceTokenUpgradeable wrappedproxy;

    address owner = address(23);

    function setUp() public {
        governanceTokenFactory = new GovernanceTokenFactory();
    }

    function testDeploymentOfERC20TokensUpgradeable() public {
        ERC20Params memory erc20Params = ERC20Params({
            name: 'MyToken',
            symbol: 'MTK',
            initialOwner: owner,
            initialSupply: 10_000 * 10 ** 8,
            maxSupply: 1_000_000_000_000 * 10 ** 8
        });

        address proxy = governanceTokenFactory.deployUpgradeableERC20Token(erc20Params);
        wrappedproxy = ERC20GovernanceTokenUpgradeable(proxy);

        bytes memory dataToCheck = abi.encode(wrappedproxy.name());
        bytes memory actualData = abi.encode('MyToken');

        assertEq(dataToCheck, actualData, 'Initialziation Failed');
    }

    function testDeploymentOfERC20Tokens() public {
        ERC20Params memory erc20Params = ERC20Params({
            name: 'MyToken',
            symbol: 'MTK',
            initialOwner: owner,
            initialSupply: 10_000 * 10 ** 8,
            maxSupply: 1_000_000_000_000 * 10 ** 8
        });

        address proxy = governanceTokenFactory.deployERC20Token(erc20Params);

        bytes memory dataToCheck = abi.encode(ERC20GovernanceToken(proxy).name());
        bytes memory actualData = abi.encode('MyToken');

        assertEq(dataToCheck, actualData, 'Initialziation Failed');
    }
}
