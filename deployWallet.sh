#!/bin/bash

username=$(whoami)
hostname=$(hostname -s)

cd ~/net.ton.dev/tonos-cli/target/release
rm ~/ton-keys/$hostname.custodian.seed.csv

for i in {1..3};
do
seed_phrase=$(./tonos-cli genphrase | awk 'FNR == 3' | sed 's/^.\{13\}//')
       echo "${seed_phrase}" >> ~/ton-keys/$hostname.custodian.seed.csv
done

seed1=$(cat ~/ton-keys/$hostname.custodian.seed.csv | awk "FNR == 1" | tr -d '"')
seed2=$(cat ~/ton-keys/$hostname.custodian.seed.csv | awk "FNR == 2" | tr -d '"')
seed3=$(cat ~/ton-keys/$hostname.custodian.seed.csv | awk "FNR == 3" | tr -d '"')

echo 0x$(./tonos-cli genpubkey "$seed1" | awk 'FNR == 3 {print $3}') > ~/ton-keys/$hostname.custodian.pubkey.csv
echo 0x$(./tonos-cli genpubkey "$seed2" | awk 'FNR == 3 {print $3}') >> ~/ton-keys/$hostname.custodian.pubkey.csv
echo 0x$(./tonos-cli genpubkey "$seed3" | awk 'FNR == 3 {print $3}') >> ~/ton-keys/$hostname.custodian.pubkey.csv

pubkey1=$(sed -n 1p ~/ton-keys/$hostname.custodian.pubkey.csv)
pubkey2=$(sed -n 2p ~/ton-keys/$hostname.custodian.pubkey.csv)
pubkey3=$(sed -n 3p ~/ton-keys/$hostname.custodian.pubkey.csv)
