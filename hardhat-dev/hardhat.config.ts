import '@nomiclabs/hardhat-ethers';
import '@openzeppelin/hardhat-upgrades';
import '@nomiclabs/hardhat-etherscan';
import "hardhat-gas-reporter"
import '@nomicfoundation/hardhat-toolbox';
import '@typechain/hardhat';
import '@typechain/hardhat/dist/type-extensions';
import 'tsconfig-paths/register';
import '@nomicfoundation/hardhat-chai-matchers';
import { HardhatUserConfig, task } from 'hardhat/config';
import { HardhatArguments, HardhatRuntimeEnvironment } from 'hardhat/types';

import dotENV from 'dotenv';
dotENV.config();

// Note: 200 seconds max for running tests
const runningTestTime: number = 200000;

task("accounts", "Prints the list of accounts", async (args: HardhatArguments, hre: HardhatRuntimeEnvironment): Promise<void> => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(await account.address);
  }
})

const config: HardhatUserConfig = {
  paths: {
    sources: './contracts',
  },
  defaultNetwork: 'hardhat',
  solidity: {
    version: "0.8.17",
    settings: {
      outputSelection: {
        "*": {
          "*": ["storageLayout"]
        }
      },
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    hardhat: {
      chainId: 31337,
      allowUnlimitedContractSize: true,
    },
    localnode: {
      url: `http://localhost:8545`,
      chainId: 31337,
      allowUnlimitedContractSize: true,
    },
    goerli: {
      url: `https://goerli.infura.io/v3/${process.env.RPC_ENDPOINT_URI}`,
      accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY]: [],
      chainId: 5,
    }
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
  gasReporter: {
    enabled: true,
    currency: 'USD',
    outputFile: "gas-report.txt",
    noColors: true,
    // coinmarketcap: process.env.COINMARKETCAP_API_KEY
  },
  typechain: {
    outDir: './typechain-types',
    target: 'ethers-v5',
  },
  mocha: {
    timeout: runningTestTime,
  }
};

export default config;
