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

deploy_addr=$(cat ~/ton-keys/$hostname.addr)
proxy0_addr=$(cat ~/ton-keys/$hostname.proxy0.addr)
proxy1_addr=$(cat ~/ton-keys/$hostname.proxy1.addr)
depool_addr=$(cat ~/ton-keys/$hostname.depool.addr)
helper_addr=$(cat ~/ton-keys/$hostname.helper.addr)

./tonos-cli call $deploy_addr \
        submitTransaction "{"\"dest"\":"\"${proxy0_addr}"\","\"value"\":200000000,"\"bounce"\":false,"\"allBalance"\":false,"\"payload"\":"\""\"}" \
        --abi ~/net.ton.dev/configs/SafeMultisigWallet.abi.json \
        --sign ~/ton-keys/$hostname.1.keys.json \
        | awk 'FNR == 18 {prtint $2}' | tr -d '"' > ~/ton-keys/deploy.confirm.txid

./tonos-cli call $deploy_addr \
        submitTransaction "{"\"dest"\":"\"${proxy1_addr}"\","\"value"\":200000000,"\"bounce"\":false,"\"allBalance"\":false,"\"payload"\":"\""\"}" \
        --abi ~/net.ton.dev/configs/SafeMultisigWallet.abi.json \
        --sign ~/ton-keys/$hostname.1.keys.json \
        | awk 'FNR == 18 {prtint $2}' | tr -d '"' >> ~/ton-keys/deploy.confirm.txid

./tonos-cli call $deploy_addr \
        submitTransaction "{"\"dest"\":"\"${depool_addr}"\","\"value"\":200000000,"\"bounce"\":false,"\"allBalance"\":false,"\"payload"\":"\""\"}" \
        --abi ~/net.ton.dev/configs/SafeMultisigWallet.abi.json \
        --sign ~/ton-keys/$hostname.1.keys.json \
        | awk 'FNR == 18 {prtint $2}' | tr -d '"' >> ~/ton-keys/deploy.confirm.txid

./tonos-cli call $deploy_addr \
        submitTransaction "{"\"dest"\":"\"${helper_addr}"\","\"value"\":200000000,"\"bounce"\":false,"\"allBalance"\":false,"\"payload"\":"\""\"}" \
        --abi ~/net.ton.dev/configs/SafeMultisigWallet.abi.json \
        --sign ~/ton-keys/$hostname.1.keys.json \
        | awk 'FNR == 18 {prtint $2}' | tr -d '"' >> ~/ton-keys/deploy.confirm.txid

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

./tonos-cli deploy ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePoolProxy.tvc "{"\"depool":"$depool_addr"\"}" --abi ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePoolProxy.abi.json --sign ~/ton-keys/$hostname.proxy0.keys.json --wc -1
./tonos-cli deploy ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePoolProxy.tvc "{"\"depool":"$depool_addr"\"}" --abi ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePoolProxy.abi.json --sign ~/ton-keys/$hostname.proxy1.keys.json --wc -1
./tonos-cli deploy ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePool.tvc "{"\"minRoundStake":100000000000000,"\"proxy0"\":"\"$proxy0_addr"\","\"proxy1"\":"\"$proxy1_addr"\","\"validatorWallet"\":"\"$deploy_addr"\","\"minStake"\":50000000000}" --abi ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePool.abi.json --sign ~/ton-keys/$hostname.depool.keys.json
