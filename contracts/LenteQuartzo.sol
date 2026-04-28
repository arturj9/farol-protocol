// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

interface ILenteQuartzo {
    function checkMembro(address usuario) external view returns (bool);
}

contract LenteQuartzo is ERC721, ILenteQuartzo {
    uint256 private _nextTokenId;

    constructor() ERC721("Lente de Quartzo", "LQTZ") {}

    function mint() public {
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
    }

    function checkMembro(address usuario) public view override returns (bool) {
        return balanceOf(usuario) > 0;
    }
}