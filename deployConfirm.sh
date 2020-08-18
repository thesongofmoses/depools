#!/bin/bash

n=$(cat ~/ton-keys/deploy.confirm.txid | wc -l)

for (( i = 1; i <= n; i++ ));
do
txid=$(cat ~/ton-keys/deploy.confirm.txid | awk "FNR == ${i}")
./tonos-cli call $deploy_addr \
        confirmTransaction '{"transactionId":"$txid"}' \
        --abi ~/net.ton.dev/configs/SafeMultisigWallet.abi.json \
        --sign ~/ton-keys/$hostname.2.keys.json 
done
