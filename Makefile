-include .env

all:  remove install build

clean  :; forge clean

remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install foundry-rs/forge-std --no-commit && forge install openzeppelin/openzeppelin-contracts --no-commit

update:; forge update

compile:; forge compile

build:; forge build

test :; forge test 

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

precommit :; forge fmt && git add .

deploy-faucet :; forge script script/faucet/DeployMonadexV1Faucet.s.sol \
	--broadcast \
	--rpc-url $(RPC_URL) \
	--private-key $(PRIVATE_KEY) \
	--verify --verifier $(VERIFIER) --verifier-url $(VERIFIER_URL) --etherscan-api-key $(VERIFICATION_API_KEY) \
	-vvvv

create-token-faucet :; forge script script/faucet/CreateTokenFaucet.s.sol \
	--broadcast \
	--rpc-url $(RPC_URL) \
	--private-key $(PRIVATE_KEY) \
	--verify --verifier $(VERIFIER) --verifier-url $(VERIFIER_URL) --etherscan-api-key $(VERIFICATION_API_KEY) \
	-vvvv

claim-from-faucet :; forge script script/faucet/ClaimTokensFromFaucet.s.sol \
	--broadcast \
	--rpc-url $(RPC_URL) \
	--private-key $(PRIVATE_KEY) \
	--verify --verifier $(VERIFIER) --verifier-url $(VERIFIER_URL) --etherscan-api-key $(VERIFICATION_API_KEY) \
	-vvvv

deploy-wmon :; forge script script/mocks/DeployWrappedMonad.s.sol \
	--broadcast \
	--rpc-url $(RPC_URL) \
	--private-key $(PRIVATE_KEY) \
	--verify --verifier $(VERIFIER) --verifier-url $(VERIFIER_URL) --etherscan-api-key $(VERIFICATION_API_KEY) \
	-vvvv

deploy-fot-token :; forge script script/mocks/DeployMockFOTToken.s.sol \
	--broadcast \
	--rpc-url $(RPC_URL) \
	--private-key $(PRIVATE_KEY) \
	--verify --verifier $(VERIFIER) --verifier-url $(VERIFIER_URL) --etherscan-api-key $(VERIFICATION_API_KEY) \
	-vvvv

deploy-multicall :; forge script script/multicall/DeployMonadexV1Multicall.s.sol \
	--broadcast \
	--rpc-url $(RPC_URL) \
	--private-key $(PRIVATE_KEY) \
	--verify --verifier $(VERIFIER) --verifier-url $(VERIFIER_URL) --etherscan-api-key $(VERIFICATION_API_KEY) \
	-vvvv