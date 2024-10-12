// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { ERC721 } from '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import { ERC721Enumerable } from '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import { ERC721URIStorage } from '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import { EIP712 } from '@openzeppelin/contracts/utils/cryptography/EIP712.sol';
import { ERC721Votes } from '@openzeppelin/contracts/token/ERC721/extensions/ERC721Votes.sol';
import { Ownable } from '@openzeppelin/contracts/access/Ownable.sol';
import { ERC721Params } from '../common/data.sol';
import { CommonErrors, validERC721Params } from '../common/errors.sol';

contract ERC721GovernanceToken is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Votes, Ownable {
    using validERC721Params for ERC721Params;

    uint private _tokenIdCounter;
    uint public immutable MAX_SUPPLY;

    constructor(
        ERC721Params memory _erc721Params
    )
        ERC721(_erc721Params.name, _erc721Params.symbol)
        EIP712(_erc721Params.name, '1')
        Ownable(_erc721Params.initialOwner)
    {
        _erc721Params.isInvalid();
        MAX_SUPPLY = _erc721Params.maxSupply;
    }

    function safeMint(address to, string memory uri) external onlyOwner {
        uint tokenId = _tokenIdCounter;
        if (tokenId >= MAX_SUPPLY) revert CommonErrors.MaxSupplyReached();
        ++_tokenIdCounter;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function burn(uint tokenId) external {
        super._burn(tokenId);
    }

    function tokenURI(uint tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _increaseBalance(
        address account,
        uint128 amount
    )
        internal
        override(ERC721, ERC721Enumerable, ERC721Votes)
    {
        super._increaseBalance(account, amount);
    }

    function _update(
        address to,
        uint tokenId,
        address auth
    )
        internal
        override(ERC721, ERC721Enumerable, ERC721Votes)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }
}
