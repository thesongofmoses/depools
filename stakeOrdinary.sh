#!/bin/bash

if [ "${1}" == '--help' ];
then
        echo 'Usage: ./stakeOrdinary.sh <value in regular unit>'
        exit 0
fi

if [ "${1}" == 'ordinary' ];
then
cd ~/net.ton.dev/tonos-cli/target/release
./tonos-cli depool stake ordinary --value "${1}" --autoresume-off | grep transId | awk '{print $2}' | tr -d '"' > ~/ton-keys/ordinary.confirm.txid

hostname=$(hostname -s)
deploy_addr=$(cat ~/ton-keys/$hostname.addr)
txid=$(cat ~/ton-keys/ordinary.confirm.txid)
./tonos-cli call $deploy_addr \
        confirmTransaction "{"\"transactionId"\":"\"$txid"\"}" \
        --abi ~/net.ton.dev/configs/SafeMultisigWallet.abi.json \
        --sign ~/ton-keys/$hostname.2.keys.json
fi

