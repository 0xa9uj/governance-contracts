// SPDX-License-Identifier: Commons-Clause-1.0
pragma solidity ^0.8.13;

import { ERC1967Proxy } from '@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol';
import { UUPSUpgradeable } from '@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol';
import { Create2 } from '@openzeppelin/contracts/utils/Create2.sol';
import { Address } from '@openzeppelin/contracts/utils/Address.sol';
import { IGovernor } from 'src/interfaces/IGovernor.sol';
import { GovernorParams } from './common/data.sol';
// import { IMainSecond } from "src/interfaces/IMainSecond.sol";
// import { IMainThird } from "src/interfaces/IMainThird.sol";

interface IGovernanceProxyFactory {
    function latestGovernanceImplementation() external view returns (address);
}

/**
 * @dev This contract wraps the proxy contract to allow for constructor-less creation to make address calculating easier/more expected.
 */
contract FactoryCreatedUUPSProxy is ERC1967Proxy {
    constructor() ERC1967Proxy(IGovernanceProxyFactory(msg.sender).latestGovernanceImplementation(), '') { }
}

contract GovernanceProxyFactory {
    bytes32 public constant proxyHash = keccak256(type(FactoryCreatedUUPSProxy).creationCode);
    bytes32 private constant PROOF_MESSAGE = keccak256('Approve governance creation');

    event ContractDeployed(address indexed contractAddress, bool indexed wasRedeployed);

    error GovernanceProxyDeployFailed();
    error GovernanceImplInvalid();

    /**
     * @dev Having this reference allows GovernanceProxy contracts to be created without requiring the
     *   implementation contract address constructor argument, which makes it easier to calculate the proxy wallet address
     */
    address public latestGovernanceImplementation;

    /**
     * @dev Initialize the contract. Sets the initial implementation address.
     * @param _govImpl The address of the implementation contract to use for the WalletProxy.
     *
     */
    constructor(address _govImpl) {
        if (_govImpl == address(0)) {
            revert GovernanceImplInvalid();
        }

        latestGovernanceImplementation = _govImpl;
    }

    receive() external payable {
        revert();
    }

    /**
     * @dev Deploys a new WalletProxy contract based on the salt provided and the caller of the contract.
     * @param _userSalt The salt to use for the deterministic address calculation. Gets concatenated with the caller address.
     * @param _govParams Owner of the Smart Wallet .
     */
    function createProxy(
        bytes32 _userSalt,
        GovernorParams calldata _govParams
    )
        external
        returns (address createdContract_)
    {
        createdContract_ = _create(getSalt(_govParams.initialOwner, _userSalt));
        (bool success,) =
            createdContract_.call(abi.encodeWithSignature('initalize(GovernanceParams,Timelock)', _govParams));
        if (success) emit ContractDeployed(createdContract_, false);
        else revert GovernanceProxyDeployFailed();
    }

    /**
     * @dev Returns an address-combined salt for the deterministic address calculation.
     */
    function getSalt(address _user, bytes32 _userSalt) public pure returns (bytes32) {
        return keccak256(abi.encode(_user, _userSalt));
    }

    /**
     * @dev Calculates the expected address of a WalletProxy contract based on the salt provided without combining an address.
     */
    function calculateExpectedAddress(bytes32 _salt) public view returns (address expectedAddress_) {
        expectedAddress_ = Create2.computeAddress(_salt, proxyHash, address(this));
    }

    /**
     * @dev Calculates the expected address of a WalletProxy contract based on the salt provided and a given address.
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
     * @dev Deploys a new WalletProxy contract based on the salt provided and the caller of the contract.
     * @param _salt The salt to use for the deterministic address calculation.
     */
    function _create(bytes32 _salt) public returns (address createdContract_) {
        createdContract_ = address(new FactoryCreatedUUPSProxy{ salt: _salt }());
        // If the latestWalletImplementation proxy fails to deploy, it will return address(0)
        if (createdContract_ == address(0)) {
            revert GovernanceProxyDeployFailed();
        }
    }
}
