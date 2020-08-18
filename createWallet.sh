#!/bin/bash

username=$(whoami)
hostname=$(hostname -s)

cd ~/net.ton.dev/tonos-cli/target/release
rm "$hostname.seed.csv"

for i in {1..4};
do
seed_phrase=$(./tonos-cli genphrase | awk 'FNR == 3' | sed 's/^.\{13\}//')
       echo "${seed_phrase}" >> ~/ton-keys/"$hostname.seed.csv"
parsed_seed_phrase=$(cat ~/ton-keys/"$hostname.seed.csv" | awk "FNR == ${i}" | tr -d '"')
        ./tonos-cli getkeypair ~/ton-keys/"$hostname.${i}.keys.json" "$parsed_seed_phrase"
done

deploy_key=$(cat ~/ton-keys/"$hostname.1.keys.json") 
raw_addr=$(./tonos-cli genaddr SafeMultisigWallet.tvc SafeMultisigWallet.abi.json --genkey $deploy_key --wc -1)
        echo $raw_addr | awk 'FNR == 11 {print $3}' > ~/ton-keys/"$hostname.addr"
