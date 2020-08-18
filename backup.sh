#!/bin/bash

for i in {1..1};
do
ip=$(cat ~/backup/ip.csv | awk "FNR == ${i}")
scp ${i}@$ip:~/ton-keys/*.keys.json ~/backup
scp ${i}@$ip:~/ton-keys/*.addr ~/backup
scp ${i}@$ip:~/ton-keys/*.seed.csv ~/backup
done
