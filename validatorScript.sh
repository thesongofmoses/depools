#!/bin/bash

username=$(whoami)
hostname=$(hostname -s)

cd ~/net.ton.dev/tonos-cli/target/release
helper_addr=$(cat ~/ton-keys/$hostname.helper.addr)
./tonos-cli call $helper_addr sendTicktock {} --abi ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePoolHelper.abi.json --sign ~/ton-keys/$hostname.helper.keys.json

cd ~/net.ton.dev/scripts && ./validator_depool.sh | grep transId | awk '{print $2}' | tr -d '"' > ~/ton-keys/validator.confirm.txid

deploy_addr=$(cat ~/ton-keys/$hostname.addr)
txid=$(cat ~/ton-keys/validator.confirm.txid)
cd ~/net.ton.dev/tonos-cli/target/release
./tonos-cli call $deploy_addr \
        confirmTransaction "{"\"transactionId"\":"\"$txid"\"}" \
        --abi ~/net.ton.dev/configs/SafeMultisigWallet.abi.json \
        --sign ~/ton-keys/$hostname.2.keys.json
