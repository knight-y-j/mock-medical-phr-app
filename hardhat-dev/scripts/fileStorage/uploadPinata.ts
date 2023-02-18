import PinataClient, { PinataPinOptions } from '@pinata/sdk';
import fs from 'fs';
import dotENV from 'dotenv';
dotENV.config();

const name: string = 'MyVillage';

const pinata = new PinataClient({
  pinataApiKey: process.env.PINATA_KEY,
  pinataSecretApiKey: process.env.PINATA_SECRET
});

const uploadFileToPinata = async (): Promise<string> => { 
  const readableStreamForFile = fs.createReadStream('./assets/yakan.jpg');

  const imgOptions: PinataPinOptions = {
    pinataMetadata: {
        name: `${name}__image`,
    },
    pinataOptions: {
        cidVersion: 0
    }
  };

  const result = await pinata.pinFileToIPFS(readableStreamForFile, imgOptions);
  console.log(`https://gateway.pinata.cloud/ipfs/${result.IpfsHash}`);

  return result.IpfsHash;
}

const uploadMetadataToPinata = async (link: string):Promise<void> => { 
  const imgOptions: PinataPinOptions = {
    pinataMetadata: {
        name: `${name}__json`,
    },
    pinataOptions: {
        cidVersion: 0
    }
  };

  const metadata = {
    name : "YAKAN",
    symbol : "MyVillage",
    description : "this is yakan",
    image : `https://gateway.pinata.cloud/ipfs/${link}`,
    attributes : [
      {
        trait_type : "YAKAN",
        value : 1
      }
    ]
  };

  const result = await pinata.pinJSONToIPFS(metadata, imgOptions);
  console.log(`https://gateway.pinata.cloud/ipfs/${result.IpfsHash}`);
}

(async () => {
  try {
    const link = await uploadFileToPinata();
    await uploadMetadataToPinata(link);
    process.exit(0);
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
})();
