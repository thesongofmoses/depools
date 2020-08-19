#!/bin/bash

hostname=$(hostname -s)

deploy_addr=$(cat ~/ton-keys/$hostname.addr)
proxy0_addr=$(cat ~/ton-keys/$hostname.proxy0.addr)
proxy1_addr=$(cat ~/ton-keys/$hostname.proxy1.addr)
depool_addr=$(cat ~/ton-keys/$hostname.depool.addr)
helper_addr=$(cat ~/ton-keys/$hostname.helper.addr)

if [ "${1}" == '--help' ];
then
        echo 'Usage: ./stake.sh <option> <value in regular unit>'
        echo 'Options: --ordinary --vesting --lock --transfer --withdraw --remove'
        exit 0
fi

if [ "${1}" == '--ordinary' ];
then
cd ~/net.ton.dev/tonos-cli/target/release
./tonos-cli depool stake ordinary --value "${2}" --autoresume-off | grep transId | awk '{print $2}' | tr -d '"' > ~/ton-keys/ordinary.confirm.txid


ordinary_txid=$(cat ~/ton-keys/ordinary.confirm.txid)
./tonos-cli call $deploy_addr \
        confirmTransaction "{"\"transactionId"\":"\"$ordinary_txid"\"}" \
        --abi ~/net.ton.dev/configs/SafeMultisigWallet.abi.json \
        --sign ~/ton-keys/$hostname.2.keys.json
fi

if [ "${1}" == '--vesting' ];
then

if [ "${1}" == '--lock' ];
then

if [ "${1}" == '--transfer' ];
then

if [ "${1}" == '--withdraw' ];
then

if [ "${1}" == '--remove' ];
then
