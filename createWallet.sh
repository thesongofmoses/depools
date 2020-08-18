#!/bin/bash

username=$(whoami)
hostname=$(hostname -s)

cd ~/net.ton.dev/tonos-cli/target/release
rm ~/ton-keys/$hostname.seed.csv

for i in {1..3};
do
seed_phrase=$(./tonos-cli genphrase | awk 'FNR == 3' | sed 's/^.\{13\}//')
       echo ${seed_phrase} >> ~/ton-keys/$hostname.seed.csv
parsed_seed_phrase=$(cat ~/ton-keys/$hostname.seed.csv | awk "FNR == ${i}" | tr -d '"')
        ./tonos-cli getkeypair ~/ton-keys/$hostname.${i}.keys.json "$parsed_seed_phrase"
done

deploy_key=~/ton-keys/$hostname.1.keys.json
raw_addr=$(./tonos-cli genaddr SafeMultisigWallet.tvc SafeMultisigWallet.abi.json --setkey $deploy_key --wc -1)
        echo "$raw_addr" | awk 'FNR == 9 {print $3}' > ~/ton-keys/$hostname.addr
