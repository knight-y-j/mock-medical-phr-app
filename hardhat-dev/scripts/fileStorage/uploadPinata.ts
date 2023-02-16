import PinataClient, { PinataPinOptions } from '@pinata/sdk';
import fs from 'fs';
import dotENV from 'dotenv';
dotENV.config();

const name: string = 'MyToken';

const pinata = new PinataClient({
  pinataApiKey: process.env.PINATA_KEY,
  pinataSecretApiKey: process.env.PINATA_SECRET
});

// https://github.com/ultronDebugs/oneNftMintService/blob/e35935417392470e1631e99554e7576d74728c94/src/uploadMetadata.ts

// npx ts-node scripts/fileStorage/uploadPinata.ts 
// {
//   IpfsHash: 'Qmb5ALi1RT1is8W6bTaXqGZwCQ4RrQmcvMFJHvVRtdQGMF',
//   PinSize: 113123,
//   Timestamp: '2023-02-16T08:13:47.625Z'
// }

const uploadFileToPinata = async () => { 
  const readableStreamForFile = fs.createReadStream('./assets/sample.jpg');

  const imgOptions: PinataPinOptions = {
    pinataMetadata: {
        name: `${name}__image`,
        // keyvalues: {
        //     customKey: 'customValue',
        // }
    },
    pinataOptions: {
        cidVersion: 0
    }
  };

  const result = await pinata.pinFileToIPFS(readableStreamForFile, imgOptions);
  console.log(result);
}

const uploadMetadataToPinata = async () => { 
  const readableStreamForFile = fs.createReadStream('./assets/sample.jpg');

  const imgOptions: PinataPinOptions = {
    pinataMetadata: {
        name: `${name}__json`,
        // keyvalues: {
        //     customKey: 'customValue',
        // }
    },
    pinataOptions: {
        cidVersion: 0
    }
  };

  const result = await pinata.pinFileToIPFS(readableStreamForFile, imgOptions);
  console.log(result);
}

(async () => {
  try {
    await uploadFileToPinata();
    process.exit(0);
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
})();
