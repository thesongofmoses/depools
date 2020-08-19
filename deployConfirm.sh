#!/bin/bash

username=$(whoami)
hostname=$(hostname -s)

cd ~/net.ton.dev/tonos-cli/target/release
n=$(cat ~/ton-keys/deploy.confirm.txid | wc -l)
deploy_addr=$(cat ~/ton-keys/$hostname.addr)

for (( i = 1; i <= n; i++ ))
do
txid=$(cat ~/ton-keys/deploy.confirm.txid | awk "FNR == ${i}")
./tonos-cli call $deploy_addr \
        confirmTransaction "{"\"transactionId"\":"\"$txid"\"}" \
        --abi ~/net.ton.dev/configs/SafeMultisigWallet.abi.json \
        --sign ~/ton-keys/$hostname.2.keys.json
done
