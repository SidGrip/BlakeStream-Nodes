# BlakeStream-Nodes
<a href="https://www.vultr.com/?ref=7390666" rel="nofollow">Believe Me, I have Tried Everything. Click Here for Vultr</a>
## VPS Requirments
Ubuntu 16.04 -- 18.04 -- 20.04  |  1CPU -- 1GIG Ram -- 25GB SSD -- $5/mo
***
#### Blakestream Nodes Install.

Copy & paste into terminal window
```
wget -q https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/blake_install.sh
```
Then run ``` bash blake_install.sh``` 
***
Will give you the option to: 
<br>
- Use Pre-Built daemons from this repository
- Compile daemons on your host machine
- View current swapfile and option to create one
- Download bootstraps that are a week behind
- Script to remove ```bootstrap.dat.old``` when node is done importing
<br>
<br>

#### To Start, Stop and Check the status of your BlakeStream nodes.
```=======================================================================================================================
Blakecoin Node is up and running listening on port 8773.
Configuration file is: /root/.blakecoin/blakecoin.conf
Start: systemctl start Blakecoin.service
Stop: systemctl stop Blakecoin.service
Please check Blakecoin daemon is running with the following command: systemctl status Blakecoin.service
=======================================================================================================================
Photon Node is up and running listening on port 35556.
Configuration file is: /root/.photon/photon.conf
Start: systemctl start Photon.service
Stop: systemctl stop Photon.service
Please check Photon daemon is running with the following command: systemctl status Photon.service
======================================================================================================================
BlakeBitcoin Node is up and running listening on port 356.
Configuration file is: /root/.blakebitcoin/blakebitcoin.conf
Start: systemctl start BlakeBitcoin.service
Stop: systemctl stop BlakeBitcoin.service
Please check BlakeBitcoin daemon is running with the following command: systemctl status BlakeBitcoin.service
=======================================================================================================================
Electron Node is up and running listening on port 6853.
Configuration file is: /root/.electron/electron.conf
Start: systemctl start Electron.service
Stop: systemctl stop Electron.service
Please check Electron daemon is running with the following command: systemctl status Electron.service
=======================================================================================================================
Lithium Node is up and running listening on port 12007.
Configuration file is: /root/.lithium/lithium.conf
Start: systemctl start Lithium.service
Stop: systemctl stop Lithium.service
Please check Lithium daemon is running with the following command: systemctl status Lithium.service
=======================================================================================================================
Universalmolecule Node is up and running listening on port 24785.
Configuration file is: /root/.universalmolecule/universalmolecule.conf
Start: systemctl start Universalmolecule.service
Stop: systemctl stop Universalmolecule.service
Please check Universalmolecule daemon is running with the following command: systemctl status Universalmolecule.service
=======================================================================================================================
```
