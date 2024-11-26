-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil

ANVIL_WALLET_ACCOUNT := "dev_anvil"
METAMASK_WALLET_ACCOUNT := "dev_metamask"

help:
	@echo "Usage:"
	@echo "  make deployLocalCoinFlip [ARGS=...]\n    example: make deployLocalCoinFlip ARGS=\"--network sepolia\""

all: clean remove install update build

# Clean the repo
clean:; forge clean

# Remove modules
remove:; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install:; forge install Cyfrin/foundry-devops --no-commit

build:; forge build

anvil:; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

NETWORK_ARGS := --rpc-url http://localhost:8545 --account $(ANVIL_WALLET_ACCOUNT) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --account $(METAMASK_WALLET_ACCOUNT) --broadcast -vvvv
endif

deployLocalCoinFlip:
	@forge script script/DeployCoinFlip.s.sol:DeployCoinFlip $(NETWORK_ARGS)

attackCoinFlip:
	@forge script script/Interactions.s.sol:AttackCoinFlip $(NETWORK_ARGS)