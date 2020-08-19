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
        submitTransaction "{"\"dest"\":"\"${proxy0_addr}"\","\"value"\":20000000000,"\"bounce"\":false,"\"allBalance"\":false,"\"payload"\":"\""\"}" \
        --abi ~/net.ton.dev/configs/SafeMultisigWallet.abi.json \
        --sign ~/ton-keys/$hostname.1.keys.json \
        | grep transId | awk '{print $2}' | tr -d '"' > ~/ton-keys/deploy.confirm.txid

./tonos-cli call $deploy_addr \
        submitTransaction "{"\"dest"\":"\"${proxy1_addr}"\","\"value"\":20000000000,"\"bounce"\":false,"\"allBalance"\":false,"\"payload"\":"\""\"}" \
        --abi ~/net.ton.dev/configs/SafeMultisigWallet.abi.json \
        --sign ~/ton-keys/$hostname.1.keys.json \
        | grep transId | awk '{print $2}' | tr -d '"' >> ~/ton-keys/deploy.confirm.txid

./tonos-cli call $deploy_addr \
        submitTransaction "{"\"dest"\":"\"${depool_addr}"\","\"value"\":20000000000,"\"bounce"\":false,"\"allBalance"\":false,"\"payload"\":"\""\"}" \
        --abi ~/net.ton.dev/configs/SafeMultisigWallet.abi.json \
        --sign ~/ton-keys/$hostname.1.keys.json \
        | grep transId | awk '{print $2}' | tr -d '"' >> ~/ton-keys/deploy.confirm.txid

./tonos-cli call $deploy_addr \
        submitTransaction "{"\"dest"\":"\"${helper_addr}"\","\"value"\":20000000000,"\"bounce"\":false,"\"allBalance"\":false,"\"payload"\":"\""\"}" \
        --abi ~/net.ton.dev/configs/SafeMultisigWallet.abi.json \
        --sign ~/ton-keys/$hostname.1.keys.json \
        | grep transId | awk '{print $2}' | tr -d '"' >> ~/ton-keys/deploy.confirm.txid

for i in {1..4}
do
txid=$(cat ~/ton-keys/deploy.confirm.txid | awk "FNR == ${i}")
./tonos-cli call $deploy_addr \
        confirmTransaction "{"\"transactionId"\":"\"$txid"\"}" \
        --abi ~/net.ton.dev/configs/SafeMultisigWallet.abi.json \
        --sign ~/ton-keys/$hostname.2.keys.json
done

./tonos-cli deploy ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePoolProxy.tvc "{"\"depool"\":"\"$depool_addr"\"}" --abi ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePoolProxy.abi.json --sign ~/ton-keys/$hostname.proxy0.keys.json --wc -1
./tonos-cli deploy ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePoolProxy.tvc "{"\"depool"\":"\"$depool_addr"\"}" --abi ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePoolProxy.abi.json --sign ~/ton-keys/$hostname.proxy1.keys.json --wc -1
./tonos-cli deploy ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePool.tvc "{"\"minRoundStake"\":100000000000000,"\"proxy0"\":"\"$proxy0_addr"\","\"proxy1"\":"\"$proxy1_addr"\","\"validatorWallet"\":"\"$deploy_addr"\","\"minStake"\":50000000000}" --abi ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePool.abi.json --sign ~/ton-keys/$hostname.depool.keys.json --wc 0
./tonos-cli deploy ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePoolHelper.tvc "{"\"pool"\":"\"$depool_addr"\"}" --abi ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePoolHelper.abi.json --sign ~/ton-keys/$hostname.helper.keys.json --wc 0

cd ~/net.ton.dev/tonos-cli/target/release
./tonos-cli call $helper_addr \
        initTimer '{"timer":"0:325e835960b83108ed594e395167c967bfc0ede9e7ef057aae364b1c0ab75467","period":360}' \
        --abi ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePoolHelper.abi.json \
        --sign ~/ton-keys/$hostname.helper.keys.json

./tonos-cli config --addr $depool_addr --wallet $deploy_addr --keys ~/ton-keys/$hostname.1.keys.json --retries 10 --timeout 120000

./tonos-cli depool withdraw off | grep transId | awk '{print $2}' | tr -d '"' > ~/ton-keys/withdraw.confirm.txid

withdraw_txid=$(cat ~/ton-keys/withdraw.confirm.txid)
./tonos-cli call $deploy_addr \
        confirmTransaction "{"\"transactionId"\":"\"$withdraw_txid"\"}" \
        --abi ~/net.ton.dev/configs/SafeMultisigWallet.abi.json \
        --sign ~/ton-keys/$hostname.2.keys.json

echo 'Deploy Succeeded"
