##############
# Environments
##############

export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export NC='\033[0m'

export COMPOSE_PROJECT_NAME=dev-net
export IMAGE_TAG=2.3.0
export CA_IMAGE_TAG=1.4.9
export CONFIG_DIR=config

##############
# Functions
##############

print() {
  MESSAGE=$1
  CODE=$2

  if [ $2 -ne 0 ] ; then
    printf "${RED}[`date +"%Y-%m-%d %H:%M:%S"`] ${MESSAGE} failed${NC}\n"
    exit -1
  fi
  printf "${GREEN}[`date +"%Y-%m-%d %H:%M:%S"`] Complete ${MESSAGE}${NC}\n\n"
  sleep 1
}

subject() {
    printf "${YELLOW}"
    echo ''
    echo '####'
    echo '#### ' $1
    echo '####'
    echo ''
    printf "${NC}"
}

##############
#
subject "Join channels..."
#

# Prepare admin certs
mkdir -p /var/artifacts/crypto-config/Org1MSP/admin/msp/admincerts
cp /var/artifacts/crypto-config/Org1MSP/peer0.org1.net/msp/admincerts/org1-admin-cert.pem /var/artifacts/crypto-config/Org1MSP/admin/msp/admincerts
mkdir -p /var/artifacts/crypto-config/Org2MSP/admin/msp/admincerts
cp /var/artifacts/crypto-config/Org2MSP/peer0.org2.net/msp/admincerts/org2-admin-cert.pem /var/artifacts/crypto-config/Org2MSP/admin/msp/admincerts
mkdir -p /var/artifacts/crypto-config/Org3MSP/admin/msp/admincerts
cp /var/artifacts/crypto-config/Org3MSP/peer0.org3.net/msp/admincerts/org3-admin-cert.pem /var/artifacts/crypto-config/Org3MSP/admin/msp/admincerts

export CORE_PEER_ADDRESS=peer0-org1:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/var/artifacts/crypto-config/Org1MSP/peer0.org1.net/tls-msp/tlscacerts/tls-0-0-0-0-5052.pem
export CORE_PEER_MSPCONFIGPATH=/var/artifacts/crypto-config/Org1MSP/admin/msp
peer channel create -c loanapp -f /var/artifacts/crypto-config/Org1MSP/peer0.org1.net/assets/channel.tx -o orderer0-org0:7050 \
  --outputBlock loanapp.block \
  --tls --cafile /var/artifacts/crypto-config/Org1MSP/peer0.org1.net/tls-msp/tlscacerts/tls-0-0-0-0-5052.pem

print "peer channel create" $?

# org1 peer0 join channel
cp loanapp.block /var/artifacts/crypto-config/Org1MSP/peer0.org1.net/assets
export CORE_PEER_ADDRESS=peer0-org1:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/var/artifacts/crypto-config/Org1MSP/peer0.org1.net/tls-msp/tlscacerts/tls-0-0-0-0-5052.pem
export CORE_PEER_MSPCONFIGPATH=/var/artifacts/crypto-config/Org1MSP/admin/msp
peer channel join -b /var/artifacts/crypto-config/Org1MSP/peer0.org1.net/assets/loanapp.block

print "join channel for org1 peer0" $?

peer channel list
peer channel getinfo -c loanapp

# org1 peer1 join channel
cp loanapp.block /var/artifacts/crypto-config/Org1MSP/peer1.org1.net/assets
export CORE_PEER_ADDRESS=peer1-org1:7151
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/var/artifacts/crypto-config/Org1MSP/peer1.org1.net/tls-msp/tlscacerts/tls-0-0-0-0-5052.pem
export CORE_PEER_MSPCONFIGPATH=/var/artifacts/crypto-config/Org1MSP/admin/msp
peer channel join -b /var/artifacts/crypto-config/Org1MSP/peer1.org1.net/assets/loanapp.block

print "join channel for org1 peer1" $?

peer channel list
peer channel getinfo -c loanapp

# org2 peer0 join channel
cp loanapp.block /var/artifacts/crypto-config/Org2MSP/peer0.org2.net/assets
export CORE_PEER_ADDRESS=peer0-org2:7251
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/var/artifacts/crypto-config/Org2MSP/peer0.org2.net/tls-msp/tlscacerts/tls-0-0-0-0-5052.pem
export CORE_PEER_MSPCONFIGPATH=/var/artifacts/crypto-config/Org2MSP/admin/msp
peer channel join -b /var/artifacts/crypto-config/Org2MSP/peer0.org2.net/assets/loanapp.block

print "join channel for org2 peer0" $?

peer channel list
peer channel getinfo -c loanapp

# org2 peer1 join channel
cp loanapp.block /var/artifacts/crypto-config/Org2MSP/peer1.org2.net/assets
export CORE_PEER_ADDRESS=peer1-org2:7351
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/var/artifacts/crypto-config/Org2MSP/peer1.org2.net/tls-msp/tlscacerts/tls-0-0-0-0-5052.pem
export CORE_PEER_MSPCONFIGPATH=/var/artifacts/crypto-config/Org2MSP/admin/msp
peer channel join -b /var/artifacts/crypto-config/Org2MSP/peer1.org2.net/assets/loanapp.block

print "join channel for org2 peer1" $?

peer channel list
peer channel getinfo -c loanapp

# org3 peer0 join channel
cp loanapp.block /var/artifacts/crypto-config/Org3MSP/peer0.org3.net/assets
export CORE_PEER_ADDRESS=peer0-org3:7451
export CORE_PEER_LOCALMSPID=Org3MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/var/artifacts/crypto-config/Org3MSP/peer0.org3.net/tls-msp/tlscacerts/tls-0-0-0-0-5052.pem
export CORE_PEER_MSPCONFIGPATH=/var/artifacts/crypto-config/Org3MSP/admin/msp
peer channel join -b /var/artifacts/crypto-config/Org3MSP/peer0.org3.net/assets/loanapp.block

print "join channel for org3 peer0" $?

peer channel list
peer channel getinfo -c loanapp

# org3 peer1 join channel
cp loanapp.block /var/artifacts/crypto-config/Org3MSP/peer1.org3.net/assets
export CORE_PEER_ADDRESS=peer1-org3:7551
export CORE_PEER_LOCALMSPID=Org3MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/var/artifacts/crypto-config/Org3MSP/peer1.org3.net/tls-msp/tlscacerts/tls-0-0-0-0-5052.pem
export CORE_PEER_MSPCONFIGPATH=/var/artifacts/crypto-config/Org3MSP/admin/msp
peer channel join -b /var/artifacts/crypto-config/Org3MSP/peer1.org3.net/assets/loanapp.block

print "join channel for org3 peer1" $?

peer channel list
peer channel getinfo -c loanapp