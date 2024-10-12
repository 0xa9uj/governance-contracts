// SPDX-License-Identifier: Commons-Clause-1.0
pragma solidity ^0.8.13;

import { BeaconProxy } from '@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol';
import { UpgradeableBeacon } from '@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';
import { Create2 } from '@openzeppelin/contracts/utils/Create2.sol';
import { Address } from '@openzeppelin/contracts/utils/Address.sol';
import { IGovernor, ITimelock } from './interfaces/IGovernor.sol';
import { GovernorParams, TimelockParams } from './common/data.sol';
import { Timelock } from './governance/Timelock.sol';
import { ERC1967Proxy } from '@openzeppelin/contracts/Proxy/ERC1967/ERC1967Proxy.sol';

interface IBeaconProxyFactory {
    function beacon() external view returns (address);
}

/**
 * @dev This contract wraps the constructor args to make address calculating easier/more expected.
 */
contract FactoryCreatedBeaconProxy is BeaconProxy {
    constructor() BeaconProxy(IBeaconProxyFactory(msg.sender).beacon(), '') { }
}

contract GovernanceBeaconProxyFactory is IBeaconProxyFactory {
    bytes32 public constant proxyHash = keccak256(type(FactoryCreatedBeaconProxy).creationCode);
    bytes32 private constant PROOF_MESSAGE = keccak256('Approve Proxy creation');

    event ContractDeployed(address indexed contractAddress, address indexed timelockContract);

    error BeaconProxyDeployFailed();
    error BeaconImplInvalid();

    /**
     * @dev Having this reference allows BeaconProxy contracts to be created without requiring the
     *   UpgradeableBeacon address constructor argument, since we can assume that the factory is creating
     *    every BeaconProxy that needs to be linked.
     */
    address public override beacon;

    /**
     * @dev Initialize the contract. Sets the initial implementation address.
     * @param _beaconImpl The address of the implementation contract to use for the BeaconProxy.
     */
    constructor(address _beaconImpl) {
        if (_beaconImpl == address(0)) {
            revert BeaconImplInvalid();
        }

        beacon = address(new UpgradeableBeacon(_beaconImpl, msg.sender));
    }

    // receive() external payable {
    //     revert();
    // }
    /**
     * @dev Deploys a new WalletProxy contract based on the salt provided and the caller of the contract.
     * @param _govParams Owner of the Smart Wallet .
     */
    function createProxy(
        TimelockParams memory _timeLockParams,
        GovernorParams memory _govParams
    )
        external
        returns (address createdContract_)
    {
        Timelock timelock = new Timelock();
        bytes memory datatimelock = abi.encodeWithSelector(Timelock.initialize.selector, _timeLockParams);

        ERC1967Proxy timelockProxy = new ERC1967Proxy(address(timelock), datatimelock);

        address addressTimeLock = address(timelockProxy);

        bytes32 _userSalt = keccak256(abi.encode(_govParams, block.timestamp, addressTimeLock));
        createdContract_ = _create(getSalt(_govParams.initialOwner, _userSalt));
        IGovernor(createdContract_).initialize(_govParams, addressTimeLock);
        emit ContractDeployed(createdContract_, addressTimeLock);
    }

    /**
     * @dev Returns an address-combined salt for the deterministic address calculation.
     */
    function getSalt(address _user, bytes32 _userSalt) public pure returns (bytes32) {
        return keccak256(abi.encode(_user, _userSalt));
    }

    /**
     * @dev Calculates the expected address of a BeaconProxy contract based on the salt provided without combining an address.
     */
    function calculateExpectedAddress(bytes32 _salt) public view returns (address expectedAddress_) {
        expectedAddress_ = Create2.computeAddress(_salt, proxyHash, address(this));
    }

    /**
     * @dev Calculates the expected address of a BeaconProxy contract based on the salt provided and a given address.
     */
    function calculateExpectedAddress(
        address _user,
        bytes32 _userSalt
    )
        public
        view
        returns (address expectedAddress_)
    {
        expectedAddress_ = calculateExpectedAddress(getSalt(_user, _userSalt));
    }

    /**
     * @dev Deploys a new BeaconProxy contract based on the salt provided and the caller of the contract.
     * @param _salt The salt to use for the deterministic address calculation.
     */
    function _create(bytes32 _salt) public returns (address createdContract_) {
        createdContract_ = address(new FactoryCreatedBeaconProxy{ salt: _salt }());
        // If the beacon proxy fails to deploy, it will return address(0)
        if (createdContract_ == address(0)) {
            revert BeaconProxyDeployFailed();
        }
    }
}
