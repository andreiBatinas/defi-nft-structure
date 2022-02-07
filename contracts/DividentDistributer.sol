// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./SVGNFT.sol";

import "hardhat/console.sol";

contract DividentDistributer is Ownable {
    SVGNFT nftCollection;
    IERC20 rewardToken;
    uint256 rewardAmount;

    constructor(
        address _nftCollectionAddress,
        address _rewardTokenAddress,
        uint256 _rewardAmount
    ) {
        nftCollection = SVGNFT(_nftCollectionAddress);
        rewardToken = IERC20(_rewardTokenAddress);
        rewardAmount = _rewardAmount;
    }

    function setRewardAmount(uint256 _rewardAmount) public onlyOwner {
        rewardAmount = _rewardAmount;
    }

    function getRewardAmount() public view returns (uint256) {
        return rewardAmount;
    }

    function setRewardToken(address _rewardTokenAddress) public onlyOwner {
        rewardToken = IERC20(_rewardTokenAddress);
    }

    function setNftCollectionAddress(address _nftCollectionAddress)
        public
        onlyOwner
    {
        nftCollection = SVGNFT(_nftCollectionAddress);
    }

    function payDividents() public onlyOwner {
        uint256 amountOfMintedNft = nftCollection.getTokenCounter();

        require(amountOfMintedNft > 0, "No minted NFTs");
        require(
            rewardToken.balanceOf(address(this)) >
                amountOfMintedNft * rewardAmount,
            "Not enough dai token"
        );

        console.log("Amount of minted NFT: %s", amountOfMintedNft);

        for (uint256 index = 0; index < amountOfMintedNft; index++) {
            address nftOwner = nftCollection.ownerOf(index);
            uint256 nftAmount = nftCollection.balanceOf(nftOwner);

            console.log("Owner: %s, nftAmount: %s", nftOwner, nftAmount);

            rewardToken.transfer(nftOwner, rewardAmount);
        }
    }
}
