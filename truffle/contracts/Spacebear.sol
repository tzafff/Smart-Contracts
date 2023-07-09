// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "@ganache/console.log/console.sol";
contract CheapBoredApeYachtClub is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("CheapBoredApeYachtClub", "BAYC") {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/";
    }

    function byeToken() public payable{
        uint256 tokenId = _tokenIdCounter.current();
        console.log("got here",tokenId,msg.value);
        require(msg.value == tokenId * 0.1 ether, "Not enought funds");
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
    }

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        pure
        override(ERC721)
        returns (string memory)
    {
        return string(abi.encodePacked(_baseURI(),"bayc_",(tokenId+1),".json"));
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}