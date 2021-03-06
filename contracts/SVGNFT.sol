// SPDX-License-Identifier: MIT
//give the contract some SVG code
//output an NFT URI with this SVG code
// storing all the nft metadata on-chain

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "base64-sol/base64.sol";

contract SVGNFT is ERC721URIStorage, Ownable {
    uint256 tokenCounter;

    event CreatedSVGNFT(uint256 indexed tokenId, string tokenURI);

    constructor() ERC721("SVG NFT", "svgNFT") {
        tokenCounter = 0;
    }

    function getTokenCounter() public view returns (uint256) {
        return tokenCounter;
    }

    function create(string memory svg) public onlyOwner {
        _safeMint(msg.sender, tokenCounter);
        string memory imageURI = svgToImageURI(svg);
        string memory tokenUri = formatTokenURI(imageURI);
        _setTokenURI(tokenCounter, tokenUri);
        emit CreatedSVGNFT(tokenCounter, tokenUri);
        tokenCounter = tokenCounter + 1;
    }

    function svgToImageURI(string memory svg)
        private
        pure
        returns (string memory)
    {
        // data:image/svg+xml;base64,<Base64-encoding>
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );

        string memory imageURI = string(
            abi.encodePacked(baseURL, svgBase64Encoded)
        );

        return imageURI;
    }

    function formatTokenURI(string memory imageURI)
        private
        pure
        returns (string memory)
    {
        string memory baseURL = "data:application/json;base64,";

        return
            string(
                abi.encodePacked(
                    baseURL,
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": "SVG NFT", ',
                                '"description": "An NFT based on SVG!", ',
                                '"attributes": "", ',
                                '"image": "',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}
