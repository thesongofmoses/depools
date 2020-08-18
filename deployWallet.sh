#!/bin/bash

username=$(whoami)
hostname=$(hostname -s)

pubkey1=$(echo 0x$(cat ~/ton-keys/$hostname.1.keys.json | grep 'public' | awk '{print $2}' | tr -d '"'\,))
pubkey2=$(echo 0x$(cat ~/ton-keys/$hostname.2.keys.json | grep 'public' | awk '{print $2}' | tr -d '"'\,))
pubkey3=$(echo 0x$(cat ~/ton-keys/$hostname.3.keys.json | grep 'public' | awk '{print $2}' | tr -d '"'\,))

cd ~/net.ton.dev/tonos-cli/target/release
./tonos-cli deploy ~/net.ton.dev/configs/SafeMultisigWallet.tvc \
        "{"\"owners"\":["\"${pubkey1}"\","\"${pubkey2}"\","\"${pubkey3}"\"],"\"reqConfirms"\":2}" \
        --abi ~/net.ton.dev/configs/SafeMultisigWallet.abi.json \
        --sign ~/ton-keys/$hostname.1.keys.json \
        --wc 0
