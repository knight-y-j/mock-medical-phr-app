import PinataClient, { PinataPinOptions } from '@pinata/sdk';
import fs from 'fs';
import dotENV from 'dotenv';
dotENV.config();

const pinataLink: string = 'https://gateway.pinata.cloud/ipfs/';

type MetadataArgs = {
  uploadfileName: string;
  cid: string;
  symbolName: string;
  metadataName: string;
  description: string;
  traitType: string;
}

const pinata = new PinataClient({
  pinataApiKey: process.env.PINATA_KEY,
  pinataSecretApiKey: process.env.PINATA_SECRET
});

const uploadFileToPinata = async (_uploadfileName: string): Promise<string> => { 
  const readableStreamForFile = fs.createReadStream('./assets/yakan.jpg');

  const imgOptions: PinataPinOptions = {
    pinataMetadata: {
        name: `${_uploadfileName}__image`,
    },
    pinataOptions: {
        cidVersion: 0
    }
  };

  const result = await pinata.pinFileToIPFS(readableStreamForFile, imgOptions);
  console.log(`${pinataLink}${result.IpfsHash}`);

  return result.IpfsHash;
}

const uploadMetadataToPinata = async (_args: MetadataArgs):Promise<void> => { 
  const imgOptions: PinataPinOptions = {
    pinataMetadata: {
        name: `${_args.uploadfileName}__json`,
    },
    pinataOptions: {
        cidVersion: 0
    }
  };

  const metadata = {
    name : _args.metadataName,
    symbol : _args.symbolName,
    description : _args.description,
    image : `${pinataLink}${_args.cid}`,
    attributes : [
      {
        trait_type : _args.traitType,
        value : 1
      }
    ]
  };

  const result = await pinata.pinJSONToIPFS(metadata, imgOptions);
  console.log(`${pinataLink}${result.IpfsHash}`);
}

(async () => {
  let args: MetadataArgs;
  let uploadfileName = "MyVillage";

  try {
    const cid = await uploadFileToPinata(uploadfileName);

    args = {
      uploadfileName,
      cid,
      symbolName: "MyVillage",
      metadataName: "YAKAN",
      description: "this is yakan",
      traitType: "YAKAN",
    }

    await uploadMetadataToPinata(args);
    process.exit(0);
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
})();
