#!/bin/bash

hostname=$(hostname -s)

deploy_addr=$(cat ~/ton-keys/$hostname.addr)
proxy0_addr=$(cat ~/ton-keys/$hostname.proxy0.addr)
proxy1_addr=$(cat ~/ton-keys/$hostname.proxy1.addr)
depool_addr=$(cat ~/ton-keys/$hostname.depool.addr)
helper_addr=$(cat ~/ton-keys/$hostname.helper.addr)

cd ~/net.ton.dev/tonos-cli/target/release

if [ "${1}" == '--help' ];
then
        echo 'Usage: ./stake.sh <subcommand> <arg>'
        echo 'Options: --ordinary --vesting --lock --transfer --withdraw --remove'
        exit 0
fi


if [ "${1}" == 'ordinary' ] && [ "${2}" == '--help' ];
then
        echo 'Usage: ./stake.sh ordinary <value>'
        exit 0

elif [ "${1}" == 'ordinary' ];
then
        ./tonos-cli depool stake ordinary --value "${2}" | grep transId | awk '{print $2}' | tr -d '"' > ~/ton-keys/ordinary.confirm.txid
        ordinary_txid=$(cat ~/ton-keys/ordinary.confirm.txid)
        ./tonos-cli call $deploy_addr \
                confirmTransaction "{"\"transactionId"\":"\"$ordinary_txid"\"}" \
                --abi ~/net.ton.dev/configs/SafeMultisigWallet.abi.json \
                --sign ~/ton-keys/$hostname.2.keys.json
fi

if [ "${1}" == 'vesting' ] && [ "${2}" == '--help' ];
then
        echo 'Usage: ./stake.sh vesting <value> <total period in days> <withdrawal in days> <beneficiary addr>'
        echo 'Info: <total period in days> must be exactly divisible by <withdrawal in days>'
        exit 0

elif [ "${1}" == 'vesting' ];
then
        ./tonos-cli depool stake vesting --value "${2}" --total "${3}" --withdrawal "${4}" --beneficiary "${5}" | grep transId | awk '{print $2}' | tr -d '"' > ~/ton-keys/vesting.confirm.txid

        vesting_txid=$(cat ~/ton-keys/vesting.confirm.txid)
        ./tonos-cli call $deploy_addr \
        confirmTransaction "{"\"transactionId"\":"\"$vesting_txid"\"}" \
        --abi ~/net.ton.dev/configs/SafeMultisigWallet.abi.json \
        --sign ~/ton-keys/$hostname.2.keys.json
fi

if [ "${1}" == 'lock' ] && [ "${2}" == '--help' ];
then
        echo 'Usage: ./stake.sh lock <value> <total period in days> <withdrawal days> <beneficiary addr>'
        echo 'Info: <total period in days> must be exactly divisible by <withdrawal in days>'
        exit 0

elif [ "${1}" == 'lock' ];
then
        ./tonos-cli depool stake lock --value "${2}" --total "${3}" --withdrawal "${4}" --beneficiary "${5}"  | grep transId | awk '{print $2}' | tr -d '"' > ~/ton-keys/lock.confirm.txid

        lock_txid=$(cat ~/ton-keys/lock.confirm.txid)
        ./tonos-cli call $deploy_addr \
        confirmTransaction "{"\"transactionId"\":"\"$lock_txid"\"}" \
        --abi ~/net.ton.dev/configs/SafeMultisigWallet.abi.json \
        --sign ~/ton-keys/$hostname.2.keys.json
fi

if [ "${1}" == 'remove' ] && [ "${2}" == '--help' ];
then
        echo 'Usage: ./stake.sh remove <value>'
        exit 0

elif [ "${1}" == 'remove' ];
then
        cd ~/net.ton.dev/tonos-cli/target/release
        ./tonos-cli depool stake remove --value "${2}" | grep transId | awk '{print $2}' | tr -d '"' > ~/ton-keys/remove.confirm.txid

        remove_txid=$(cat ~/ton-keys/remove.confirm.txid)
        ./tonos-cli call $deploy_addr \
        confirmTransaction "{"\"transactionId"\":"\"$remove_txid"\"}" \
        --abi ~/net.ton.dev/configs/SafeMultisigWallet.abi.json \
        --sign ~/ton-keys/$hostname.2.keys.json
fi

if [ "${1}" == 'transfer' ] && [ "${2}" == '--help' ];
then
        echo 'Usage: ./stake.sh transfer <value> <dest>'
        exit 0

elif [ "${1}" == 'transfer' ];
then
        ./tonos-cli depool stake transfer --value "${2}" --dest "${3}" | grep transId | awk '{print $2}' | tr -d '"' > ~/ton-keys/transfer.confirm.txid

        transfer_txid=$(cat ~/ton-keys/transfer.confirm.txid)
        ./tonos-cli call $deploy_addr \
        confirmTransaction "{"\"transactionId"\":"\"$transfer_txid"\"}" \
        --abi ~/net.ton.dev/configs/SafeMultisigWallet.abi.json \
        --sign ~/ton-keys/$hostname.2.keys.json
fi

if [ "${1}" == 'withdraw' ];
then
        ./tonos-cli depool withdraw off
fi
