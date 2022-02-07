const { expect } = require("chai");
const { ethers } = require("hardhat");
const fs = require("fs");

describe("Divident Test", function () {
  let nft;
  let owner;
  let addr1;
  let addr2;

  let dividentDistributer;
  let token;

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();

    //test token deploy
    const TempToken = await ethers.getContractFactory("TempToken");
    token = await TempToken.deploy(1000);
    await token.deployed();

    expect(await token.balanceOf(owner.address)).to.be.equal(1000);

    // nft deploy
    const NFT = await ethers.getContractFactory("SVGNFT");
    nft = await NFT.deploy();
    await nft.deployed();

    // mint 10 nft

    for (let i = 0; i <= 9; i++) {
      const filePath = "./img/house-u1.svg";
      const svg = fs.readFileSync(filePath, { encoding: "utf8" });

      const transactionResponse = await nft.create(svg);
      const receit = await transactionResponse.wait(1);
    }

    const OwnerBalance = await nft.balanceOf(owner.address);
    expect(OwnerBalance).to.be.equal(10);

    // divident distributer deploy
    const DividentDistributer = await ethers.getContractFactory(
      "DividentDistributer"
    );
    dividentDistributer = await DividentDistributer.deploy(
      nft.address,
      token.address,
      5
    );

    await dividentDistributer.deployed();
  });

  it("pay dividents successfull", async function () {
    await token.transfer(dividentDistributer.address, 100);
    expect(await token.balanceOf(dividentDistributer.address)).to.be.equal(100);

    await dividentDistributer.payDividents();

    expect(await token.balanceOf(owner.address)).to.be.equal(950);
  });
});
