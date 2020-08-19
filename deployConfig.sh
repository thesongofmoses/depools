#!/bin/bash

./tonos-cli call $helper_addr \
        initTimer '{"timer":"0:325e835960b83108ed594e395167c967bfc0ede9e7ef057aae364b1c0ab75467","period":360}' \
        --abi ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePoolHelper.abi.json \
        --sign ~/ton-keys/$hostname.helper.keys.json
