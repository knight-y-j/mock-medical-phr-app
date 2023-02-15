import { create } from 'ipfs-http-client';

const uploadIPFS = async () => { 
  const client = create({
    host: '0.0.0.0',
    port: 5001,
    protocol: 'https'
  })

  console.log(client);
}

(async () => {
  try {
    await uploadIPFS();
    process.exit(0);
  } catch (err) {
    console.log(err)
    process.exit(1);
  }
})();
