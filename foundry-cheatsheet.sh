#!/bin/bash
# ==========================================
# Foundry Cheatsheet - Smart Contract Dev
# Author: 0xKimutai
# ==========================================

echo " Foundry Commands Cheatsheet "
echo ""

# -------------------------------
# Setup & Initialization
# -------------------------------
echo " Project Setup"
echo "forge init my-project        # Initialize a new Foundry project"
echo "forge install <repo>         # Install dependencies (e.g., OpenZeppelin)"
echo "forge update                 # Update dependencies"
echo ""

# -------------------------------
# Build & Compilation
# -------------------------------
echo " Build / Compile"
echo "forge build                  # Compile contracts"
echo "forge clean                  # Remove build artifacts"
echo ""

# -------------------------------
# Testing
# -------------------------------
echo " Testing"
echo "forge test                   # Run all tests"
echo "forge test -vvvv             # Run with detailed logs"
echo "forge test --match-test <t>  # Run a specific test function"
echo "forge snapshot               # Snapshot gas costs"
echo ""

# -------------------------------
# Script Execution
# -------------------------------
echo " Scripts"
echo "forge script script/MyScript.s.sol       # Run a script"
echo "forge script script/MyScript.s.sol --broadcast --rpc-url <URL>  # Run & broadcast"
echo ""

# -------------------------------
# Deployments
# -------------------------------
echo " Deployment"
echo "forge create src/Contract.sol:MyContract \ "
echo "  --rpc-url <URL> \ "
echo "  --private-key <KEY>       # Deploy contract"
echo ""

# -------------------------------
# Utilities
# -------------------------------
echo "🛠 Utilities"
echo "cast send <address> \"func(args)\" --rpc-url <URL> --private-key <KEY>   # Call/write to contract"
echo "cast call <address> \"func(args)\" --rpc-url <URL>                     # Call/read from contract"
echo "cast balance <address> --rpc-url <URL>                                # Check balance"
echo "cast chain-id --rpc-url <URL>                                         # Get chain ID"
echo ""

# -------------------------------
# ABI & Interfaces
# -------------------------------
echo " ABI & Interfaces"
echo "forge inspect src/Contract.sol:MyContract abi              # Get ABI"
echo "forge inspect src/Contract.sol:MyContract storageLayout    # Storage layout"
echo "forge inspect src/Contract.sol:MyContract methods          # List functions"
echo ""

# -------------------------------
# Gas & Coverage
# -------------------------------
echo " Gas & Coverage"
echo "forge test --gas-report      # Generate gas report"
echo "forge coverage               # Generate coverage report"
echo ""

# -------------------------------
# Fmt & Lint
# -------------------------------
echo " Format / Lint"
echo "forge fmt                    # Format Solidity code"
echo ""

echo "End of Foundry Cheatsheet"
