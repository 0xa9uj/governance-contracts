// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { GovernorUpgradeable } from '@openzeppelin/contracts-upgradeable/governance/GovernorUpgradeable.sol';
import { GovernorSettingsUpgradeable } from
    '@openzeppelin/contracts-upgradeable/governance/extensions/GovernorSettingsUpgradeable.sol';
import { GovernorCountingSimpleUpgradeable } from
    '@openzeppelin/contracts-upgradeable/governance/extensions/GovernorCountingSimpleUpgradeable.sol';
import { GovernorVotesUpgradeable } from
    '@openzeppelin/contracts-upgradeable/governance/extensions/GovernorVotesUpgradeable.sol';
import { GovernorVotesQuorumFractionUpgradeable } from
    '@openzeppelin/contracts-upgradeable/governance/extensions/GovernorVotesQuorumFractionUpgradeable.sol';
import { GovernorTimelockControlUpgradeable } from
    '@openzeppelin/contracts-upgradeable/governance/extensions/GovernorTimelockControlUpgradeable.sol';
import { Initializable } from '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';
import { OwnableUpgradeable } from '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';
import { GovernorParams } from '../common/data.sol';
import { validGovernanceParams } from '../common/errors.sol';
import { IVotes } from '@openzeppelin/contracts/governance/utils/IVotes.sol';
import { UUPSUpgradeable } from '@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol';
import { Timelock } from './Timelock.sol';

contract MyGovernor is
    Initializable,
    GovernorUpgradeable,
    GovernorSettingsUpgradeable,
    GovernorCountingSimpleUpgradeable,
    GovernorVotesUpgradeable,
    GovernorVotesQuorumFractionUpgradeable,
    GovernorTimelockControlUpgradeable,
    OwnableUpgradeable,
    UUPSUpgradeable
{
    using validGovernanceParams for GovernorParams;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(GovernorParams memory _governorParams, address _timelock) public initializer {
        validGovernanceParams.isInvalid(_governorParams);
        __Governor_init(_governorParams.name);
        __GovernorSettings_init(
            _governorParams.tokenClockMode.initialVotingDelay,
            _governorParams.tokenClockMode.initialVotingPeriod,
            _governorParams.tokenClockMode.initialProposalThreshold
        );
        __GovernorCountingSimple_init();
        __GovernorVotes_init(IVotes(_governorParams.token));
        __GovernorVotesQuorumFraction_init(_governorParams.quorum);
        __GovernorTimelockControl_init(Timelock(payable(_timelock)));
        __Ownable_init(_governorParams.initialOwner);
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner { }

    // The following functions are overrides required by Solidity.

    function votingDelay() public view override(GovernorUpgradeable, GovernorSettingsUpgradeable) returns (uint) {
        return super.votingDelay();
    }

    function votingPeriod() public view override(GovernorUpgradeable, GovernorSettingsUpgradeable) returns (uint) {
        return super.votingPeriod();
    }

    function quorum(
        uint blockNumber
    )
        public
        view
        override(GovernorUpgradeable, GovernorVotesQuorumFractionUpgradeable)
        returns (uint)
    {
        return super.quorum(blockNumber);
    }

    function state(
        uint proposalId
    )
        public
        view
        override(GovernorUpgradeable, GovernorTimelockControlUpgradeable)
        returns (ProposalState)
    {
        return super.state(proposalId);
    }

    function proposalNeedsQueuing(
        uint proposalId
    )
        public
        view
        override(GovernorUpgradeable, GovernorTimelockControlUpgradeable)
        returns (bool)
    {
        return super.proposalNeedsQueuing(proposalId);
    }

    function proposalThreshold()
        public
        view
        override(GovernorUpgradeable, GovernorSettingsUpgradeable)
        returns (uint)
    {
        return super.proposalThreshold();
    }

    function _queueOperations(
        uint proposalId,
        address[] memory targets,
        uint[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    )
        internal
        override(GovernorUpgradeable, GovernorTimelockControlUpgradeable)
        returns (uint48)
    {
        return super._queueOperations(proposalId, targets, values, calldatas, descriptionHash);
    }

    function _executeOperations(
        uint proposalId,
        address[] memory targets,
        uint[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    )
        internal
        override(GovernorUpgradeable, GovernorTimelockControlUpgradeable)
    {
        super._executeOperations(proposalId, targets, values, calldatas, descriptionHash);
    }

    function _cancel(
        address[] memory targets,
        uint[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    )
        internal
        override(GovernorUpgradeable, GovernorTimelockControlUpgradeable)
        returns (uint)
    {
        return super._cancel(targets, values, calldatas, descriptionHash);
    }

    function _executor()
        internal
        view
        override(GovernorUpgradeable, GovernorTimelockControlUpgradeable)
        returns (address)
    {
        return super._executor();
    }
}
