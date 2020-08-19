#!/bin/bash

username=$(whoami)
hostname=$(hostname -s)

deploy_addr=$(cat ~/ton-keys/$hostname.addr)
proxy0_addr=$(cat ~/ton-keys/$hostname.proxy0.addr)
proxy1_addr=$(cat ~/ton-keys/$hostname.proxy1.addr)
depool_addr=$(cat ~/ton-keys/$hostname.depool.addr)
helper_addr=$(cat ~/ton-keys/$hostname.helper.addr)

cd ~/net.ton.dev/tonos-cli/target/release
./tonos-cli call $helper_addr \
        initTimer '{"timer":"0:325e835960b83108ed594e395167c967bfc0ede9e7ef057aae364b1c0ab75467","period":360}' \
        --abi ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePoolHelper.abi.json \
        --sign ~/ton-keys/$hostname.helper.keys.json
