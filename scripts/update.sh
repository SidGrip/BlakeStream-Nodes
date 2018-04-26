# Stopping, deleting & updating nodes

clear

cd ~/.blakecoin
./blakecoind stop
sleep 10
rm blakecoind
sleep 3
wget -q https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/blc/blakecoind 
chmod u+x blakecoind

cd ~/.photon
./photond stop
sleep 10
rm photond
sleep 3
wget -q https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/pho/photond
chmod u+x photond

cd ~/.blakebitcoin
./blakebitcoind stop
sleep 10
rm blakebitcoind
sleep 3
wget -q https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/bbtc/blakebitcoind
chmod u+x blakebitcoind

cd ~/.lithium
./lithiumd stop
sleep 10
rm lithiumd
sleep 3
wget -q https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/lit/lithiumd
chmod u+x lithiumd

cd ~/.universalmolecule
./universalmoleculed stop
sleep 10
rm universalmoleculed
sleep 3
wget -q https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/umo/universalmoleculed
chmod u+x universalmoleculed

cd ~/.electron
# killall -9 electrond
./electrond stop
sleep 10
rm electrond
sleep 3
wget -q https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/elt/electrond
chmod u+x electrond

clear

echo Server will restart to start BlakeStream Nodes

sleep 5

reboot
