#!/bin/bash

n=$(cat ~/ip.csv | wc -l)
for (( i = 1; i <= n; i++ ))

do
ip=$(cat ~/ip.csv | awk "FNR == ${i}")
scp ${i}@$ip:~/ton-keys/*.keys.json ~/ 
scp ${i}@$ip:~/ton-keys/*.addr ~/      
scp ${i}@$ip:~/ton-keys/*.seed.csv ~/      
done
