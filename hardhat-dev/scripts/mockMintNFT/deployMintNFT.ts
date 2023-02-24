import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { Contract, ContractFactory } from 'ethers';
import { ethers, upgrades } from 'hardhat';

const deployMintNFT = async () => { 
  let mv: Contract;
  let owner: SignerWithAddress;
  [owner] = await ethers.getSigners();

  let mintNFTFactory: ContractFactory = await ethers.getContractFactory("MyVillage");
  mv = await upgrades.deployProxy(mintNFTFactory);

  await mv.deployed();

  console.log(`MyVillage contract address : ${mv.address}`);
}

(async () => {
  try {
    await deployMintNFT();
    process.exit(0);
  } catch (err) {
    console.log(err)
    process.exit(1);
  }
 })();