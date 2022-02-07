const { expect } = require("chai");
const { ethers } = require("hardhat");
const fs = require("fs");

describe("NFT test", function () {

  let nft
  let owner
  let addr1
  let addr2

  beforeEach(async function () {

    [owner, addr1, addr2] = await ethers.getSigners();
    const NFT = await ethers.getContractFactory("SVGNFT");
    nft = await NFT.deploy();
    await nft.deployed();

  });

  it("Only Owner can mint NFT", async function () {

    const filePath = "./img/house-u1.svg"
    const svg = fs.readFileSync(filePath, { encoding: "utf8" })

    const transactionResponse = await nft.create(svg)
    const receit = await transactionResponse.wait(1)

    const OwnerBalance = await nft.balanceOf(owner.address)
    expect(OwnerBalance).to.be.equal(1)

    await
      await expect(
        nft.connect(addr1).create(svg)
      ).to.be.revertedWith("Ownable: caller is not the owner")

  });

  it("Can send nft", async function () {

    const filePath = "./img/house-u1.svg"
    const svg = fs.readFileSync(filePath, { encoding: "utf8" })

    const transactionResponse = await nft.create(svg)
    const receit = await transactionResponse.wait(1)

    let OwnerBalance = await nft.balanceOf(owner.address)
    expect(OwnerBalance).to.be.equal(1)

    const send_response = await nft.transferFrom(owner.address, addr1.address, 0)
    const send_tx = await send_response.wait(1)

    const addr1Balance = await nft.balanceOf(addr1.address)
    expect(addr1Balance).to.be.equal(1)
     OwnerBalance = await nft.balanceOf(owner.address)
    expect(OwnerBalance).to.be.equal(0)

  });

  
});
