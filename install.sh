#!/bin/bash

#BlakeCoin
BLC_TMP_FOLDER=$(mktemp -d)
BLC_CONFIG_FILE='blakecoin.conf'
BLC_CONFIGFOLDER='/root/.blakecoin'
BLC_COIN_DAEMON='blakecoind'
BLC_COIN_PATH='/usr/local/bin/'
BLC_COIN_TGZ='https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/blc/blakecoin.tar'
BLC_COIN_ZIP=$(echo $BLC_COIN_TGZ | awk -F'/' '{print $NF}')
BLC_COIN_NAME='Blakecoin'
BLC_RPC_PORT='8772'
BLC_COIN_PORT='8773'

#Photon
PHO_TMP_FOLDER=$(mktemp -d)
PHO_CONFIG_FILE='photon.conf'
PHO_CONFIGFOLDER='/root/.photon'
PHO_COIN_DAEMON='photond'
PHO_COIN_PATH='/usr/local/bin/'
PHO_COIN_TGZ='https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/pho/photon.tar'
PHO_COIN_ZIP=$(echo $PHO_COIN_TGZ | awk -F'/' '{print $NF}')
PHO_COIN_NAME='Photon'
PHO_RPC_PORT='8984'
PHO_COIN_PORT='35556'

#BlakeBitcoin
BBTC_TMP_FOLDER=$(mktemp -d)
BBTC_CONFIG_FILE='blakebitcoin.conf'
BBTC_CONFIGFOLDER='/root/.blakebitcoin'
BBTC_COIN_DAEMON='blakebitcoind'
BBTC_COIN_PATH='/usr/local/bin/'
BBTC_COIN_TGZ='https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/bbtc/blakebitcoin.tar'
BBTC_COIN_ZIP=$(echo $BBTC_COIN_TGZ | awk -F'/' '{print $NF}')
BBTC_COIN_NAME='BlakeBitcoin'
BBTC_RPC_PORT='243'
BBTC_COIN_PORT='356'

#Electron
ELT_TMP_FOLDER=$(mktemp -d)
ELT_CONFIG_FILE='electron.conf'
ELT_CONFIGFOLDER='/root/.electron'
ELT_COIN_DAEMON='electrond'
ELT_COIN_PATH='/usr/local/bin/'
ELT_COIN_TGZ='https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/elt/electron.tar'
ELT_COIN_ZIP=$(echo $ELT_COIN_TGZ | awk -F'/' '{print $NF}')
ELT_COIN_NAME='Electron'
ELT_RPC_PORT='6852'
ELT_COIN_PORT='6853'

#Lithium
LIT_TMP_FOLDER=$(mktemp -d)
LIT_CONFIG_FILE='lithium.conf'
LIT_CONFIGFOLDER='/root/.lithium'
LIT_COIN_DAEMON='lithiumd'
LIT_COIN_PATH='/usr/local/bin/'
LIT_COIN_TGZ='https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/lit/lithium.tar'
LIT_COIN_ZIP=$(echo $LIT_COIN_TGZ | awk -F'/' '{print $NF}')
LIT_COIN_NAME='Lithium'
LIT_RPC_PORT='12345'
LIT_COIN_PORT='12007'

#Universalmolecule
UMO_TMP_FOLDER=$(mktemp -d)
UMO_CONFIG_FILE='universalmolecule.conf'
UMO_CONFIGFOLDER='/root/.universalmolecule'
UMO_COIN_DAEMON='universalmoleculed'
UMO_COIN_PATH='/usr/local/bin/'
UMO_COIN_TGZ='https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/umo/universalmolecule.tar'
UMO_COIN_ZIP=$(echo $UMO_COIN_TGZ | awk -F'/' '{print $NF}')
UMO_COIN_NAME='Universalmolecule'
UMO_RPC_PORT='19738'
UMO_COIN_PORT='24785'

BBlue='\033[1;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
WHITE='\033[1;97m'
YELLOW='\033[0;93m'
NC='\033[0m'

function checks() {
if [[ $(lsb_release -d) != *16.04* ]]; then
  echo -e "${RED}You are not running Ubuntu 16.04. Installation is cancelled.${NC}"
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}$0 must be run as root.${NC}"
   exit 1
fi

if [ -n "$(pidof $COIN_DAEMON)" ] || [ -e "$COIN_DAEMOM" ] ; then
  echo -e "${RED}$COIN_NAME is already installed.${NC}"
  exit 1
fi
}

function swap() {
#checking for swapfile
if [ $(free | awk '/^Swap:/ {exit !$2}') ] || [ ! -f "/var/swap.img" ];then
    echo "Creating Swap"
    rm -f /var/swap.img
    dd if=/dev/zero of=/var/swap.img bs=1024k count=5120
    chmod 0600 /var/swap.img
    mkswap /var/swap.img
    swapon /var/swap.img
    echo '/var/swap.img none swap sw 0 0' | tee -a /etc/fstab
    echo 'vm.swappiness=10' | tee -a /etc/sysctl.conf               
    echo 'vm.vfs_cache_pressure=50' | tee -a /etc/sysctl.conf
clear	
else
    echo "Swapfile created"
fi
}

function prepare_system() {
echo -e "Preparing to install ${BBlue}BlakeStream Nodes."
apt-get update >/dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get update > /dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y -qq upgrade >/dev/null 2>&1
apt install -y software-properties-common >/dev/null 2>&1
echo -e "Thanks for Supporting the Blakestream"
apt-add-repository -y ppa:bitcoin/bitcoin >/dev/null 2>&1
echo -e "${NC}Installing required packages, it may take some time to finish."
apt-get update >/dev/null 2>&1
apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" make software-properties-common \
build-essential libtool software-properties-common autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev \
libboost-program-options-dev libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git curl libcurl4-gnutls-dev libudev-dev libdb4.8-dev \
jp2a libqrencode-dev pv virtualenv bsdmainutils protobuf-compiler libprotobuf-dev libdb4.8++-dev libminiupnpc-dev libgmp3-dev ufw pkg-config libevent-dev \
libdb5.3++ unzip libzmq5 libboost-all-dev >/dev/null 2>&1
if [ "$?" -gt "0" ];
  then
    echo -e "${RED}Not all required packages were installed properly. Try to install them manually by running the following commands:${NC}\n"
    echo "apt-get update"
    echo "apt -y install software-properties-common"
    echo "apt-add-repository -y ppa:bitcoin/bitcoin"
    echo "apt-get update"
    echo "apt install -y make build-essential libtool software-properties-common autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev \
libboost-program-options-dev libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git curl libcurl4-gnutls-dev libudev-dev libdb4.8-dev \
jp2a libqrencode-dev pv virtualenv bsdmainutils protobuf-compiler libprotobuf-dev libdb4.8++-dev libminiupnpc-dev libgmp3-dev ufw pkg-config libevent-dev \
libdb5.3++ unzip libzmq5 libboost-all-dev"
 exit 1
fi
clear
}

function enable_firewall() {
  echo -e "Installing and setting up firewall ${GREEN}$COIN_PORT${NC}"
  ufw allow $BLC_COIN_PORT/tcp comment "$BLC_COIN_NAME port" >/dev/null
  ufw allow $PHO_COIN_PORT/tcp comment "$PHO_COIN_NAME port" >/dev/null
  ufw allow $BBTC_COIN_PORT/tcp comment "$BBTC_COIN_NAME port" >/dev/null
  ufw allow $ELT_COIN_PORT/tcp comment "$ELT_COIN_NAME port" >/dev/null
  ufw allow $LIT_COIN_PORT/tcp comment "$LIT_COIN_NAME port" >/dev/null
  ufw allow ssh comment "SSH" >/dev/null 2>&1
  ufw limit ssh/tcp >/dev/null 2>&1
  echo "y" | ufw enable >/dev/null 2>&1
  clear
}

function download_node() {
  echo -e "Installing $BLC_COIN_NAME${NC}."
  cd $BLC_TMP_FOLDER >/dev/null 2>&1
  wget -q $BLC_COIN_TGZ
  tar xvf $BLC_COIN_ZIP
  chmod +x $BLC_COIN_DAEMON
  cp $BLC_COIN_DAEMON $BLC_COIN_PATH
  cd ~ >/dev/null 2>&1
  #rm -rf $BLC_TMP_FOLDER >/dev/null 2>&1
  clear
  
  echo -e "Installing $PHO_COIN_NAME${NC}."
  cd $PHO_TMP_FOLDER >/dev/null 2>&1
  wget -q $PHO_COIN_TGZ
  tar xvf $PHO_COIN_ZIP
  chmod +x $PHO_COIN_DAEMON
  cp $PHO_COIN_DAEMON $PHO_COIN_PATH
  cd ~ >/dev/null 2>&1
  #rm -rf $PHO_TMP_FOLDER >/dev/null 2>&1
  clear
  
    echo -e "Installing $BBTC_COIN_NAME${NC}."
  cd $BBTC_TMP_FOLDER >/dev/null 2>&1
  wget -q $BBTC_COIN_TGZ
  tar xvf $BBTC_COIN_ZIP
  chmod +x $BBTC_COIN_DAEMON
  cp $BBTC_COIN_DAEMON $BBTC_COIN_PATH
  cd ~ >/dev/null 2>&1
  #rm -rf $BBTC_TMP_FOLDER >/dev/null 2>&1
  clear
  
      echo -e "Installing $ELT_COIN_NAME${NC}."
  cd $ELT_TMP_FOLDER >/dev/null 2>&1
  wget -q $ELT_COIN_TGZ
  tar xvf $ELT_COIN_ZIP
  chmod +x $ELT_COIN_DAEMON
  cp $ELT_COIN_DAEMON $ELT_COIN_PATH
  cd ~ >/dev/null 2>&1
  #rm -rf $ELT_TMP_FOLDER >/dev/null 2>&1
  clear
  
        echo -e "Installing $LIT_COIN_NAME${NC}."
  cd $LIT_TMP_FOLDER >/dev/null 2>&1
  wget -q $LIT_COIN_TGZ
  tar xvf $LIT_COIN_ZIP
  chmod +x $LIT_COIN_DAEMON
  cp $LIT_COIN_DAEMON $LIT_COIN_PATH
  cd ~ >/dev/null 2>&1
  #rm -rf $LIT_TMP_FOLDER >/dev/null 2>&1
  clear
  
          echo -e "Installing $UMO_COIN_NAME${NC}."
  cd $UMO_TMP_FOLDER >/dev/null 2>&1
  wget -q $UMO_COIN_TGZ
  tar xvf $UMO_COIN_ZIP
  chmod +x $UMO_COIN_DAEMON
  cp $UMO_COIN_DAEMON $UMO_COIN_PATH
  cd ~ >/dev/null 2>&1
  #rm -rf $UMO_TMP_FOLDER >/dev/null 2>&1
  clear
}


function create_config() {
  mkdir $BLC_CONFIGFOLDER >/dev/null 2>&1
  BLC_RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  BLC_RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $BLC_CONFIGFOLDER/$BLC_CONFIG_FILE
maxconnections=256
listen=1
daemon=1
gen=0
server=1
rpcuser=$BLC_RPCUSER
rpcpassword=$BLC_RPCPASSWORD
rpcallowip=127.0.0.1
rpcport=$BLC_RPC_PORT
port=$BLC_COIN_PORT
addnode=104.156.255.123
addnode=104.238.177.36
addnode=146.185.135.24
addnode=149.28.19.72
addnode=173.82.100.157
addnode=178.63.11.230
addnode=45.32.196.227
addnode=45.32.69.42
addnode=45.63.105.204
addnode=45.76.42.149
addnode=45.77.246.197
addnode=67.167.9.176
addnode=80.114.174.211
addnode=80.240.20.113
EOF

  mkdir $PHO_CONFIGFOLDER >/dev/null 2>&1
  PHO_RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  PHO_RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $PHO_CONFIGFOLDER/$PHO_CONFIG_FILE
maxconnections=256
listen=1
daemon=1
gen=0
server=1
rpcuser=$PHO_RPCUSER
rpcpassword=$PHO_RPCPASSWORD
rpcallowip=127.0.0.1
rpcport=$PHO_RPC_PORT
port=$PHO_COIN_PORT
addnode=104.156.255.123
addnode=104.238.177.36
addnode=146.185.135.24
addnode=149.28.19.72
addnode=173.82.100.157
addnode=178.63.11.230
addnode=45.32.196.227
addnode=45.32.69.42
addnode=45.63.105.204
addnode=45.76.42.149
addnode=45.77.246.197
addnode=67.167.9.176
addnode=80.114.174.211
addnode=80.240.20.113
EOF

  mkdir $BBTC_CONFIGFOLDER >/dev/null 2>&1
  BBTC_RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  BBTC_RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $BBTC_CONFIGFOLDER/$BBTC_CONFIG_FILE
maxconnections=256
listen=1
daemon=1
gen=0
server=1
rpcuser=$BBTC_RPCUSER
rpcpassword=$BBTC_RPCPASSWORD
rpcallowip=127.0.0.1
rpcport=$BBTC_RPC_PORT
port=$BBTC_COIN_PORT
addnode=104.156.255.123
addnode=104.238.177.36
addnode=146.185.135.24
addnode=149.28.19.72
addnode=173.82.100.157
addnode=178.63.11.230
addnode=45.32.196.227
addnode=45.32.69.42
addnode=45.63.105.204
addnode=45.76.42.149
addnode=45.77.246.197
addnode=67.167.9.176
addnode=80.114.174.211
addnode=80.240.20.113
EOF

  mkdir $ELT_CONFIGFOLDER >/dev/null 2>&1
  ELT_RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  ELT_RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $ELT_CONFIGFOLDER/$ELT_CONFIG_FILE
maxconnections=256
listen=1
daemon=1
gen=0
server=1
rpcuser=$ELT_RPCUSER
rpcpassword=$ELT_RPCPASSWORD
rpcallowip=127.0.0.1
rpcport=$ELT_RPC_PORT
port=$ELT_COIN_PORT
addnode=104.156.255.123
addnode=104.238.177.36
addnode=146.185.135.24
addnode=149.28.19.72
addnode=173.82.100.157
addnode=178.63.11.230
addnode=45.32.196.227
addnode=45.32.69.42
addnode=45.63.105.204
addnode=45.76.42.149
addnode=45.77.246.197
addnode=67.167.9.176
addnode=80.114.174.211
addnode=80.240.20.113
EOF

  mkdir $LIT_CONFIGFOLDER >/dev/null 2>&1
  LIT_RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  LIT_RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $LIT_CONFIGFOLDER/$LIT_CONFIG_FILE
maxconnections=256
listen=1
daemon=1
gen=0
server=1
rpcuser=$LIT_RPCUSER
rpcpassword=$LIT_RPCPASSWORD
rpcallowip=127.0.0.1
rpcport=$LIT_RPC_PORT
port=$LIT_COIN_PORT
addnode=104.156.255.123
addnode=104.238.177.36
addnode=146.185.135.24
addnode=149.28.19.72
addnode=173.82.100.157
addnode=178.63.11.230
addnode=45.32.196.227
addnode=45.32.69.42
addnode=45.63.105.204
addnode=45.76.42.149
addnode=45.77.246.197
addnode=67.167.9.176
addnode=80.114.174.211
addnode=80.240.20.113
EOF

  mkdir $UMO_CONFIGFOLDER >/dev/null 2>&1
  UMO_RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  UMO_RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $UMO_CONFIGFOLDER/$UMO_CONFIG_FILE
maxconnections=256
listen=1
daemon=1
gen=0
server=1
rpcuser=$UMO_RPCUSER
rpcpassword=$UMO_RPCPASSWORD
rpcallowip=127.0.0.1
rpcport=$UMO_RPC_PORT
port=$UMO_COIN_PORT
addnode=104.156.255.123
addnode=104.238.177.36
addnode=146.185.135.24
addnode=149.28.19.72
addnode=173.82.100.157
addnode=178.63.11.230
addnode=45.32.196.227
addnode=45.32.69.42
addnode=45.63.105.204
addnode=45.76.42.149
addnode=45.77.246.197
addnode=67.167.9.176
addnode=80.114.174.211
addnode=80.240.20.113
EOF
}


function configure_systemd() {
  cat << EOF > /etc/systemd/system/$BLC_COIN_NAME.service
[Unit]
Description=$BLC_COIN_NAME service
After=network.target
[Service]
User=root
Group=root
Type=forking
#PIDFile=$BLC_CONFIGFOLDER/$BLC_COIN_NAME.pid
ExecStart=$BLC_COIN_PATH$BLC_COIN_DAEMON -daemon -conf=$BLC_CONFIGFOLDER/$BLC_CONFIG_FILE -datadir=$BLC_CONFIGFOLDER
ExecStop=-$BLC_COIN_PATH$BLC_COIN_DAEMON -conf=$BLC_CONFIGFOLDER/$BLC_CONFIG_FILE -datadir=$BLC_CONFIGFOLDER stop
Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=2
[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 4
  systemctl start $BLC_COIN_NAME.service
  systemctl enable $BLC_COIN_NAME.service >/dev/null 2>&1
  #sleep 4
  #systemctl restart $BLC_COIN_NAME.service >/dev/null 2>&1

  if [[ -z "$(ps axo cmd:100 | egrep $BLC_COIN_DAEMON)" ]]; then
    echo -e "${RED}$BLC_COIN_NAME is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $BLC_COIN_NAME.service"
    echo -e "systemctl status $BLC_COIN_NAME.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
    fi

    cat << EOF > /etc/systemd/system/$PHO_COIN_NAME.service
[Unit]
Description=$PHO_COIN_NAME service
After=network.target
[Service]
User=root
Group=root
Type=forking
#PIDFile=$PHO_CONFIGFOLDER/$PHO_COIN_NAME.pid
ExecStart=$PHO_COIN_PATH$PHO_COIN_DAEMON -daemon -conf=$PHO_CONFIGFOLDER/$PHO_CONFIG_FILE -datadir=$PHO_CONFIGFOLDER
ExecStop=-$PHO_COIN_PATH$PHO_COIN_DAEMON -conf=$PHO_CONFIGFOLDER/$PHO_CONFIG_FILE -datadir=$PHO_CONFIGFOLDER stop
Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=2
[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 4
  systemctl start $PHO_COIN_NAME.service
  systemctl enable $PHO_COIN_NAME.service >/dev/null 2>&1
  #sleep 4
  #systemctl restart $PHO_COIN_NAME.service >/dev/null 2>&1

  if [[ -z "$(ps axo cmd:100 | egrep $PHO_COIN_DAEMON)" ]]; then
    echo -e "${RED}$PHO_COIN_NAME is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $PHO_COIN_NAME.service"
    echo -e "systemctl status $PHO_COIN_NAME.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
  fi
  
      cat << EOF > /etc/systemd/system/$BBTC_COIN_NAME.service
[Unit]
Description=$BBTC_COIN_NAME service
After=network.target
[Service]
User=root
Group=root
Type=forking
#PIDFile=$BBTC_CONFIGFOLDER/$BBTC_COIN_NAME.pid
ExecStart=$BBTC_COIN_PATH$BBTC_COIN_DAEMON -daemon -conf=$BBTC_CONFIGFOLDER/$BBTC_CONFIG_FILE -datadir=$BBTC_CONFIGFOLDER
ExecStop=-$BBTC_COIN_PATH$BBTC_COIN_DAEMON -conf=$BBTC_CONFIGFOLDER/$BBTC_CONFIG_FILE -datadir=$BBTC_CONFIGFOLDER stop
Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=2
[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 4
  systemctl start $BBTC_COIN_NAME.service
  systemctl enable $BBTC_COIN_NAME.service >/dev/null 2>&1
  #sleep 4
  #systemctl restart $BBTC_COIN_NAME.service >/dev/null 2>&1

  if [[ -z "$(ps axo cmd:100 | egrep $BBTC_COIN_DAEMON)" ]]; then
    echo -e "${RED}$BBTC_COIN_NAME is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $BBTC_COIN_NAME.service"
    echo -e "systemctl status $BBTC_COIN_NAME.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
  fi
  
        cat << EOF > /etc/systemd/system/$ELT_COIN_NAME.service
[Unit]
Description=$ELT_COIN_NAME service
After=network.target
[Service]
User=root
Group=root
Type=forking
#PIDFile=$ELT_CONFIGFOLDER/$ELT_COIN_NAME.pid
ExecStart=$ELT_COIN_PATH$ELT_COIN_DAEMON -daemon -conf=$ELT_CONFIGFOLDER/$ELT_CONFIG_FILE -datadir=$ELT_CONFIGFOLDER
ExecStop=-$ELT_COIN_PATH$ELT_COIN_DAEMON -conf=$ELT_CONFIGFOLDER/$ELT_CONFIG_FILE -datadir=$ELT_CONFIGFOLDER stop
Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=2
[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 4
  systemctl start $ELT_COIN_NAME.service
  systemctl enable $ELT_COIN_NAME.service >/dev/null 2>&1
  #sleep 4
  #systemctl restart $ELT_COIN_NAME.service >/dev/null 2>&1

  if [[ -z "$(ps axo cmd:100 | egrep $ELT_COIN_DAEMON)" ]]; then
    echo -e "${RED}$ELT_COIN_NAME is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $ELT_COIN_NAME.service"
    echo -e "systemctl status $ELT_COIN_NAME.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
  fi
  
          cat << EOF > /etc/systemd/system/$LIT_COIN_NAME.service
[Unit]
Description=$LIT_COIN_NAME service
After=network.target
[Service]
User=root
Group=root
Type=forking
#PIDFile=$LIT_CONFIGFOLDER/$LIT_COIN_NAME.pid
ExecStart=$LIT_COIN_PATH$LIT_COIN_DAEMON -daemon -conf=$LIT_CONFIGFOLDER/$LIT_CONFIG_FILE -datadir=$LIT_CONFIGFOLDER
ExecStop=-$LIT_COIN_PATH$LIT_COIN_DAEMON -conf=$LIT_CONFIGFOLDER/$LIT_CONFIG_FILE -datadir=$LIT_CONFIGFOLDER stop
Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=2
[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 4
  systemctl start $LIT_COIN_NAME.service
  systemctl enable $LIT_COIN_NAME.service >/dev/null 2>&1
  #sleep 4
  #systemctl restart $LIT_COIN_NAME.service >/dev/null 2>&1

  if [[ -z "$(ps axo cmd:100 | egrep $LIT_COIN_DAEMON)" ]]; then
    echo -e "${RED}$LIT_COIN_NAME is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $LIT_COIN_NAME.service"
    echo -e "systemctl status $LIT_COIN_NAME.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
  fi
  
            cat << EOF > /etc/systemd/system/$UMO_COIN_NAME.service
[Unit]
Description=$UMO_COIN_NAME service
After=network.target
[Service]
User=root
Group=root
Type=forking
#PIDFile=$UMO_CONFIGFOLDER/$UMO_COIN_NAME.pid
ExecStart=$UMO_COIN_PATH$UMO_COIN_DAEMON -daemon -conf=$UMO_CONFIGFOLDER/$UMO_CONFIG_FILE -datadir=$UMO_CONFIGFOLDER
ExecStop=-$UMO_COIN_PATH$UMO_COIN_DAEMON -conf=$UMO_CONFIGFOLDER/$UMO_CONFIG_FILE -datadir=$UMO_CONFIGFOLDER stop
Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=2
[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 4
  systemctl start $UMO_COIN_NAME.service
  systemctl enable $UMO_COIN_NAME.service >/dev/null 2>&1
  #sleep 4
  #systemctl restart $UMO_COIN_NAME.service >/dev/null 2>&1

  if [[ -z "$(ps axo cmd:100 | egrep $UMO_COIN_DAEMON)" ]]; then
    echo -e "${RED}$UMO_COIN_NAME is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $UMO_COIN_NAME.service"
    echo -e "systemctl status $UMO_COIN_NAME.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
  fi
}

function important_information() {
 echo -e "================================================================================================================================"
 echo -e "$BLC_COIN_NAME Node is up and running listening on port ${GREEN}$BLC_COIN_PORT${NC}."
 echo -e "Configuration file is: ${RED}$BLC_CONFIGFOLDER/$BLC_CONFIG_FILE${NC}"
 echo -e "Start: ${RED}systemctl start $BLC_COIN_NAME.service${NC}"
 echo -e "Stop: ${RED}systemctl stop $BLC_COIN_NAME.service${NC}"
 echo -e "Please check ${GREEN}$BLC_COIN_NAME${NC} daemon is running with the following command: ${BBlue}systemctl status $BLC_COIN_NAME.service${NC}"
 echo -e "================================================================================================================================"
 echo -e "$PHO_COIN_NAME Node is up and running listening on port ${GREEN}$PHO_COIN_PORT${NC}."
 echo -e "Configuration file is: ${RED}$PHO_CONFIGFOLDER/$PHO_CONFIG_FILE${NC}"
 echo -e "Start: ${RED}systemctl start $PHO_COIN_NAME.service${NC}"
 echo -e "Stop: ${RED}systemctl stop $PHO_COIN_NAME.service${NC}"
 echo -e "Please check ${GREEN}$PHO_COIN_NAME${NC} daemon is running with the following command: ${BBlue}systemctl status $PHO_COIN_NAME.service${NC}"
 echo -e "================================================================================================================================"
 echo -e "$BBTC_COIN_NAME Node is up and running listening on port ${GREEN}$BBTC_COIN_PORT${NC}."
 echo -e "Configuration file is: ${RED}$BBTC_CONFIGFOLDER/$BBTC_CONFIG_FILE${NC}"
 echo -e "Start: ${RED}systemctl start $BBTC_COIN_NAME.service${NC}"
 echo -e "Stop: ${RED}systemctl stop $BBTC_COIN_NAME.service${NC}"
 echo -e "Please check ${GREEN}$BBTC_COIN_NAME${NC} daemon is running with the following command: ${BBlue}systemctl status $BBTC_COIN_NAME.service${NC}"
 echo -e "================================================================================================================================"
 echo -e "$ELT_COIN_NAME Node is up and running listening on port ${GREEN}$ELT_COIN_PORT${NC}."
 echo -e "Configuration file is: ${RED}$ELT_CONFIGFOLDER/$ELT_CONFIG_FILE${NC}"
 echo -e "Start: ${RED}systemctl start $ELT_COIN_NAME.service${NC}"
 echo -e "Stop: ${RED}systemctl stop $ELT_COIN_NAME.service${NC}"
 echo -e "Please check ${GREEN}$ELT_COIN_NAME${NC} daemon is running with the following command: ${BBlue}systemctl status $ELT_COIN_NAME.service${NC}"
 echo -e "================================================================================================================================"
 echo -e "$LIT_COIN_NAME Node is up and running listening on port ${GREEN}$LIT_COIN_PORT${NC}."
 echo -e "Configuration file is: ${RED}$LIT_CONFIGFOLDER/$LIT_CONFIG_FILE${NC}"
 echo -e "Start: ${RED}systemctl start $LIT_COIN_NAME.service${NC}"
 echo -e "Stop: ${RED}systemctl stop $LIT_COIN_NAME.service${NC}"
 echo -e "Please check ${GREEN}$LIT_COIN_NAME${NC} daemon is running with the following command: ${BBlue}systemctl status $LIT_COIN_NAME.service${NC}"
 echo -e "================================================================================================================================"
 echo -e "$UMO_COIN_NAME Node is up and running listening on port ${GREEN}$UMO_COIN_PORT${NC}."
 echo -e "Configuration file is: ${RED}$UMO_CONFIGFOLDER/$UMO_CONFIG_FILE${NC}"
 echo -e "Start: ${RED}systemctl start $UMO_COIN_NAME.service${NC}"
 echo -e "Stop: ${RED}systemctl stop $UMO_COIN_NAME.service${NC}"
 echo -e "Please check ${GREEN}$UMO_COIN_NAME${NC} daemon is running with the following command: ${BBlue}systemctl status $UMO_COIN_NAME.service${NC}"
 echo -e "================================================================================================================================"
 echo -e "${YELLOW}===============================================   ${WHITE}Finishing up Please Wait${NC}   ${YELLOW}===================================================${NC}"
}

function clean() {
cd ~/.blakecoin 
rm debug.log
cd ~/.photon
rm debug.log
cd ~/.blakebitcoin
rm debug.log
cd ~/.electron
rm debug.log
cd ~/.lithium
rm debug.log
cd ~/.universalmolecule
rm debug.log

}
function setup_node() {
  swap
  create_config
  enable_firewall
  important_information
  configure_systemd
  clean
}


##### Main #####
clear

checks
prepare_system
download_node
setup_node
