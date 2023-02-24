import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { ContractFactory } from 'ethers';
import { ethers } from 'hardhat';

const MINT_CONTRACT_ADDRESS = '0xcd6c2D714B14cbC9B36F2B2F8D133EdDE940BDf1';
const META_DATA_URL = 'https://gateway.pinata.cloud/ipfs/QmTiiKc9JjkQAArVBvZa8ZS3kWnYeqQjtXEepjszw5kXVL/'

const mintNFT = async () => {
  let mintNFTFactory: ContractFactory;
  let owner: SignerWithAddress;
  [owner] = await ethers.getSigners();

  mintNFTFactory = await ethers.getContractFactory("MyVillage");

  await mintNFTFactory.attach(MINT_CONTRACT_ADDRESS).safeMint(owner.address, META_DATA_URL);

  console.log(`NFT minted to: ${owner.address}`);
}

(async () => {
  try {
    await mintNFT();
    process.exit(0);
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
})();
