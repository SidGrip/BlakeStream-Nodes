#Script to start all BlakeStream Nodes.

cd ~/.blakecoin
./blakecoind

sleep 10

cd ~/.photon
./photond

sleep 10

cd ~/.blakebitcoin
./blakebitcoind

sleep 10

cd ~/.lithium
./lithiumd

sleep 10

cd ~/.universalmolecule
./universalmoleculed

sleep 10

cd ~/.electron
./electrond
