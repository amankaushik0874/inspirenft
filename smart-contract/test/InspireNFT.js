const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Inspire NFT", function () {
  let inftContract;
  let owner;
  let address1;

  beforeEach(async () => {
    const INFT = await ethers.getContractFactory("InspireNFT");
    inftContract = await INFT.deploy();
    [owner, address1] = await ethers.getSigners();
  });
  it("Should return the success deploy", async function () {
    const deployed = await inftContract.deployed();

    // eslint-disable-next-line no-unused-expressions
    expect(deployed?.deployTransaction?.hash).to.not.be.null;
  });

  it("NFT is minted successfully", async function () {
    const deployed = await inftContract.deployed();

    expect(await deployed.balanceOf(address1.address)).to.equal(0);

    const tokenURI =
      "https://opensea-creatures-api.herokuapp.com/api/creature/1";
    const tx = await deployed
      .connect(owner)
      .mint(
        address1.address,
        tokenURI,
        "hashDoArquivo",
        1234,
        "mov",
        "MeuGoldePlaca",
        "Gol do Bruno no Maracana 1987",
        "Gol mais bonito da história do maracana",
        "external_id123456"
      );

    const receipt = await tx.wait();
    expect(await deployed.balanceOf(address1.address)).to.equal(1);
    expect(receipt.events[1].event).to.equal("MintedNFT");
  });
  it("Should Add Collection", async function () {
    const deployed = await inftContract.deployed();

    const addNft = await deployed.addCollection(
      "LAMBO",
      "description",
      "google.com",
      "0x46A8E0e3C7597077d69A779574641989e8ed934F"
    );
    const addedNft = await addNft.wait();
    expect(addedNft.events[0].event).to.equal("NewCollection");
  });
});
