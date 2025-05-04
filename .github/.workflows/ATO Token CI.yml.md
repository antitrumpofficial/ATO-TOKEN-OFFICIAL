name: ATO Token CI

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  compile:
    name: Compile Solidity Contract
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install Dependencies
        run: |
          npm install -g hardhat

      - name: Compile Contract
        run: |
          npx hardhat compile

  lint:
    name: Lint Check (Basic)
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3

      - name: Lint Solidity (Basic Check)
        run: |
          echo "No advanced linter yet. Add slither or solhint if needed."