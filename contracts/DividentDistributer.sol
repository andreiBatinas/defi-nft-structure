// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./SVGNFT.sol";

contract DividentDistributer is Ownable {
    SVGNFT nftCollection;
    IERC20 daiToken;
    uint256 daiRewardAmount;

    constructor(
        address _nftCollectionAddress,
        address _daiTokenAddress,
        uint256 _daiRewardAmount
    ) {
        nftCollection = SVGNFT(_nftCollectionAddress);
        daiToken = IERC20(_daiTokenAddress);
        daiRewardAmount = _daiRewardAmount;
    }

    function payDividents() public onlyOwner {
        uint256 amountOfMintedNft = nftCollection.getTokenCounter();

        require(amountOfMintedNft > 0, "No minted NFTs");
        require(
            daiToken.balanceOf(address(this)) >
                amountOfMintedNft * daiRewardAmount,
            "Not enough dai token"
        );

        for (uint256 index = 0; index < amountOfMintedNft; index++) {
            address nftOwner = nftCollection.ownerOf(index);
            uint256 nftAmount = nftCollection.balanceOf(nftOwner);

            daiToken.transfer(nftOwner, nftAmount * daiRewardAmount);
        }
    }
}
