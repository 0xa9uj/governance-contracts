// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {GovernorParams, TokenClockMode, TimelockParams, ERC20Params, ERC721Params} from "./data.sol";
import {IVotes} from "@openzeppelin/contracts/governance/utils/IVotes.sol";

library CommonErrors {
    error InvalidParams();
    error MaxSupplyReached();
}

library validGovernanceParams {
    function isInvalid(GovernorParams calldata self) internal pure {
        if (
            (keccak256(abi.encodePacked(self.name))) == keccak256(abi.encodePacked(""))
                || self.token != IVotes(address(0)) || invalidTokenClockMode(self.tokenClockMode) || self.quorum == 0
                || self.initialOwner == address(0)
        ) revert CommonErrors.InvalidParams();
    }

    function invalidTokenClockMode(TokenClockMode calldata self) private pure returns (bool) {
        return (self.initialVotingDelay == 0 || self.initialVotingPeriod == 0 || self.initialProposalThreshold == 0);
    }
}

library validTimelockParams {
    function isInvalid(TimelockParams memory self) internal pure {
        if (self.admin == address(0) || self.minDelay == 0 || self.proposers.length == 0 || self.executors.length == 0)
        {
            revert CommonErrors.InvalidParams();
        }
    }
}

library validERC20Params {
    error InitialSupplyExceedsMaxSupply();

    function isInvalid(ERC20Params memory self) internal pure {
        if (
            (keccak256(abi.encodePacked(self.name))) == keccak256(abi.encodePacked(""))
                || (keccak256(abi.encodePacked(self.symbol))) == keccak256(abi.encodePacked(""))
                || self.initialOwner == address(0) || self.initialSupply == 0 || self.maxSupply == 0
        ) revert CommonErrors.InvalidParams();
        if (self.initialSupply > self.maxSupply) {
            revert InitialSupplyExceedsMaxSupply();
        }
    }
}

library validERC721Params {
    function isInvalid(ERC721Params memory self) internal pure {
        if (
            (keccak256(abi.encodePacked(self.name))) == keccak256(abi.encodePacked(""))
                || (keccak256(abi.encodePacked(self.symbol))) == keccak256(abi.encodePacked(""))
                || self.initialOwner == address(0) || self.maxSupply == 0
        ) revert CommonErrors.InvalidParams();
    }
}
