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
subject "Create Genesis Block..."
#

# org0
mkdir -p /var/artifacts/crypto-config/Org0MSP/msp/admincerts
mkdir -p /var/artifacts/crypto-config/Org0MSP/msp/cacerts
mkdir -p /var/artifacts/crypto-config/Org0MSP/msp/tlscacerts
mkdir -p /var/artifacts/crypto-config/Org0MSP/msp/users

cp /var/artifacts/crypto-config/Org0MSP/orderer0.org0.com/msp/admincerts/org0-admin-cert.pem /var/artifacts/crypto-config/Org0MSP/msp/admincerts
cp /var/artifacts/crypto-config/Org0MSP/orderer0.org0.com/assets/ca/org0-ca-cert.pem /var/artifacts/crypto-config/Org0MSP/msp/cacerts
cp /var/artifacts/crypto-config/Org0MSP/orderer0.org0.com/assets/tls-ca/tls-ca-cert.pem /var/artifacts/crypto-config/Org0MSP/msp/tlscacerts

print "preparing certs for org0" $?

# org1
mkdir -p /var/artifacts/crypto-config/Org1MSP/msp/admincerts
mkdir -p /var/artifacts/crypto-config/Org1MSP/msp/cacerts
mkdir -p /var/artifacts/crypto-config/Org1MSP/msp/tlscacerts
mkdir -p /var/artifacts/crypto-config/Org1MSP/msp/users

cp /var/artifacts/crypto-config/Org1MSP/peer0.org1.net/msp/admincerts/org1-admin-cert.pem /var/artifacts/crypto-config/Org1MSP/msp/admincerts
cp /var/artifacts/crypto-config/Org1MSP/peer0.org1.net/assets/ca/org1-ca-cert.pem /var/artifacts/crypto-config/Org1MSP/msp/cacerts
cp /var/artifacts/crypto-config/Org1MSP/peer0.org1.net/assets/tls-ca/tls-ca-cert.pem /var/artifacts/crypto-config/Org1MSP/msp/tlscacerts

print "preparing certs for org1" $?

# org2
mkdir -p /var/artifacts/crypto-config/Org2MSP/msp/admincerts
mkdir -p /var/artifacts/crypto-config/Org2MSP/msp/cacerts
mkdir -p /var/artifacts/crypto-config/Org2MSP/msp/tlscacerts
mkdir -p /var/artifacts/crypto-config/Org2MSP/msp/users

cp /var/artifacts/crypto-config/Org2MSP/peer0.org2.net/msp/admincerts/org2-admin-cert.pem /var/artifacts/crypto-config/Org2MSP/msp/admincerts
cp /var/artifacts/crypto-config/Org2MSP/peer0.org2.net/assets/ca/org2-ca-cert.pem /var/artifacts/crypto-config/Org2MSP/msp/cacerts
cp /var/artifacts/crypto-config/Org2MSP/peer0.org2.net/assets/tls-ca/tls-ca-cert.pem /var/artifacts/crypto-config/Org2MSP/msp/tlscacerts

print "preparing certs for org2" $?

# org3
mkdir -p /var/artifacts/crypto-config/Org3MSP/msp/admincerts
mkdir -p /var/artifacts/crypto-config/Org3MSP/msp/cacerts
mkdir -p /var/artifacts/crypto-config/Org3MSP/msp/tlscacerts
mkdir -p /var/artifacts/crypto-config/Org3MSP/msp/users

cp /var/artifacts/crypto-config/Org3MSP/peer0.org3.net/msp/admincerts/org3-admin-cert.pem /var/artifacts/crypto-config/Org3MSP/msp/admincerts
cp /var/artifacts/crypto-config/Org3MSP/peer0.org3.net/assets/ca/org3-ca-cert.pem /var/artifacts/crypto-config/Org3MSP/msp/cacerts
cp /var/artifacts/crypto-config/Org3MSP/peer0.org3.net/assets/tls-ca/tls-ca-cert.pem /var/artifacts/crypto-config/Org3MSP/msp/tlscacerts

print "preparing certs for org3" $?

configtxgen -profile OrgsOrdererGenesis -outputBlock genesis.block -channelID ordererchannel

print "preparing genesis.block" $?

configtxgen -profile OrgsChannel -outputCreateChannelTx channel.tx -channelID loanapp

print "preparing channel.tx" $?

cp genesis.block /var/artifacts/crypto-config/Org0MSP/orderer0.org0.com
cp genesis.block /var/artifacts/crypto-config/Org0MSP/orderer1.org0.com
cp genesis.block /var/artifacts/crypto-config/Org0MSP/orderer2.org0.com
cp genesis.block /var/artifacts/crypto-config/Org0MSP/orderer3.org0.com
cp genesis.block /var/artifacts/crypto-config/Org0MSP/orderer4.org0.com
cp channel.tx /var/artifacts/crypto-config/Org1MSP/peer0.org1.net/assets

print "creating genesis block" $?