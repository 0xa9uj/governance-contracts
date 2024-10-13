// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { ERC20GovernanceTokenUpgradeable } from './tokens/ERC20GovernanceUpgradeable.sol';
import { ERC20GovernanceToken } from './tokens/ERC20Governance.sol';
import { ERC1967Proxy } from '@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol';
import { ERC20Params } from './common/data.sol';

contract GovernanceTokenFactory {
    event UpgradeableERC20TokenDeployed(address tokenAddress, bytes32 salt);
    event ERC20TokenDeployed(address tokenAddress, bytes32 salt);

    function deployUpgradeableERC20Token(ERC20Params calldata _params) external returns (address) {
        // Deploy implementation
        bytes32 _salt = keccak256(abi.encode(_params, block.timestamp, msg.sender));
        bytes memory implBytecode = type(ERC20GovernanceTokenUpgradeable).creationCode;
        bytes32 implSalt = keccak256(abi.encodePacked(_salt, 'implementation'));
        address implementationContract = deploy(implBytecode, implSalt);

        // Prepare initialization data
        bytes memory initData = abi.encodeWithSelector(ERC20GovernanceTokenUpgradeable.initialize.selector, _params);

        // Deploy proxy
        bytes memory proxyBytecode =
            abi.encodePacked(type(ERC1967Proxy).creationCode, abi.encode(implementationContract, initData));
        address proxy = deploy(proxyBytecode, _salt);

        emit UpgradeableERC20TokenDeployed(proxy, _salt);
        return proxy;
    }

    function deployERC20Token(ERC20Params memory _params) external returns (address) {
        bytes32 _salt = keccak256(abi.encode(_params, block.timestamp, msg.sender));
        bytes memory bytecode = abi.encodePacked(type(ERC20GovernanceToken).creationCode, abi.encode(_params));
        address newToken = deploy(bytecode, _salt);
        emit ERC20TokenDeployed(newToken, _salt);
        return newToken;
    }

    function deploy(bytes memory _bytecode, bytes32 _salt) internal returns (address) {
        address addr;
        assembly {
            addr := create2(0, add(_bytecode, 0x20), mload(_bytecode), _salt)
            if iszero(extcodesize(addr)) { revert(0, 0) }
        }
        return addr;
    }

    receive() external payable {
        revert();
    }

    fallback() external payable {
        revert();
    }
}
