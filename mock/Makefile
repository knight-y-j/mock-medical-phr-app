include .env

.PHONY: run-localnet
run-localnet:
	anvil

.PHONY: deploy-localnet
deploy-localnet:
	forge script script/${DEPLOY} --fork-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast
