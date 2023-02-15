# Creat initial hardhat project
.PHONY: ht-deps
ht-deps: yarn-init ht-install ht-init

# Install NPM PKGs for initial hardhat project
.PHONY: yarn-deps
yarn-deps: yarn-install yarn-install-d

.PHONY: yarn-init
yarn-init:
	yarn init -y

.PHONY: yarn-install
yarn-install:
	yarn add @openzeppelin/contracts-upgradeable @openzeppelin/hardhat-upgrades @openzeppelin/hardhat-defender @gnosis.pm/safe-core-sdk @gnosis.pm/safe-ethers-lib @nomiclabs/hardhat-etherscan @openzeppelin/contracts @defi-wonderland/smock @nomiclabs/ethereumjs-vm @nomiclabs/hardhat-waffle nft.storage mime @types/mime ipfs-http-client dotenv

.PHONY: yarn-install-d
yarn-install-d:
	yarn add -D @types/dotenv tsconfig-paths

# Hardhat Cli
.PHONY: ht-install
ht-install:
	yarn add hardhat

.PHONY: ht-init
ht-init:
	npx hardhat
