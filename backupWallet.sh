#!/bin/bash

n=$(cat ~/ip.csv | wc -l)
for (( i = 1; i <= n; i++ ))

do
rm -rf ~/keys
mkdir keys
password=''

ip=$(cat ~/ip.csv | awk "FNR == ${i}")
scp username@$ip:~/ton-keys/*.keys.json ~/keys
echo 'yes'
echo $password 
scp username@$ip:~/ton-keys/*.addr ~/keys  
echo $password
scp username@$ip:~/ton-keys/*.seed.csv ~/keys
echo $password
done
