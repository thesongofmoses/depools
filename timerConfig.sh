#!/bin/bash

hostname=$(hostname -s)
helper_addr=$(cat ~/ton-keys/$hostname.helper.addr)

if [ ${1} == '--help' ];
then
        echo 'Usage: ./timerConfig.sh <timer_addr> <period>'
        exit 0
fi

cd ~/net.ton.dev/tonos-cli/target/release
./tonos-cli call $helper_addr initTimer "{"\"timer"\":"\"${1}"\","\"period"\":"\"${2}"\"}" \
        --abi ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePoolHelper.abi.json \
        --sign ~/ton-keys/$hostname.helper.keys.json
