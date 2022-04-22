const hre = require("hardhat");

async function main() {
  const NFT = await hre.ethers.getContractFactory("NFTWhitelist");
  const nft = await NFT.deploy(
    "Web3 Group 3 ladies",
    "WGL",
    "fda3f793697acd377664e59987caa4b3a5c2118237e6c2889510a484a18b4ea3"
  );

  await nft.deployed();

  console.log("NFT deployed to:", nft.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
