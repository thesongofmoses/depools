#!/bin/bash

username=$(whoami)
hostname=$(hostname -s)

cd ~/net.ton.dev/tonos-cli/target/release
rm ~/ton-keys/$hostname.seed.csv

for i in {1..3};
do
seed_phrase=$(./tonos-cli genphrase | awk 'FNR == 3' | sed 's/^.\{13\}//')
       echo "${seed_phrase}" >> ~/ton-keys/$hostname.seed.csv
parsed_seed_phrase=$(cat ~/ton-keys/$hostname.seed.csv | awk "FNR == ${i}" | tr -d '"')
        ./tonos-cli getkeypair ~/ton-keys/$hostname.${i}.keys.json "$parsed_seed_phrase"
        cp ~/ton-keys/$hostname.1.keys.json ~/ton-keys/msig.keys.json
deploy_key=~/ton-keys/$hostname.1.keys.json
raw_addr=$(./tonos-cli genaddr ~/net.ton.dev/configs/SafeMultisigWallet.tvc ~/net.ton.dev/configs/SafeMultisigWallet.abi.json --setkey $deploy_key --wc 0)
        echo "$raw_addr" | awk 'FNR == 9 {print $3}' > ~/ton-keys/$hostname.addr
done

proxy0_seed_phrase=$(./tonos-cli genphrase | awk 'FNR == 3' | sed 's/^.\{13\}//')
       echo "${proxy0_seed_phrase}" > ~/ton-keys/$hostname.proxy0.seed.csv
proxy1_seed_phrase=$(./tonos-cli genphrase | awk 'FNR == 3' | sed 's/^.\{13\}//')
       echo "${proxy1_seed_phrase}" > ~/ton-keys/$hostname.proxy1.seed.csv
depool_seed_phrase=$(./tonos-cli genphrase | awk 'FNR == 3' | sed 's/^.\{13\}//')
       echo "${depool_seed_phrase}" > ~/ton-keys/$hostname.depool.seed.csv
helper_seed_phrase=$(./tonos-cli genphrase | awk 'FNR == 3' | sed 's/^.\{13\}//')
       echo "${helper_seed_phrase}" > ~/ton-keys/$hostname.helper.seed.csv

parsed_proxy0_seed_phrase=$(cat ~/ton-keys/$hostname.proxy0.seed.csv | tr -d '"')
        ./tonos-cli getkeypair ~/ton-keys/$hostname.proxy0.keys.json "$parsed_proxy0_seed_phrase"
proxy0_deploy_key=~/ton-keys/$hostname.proxy0.keys.json
proxy0_raw_addr=$(./tonos-cli genaddr ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePoolProxy.tvc ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePoolProxy.abi.json --setkey $proxy0_deploy_key --wc -1)
        echo "$proxy0_raw_addr" | awk 'FNR == 9 {print $3}' > ~/ton-keys/$hostname.proxy0.addr

parsed_proxy1_seed_phrase=$(cat ~/ton-keys/$hostname.proxy1.seed.csv | tr -d '"')
        ./tonos-cli getkeypair ~/ton-keys/$hostname.proxy1.keys.json "$parsed_proxy1_seed_phrase"
proxy1_deploy_key=~/ton-keys/$hostname.proxy1.keys.json
proxy1_raw_addr=$(./tonos-cli genaddr ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePoolProxy.tvc ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePoolProxy.abi.json --setkey $proxy1_deploy_key --wc -1)
        echo "$proxy1_raw_addr" | awk 'FNR == 9 {print $3}' > ~/ton-keys/$hostname.proxy1.addr

parsed_depool_seed_phrase=$(cat ~/ton-keys/$hostname.depool.seed.csv | tr -d '"')
        ./tonos-cli getkeypair ~/ton-keys/$hostname.depool.keys.json "$parsed_depool_seed_phrase"
depool_deploy_key=~/ton-keys/$hostname.depool.keys.json
depool_raw_addr=$(./tonos-cli genaddr ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePool.tvc ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePool.abi.json --setkey $depool_deploy_key --wc 0)
        echo "$depool_raw_addr" | awk 'FNR == 9 {print $3}' > ~/ton-keys/$hostname.depool.addr
        cp ~/ton-keys/$hostname.depool.addr ~/ton-keys/depool.addr

parsed_helper_seed_phrase=$(cat ~/ton-keys/$hostname.helper.seed.csv | tr -d '"')
        ./tonos-cli getkeypair ~/ton-keys/$hostname.helper.keys.json "$parsed_helper_seed_phrase"
helper_deploy_key=~/ton-keys/$hostname.helper.keys.json
helper_raw_addr=$(./tonos-cli genaddr ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePoolHelper.tvc ~/net.ton.dev/ton-labs-contracts/solidity/depool/DePoolHelper.abi.json --setkey $helper_deploy_key --wc 0)
        echo "$helper_raw_addr" | awk 'FNR == 9 {print $3}' > ~/ton-keys/$hostname.helper.addr
