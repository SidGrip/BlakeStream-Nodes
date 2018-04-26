#!/bin/bash
# vultr Ubuntu 16.04 x64  2CPU  4GIG Ram 60GB SSD

apt-get update

apt-get -y install build-essential libboost-dev libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libssl-dev libdb5.3++-dev libminiupnpc-dev build-essential libboost-dev libboost-system-dev libboost-filesystem-dev 

# apt-get -y install libssl-dev libdb5.3++-dev libminiupnpc-dev libevent-dev libboost-all-dev libminiupnpc10 libzmq5 software-properties-common

add-apt-repository ppa:bitcoin/bitcoin -y
apt-get update

apt-get install libdb4.8-dev libdb4.8++-dev -y

mkdir ~/.scripts
mkdir ~/.blakecoin
mkdir ~/.photon
mkdir ~/.blakebitcoin
mkdir ~/.lithium
mkdir ~/.universalmolecule
mkdir ~/.electron

wget -q https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/scripts/update.sh
chmod u+x update.sh

cd ~/.scripts
wget -q https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/scripts/start.sh
chmod u+x start.sh

cd
( crontab -l | grep -v -F "@reboot ~/.scripts/start.sh" ; echo "@reboot ~/.scripts/start.sh" ) | crontab -

cd ~/.blakecoin
wget -q https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/blc/blakecoind 
wget -q https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/blc/blakecoin.conf 
chmod u+x blakecoind


cd ~/.photon
wget -q https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/pho/photond 
wget -q https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/pho/photon.conf
chmod u+x photond


cd ~/.blakebitcoin
wget -q https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/bbtc/blakebitcoind 
wget -q https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/bbtc/blakebitcoin.conf
chmod u+x blakebitcoind


cd ~/.lithium
wget -q https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/lit/lithiumd 
wget -q https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/lit/lithium.conf
chmod u+x lithiumd


cd ~/.universalmolecule
wget -q https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/umo/universalmoleculed 
wget -q https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/umo/universalmolecule.conf
chmod u+x universalmoleculed


cd ~/.electron
wget -q https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/elt/electrond 
wget -q https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/elt/electron.conf 
chmod u+x electrond
cd

clear

echo Server will restart and start BlakeStream Nodes

sleep 5

reboot
