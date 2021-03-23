#!/bin/bash
FTP='ftp://45.77.246.197'
USER=$(whoami)
USERDIR=$(eval echo ~$user)
STRAP='bootstrap.dat'
COIN_PATH='/usr/local/bin'
PEERS='peers.txt'

#BlakeCoin
BLC_TMP_FOLDER=$(mktemp -d)
BLC_CONFIG_FILE='blakecoin.conf'
BLC_CONFIGFOLDER='.blakecoin'
BLC_COIN_DAEMON='blakecoind'
BLC_COIN_TGZ='https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/blc/blakecoin.tar'
BLC_COIN_ZIP=$(echo $BLC_COIN_TGZ | awk -F'/' '{print $NF}')
BLC_COIN_NAME='Blakecoin'
BLC_RPC_PORT='8772'
BLC_COIN_PORT='8773'
BLC_PEERS=$(curl -s$ $FTP/$BLC_COIN_NAME/$PEERS)

#Photon
PHO_TMP_FOLDER=$(mktemp -d)
PHO_CONFIG_FILE='photon.conf'
PHO_CONFIGFOLDER='.photon'
PHO_COIN_DAEMON='photond'
PHO_COIN_TGZ='https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/pho/photon.tar'
PHO_COIN_ZIP=$(echo $PHO_COIN_TGZ | awk -F'/' '{print $NF}')
PHO_COIN_NAME='Photon'
PHO_RPC_PORT='8984'
PHO_COIN_PORT='35556'
PHO_PEERS=$(curl -s$ $FTP/$PHO_COIN_NAME/$PEERS)

#BlakeBitcoin
BBTC_TMP_FOLDER=$(mktemp -d)
BBTC_CONFIG_FILE='blakebitcoin.conf'
BBTC_CONFIGFOLDER='.blakebitcoin'
BBTC_COIN_DAEMON='blakebitcoind'
BBTC_COIN_TGZ='https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/bbtc/blakebitcoin.tar'
BBTC_COIN_ZIP=$(echo $BBTC_COIN_TGZ | awk -F'/' '{print $NF}')
BBTC_COIN_NAME='BlakeBitcoin'
BBTC_RPC_PORT='243'
BBTC_COIN_PORT='356'
BBTC_PEERS=$(curl -s$ $FTP/$BBTC_COIN_NAME/$PEERS)

#Electron
ELT_TMP_FOLDER=$(mktemp -d)
ELT_CONFIG_FILE='electron.conf'
ELT_CONFIGFOLDER='.electron'
ELT_COIN_DAEMON='electrond'
ELT_COIN_TGZ='https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/elt/electron.tar'
ELT_COIN_ZIP=$(echo $ELT_COIN_TGZ | awk -F'/' '{print $NF}')
ELT_COIN_NAME='Electron'
ELT_RPC_PORT='6852'
ELT_COIN_PORT='6853'
ELT_PEERS=$(curl -s$ $FTP/$ELT_COIN_NAME/$PEERS)

#Lithium
LIT_TMP_FOLDER=$(mktemp -d)
LIT_CONFIG_FILE='lithium.conf'
LIT_CONFIGFOLDER='.lithium'
LIT_COIN_DAEMON='lithiumd'
LIT_COIN_TGZ='https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/lit/lithium.tar'
LIT_COIN_ZIP=$(echo $LIT_COIN_TGZ | awk -F'/' '{print $NF}')
LIT_COIN_NAME='Lithium'
LIT_RPC_PORT='12345'
LIT_COIN_PORT='12007'
LIT_PEERS=$(curl -s$ $FTP/$LIT_COIN_NAME/$PEERS)

#Universalmolecule
UMO_TMP_FOLDER=$(mktemp -d)
UMO_CONFIG_FILE='universalmolecule.conf'
UMO_CONFIGFOLDER='.universalmolecule'
UMO_COIN_DAEMON='universalmoleculed'
UMO_COIN_TGZ='https://raw.githubusercontent.com/SidGrip/BlakeStream-Nodes/master/umo/universalmolecule.tar'
UMO_COIN_ZIP=$(echo $UMO_COIN_TGZ | awk -F'/' '{print $NF}')
UMO_COIN_NAME='Universalmolecule'
UMO_RPC_PORT='19738'
UMO_COIN_PORT='24785'
UMO_PEERS=$(curl -s$ $FTP/$UMO_COIN_NAME/$PEERS)

BBlue='\033[1;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
WHITE='\033[1;97m'
YELLOW='\033[0;93m'
NC='\033[0m'

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec &> >(tee setup.log) 2>&1
# Everything below will go to the file 'setup.log':

function checks() {
if [[ $(lsb_release -d) != *16.04* ]]; then
  echo -e "${RED}You are not running Ubuntu 16.04. Installation is cancelled.${NC}"
  exit 1
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

function swap() {
#checking for swapfile
if [ $(free | awk '/^Swap:/ {exit !$2}') ] || [ ! -f "/var/mnode_swap.img" ];then
    echo "Creating Swap"
    rm -f /var/mnode_swap.img
    dd if=/dev/zero of=/var/mnode_swap.img bs=1024k count=4000
    chmod 0600 /var/mnode_swap.img
    mkswap /var/mnode_swap.img
    swapon /var/mnode_swap.img
    echo '/var/mnode_swap.img none swap sw 0 0' | tee -a /etc/fstab
    echo 'vm.swappiness=10' | tee -a /etc/sysctl.conf               
    echo 'vm.vfs_cache_pressure=50' | tee -a /etc/sysctl.conf
clear	
else
    echo "Swapfile created"
fi
}

function enable_firewall() {
  echo -e "Setting up firewall ${GREEN}$COIN_PORT${NC}"
  ufw allow $BLC_COIN_PORT/tcp comment "$BLC_COIN_NAME" >/dev/null
  ufw allow $PHO_COIN_PORT/tcp comment "$PHO_COIN_NAME" >/dev/null
  ufw allow $BBTC_COIN_PORT/tcp comment "$BBTC_COIN_NAME" >/dev/null
  ufw allow $ELT_COIN_PORT/tcp comment "$ELT_COIN_NAME" >/dev/null
  ufw allow $LIT_COIN_PORT/tcp comment "$LIT_COIN_NAME" >/dev/null
  ufw allow $UMO_COIN_PORT/tcp comment "$UMO_COIN_NAME" >/dev/null
  ufw allow ssh comment "SSH" >/dev/null 2>&1
  ufw limit ssh/tcp >/dev/null 2>&1
  echo "y" | ufw enable >/dev/null 2>&1
  clear
}

function create_folders()  {
mkdir $USERDIR/$BLC_CONFIGFOLDER >/dev/null 2>&1
mkdir $USERDIR/$PHO_CONFIGFOLDER >/dev/null 2>&1
mkdir $USERDIR/$BBTC_CONFIGFOLDER >/dev/null 2>&1
mkdir $USERDIR/$ELT_CONFIGFOLDER >/dev/null 2>&1
mkdir $USERDIR/$LIT_CONFIGFOLDER >/dev/null 2>&1
mkdir $USERDIR/$UMO_CONFIGFOLDER >/dev/null 2>&1
}

function create_config() {
echo -e "Creating $BLC_COIN_NAME config file"
  RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $USERDIR/$BLC_CONFIGFOLDER/$BLC_CONFIG_FILE
maxconnections=12
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcallowip=127.0.0.1
rpcport=$BLC_RPC_PORT
port=$BLC_COIN_PORT
gen=0
listen=1
daemon=1
server=1
txindex=1
$BLC_PEERS
EOF

echo -e "Creating $PHO_COIN_NAME config file"
  RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $USERDIR/$PHO_CONFIGFOLDER/$PHO_CONFIG_FILE
maxconnections=12
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcallowip=127.0.0.1
rpcport=$PHO_RPC_PORT
port=$PHO_COIN_PORT
gen=0
listen=1
daemon=1
server=1
txindex=1
$PHO_PEERS
EOF

echo -e "Creating $BBTC_COIN_NAME config file"
  RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $USERDIR/$BBTC_CONFIGFOLDER/$BBTC_CONFIG_FILE
maxconnections=12
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcallowip=127.0.0.1
rpcport=$BBTC_RPC_PORT
port=$BBTC_COIN_PORT
gen=0
listen=1
daemon=1
server=1
txindex=1
$BBTC_PEERS
EOF

echo -e "Creating $ELT_COIN_NAME config file"
  RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $USERDIR/$ELT_CONFIGFOLDER/$ELT_CONFIG_FILE
maxconnections=12
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcallowip=127.0.0.1
rpcport=$ELT_RPC_PORT
port=$ELT_COIN_PORT
gen=0
listen=1
daemon=1
server=1
txindex=1
$ELT_PEERS
EOF

echo -e "Creating $LIT_COIN_NAME config file"
  RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $USERDIR/$LIT_CONFIGFOLDER/$LIT_CONFIG_FILE
maxconnections=12
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcallowip=127.0.0.1
rpcport=$LIT_RPC_PORT
port=$LIT_COIN_PORT
gen=0
listen=1
daemon=1
server=1
txindex=1
$LIT_PEERS
EOF

echo -e "Creating $UMO_COIN_NAME config file"
  RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $USERDIR/$UMO_CONFIGFOLDER/$UMO_CONFIG_FILE
maxconnections=12
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcallowip=127.0.0.1
rpcport=$UMO_RPC_PORT
port=$UMO_COIN_PORT
gen=0
listen=1
daemon=1
server=1
txindex=1
$UMO_PEERS
EOF
}

progressfilt ()
{
    local flag=false c count cr=$'\r' nl=$'\n'
    while IFS='' read -d '' -rn 1 c
    do
        if $flag
        then
            printf '%s' "$c"
        else
            if [[ $c != $cr && $c != $nl ]]
            then
                count=0
            else
                ((count++))
                if ((count > 1))
                then
                    flag=true
                fi
            fi
        fi
    done
}

function bootstrap() {
while true; do
    read -p "Download BootStraps for all Blakestream Coins? (Y or N)" yn
    case $yn in
        [Yy]* ) echo Downloading $BLC_COIN_NAME $STRAP to $USERDIR/$BLC_CONFIGFOLDER
		wget --progress=bar:force -O $USERDIR/$BLC_CONFIGFOLDER/$STRAP $FTP/$BLC_COIN_NAME/$STRAP 2>&1 | progressfilt; 
		echo Downloading $PHO_COIN_NAME $STRAP to $USERDIR/$PHO_CONFIGFOLDER
		wget --progress=bar:force -O $USERDIR/$PHO_CONFIGFOLDER/$STRAP $FTP/$PHO_COIN_NAME/$STRAP 2>&1 | progressfilt; 
		echo Downloading $BBTC_COIN_NAME $STRAP to $USERDIR/$BBTC_CONFIGFOLDER
		wget --progress=bar:force -O $USERDIR/$BBTC_CONFIGFOLDER/$STRAP $FTP/$BBTC_COIN_NAME/$STRAP 2>&1 | progressfilt; 
		echo Downloading $ELT_COIN_NAME $STRAP to $USERDIR/$ELT_CONFIGFOLDER
		wget --progress=bar:force -O $USERDIR/$ELT_CONFIGFOLDER/$STRAP $FTP/$ELT_COIN_NAME/$STRAP 2>&1 | progressfilt; 
		echo Downloading $LIT_COIN_NAME $STRAP to $USERDIR/$LIT_CONFIGFOLDER
		wget --progress=bar:force -O $USERDIR/$LIT_CONFIGFOLDER/$STRAP $FTP/$LIT_COIN_NAME/$STRAP 2>&1 | progressfilt; 
		echo Downloading $UMO_COIN_NAME $STRAP to $USERDIR/$UMO_CONFIGFOLDER
		wget --progress=bar:force -O $USERDIR/$UMO_CONFIGFOLDER/$STRAP $FTP/$UMO_COIN_NAME/$STRAP 2>&1 | progressfilt; break;;
        [Nn]* ) echo You chose not to download the bootstraps; break;;
        * ) echo "Please answer yes or no.";;
    esac
done
}

function download_node() {
  echo -e "Installing $BLC_COIN_NAME${NC}."
  cd $BLC_TMP_FOLDER >/dev/null 2>&1
  wget -q $BLC_COIN_TGZ
  tar xvf $BLC_COIN_ZIP
  chmod +x $BLC_COIN_DAEMON
  cp $BLC_COIN_DAEMON $COIN_PATH
  cd ~ >/dev/null 2>&1
  rm -rf $BLC_TMP_FOLDER >/dev/null 2>&1
  clear
  
  echo -e "Installing $PHO_COIN_NAME${NC}."
  cd $PHO_TMP_FOLDER >/dev/null 2>&1
  wget -q $PHO_COIN_TGZ
  tar xvf $PHO_COIN_ZIP
  chmod +x $PHO_COIN_DAEMON
  cp $PHO_COIN_DAEMON $COIN_PATH
  cd ~ >/dev/null 2>&1
  rm -rf $PHO_TMP_FOLDER >/dev/null 2>&1
  clear
  
    echo -e "Installing $BBTC_COIN_NAME${NC}."
  cd $BBTC_TMP_FOLDER >/dev/null 2>&1
  wget -q $BBTC_COIN_TGZ
  tar xvf $BBTC_COIN_ZIP
  chmod +x $BBTC_COIN_DAEMON
  cp $BBTC_COIN_DAEMON $COIN_PATH
  cd ~ >/dev/null 2>&1
  rm -rf $BBTC_TMP_FOLDER >/dev/null 2>&1
  clear
  
      echo -e "Installing $ELT_COIN_NAME${NC}."
  cd $ELT_TMP_FOLDER >/dev/null 2>&1
  wget -q $ELT_COIN_TGZ
  tar xvf $ELT_COIN_ZIP
  chmod +x $ELT_COIN_DAEMON
  cp $ELT_COIN_DAEMON $COIN_PATH
  cd ~ >/dev/null 2>&1
  rm -rf $ELT_TMP_FOLDER >/dev/null 2>&1
  clear
  
        echo -e "Installing $LIT_COIN_NAME${NC}."
  cd $LIT_TMP_FOLDER >/dev/null 2>&1
  wget -q $LIT_COIN_TGZ
  tar xvf $LIT_COIN_ZIP
  chmod +x $LIT_COIN_DAEMON
  cp $LIT_COIN_DAEMON $COIN_PATH
  cd ~ >/dev/null 2>&1
  rm -rf $LIT_TMP_FOLDER >/dev/null 2>&1
  clear
  
          echo -e "Installing $UMO_COIN_NAME${NC}."
  cd $UMO_TMP_FOLDER >/dev/null 2>&1
  wget -q $UMO_COIN_TGZ
  tar xvf $UMO_COIN_ZIP
  chmod +x $UMO_COIN_DAEMON
  cp $UMO_COIN_DAEMON $COIN_PATH
  cd ~ >/dev/null 2>&1
  rm -rf $UMO_TMP_FOLDER >/dev/null 2>&1
  clear
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
#PIDFile=$USERDIR/$BLC_CONFIGFOLDER/$BLC_COIN_NAME.pid
ExecStart=$COIN_PATH/$BLC_COIN_DAEMON -daemon -conf=$USERDIR/$BLC_CONFIGFOLDER/$BLC_CONFIG_FILE -datadir=$USERDIR/$BLC_CONFIGFOLDER
ExecStop=$COIN_PATH/$BLC_COIN_DAEMON -conf=$USERDIR/$BLC_CONFIGFOLDER/$BLC_CONFIG_FILE -datadir=$USERDIR/$BLC_CONFIGFOLDER stop
Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=2
CPUWeight=20
CPUQuota=60%
IOWeight=20
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
#PIDFile=$USERDIR/$PHO_CONFIGFOLDER/$PHO_COIN_NAME.pid
ExecStart=$COIN_PATH/$PHO_COIN_DAEMON -daemon -conf=$USERDIR/$PHO_CONFIGFOLDER/$PHO_CONFIG_FILE -datadir=$USERDIR/$PHO_CONFIGFOLDER
ExecStop=-$COIN_PATH/$PHO_COIN_DAEMON -conf=$USERDIR/$PHO_CONFIGFOLDER/$PHO_CONFIG_FILE -datadir=$USERDIR/$PHO_CONFIGFOLDER stop
Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=2
CPUWeight=20
CPUQuota=60%
IOWeight=20
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
#PIDFile=$USERDIR/$BBTC_CONFIGFOLDER/$BBTC_COIN_NAME.pid
ExecStart=$COIN_PATH/$BBTC_COIN_DAEMON -daemon -conf=$USERDIR/$BBTC_CONFIGFOLDER/$BBTC_CONFIG_FILE -datadir=$USERDIR/$BBTC_CONFIGFOLDER
ExecStop=-$COIN_PATH/$BBTC_COIN_DAEMON -conf=$USERDIR/$BBTC_CONFIGFOLDER/$BBTC_CONFIG_FILE -datadir=$USERDIR/$BBTC_CONFIGFOLDER stop
Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=2
CPUWeight=20
CPUQuota=60%
IOWeight=20
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
#PIDFile=$USERDIR/$ELT_CONFIGFOLDER/$ELT_COIN_NAME.pid
ExecStart=$COIN_PATH/$ELT_COIN_DAEMON -daemon -conf=$USERDIR/$ELT_CONFIGFOLDER/$ELT_CONFIG_FILE -datadir=$USERDIR/$ELT_CONFIGFOLDER
ExecStop=-$COIN_PATH/$ELT_COIN_DAEMON -conf=$USERDIR/$ELT_CONFIGFOLDER/$ELT_CONFIG_FILE -datadir=$USERDIR/$ELT_CONFIGFOLDER stop
Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=2
CPUWeight=20
CPUQuota=60%
IOWeight=20
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
#PIDFile=$USERDIR/$LIT_CONFIGFOLDER/$LIT_COIN_NAME.pid
ExecStart=$COIN_PATH/$LIT_COIN_DAEMON -daemon -conf=$USERDIR/$LIT_CONFIGFOLDER/$LIT_CONFIG_FILE -datadir=$USERDIR/$LIT_CONFIGFOLDER
ExecStop=-$COIN_PATH/$LIT_COIN_DAEMON -conf=$USERDIR/$LIT_CONFIGFOLDER/$LIT_CONFIG_FILE -datadir=$USERDIR/$LIT_CONFIGFOLDER stop
Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=2
CPUWeight=20
CPUQuota=60%
IOWeight=20
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
#PIDFile=$USERDIR/$UMO_CONFIGFOLDER/$UMO_COIN_NAME.pid
ExecStart=$COIN_PATH/$UMO_COIN_DAEMON -daemon -conf=$USERDIR/$UMO_CONFIGFOLDER/$UMO_CONFIG_FILE -datadir=$USERDIR/$UMO_CONFIGFOLDER
ExecStop=-$COIN_PATH/$UMO_COIN_DAEMON -conf=$USERDIR/$UMO_CONFIGFOLDER/$UMO_CONFIG_FILE -datadir=$USERDIR/$UMO_CONFIGFOLDER stop
Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=2
CPUWeight=20
CPUQuota=60%
IOWeight=20
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
clear
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
#On first launch debug.log will grow to be the size of the blockchain. Removing the log just makes sense.
rm $USERDIR/$BLC_CONFIGFOLDER/debug.log
rm $USERDIR/$PHO_CONFIGFOLDER/debug.log
rm $USERDIR/$BBTC_CONFIGFOLDER/debug.log
rm $USERDIR/$ELT_CONFIGFOLDER/debug.log
rm $USERDIR/$LIT_CONFIGFOLDER/debug.log
rm $USERDIR/$UMO_CONFIGFOLDER/debug.log
}

function bootstrap_check() {
if [ -f "$USERDIR/$BLC_CONFIGFOLDER/$STRAP" ]; then
cat << 'EOT' > $USERDIR/bootstrap.sh
#!/bin/bash
USER=$(whoami)
USERDIR=$(eval echo ~$user)
BLC_CONFIGFOLDER='.blakecoin'
PHO_CONFIGFOLDER='.photon'
BBTC_CONFIGFOLDER='.blakebitcoin'
ELT_CONFIGFOLDER='.electron'
LIT_CONFIGFOLDER='.lithium'
UMO_CONFIGFOLDER='.universalmolecule'

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec &> >(tee $USERDIR/bootstrap.log) 2>&1
# Everything below will go to the file '$USERDIR/bootstrap.log':

date +%d/%m/%Y%t%H:%M:%S
#Checking for Bootstrap
if [ -f "$USERDIR/$BLC_CONFIGFOLDER/bootstrap.dat" ]; then
echo "Blakecoin still importing bootstrap"
elif [ -f "$USERDIR/$BLC_CONFIGFOLDER/bootstrap.dat.old" ]; then
rm $USERDIR/$BLC_CONFIGFOLDER/bootstrap.dat.old
echo "Deleting Blakecoin Bootstrap"
BLC='0'
elif [ ! -f "$USERDIR/$BLC_CONFIGFOLDER/bootstrap.dat && -a -f $USERDIR/$BLC_CONFIGFOLDER/bootstrap.dat.old" ]; then
echo "Blakecoin Bootstrap has already been removed"
BLC='0'
fi

if [ -f "$USERDIR/$PHO_CONFIGFOLDER/bootstrap.dat" ]; then
echo "Photon still importing bootstrap"
elif [ -f "$USERDIR/$PHO_CONFIGFOLDER/bootstrap.dat.old" ]; then
rm $USERDIR/$PHO_CONFIGFOLDER/bootstrap.dat.old
echo "Deleting Photon Bootstrap"
PHO='0'
elif [ ! -f "$USERDIR/$PHO_CONFIGFOLDER/bootstrap.dat && -a -f $USERDIR/$PHO_CONFIGFOLDER/bootstrap.dat.old" ]; then
echo "Photon Bootstrap has already been removed"
PHO='0'
fi

if [ -f "$USERDIR/$BBTC_CONFIGFOLDER/bootstrap.dat" ]; then
echo "Blakebitcoin still importing bootstrap"
elif [ -f "$USERDIR/$BBTC_CONFIGFOLDER/bootstrap.dat.old" ]; then
rm $USERDIR/$BBTC_CONFIGFOLDER/bootstrap.dat.old
echo "Deleting Blakebitcoin Bootstrap"
BBTC='0'
elif [ ! -f "$USERDIR/$BBTC_CONFIGFOLDER/bootstrap.dat && -a -f $USERDIR/$BBTC_CONFIGFOLDER/bootstrap.dat.old" ]; then
echo "Blakebitcoin Bootstrap has already been removed"
BBTC='0'
fi

if [ -f "$USERDIR/$ELT_CONFIGFOLDER/bootstrap.dat" ]; then
echo "Electron still importing bootstrap"
elif [ -f "$USERDIR/$ELT_CONFIGFOLDER/bootstrap.dat.old" ]; then
rm $USERDIR/$ELT_CONFIGFOLDER/bootstrap.dat.old
echo "Deleting Electron Bootstrap"
ELT='0'
elif [ ! -f "$USERDIR/$ELT_CONFIGFOLDER/bootstrap.dat && -a -f $USERDIR/$ELT_CONFIGFOLDER/bootstrap.dat.old" ]; then
echo "Electron Bootstrap has already been removed"
ELT='0'
fi

if [ -f "$USERDIR/$UMO_CONFIGFOLDER/bootstrap.dat" ]; then
echo "Universal Molecule still importing bootstrap"
elif [ -f "$USERDIR/$UMO_CONFIGFOLDER/bootstrap.dat.old" ]; then
rm $USERDIR/$UMO_CONFIGFOLDER/bootstrap.dat.old
echo "Deleting Universal Molecule Bootstrap"
UMO='0'
elif [ ! -f "$USERDIR/$UMO_CONFIGFOLDER/bootstrap.dat && -a -f $USERDIR/$UMO_CONFIGFOLDER/bootstrap.dat.old" ]; then
echo "Universal Molecule Bootstrap has already been removed"
UMO='0'
fi

if [ -f "$USERDIR/$LIT_CONFIGFOLDER/bootstrap.dat" ]; then
echo "Lithium still importing bootstrap"
elif [ -f "$USERDIR/$LIT_CONFIGFOLDER/bootstrap.dat.old" ]; then
rm $USERDIR/$LIT_CONFIGFOLDER/bootstrap.dat.old
echo "Deleting Lithium Molecule Bootstrap"
LIT='0'
elif [ ! -f "$USERDIR/$LIT_CONFIGFOLDER/bootstrap.dat && -a -f $USERDIR/$LIT_CONFIGFOLDER/bootstrap.dat.old" ]; then
echo "Lithium Molecule Bootstrap has already been removed"
LIT='0'
fi

if [[ -z $BLC || -z $PHO || -z $BBTC || -z $ELT || -z $UMO || -z $LIT ]]; then
echo "Blockchains are still importing bootstraps"
 else
echo "Disabling Bootstrap systemctl service"
systemctl disable bootstrap.service
systemctl daemon-reload
sleep 2
echo "Deleting this script"
rm -- "$0"
fi
EOT

chmod u+x bootstrap.sh

cat << EOF > /etc/systemd/system/bootstrap.service
[Unit]
Description=Check and remove bootstraps when done
[Service]
StandardOutput=null
#StandardError=null
User=$USER
Restart=always
RestartSec=3600s
ExecStart=$USERDIR/bootstrap.sh
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
sleep 4
systemctl start bootstrap.service
systemctl enable bootstrap.service >/dev/null 2>&1
else
echo "Bootstraps not downloaded, Removal script not setup"
fi
}
function setup_node() {
  swap
  enable_firewall
  create_folders
  create_config
  bootstrap
  important_information
  configure_systemd
  clean
  bootstrap_check
}

##### Main #####
clear

checks
prepare_system
download_node
setup_node
