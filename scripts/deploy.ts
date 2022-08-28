import { ethers } from "hardhat";

async function main() {
  const ChainBattles = await ethers.getContractFactory("ChainBattles");
  const cb = await ChainBattles.deploy();

  await cb.deployed();

  console.log(`Contract deployed to ${cb.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
