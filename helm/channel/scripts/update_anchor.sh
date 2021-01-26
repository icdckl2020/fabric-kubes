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
subject "Update Anchor Peer..."
#

export FABRIC_CFG_PATH=/config
configtxgen -profile OrgsChannel -outputAnchorPeersUpdate /var/artifacts/crypto-config/Org1MSP/peer0.org1.net/assets/org1Anchors.tx -channelID loanapp -asOrg org1

print "preparing org1Anchors.tx" $?

export FABRIC_CFG_PATH=/etc/hyperledger/fabric
export CORE_PEER_ADDRESS=peer0-org1:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_MSPCONFIGPATH=/var/artifacts/crypto-config/Org1MSP/admin/msp
peer channel update -c loanapp -f /var/artifacts/crypto-config/Org1MSP/peer0.org1.net/assets/org1Anchors.tx \
    -o orderer0-org0:7050 \
    --tls --cafile /var/artifacts/crypto-config/Org1MSP/peer0.org1.net/tls-msp/tlscacerts/tls-0-0-0-0-5052.pem

print "update anchor peer for org1" $?

export FABRIC_CFG_PATH=/config
configtxgen -profile OrgsChannel -outputAnchorPeersUpdate /var/artifacts/crypto-config/Org2MSP/peer0.org2.net/assets/org2Anchors.tx -channelID loanapp -asOrg org2

print "preparing org2Anchors.tx" $?

export FABRIC_CFG_PATH=/etc/hyperledger/fabric
export CORE_PEER_ADDRESS=peer0-org2:7251
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_PEER_MSPCONFIGPATH=/var/artifacts/crypto-config/Org2MSP/admin/msp
peer channel update -c loanapp -f /var/artifacts/crypto-config/Org2MSP/peer0.org2.net/assets/org2Anchors.tx \
    -o orderer0-org0:7050 \
    --tls --cafile /var/artifacts/crypto-config/Org2MSP/peer0.org2.net/tls-msp/tlscacerts/tls-0-0-0-0-5052.pem

print "update anchor peer for org2" $?

export FABRIC_CFG_PATH=/config
configtxgen -profile OrgsChannel -outputAnchorPeersUpdate /var/artifacts/crypto-config/Org3MSP/peer0.org3.net/assets/org3Anchors.tx -channelID loanapp -asOrg org3

print "preparing org3Anchors.tx" $?

export FABRIC_CFG_PATH=/etc/hyperledger/fabric
export CORE_PEER_ADDRESS=peer0-org3:7451
export CORE_PEER_LOCALMSPID=Org3MSP
export CORE_PEER_MSPCONFIGPATH=/var/artifacts/crypto-config/Org3MSP/admin/msp
peer channel update -c loanapp -f /var/artifacts/crypto-config/Org3MSP/peer0.org3.net/assets/org3Anchors.tx \
    -o orderer0-org0:7050 \
    --tls --cafile /var/artifacts/crypto-config/Org3MSP/peer0.org3.net/tls-msp/tlscacerts/tls-0-0-0-0-5052.pem

print "update anchor peer for org3" $?
