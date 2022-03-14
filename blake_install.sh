#!/bin/bash

#Global varables

#Config settings - change to suit needs
MAXCONNECTIONS='maxconnections=20'
RPCALLOWIP='rpcallowip=127.0.0.1'
GEN='gen=0'
LISTEN='listen=1'
DAEMON='daemon=1'
SERVER='server=1'
TXINDEX='txindex=0'

#For Script
FTP='https://bootstrap.specminer.com'
USER=$(whoami)
USERDIR=$(eval echo ~$user)
STRAP='bootstrap.dat'
COIN_PATH='/usr/local/bin'
SWAP="$(swapon --show)"
cols="$(tput cols)"
BBlue='\033[1;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
WHITE='\033[1;97m'
YELLOW='\033[0;93m'
UYellow='\033[4;33m'
NC='\033[0m'
HEART=' \u2665'


#For Menu
ERROR=" "

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec &> >(tee setup.log) 2>&1
# Everything below will go to the file 'setup.log':

clear

repeat(){
	for ((i=0; i<cols; i++));do printf "="; done; echo
}

function native() {
#Menu option Native Daemon Instller
options[0]="Pre-Built"
options[1]="Build Locally"
options[2]="Create swapfile"

#Menu function
function MENU {
    echo -e "${WHITE}Blakestream Daemon Install${NC}"
    for NUM in ${!options[@]}; do
        echo -e "${WHITE}[${NC}"${RED}"${choices[NUM]:- }""""${WHITE}]${NC}"$(( NUM+1 ))"-> ${options[NUM]}${NC}"
    done
    echo -e "${WHITE}Daemons pulled from Github unless *Build Locally* is selected${NC}"
    repeat ; echo -e ${UYellow}'\nCurrent SwapFile'${NC}
    echo "$SWAP"
    repeat ;
    echo "$ERROR"
}

#Menu loop
while MENU && read -e -p "Select the desired options using their number (again to uncheck, ENTER when done): " -n1 SELECTION && [[ -n "$SELECTION" ]]; do
    clear
    if [[ "$SELECTION" == *[[:digit:]]* && $SELECTION -ge 1 && $SELECTION -le ${#options[@]} ]]; then
        (( SELECTION-- ))
        if [[ "${choices[SELECTION]}" == "+" ]]; then
            choices[SELECTION]=""
        else
            choices[SELECTION]="+"
        fi
            ERROR=" "
    else
        ERROR="Invalid option: $SELECTION"
    fi
done
{
#Selection
    if [[ ${choices[0]} ]]; then
        echo "- Pre-Built"
        pre_built='Y'
        bld='Pre-Built'
    fi
    if [[ ${choices[1]} ]]; then
        echo "- Build Locally"
        local='Y'
        bld='Local Built'
    fi
    if [[ ${choices[2]} ]]; then
        echo "- Create Swap File"
        swp='Y'    
    fi
  }

}

function menu_check() {
    if [[ $pre_built == "Y" ]] && [[ $local == "Y" ]]; then
    clear
       echo -e "${WHITE}Choose \u1F63nly Pre-Built OR Build Locally${NC}"
       exit 1
    fi
   if [[ $pre_built == "Y" ]]; then
        clear
        #echo "Installing Pre-Built BlakeStream Daemons"
           if [[ $swp == "Y" ]]; then
              clear
              echo "Create Swapfile for Daemon Install"
              swapsz ;
              swap ;
            fi
   elif [[ $local == "Y" ]]; then
        clear
        #echo "Installing local built Daemons"
           if [[ $swp == "Y" ]]; then
              clear
              echo "Create Swapfile for Daemon Install"
              swapsz ;
              swap ;
           fi
   elif [[ $swp == "Y" ]]; then
        clear
        echo -e "Create Swapfile - No Daemon Install"
        swapsz ;
        swap ;
        exit 1
    else
     clear
     echo -e "${WHITE}No Install option Selected${NC}"
     echo $pre_built
     echo $local
     exit 1
    fi
sleep 2
}

swapsz(){
#Set size of swapfile in megabytes
    repeat ; echo -e ${WHITE}Size of swapfile in megabytes${NC}
echo -e "500mb= 512 - 1gb= 1024 - 2gb= 2048"
echo -e " 3gb= 3072 - 4gb= 4096 - 5gb= 5120"
    repeat ;
read -p "Enter swapfile size: " swapsize
read -p "Continue with $swapsize swapfile? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
}

swap(){
#checking for swapfile
if [ $(free | awk '/^Swap:/ {exit !$2}') ] || [ ! -f "/blake_swap.img" ]; then
    echo "Creating a Swap file"
    rm -f /blake_swap.img
    dd if=/dev/zero of=/blake_swap.img bs=1024k count="$swapsize"
    chmod 0600 /blake_swap.img
    mkswap /blake_swap.img
    swapon /blake_swap.img
    echo '/blake_swap.img none swap sw 0 0' | tee -a /etc/fstab
    echo 'vm.swappiness=10' | tee -a /etc/sysctl.conf               
    echo 'vm.vfs_cache_pressure=50' | tee -a /etc/sysctl.conf
clear	
else
    echo "A Swap File aready exist"
sleep 1
fi
}

function wallet_select() {
unset SELECTION
unset choices
clear
#Menu option for coin selection
options[0]="All BlakeStream Coins"
options[1]="Blakecoin"
options[2]="Photon"
options[3]="BlakeBitcoin"
options[4]="Electron"
options[5]="Universal Molecule"
options[6]="Lithium"
options[7]="Download bootstraps for selected Daemons"
options[8]="Install bootstrap removal script"

#Menu function
function COIN {
    echo -e "${WHITE}Blakestream "$bld" Daemon Install${NC}"
    for NUM in ${!options[@]}; do
        echo -e "${WHITE}[${NC}"${RED}"${choices[NUM]:- }""""${WHITE}]${NC}"$(( NUM+1 ))"-> ${options[NUM]}${NC}"
    done

    echo "$ERROR"
}

#Menu loop
while COIN && read -e -p "Select the desired options using their number (again to uncheck, ENTER when done): " -n1 SELECTION && [[ -n "$SELECTION" ]]; do
    clear
    if [[ "$SELECTION" == *[[:digit:]]* && $SELECTION -ge 1 && $SELECTION -le ${#options[@]} ]]; then
        (( SELECTION-- ))
        if [[ "${choices[SELECTION]}" == "+" ]]; then
            choices[SELECTION]=""
        else
            choices[SELECTION]="+"
        fi
            ERROR=" "
    else
        ERROR="Invalid option: $SELECTION"
    fi

done
{
#Selection
        echo "  "
        echo "================="
        echo "Selected Options"
        echo "================="
 if [[ ${choices[0]} ]]; then
        #Option 1 selected
        echo "- All Blakestream Daemons"
        ALL='Y'
    fi
    if [[ ${choices[1]} ]]; then
        #Option 2 selected
        echo "- Blakecoin"
        BLC='Y'
    fi
    if [[ ${choices[2]} ]]; then
        #Option 3 selected
        echo "- Photon"
        PHO='Y'
    fi
    if [[ ${choices[3]} ]]; then
        #Option 4 selected
        echo "- BlakeBitcoin"
        BBTC='Y'
    fi
    if [[ ${choices[4]} ]]; then
        #Option 5 selected
        echo "- Electron"
        ELT='Y'
    fi
    if [[ ${choices[5]} ]]; then
        #Option 6 selected
        echo "- Universal Molecule"
        UMO='Y'
    fi
    if [[ ${choices[6]} ]]; then
        #Option 7 selected
        echo "- Lithium"
        LIT='Y'
    fi
    if [[ ${choices[7]} ]]; then
        #Option 8 selected
        echo "- Download Boostrap for selected Daemons"
        BSTRP='Y'
    fi
    if [[ ${choices[8]} ]]; then
        #Option 8 selected
        echo "- Install bootstrap removal script"
        BOOT='Y'
    fi
sleep 2
  }
}

function depend_native() {
clear
    if [[ $(lsb_release -d) = *16.04* ]]; then
      echo -e "${WHITE}Installing Dependancies for Ubuntu 16.04${NC}"
      apt-get update
      sleep 1
      apt install --no-install-recommends -y software-properties-common
      apt-add-repository -y ppa:bitcoin/bitcoin
      apt-get update
      apt install --no-install-recommends -y wget git curl build-essential libssl-dev libboost-all-dev libminiupnpc-dev libdb4.8-dev libdb4.8++-dev
      clone='git clone -b 16.04'
      pre_com='16.04'
      USRDIR='/usr/local/bin/'

    elif [[ $(lsb_release -d) = *18.04* ]]; then
      echo -e "${WHITE}Installing Dependancies for Ubuntu 18.04${NC}"
      apt-get update
      sleep 1
      apt install --no-install-recommends -y software-properties-common
      apt-add-repository -y ppa:bitcoin/bitcoin
      apt-get update
      apt install --no-install-recommends -y wget git curl build-essential libssl-dev libboost-all-dev libminiupnpc-dev libdb4.8-dev libdb4.8++-dev
      clone='git clone -b 16.04'
      pre_com='18.04'
      USRDIR='/usr/local/bin/'

    elif [[ $(lsb_release -d) = *20.04* ]]; then
      echo -e "${WHITE}Installing Dependancies for Ubuntu 20.04${NC}"
      apt-get update
      sleep 1
      apt install --no-install-recommends -y software-properties-common 
      wget --no-check-certificate -O $USERDIR/BitcoinPPA.key 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xc70ef1f0305a1adb9986dbd8d46f45428842ce5e'
      apt-key add $USERDIR/BitcoinPPA.key
      echo "deb http://ppa.launchpad.net/bitcoin/bitcoin/ubuntu/ bionic main" | sudo tee -a /etc/apt/sources.list
      apt-get update
      apt install --no-install-recommends -y wget git curl build-essential libssl-dev libboost-all-dev libminiupnpc-dev libdb4.8-dev libdb4.8++-dev
      clone='git clone'
      pre_com='20.04'
    else 
      echo -e "${RED}No Compatable Ubuntu version installed${NC}"
fi
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

function blc_native() {
clear
   if [ -f "$USERDIR/$BLC_CONFIGFOLDER/peers.dat" ]; then
   echo "$BLC_COIN_NAME already installed skipping"
   elif [[ $BLC == Y || $ALL == Y ]]; then

#BlakeCoin Variables
BLC_REPO='https://github.com/BlueDragon747/Blakecoin.git'
BLC_DAEMON='https://github.com/SidGrip/BlakeStream-Nodes/releases/download'
BLC_CONFIG_FILE='blakecoin.conf'
BLC_CONFIGFOLDER='.blakecoin'
BLC_COIN_DAEMON='blakecoind'
BLC_COIN_NAME='Blakecoin'
BLC_RPC_PORT='8772'
BLC_P2P_PORT='8773'
echo "Setting up $BLC_COIN_NAME Daemon"
sleep 2
 
   if [[ $local == Y ]]; then
    echo -e "${WHITE}Compiling wallet locally${NC}"
    $clone $BLC_REPO /tmp/$BLC_COIN_NAME
    chmod +x /tmp/$BLC_COIN_NAME/src/leveldb/build_detect_platform
    cd /tmp/$BLC_COIN_NAME/src
    make -f makefile.unix
    strip $BLC_COIN_DAEMON
    mv $BLC_COIN_DAEMON $COIN_PATH
   blc_setup ;
   blc_service ;
   fi
  if [[ $pre_built == Y ]]; then
    wget --progress=bar:force -O $COIN_PATH/$BLC_COIN_DAEMON $BLC_DAEMON/$pre_com/$BLC_COIN_DAEMON 2>&1 | progressfilt;
    sleep 2
    chmod +x $COIN_PATH/$BLC_COIN_DAEMON
    clear
   blc_setup ;
   blc_service ;
  fi
 else
        echo "$BLC_COIN_NAME option not chosen"
fi
}

blc_setup(){
#Setup Firewall
 echo -e "Opening port# ${GREEN}$BLC_P2P_PORT${NC}"
  ufw allow $BLC_P2P_PORT/tcp comment "$BLC_COIN_NAME" >/dev/null

#Make Coin Directory
mkdir $USERDIR/$BLC_CONFIGFOLDER >/dev/null 2>&1

#Create Config File
echo -e "Creating $BLC_COIN_NAME config file"
# get list of curent active nodes from chainz block explorer sort and save to var
NODES=$(curl -s https://chainz.cryptoid.info/blc/api.dws?q=nodes)
BLC_PEERS=$(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' <<< "$NODES" | sed -e 's/^/addnode=/')
RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $USERDIR/$BLC_CONFIGFOLDER/$BLC_CONFIG_FILE
$MAXCONNECTIONS
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
$RPCALLOWIP
rpcport=$BLC_RPC_PORT
port=$BLC_P2P_PORT
$GEN
$LISTEN
$DAEMON
$SERVER
$TXINDEX
$BLC_PEERS
EOF

#Downloading Bootstrap
   if [[ $BSTRP == Y ]]; then
echo "Downloading $BLC_COIN_NAME $STRAP to $USERDIR/$BLC_CONFIGFOLDER"
  wget --progress=bar:force -O $USERDIR/$BLC_CONFIGFOLDER/$STRAP $FTP/$BLC_COIN_NAME/$STRAP 2>&1 | progressfilt; 
else
echo "$BLC_COIN_NAME Boostrap not selected"
fi
}

blc_service(){
#Create system servivce
 cat << EOF > /etc/systemd/system/$BLC_COIN_NAME.service
[Unit]
Description=$BLC_COIN_NAME service
After=network.target
[Service]
User=root
Group=root
Type=forking
#PIDFile=$USERDIR/$BLC_CONFIGFOLDER/$BLC_COIN_NAME.pid
ExecStart=$USRDIR$BLC_COIN_DAEMON -daemon -conf=$USERDIR/$BLC_CONFIGFOLDER/$BLC_CONFIG_FILE -datadir=$USERDIR/$BLC_CONFIGFOLDER
ExecStop=$USRDIR$BLC_COIN_DAEMON -conf=$USERDIR/$BLC_CONFIGFOLDER/$BLC_CONFIG_FILE -datadir=$USERDIR/$BLC_CONFIGFOLDER stop
Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=2
CPUQuota=60%
[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 4
  systemctl start $BLC_COIN_NAME.service
  systemctl enable $BLC_COIN_NAME.service >/dev/null 2>&1

  if [[ -z "$(ps axo cmd:100 | egrep $BLC_COIN_DAEMON)" ]]; then
    echo -e "${RED}$BLC_COIN_NAME is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $BLC_COIN_NAME.service"
    echo -e "systemctl status $BLC_COIN_NAME.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
  fi
sleep 2
echo -e "Starting $BLC_COIN_NAME Daemon"
sleep 4 
rm $USERDIR/$BLC_CONFIGFOLDER/debug.log
}

function pho_native() {
clear
if [ -f "$USERDIR/$PHO_CONFIGFOLDER/peers.dat" ]; then
echo "$PHO_COIN_NAME already installed skipping"
elif [[ $PHO == Y || $ALL == Y ]]; then

#PhotonCoin Variables
PHO_REPO='https://github.com/photonproject/photon.git'
PHO_DAEMON='https://github.com/SidGrip/BlakeStream-Nodes/releases/download'
PHO_CONFIG_FILE='photon.conf'
PHO_CONFIGFOLDER='.photon'
PHO_COIN_DAEMON='photond'
PHO_COIN_NAME='Photon'
PHO_RPC_PORT='8984'
PHO_P2P_PORT='35556'
echo "Setting up $PHO_COIN_NAME Daemon"
sleep 2
 
   if [[ $local == Y ]]; then
    echo -e "${WHITE}Compiling wallet locally${NC}"
    $clone $PHO_REPO /tmp/$PHO_COIN_NAME
    chmod +x /tmp/$PHO_COIN_NAME/src/leveldb/build_detect_platform
    cd /tmp/$PHO_COIN_NAME/src
    make -f makefile.unix
    strip $PHO_COIN_DAEMON
    mv $PHO_COIN_DAEMON $COIN_PATH
    pho_setup ;
    pho_service ;
   fi
   if [[ $pre_built == Y ]]; then
    wget --progress=bar:force -O $COIN_PATH/$PHO_COIN_DAEMON $PHO_DAEMON/$pre_com/$PHO_COIN_DAEMON 2>&1 | progressfilt;
    sleep 2
    chmod +x $COIN_PATH/$PHO_COIN_DAEMON
    clear
    pho_setup ;
    pho_service ;
  fi
  else
        echo "$PHO_COIN_NAME option not chosen"
fi
}

pho_setup(){
#Setup Firewall
 echo -e "Opening port# ${GREEN}$PHO_P2P_PORT${NC}"
  ufw allow $PHO_P2P_PORT/tcp comment "$PHO_COIN_NAME" >/dev/null

#Make Coin Directory
mkdir $USERDIR/$PHO_CONFIGFOLDER >/dev/null 2>&1

#Create Config File
echo -e "Creating $PHO_COIN_NAME config file"
# get list of curent active nodes from chainz block explorer sort and save to var
NODES=$(curl -s https://chainz.cryptoid.info/pho/api.dws?q=nodes)
PHO_PEERS=$(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' <<< "$NODES" | sed -e 's/^/addnode=/')
RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $USERDIR/$PHO_CONFIGFOLDER/$PHO_CONFIG_FILE
$MAXCONNECTIONS
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
$RPCALLOWIP
rpcport=$PHO_RPC_PORT
port=$PHO_P2P_PORT
$GEN
$LISTEN
$DAEMON
$SERVER
$TXINDEX
$PHO_PEERS
EOF

#Downloading Bootstrap
   if [[ $BSTRP == Y ]]; then
echo "Downloading $PHO_COIN_NAME $STRAP to $USERDIR/$PHO_CONFIGFOLDER"
  wget --progress=bar:force -O $USERDIR/$PHO_CONFIGFOLDER/$STRAP $FTP/$PHO_COIN_NAME/$STRAP 2>&1 | progressfilt; 
else
echo "$PHO_COIN_NAME Boostrap not selected"
fi
}

pho_service(){
#Create system servivce
cat << EOF > /etc/systemd/system/$PHO_COIN_NAME.service
[Unit]
Description=$PHO_COIN_NAME service
After=network.target
[Service]
User=root
Group=root
Type=forking
#PIDFile=$USERDIR/$PHO_CONFIGFOLDER/$PHO_COIN_NAME.pid
ExecStart=$USRDIR$PHO_COIN_DAEMON -daemon -conf=$USERDIR/$PHO_CONFIGFOLDER/$PHO_CONFIG_FILE -datadir=$USERDIR/$PHO_CONFIGFOLDER
ExecStop=$USRDIR$PHO_COIN_DAEMON -conf=$USERDIR/$PHO_CONFIGFOLDER/$PHO_CONFIG_FILE -datadir=$USERDIR/$PHO_CONFIGFOLDER stop
Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=2
CPUQuota=60%
[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 4
  systemctl start $PHO_COIN_NAME.service
  systemctl enable $PHO_COIN_NAME.service >/dev/null 2>&1

  if [[ -z "$(ps axo cmd:100 | egrep $PHO_COIN_DAEMON)" ]]; then
    echo -e "${RED}$PHO_COIN_NAME is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $PHO_COIN_NAME.service"
    echo -e "systemctl status $PHO_COIN_NAME.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
  fi
sleep 2
echo -e "Starting $PHO_COIN_NAME Daemon"
sleep 4 
rm $USERDIR/$PHO_CONFIGFOLDER/debug.log
}

function bbtc_native() {
clear
if [ -f "$USERDIR/$BBTC_CONFIGFOLDER/peers.dat" ]; then
echo "$BBTC_COIN_NAME already installed skipping"
elif [[ $BBTC == Y || $ALL == Y ]]; then

#BlakeBitcoin Variables
BBTC_REPO='https://github.com/BlakeBitcoin/BlakeBitcoin.git'
BBTC_DAEMON='https://github.com/SidGrip/BlakeStream-Nodes/releases/download'
BBTC_CONFIG_FILE='blakebitcoin.conf'
BBTC_CONFIGFOLDER='.blakebitcoin'
BBTC_COIN_DAEMON='blakebitcoind'
BBTC_COIN_NAME='BlakeBitcoin'
BBTC_RPC_PORT='243'
BBTC_P2P_PORT='356'
echo "Setting up $BBTC_COIN_NAME Daemon"
sleep 2
 
   if [[ $local == Y ]]; then
    echo -e "${WHITE}Compiling wallet locally${NC}"
    $clone $BBTC_REPO /tmp/$BBTC_COIN_NAME
    chmod +x /tmp/$BBTC_COIN_NAME/src/leveldb/build_detect_platform
    cd /tmp/$BBTC_COIN_NAME/src
    make -f makefile.unix
    strip $BBTC_COIN_DAEMON
    mv $BBTC_COIN_DAEMON $COIN_PATH
    bbtc_setup ;
    bbtc_service ;
   fi
   if [[ $pre_built == Y ]]; then
    wget --progress=bar:force -O $COIN_PATH/$BBTC_COIN_DAEMON $BBTC_DAEMON/$pre_com/$BBTC_COIN_DAEMON 2>&1 | progressfilt;
    sleep 2
    chmod +x $COIN_PATH/$BBTC_COIN_DAEMON
    clear
    bbtc_setup ;
    bbtc_service ;
  fi
  else
        echo "$BBTC_COIN_NAME option not chosen"
fi
}

bbtc_setup(){
#Setup Firewall
 echo -e "Opening port# ${GREEN}$BBTC_P2P_PORT${NC}"
  ufw allow $BBTC_P2P_PORT/tcp comment "$BBTC_COIN_NAME" >/dev/null

#Make Coin Directory
mkdir $USERDIR/$BBTC_CONFIGFOLDER >/dev/null 2>&1

#Create Config File
echo -e "Creating $BBTC_COIN_NAME config file"
# get list of curent active nodes from chainz block explorer sort and save to var
NODES=$(curl -s https://chainz.cryptoid.info/bbtc/api.dws?q=nodes)
BBTC_PEERS=$(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' <<< "$NODES" | sed -e 's/^/addnode=/')
RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $USERDIR/$BBTC_CONFIGFOLDER/$BBTC_CONFIG_FILE
$MAXCONNECTIONS
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
$RPCALLOWIP
rpcport=$BBTC_RPC_PORT
port=$BBTC_P2P_PORT
$GEN
$LISTEN
$DAEMON
$SERVER
$TXINDEX
$BBTC_PEERS
EOF

#Downloading Bootstrap
   if [[ $BSTRP == Y ]]; then
echo "Downloading $BBTC_COIN_NAME $STRAP to $USERDIR/$BBTC_CONFIGFOLDER"
  wget --progress=bar:force -O $USERDIR/$BBTC_CONFIGFOLDER/$STRAP $FTP/$BBTC_COIN_NAME/$STRAP 2>&1 | progressfilt; 
else
echo "$BBTC_COIN_NAME Boostrap not selected"
fi
}

bbtc_service(){
#Create system servivce
cat << EOF > /etc/systemd/system/$BBTC_COIN_NAME.service
[Unit]
Description=$BBTC_COIN_NAME service
After=network.target
[Service]
User=root
Group=root
Type=forking
#PIDFile=$USERDIR/$BBTC_CONFIGFOLDER/$BBTC_COIN_NAME.pid
ExecStart=$USRDIR$BBTC_COIN_DAEMON -daemon -conf=$USERDIR/$BBTC_CONFIGFOLDER/$BBTC_CONFIG_FILE -datadir=$USERDIR/$BBTC_CONFIGFOLDER
ExecStop=$USRDIR$BBTC_COIN_DAEMON -conf=$USERDIR/$BBTC_CONFIGFOLDER/$BBTC_CONFIG_FILE -datadir=$USERDIR/$BBTC_CONFIGFOLDER stop
Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=2
CPUQuota=60%
[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 4
  systemctl start $BBTC_COIN_NAME.service
  systemctl enable $BBTC_COIN_NAME.service >/dev/null 2>&1

  if [[ -z "$(ps axo cmd:100 | egrep $BBTC_COIN_DAEMON)" ]]; then
    echo -e "${RED}$BBTC_COIN_NAME is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $BBTC_COIN_NAME.service"
    echo -e "systemctl status $BBTC_COIN_NAME.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
  fi
sleep 2
echo -e "Starting $BBTC_COIN_NAME Daemon"
sleep 4 
rm $USERDIR/$BBTC_CONFIGFOLDER/debug.log
}

function elt_native() {
clear
if [ -f "$USERDIR/$ELT_CONFIGFOLDER/peers.dat" ]; then
echo "$ELT_COIN_NAME already installed skipping"
elif [[ $ELT == Y || $ALL == Y ]]; then

#ElectronCoin Variables
ELT_REPO='https://github.com/BlueDragon747/Electron-ELT.git'
ELT_DAEMON='https://github.com/SidGrip/BlakeStream-Nodes/releases/download'
ELT_CONFIG_FILE='electron.conf'
ELT_CONFIGFOLDER='.electron'
ELT_COIN_DAEMON='electrond'
ELT_COIN_NAME='Electron'
ELT_RPC_PORT='6852'
ELT_P2P_PORT='6853'
echo "Setting up $ELT_COIN_NAME Daemon"
sleep 2
 
   if [[ $local == Y ]]; then
    echo -e "${WHITE}Compiling wallet locally${NC}"
    $clone $ELT_REPO /tmp/$ELT_COIN_NAME
    chmod +x /tmp/$ELT_COIN_NAME/src/leveldb/build_detect_platform
    cd /tmp/$ELT_COIN_NAME/src
    make -f makefile.unix
    strip $ELT_COIN_DAEMON
    mv $ELT_COIN_DAEMON $COIN_PATH
    elt_setup ;
    elt_service ;
   fi
   if [[ $pre_built == Y ]]; then
    wget --progress=bar:force -O $COIN_PATH/$ELT_COIN_DAEMON $ELT_DAEMON/$pre_com/$ELT_COIN_DAEMON 2>&1 | progressfilt;
    sleep 2
    chmod +x $COIN_PATH/$ELT_COIN_DAEMON
    clear
    elt_setup ;
    elt_service ;
  fi
  else
        echo "$ELT_COIN_NAME option not chosen"
fi
}

elt_setup(){
#Setup Firewall
 echo -e "Opening port# ${GREEN}$ELT_P2P_PORT${NC}"
  ufw allow $ELT_P2P_PORT/tcp comment "$ELT_COIN_NAME" >/dev/null

#Make Coin Directory
mkdir $USERDIR/$ELT_CONFIGFOLDER >/dev/null 2>&1

#Create Config File
echo -e "Creating $ELT_COIN_NAME config file"
# get list of curent active nodes from chainz block explorer sort and save to var
NODES=$(curl -s https://chainz.cryptoid.info/bbtc/api.dws?q=nodes)
ELT_PEERS=$(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' <<< "$NODES" | sed -e 's/^/addnode=/')
RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $USERDIR/$ELT_CONFIGFOLDER/$ELT_CONFIG_FILE
$MAXCONNECTIONS
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
$RPCALLOWIP
rpcport=$ELT_RPC_PORT
port=$ELT_P2P_PORT
$GEN
$LISTEN
$DAEMON
$SERVER
$TXINDEX
$ELT_PEERS
EOF

#Downloading Bootstrap
   if [[ $BSTRP == Y ]]; then
echo "Downloading $ELT_COIN_NAME $STRAP to $USERDIR/$ELT_CONFIGFOLDER"
  wget --progress=bar:force -O $USERDIR/$ELT_CONFIGFOLDER/$STRAP $FTP/$ELT_COIN_NAME/$STRAP 2>&1 | progressfilt; 
else
echo "$ELT_COIN_NAME Boostrap not selected"
fi
}

elt_service(){
#Create system servivce
cat << EOF > /etc/systemd/system/$ELT_COIN_NAME.service
[Unit]
Description=$ELT_COIN_NAME service
After=network.target
[Service]
User=root
Group=root
Type=forking
#PIDFile=$USERDIR/$ELT_CONFIGFOLDER/$ELT_COIN_NAME.pid
ExecStart=$USRDIR$ELT_COIN_DAEMON -daemon -conf=$USERDIR/$ELT_CONFIGFOLDER/$ELT_CONFIG_FILE -datadir=$USERDIR/$ELT_CONFIGFOLDER
ExecStop=$USRDIR$ELT_COIN_DAEMON -conf=$USERDIR/$ELT_CONFIGFOLDER/$ELT_CONFIG_FILE -datadir=$USERDIR/$ELT_CONFIGFOLDER stop
Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=2
CPUQuota=60%
[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 4
  systemctl start $ELT_COIN_NAME.service
  systemctl enable $ELT_COIN_NAME.service >/dev/null 2>&1

  if [[ -z "$(ps axo cmd:100 | egrep $ELT_COIN_DAEMON)" ]]; then
    echo -e "${RED}$ELT_COIN_NAME is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $ELT_COIN_NAME.service"
    echo -e "systemctl status $ELT_COIN_NAME.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
  fi
sleep 2
echo -e "Starting $ELT_COIN_NAME Daemon"
sleep 4 
rm $USERDIR/$ELT_CONFIGFOLDER/debug.log
}

function umo_native() {
clear
if [ -f "$USERDIR/$UMO_CONFIGFOLDER/peers.dat" ]; then
echo "$UMO_COIN_NAME already installed skipping"
elif [[ $UMO == Y || $ALL == Y ]]; then

#Universalmolecule Variables
UMO_REPO='https://github.com/BlueDragon747/universalmol.git'
UMO_DAEMON='https://github.com/SidGrip/BlakeStream-Nodes/releases/download'
UMO_CONFIG_FILE='universalmolecule.conf'
UMO_CONFIGFOLDER='.universalmolecule'
UMO_COIN_DAEMON='universalmoleculed'
UMO_COIN_NAME='UniversalMolecule'
UMO_RPC_PORT='19738'
UMO_P2P_PORT='24785'
echo "Setting up $UMO_COIN_NAME Daemon"
sleep 2
 
   if [[ $local == Y ]]; then
    echo -e "${WHITE}Compiling wallet locally${NC}"
    $clone $UMO_REPO /tmp/$UMO_COIN_NAME
    chmod +x /tmp/$UMO_COIN_NAME/src/leveldb/build_detect_platform
    cd /tmp/$UMO_COIN_NAME/src
    make -f makefile.unix
    strip $UMO_COIN_DAEMON
    mv $UMO_COIN_DAEMON $COIN_PATH
    umo_setup ;
    umo_service ;
   fi
   if [[ $pre_built == Y ]]; then
    wget --progress=bar:force -O $COIN_PATH/$UMO_COIN_DAEMON $UMO_DAEMON/$pre_com/$UMO_COIN_DAEMON 2>&1 | progressfilt;
    sleep 2
    chmod +x $COIN_PATH/$UMO_COIN_DAEMON
    clear
    umo_setup ;
    umo_service ;
  fi
  else
        echo "$UMO_COIN_NAME option not chosen"
fi
}

umo_setup(){
#Setup Firewall
 echo -e "Opening port# ${GREEN}$UMO_P2P_PORT${NC}"
  ufw allow $UMO_P2P_PORT/tcp comment "$UMO_COIN_NAME" >/dev/null

#Make Coin Directory
mkdir $USERDIR/$UMO_CONFIGFOLDER >/dev/null 2>&1

#Create Config File
echo -e "Creating $UMO_COIN_NAME config file"
# get list of curent active nodes from chainz block explorer sort and save to var
NODES=$(curl -s https://chainz.cryptoid.info/bbtc/api.dws?q=nodes)
UMO_PEERS=$(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' <<< "$NODES" | sed -e 's/^/addnode=/')
RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $USERDIR/$UMO_CONFIGFOLDER/$UMO_CONFIG_FILE
$MAXCONNECTIONS
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
$RPCALLOWIP
rpcport=$UMO_RPC_PORT
port=$UMO_P2P_PORT
$GEN
$LISTEN
$DAEMON
$SERVER
$TXINDEX
$UMO_PEERS
EOF

#Downloading Bootstrap
   if [[ $BSTRP == Y ]]; then
echo "Downloading $UMO_COIN_NAME $STRAP to $USERDIR/$UMO_CONFIGFOLDER"
  wget --progress=bar:force -O $USERDIR/$UMO_CONFIGFOLDER/$STRAP $FTP/$UMO_COIN_NAME/$STRAP 2>&1 | progressfilt; 
else
echo "$UMO_COIN_NAME Boostrap not selected"
fi
}

umo_service() {
#Create system servivce
cat << EOF > /etc/systemd/system/$UMO_COIN_NAME.service
[Unit]
Description=$UMO_COIN_NAME service
After=network.target
[Service]
User=root
Group=root
Type=forking
#PIDFile=$USERDIR/$UMO_CONFIGFOLDER/$UMO_COIN_NAME.pid
ExecStart=$USRDIR$UMO_COIN_DAEMON -daemon -conf=$USERDIR/$UMO_CONFIGFOLDER/$UMO_CONFIG_FILE -datadir=$USERDIR/$UMO_CONFIGFOLDER
ExecStop=$USRDIR$UMO_COIN_DAEMON -conf=$USERDIR/$UMO_CONFIGFOLDER/$UMO_CONFIG_FILE -datadir=$USERDIR/$UMO_CONFIGFOLDER stop
Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=2
CPUQuota=60%
[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 4
  systemctl start $UMO_COIN_NAME.service
  systemctl enable $UMO_COIN_NAME.service >/dev/null 2>&1

  if [[ -z "$(ps axo cmd:100 | egrep $UMO_COIN_DAEMON)" ]]; then
    echo -e "${RED}$UMO_COIN_NAME is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $UMO_COIN_NAME.service"
    echo -e "systemctl status $UMO_COIN_NAME.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
  fi
sleep 2
echo -e "Starting $UMO_COIN_NAME Daemon"
sleep 4 
rm $USERDIR/$UMO_CONFIGFOLDER/debug.log
}

function lit_native() {
clear
if [ -f "$USERDIR/$LIT_CONFIGFOLDER/peers.dat" ]; then
echo "$LIT_COIN_NAME already installed skipping"
elif [[ $LIT == Y || $ALL == Y ]]; then

#LithiumCoin Variables
LIT_REPO='https://github.com/lithiumcoin/lithium.git'
LIT_DAEMON='https://github.com/SidGrip/BlakeStream-Nodes/releases/download'
LIT_CONFIG_FILE='lithium.conf'
LIT_CONFIGFOLDER='.lithium'
LIT_COIN_DAEMON='lithiumd'
LIT_COIN_NAME='Lithium'
LIT_RPC_PORT='12345'
LIT_P2P_PORT='12007'
echo "Setting up $LIT_COIN_NAME Daemon"
sleep 2
 
   if [[ $local == Y ]]; then
    echo -e "${WHITE}Compiling wallet locally${NC}"
    $clone $LIT_REPO /tmp/$LIT_COIN_NAME
    chmod +x /tmp/$LIT_COIN_NAME/src/leveldb/build_detect_platform
    cd /tmp/$LIT_COIN_NAME/src
    make -f makefile.unix
    strip $LIT_COIN_DAEMON
    mv $LIT_COIN_DAEMON $COIN_PATH
    lit_setup ;
    lit_service ;
  fi
  if [[ $pre_built == Y ]]; then
    wget --progress=bar:force -O $COIN_PATH/$LIT_COIN_DAEMON $LIT_DAEMON/$pre_com/$LIT_COIN_DAEMON 2>&1 | progressfilt;
    sleep 2
    chmod +x $COIN_PATH/$LIT_COIN_DAEMON
    clear
    lit_setup ;
    lit_service ;
  fi
  else
        echo "$LIT_COIN_NAME option not chosen"
fi
}

lit_setup(){
#Setup Firewall
 echo -e "Opening port# ${GREEN}$LIT_P2P_PORT${NC}"
  ufw allow $LIT_P2P_PORT/tcp comment "$LIT_COIN_NAME" >/dev/null

#Make Coin Directory
mkdir $USERDIR/$LIT_CONFIGFOLDER >/dev/null 2>&1

#Create Config File
echo -e "Creating $LIT_COIN_NAME config file"
# get list of curent active nodes from chainz block explorer sort and save to var
NODES=$(curl -s https://chainz.cryptoid.info/bbtc/api.dws?q=nodes)
LIT_PEERS=$(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' <<< "$NODES" | sed -e 's/^/addnode=/')
RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $USERDIR/$LIT_CONFIGFOLDER/$LIT_CONFIG_FILE
$MAXCONNECTIONS
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
$RPCALLOWIP
rpcport=$LIT_RPC_PORT
port=$LIT_P2P_PORT
$GEN
$LISTEN
$DAEMON
$SERVER
$TXINDEX
$LIT_PEERS
EOF

#Downloading Bootstrap
   if [[ $BSTRP == Y ]]; then
echo "Downloading $LIT_COIN_NAME $STRAP to $USERDIR/$LIT_CONFIGFOLDER"
  wget --progress=bar:force -O $USERDIR/$LIT_CONFIGFOLDER/$STRAP $FTP/$LIT_COIN_NAME/$STRAP 2>&1 | progressfilt; 
else
echo "$LIT_COIN_NAME Boostrap not selected"
fi
}

lit_service(){
#Create system servivce
cat << EOF > /etc/systemd/system/$LIT_COIN_NAME.service
[Unit]
Description=$LIT_COIN_NAME service
After=network.target
[Service]
User=root
Group=root
Type=forking
#PIDFile=$USERDIR/$LIT_CONFIGFOLDER/$LIT_COIN_NAME.pid
ExecStart=$USRDIR$LIT_COIN_DAEMON -daemon -conf=$USERDIR/$LIT_CONFIGFOLDER/$LIT_CONFIG_FILE -datadir=$USERDIR/$LIT_CONFIGFOLDER
ExecStop=$USRDIR$LIT_COIN_DAEMON -conf=$USERDIR/$LIT_CONFIGFOLDER/$LIT_CONFIG_FILE -datadir=$USERDIR/$LIT_CONFIGFOLDER stop
Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=2
CPUQuota=60%
[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 4
  systemctl start $LIT_COIN_NAME.service
  systemctl enable $LIT_COIN_NAME.service >/dev/null 2>&1

  if [[ -z "$(ps axo cmd:100 | egrep $LIT_COIN_DAEMON)" ]]; then
    echo -e "${RED}$LIT_COIN_NAME is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $LIT_COIN_NAME.service"
    echo -e "systemctl status $LIT_COIN_NAME.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
  fi
sleep 2
echo -e "Starting $LIT_COIN_NAME Daemon"
sleep 4 
rm $USERDIR/$LIT_CONFIGFOLDER/debug.log
clear
}

important_information() {
clear
if [ -f "/etc/systemd/system/$BLC_COIN_NAME.service" ]; then
    repeat ;
 echo -e "$BLC_COIN_NAME Node is up and running listening on port ${GREEN}$BLC_COIN_PORT${NC}."
 echo -e "Configuration file is: ${RED}$BLC_CONFIGFOLDER/$BLC_CONFIG_FILE${NC}"
 echo -e "Start: ${RED}systemctl start $BLC_COIN_NAME.service${NC}"
 echo -e "Stop: ${RED}systemctl stop $BLC_COIN_NAME.service${NC}"
 echo -e "Please check ${GREEN}$BLC_COIN_NAME${NC} daemon is running with the following command: ${BBlue}systemctl status $BLC_COIN_NAME.service${NC}"
fi
if [ -f "/etc/systemd/system/$PHO_COIN_NAME.service" ]; then
    repeat ;
 echo -e "$PHO_COIN_NAME Node is up and running listening on port ${GREEN}$PHO_COIN_PORT${NC}."
 echo -e "Configuration file is: ${RED}$PHO_CONFIGFOLDER/$PHO_CONFIG_FILE${NC}"
 echo -e "Start: ${RED}systemctl start $PHO_COIN_NAME.service${NC}"
 echo -e "Stop: ${RED}systemctl stop $PHO_COIN_NAME.service${NC}"
 echo -e "Please check ${GREEN}$PHO_COIN_NAME${NC} daemon is running with the following command: ${BBlue}systemctl status $PHO_COIN_NAME.service${NC}"
fi
if [ -f "/etc/systemd/system/$BBTC_COIN_NAME.service" ]; then
    repeat ;
 echo -e "$BBTC_COIN_NAME Node is up and running listening on port ${GREEN}$BBTC_COIN_PORT${NC}."
 echo -e "Configuration file is: ${RED}$BBTC_CONFIGFOLDER/$BBTC_CONFIG_FILE${NC}"
 echo -e "Start: ${RED}systemctl start $BBTC_COIN_NAME.service${NC}"
 echo -e "Stop: ${RED}systemctl stop $BBTC_COIN_NAME.service${NC}"
 echo -e "Please check ${GREEN}$BBTC_COIN_NAME${NC} daemon is running with the following command: ${BBlue}systemctl status $BBTC_COIN_NAME.service${NC}"
fi
if [ -f "/etc/systemd/system/$ELT_COIN_NAME.service" ]; then
    repeat ;
 echo -e "$ELT_COIN_NAME Node is up and running listening on port ${GREEN}$ELT_COIN_PORT${NC}."
 echo -e "Configuration file is: ${RED}$ELT_CONFIGFOLDER/$ELT_CONFIG_FILE${NC}"
 echo -e "Start: ${RED}systemctl start $ELT_COIN_NAME.service${NC}"
 echo -e "Stop: ${RED}systemctl stop $ELT_COIN_NAME.service${NC}"
 echo -e "Please check ${GREEN}$ELT_COIN_NAME${NC} daemon is running with the following command: ${BBlue}systemctl status $ELT_COIN_NAME.service${NC}"
fi
if [ -f "/etc/systemd/system/$UMO_COIN_NAME.service" ]; then
    repeat ;
 echo -e "$UMO_COIN_NAME Node is up and running listening on port ${GREEN}$UMO_COIN_PORT${NC}."
 echo -e "Configuration file is: ${RED}$UMO_CONFIGFOLDER/$UMO_CONFIG_FILE${NC}"
 echo -e "Start: ${RED}systemctl start $UMO_COIN_NAME.service${NC}"
 echo -e "Stop: ${RED}systemctl stop $UMO_COIN_NAME.service${NC}"
 echo -e "Please check ${GREEN}$UMO_COIN_NAME${NC} daemon is running with the following command: ${BBlue}systemctl status $UMO_COIN_NAME.service${NC}"
fi
if [ -f "/etc/systemd/system/$LIT_COIN_NAME.service" ]; then
    repeat ;
 echo -e "$LIT_COIN_NAME Node is up and running listening on port ${GREEN}$LIT_COIN_PORT${NC}."
 echo -e "Configuration file is: ${RED}$LIT_CONFIGFOLDER/$LIT_CONFIG_FILE${NC}"
 echo -e "Start: ${RED}systemctl start $LIT_COIN_NAME.service${NC}"
 echo -e "Stop: ${RED}systemctl stop $LIT_COIN_NAME.service${NC}"
 echo -e "Please check ${GREEN}$LIT_COIN_NAME${NC} daemon is running with the following command: ${BBlue}systemctl status $LIT_COIN_NAME.service${NC}"
fi
    repeat ;
}

function bootstrap_check() {
#script to check and remove bootstrap.dat.old
if [[ $BSTRP == "Y" ]] && [[ $BOOT == "Y" ]]; then
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
sleep 2
chmod u+x $USERDIR/bootstrap.sh
bootstrap_service ;
fi
}

bootstrap_service() {
if [ -f "/etc/systemd/system/bootstrap.service" ]; then
echo -e "Bootstrap Removal Service Already Running"
exit
else
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
fi

systemctl daemon-reload
sleep 4
systemctl start bootstrap.service
systemctl enable bootstrap.service >/dev/null 2>&1
}


function menu() {
  native
  menu_check
}

function wallet() {
  wallet_select
}

function native_setup() {
  depend_native
  blc_native
  pho_native
  bbtc_native
  elt_native
  umo_native
  lit_native
  important_information
  bootstrap_check
}


##### Main #####
clear
menu
wallet
native_setup
