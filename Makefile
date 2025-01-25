-include .env

# comment line
SOLIDITY_COMMENT := "../commend line/solidity commend line.sh"

solidity:
	@bash $(SOLIDITY_COMMENT) $(text)

PYTHON_COMMENT := "../commend line/python commend line.sh"

python:
	@bash $(PYTHON_COMMENT) $(text)

RUN_SCRIPT:; forge script script/YAPPY_TOKEN.s.sol --rpc-url $(RPC_URL) --broadcast