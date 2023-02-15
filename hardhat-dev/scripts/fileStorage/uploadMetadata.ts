import { NFTStorage, File } from 'nft.storage';
import mime from 'mime';
import { Token, TokenInput } from 'nft.storage/dist/src/token';
import fs from 'fs';
import path from 'path';

import dotENV from 'dotenv';
dotENV.config();

// npx ts-node scripts/fileStorage/uploadMetadata.ts 
// Metadata stored on Filecoin and IPFS with URL: ipfs://bafyreihuyiqgb5tv7oho33lbam7z5fisvu7qvylptk2se74tjuvahprer4/metadata.json

const fileFromPath = async (filePath: string): Promise<File> => {
  const content = await fs.promises.readFile(filePath);
  const type = mime.getType(filePath)!;

  return new File([content], path.basename(filePath), { type })
}

const uploadToFileStorage = async (client: NFTStorage): Promise<Token<TokenInput>> => {
  const name: string = 'MyToken';
  const description: string = 'This asset is a test metadata';
  const filePath: string = 'assets/sample.jpg';

  const image = await fileFromPath(filePath);

  return await client.store({
    image,
    name,
    description,
  })
}

const storeAsset = async () => {
  let client: NFTStorage;
  let metadata: Token<TokenInput>;

  try {
    client = new NFTStorage({
      token: process.env.STORAGE_API_KEY!
    });

    if (client) {
      metadata = await uploadToFileStorage(client);

      console.log(`Metadata stored on Filecoin and IPFS with URL: ${metadata.url}`)
    }
  } catch (err) {
    throw new Error(`Could not upload metadata : ${err}`);
  }
}

(async () => {
  try {
    await storeAsset();
    process.exit(0);
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
})()
