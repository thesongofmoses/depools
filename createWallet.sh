#!/bin/bash

username=$(whoami)
hostname=$(hostname -s)

cd ~/net.ton.dev/tonos-cli/target/release
rm "$hostname.seed.csv"

for i in {1..4};
do
seed_phrase=$(./tonos-cli genphrase | awk 'FNR == 3' | sed 's/^.\{13\}//')
       echo "${seed_phrase}" >> "$hostname.seed.csv"
parsed_seed_phrase=$(cat "$hostname.seed.csv" | awk "FNR == ${i}" | tr -d '"')
        ./tonos-cli getkeypair "$hostname.${i}.keys.json" "$parsed_seed_phrase"
done
