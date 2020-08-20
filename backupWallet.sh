#!/bin/bash

n=$(cat ~/ip.csv | wc -l)
for (( i = 1; i <= n; i++ ))

do
ip=$(cat ~/ip.csv | awk "FNR == ${i}")
scp username@$ip:~/ton-keys/*.keys.json ~/keys 
scp username@$ip:~/ton-keys/*.addr ~/keys      
scp username@$ip:~/ton-keys/*.seed.csv ~/keys      
done
