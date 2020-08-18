#!/bin/bash

#kill engine, console
killall -15 validator-engine
killall -15 validator-engine-console

#delete existing dirs
sudo rm -rf /var/ton-work \
rm -rf ~/ton-keys \
rm -rf ~/net.ton.dev \

#build
sudo apt-get update -y && \
sudo apt-get full-upgrade -y && \
cd && git clone https://github.com/tonlabs/net.ton.dev.git && \
cd net.ton.dev/scripts && \
. ./env.sh && \
./build.sh && \

#run
./setup.sh && \
./run.sh && \

#set configs for tonos-cli
cd ~/net.ton.dev/tonos-cli/target/release/ && ./tonos-cli config --url https://"${1}".ton.dev --wc -1 && \
cp ~/net.ton.dev/tonos-cli/target/release/tonlabs-cli.conf.json ~/net.ton.dev/scripts/tonlabs-cli.conf.json \

#echo node versions
echo '/ton version:' && \
cd ~/net.ton.dev/ton && git rev-parse HEAD && \
echo '/net.ton.dev version:' && \
cd ~/net.ton.dev && git rev-parse HEAD
