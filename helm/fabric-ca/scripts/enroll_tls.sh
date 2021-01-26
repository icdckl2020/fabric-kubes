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

# Enroll tls-ca-org0's Admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/Org0MSP/tls/server/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/Org0MSP/tls/admin

fabric-ca-client enroll -d -u https://tls-ca-admin:tls-ca-adminPW@0.0.0.0:5052
fabric-ca-client register -d --id.name peer0.org1.net --id.secret 9d8vdCdk --id.type peer -u https://0.0.0.0:5052
fabric-ca-client register -d --id.name peer1.org1.net --id.secret Trxg68PA --id.type peer -u https://0.0.0.0:5052
fabric-ca-client register -d --id.name peer0.org2.net --id.secret zkZDG96L --id.type peer -u https://0.0.0.0:5052
fabric-ca-client register -d --id.name peer1.org2.net --id.secret 4KnyJmwB --id.type peer -u https://0.0.0.0:5052
fabric-ca-client register -d --id.name peer0.org3.net --id.secret zkZDG96L --id.type peer -u https://0.0.0.0:5052
fabric-ca-client register -d --id.name peer1.org3.net --id.secret 4KnyJmwB --id.type peer -u https://0.0.0.0:5052
fabric-ca-client register -d --id.name orderer0.org0.com --id.secret PCzEE5x2 --id.type orderer -u https://0.0.0.0:5052
fabric-ca-client register -d --id.name orderer1.org0.com --id.secret E9Rd54w2 --id.type orderer -u https://0.0.0.0:5052
fabric-ca-client register -d --id.name orderer2.org0.com --id.secret x4Y95QFC --id.type orderer -u https://0.0.0.0:5052
fabric-ca-client register -d --id.name orderer3.org0.com --id.secret gf4ZKPSU --id.type orderer -u https://0.0.0.0:5052
fabric-ca-client register -d --id.name orderer4.org0.com --id.secret NhZM2pLZ --id.type orderer -u https://0.0.0.0:5052

#############
# org1 peer0#
#############

# Copy certificate of the TLS CA for org1 peer0
mkdir -p /var/artifacts/crypto-config/Org1MSP/peer0.org1.net/assets/tls-ca
cp /var/artifacts/crypto-config/Org0MSP/tls/admin/msp/cacerts/0-0-0-0-5052.pem /var/artifacts/crypto-config/Org1MSP/peer0.org1.net/assets/tls-ca/tls-ca-cert.pem

# Enroll org1 peer0
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/Org1MSP/peer0.org1.net
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/Org1MSP/peer0.org1.net/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer0.org1.net:9d8vdCdk@0.0.0.0:5052 --enrollment.profile tls --csr.hosts peer0-org1,127.0.0.1

mv /var/artifacts/crypto-config/Org1MSP/peer0.org1.net/tls-msp/keystore/* /var/artifacts/crypto-config/Org1MSP/peer0.org1.net/tls-msp/keystore/key.pem

#############
# org1 peer1#
#############

# Copy certificate of the TLS CA for org1 peer1
mkdir -p /var/artifacts/crypto-config/Org1MSP/peer1.org1.net/assets/tls-ca
cp /var/artifacts/crypto-config/Org0MSP/tls/admin/msp/cacerts/0-0-0-0-5052.pem /var/artifacts/crypto-config/Org1MSP/peer1.org1.net/assets/tls-ca/tls-ca-cert.pem

# Enroll org1 peer1
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/Org1MSP/peer1.org1.net
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/Org1MSP/peer1.org1.net/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer1.org1.net:Trxg68PA@0.0.0.0:5052 --enrollment.profile tls --csr.hosts peer1-org1,127.0.0.1

mv /var/artifacts/crypto-config/Org1MSP/peer1.org1.net/tls-msp/keystore/* /var/artifacts/crypto-config/Org1MSP/peer1.org1.net/tls-msp/keystore/key.pem

#############
# org2 peer0#
#############

# Copy certificate of the TLS CA for org2 peer0
mkdir -p /var/artifacts/crypto-config/Org2MSP/peer0.org2.net/assets/tls-ca
cp /var/artifacts/crypto-config/Org0MSP/tls/admin/msp/cacerts/0-0-0-0-5052.pem /var/artifacts/crypto-config/Org2MSP/peer0.org2.net/assets/tls-ca/tls-ca-cert.pem

# Enroll org2 peer0
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/Org2MSP/peer0.org2.net
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/Org2MSP/peer0.org2.net/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer0.org2.net:zkZDG96L@0.0.0.0:5052 --enrollment.profile tls --csr.hosts peer0-org2,127.0.0.1

mv /var/artifacts/crypto-config/Org2MSP/peer0.org2.net/tls-msp/keystore/* /var/artifacts/crypto-config/Org2MSP/peer0.org2.net/tls-msp/keystore/key.pem

#############
# org2 peer1#
#############

# Copy certificate of the TLS CA for org2 peer1
mkdir -p /var/artifacts/crypto-config/Org2MSP/peer1.org2.net/assets/tls-ca
cp /var/artifacts/crypto-config/Org0MSP/tls/admin/msp/cacerts/0-0-0-0-5052.pem /var/artifacts/crypto-config/Org2MSP/peer1.org2.net/assets/tls-ca/tls-ca-cert.pem

# Enroll org2 peer1
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/Org2MSP/peer1.org2.net
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/Org2MSP/peer1.org2.net/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer1.org2.net:4KnyJmwB@0.0.0.0:5052 --enrollment.profile tls --csr.hosts peer1-org2,127.0.0.1

mv /var/artifacts/crypto-config/Org2MSP/peer1.org2.net/tls-msp/keystore/* /var/artifacts/crypto-config/Org2MSP/peer1.org2.net/tls-msp/keystore/key.pem

#############
# org3 peer0#
#############

# Copy certificate of the TLS CA for org3 peer0
mkdir -p /var/artifacts/crypto-config/Org3MSP/peer0.org3.net/assets/tls-ca
cp /var/artifacts/crypto-config/Org0MSP/tls/admin/msp/cacerts/0-0-0-0-5052.pem /var/artifacts/crypto-config/Org3MSP/peer0.org3.net/assets/tls-ca/tls-ca-cert.pem

# Enroll org3 peer0
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/Org3MSP/peer0.org3.net
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/Org3MSP/peer0.org3.net/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer0.org3.net:zkZDG96L@0.0.0.0:5052 --enrollment.profile tls --csr.hosts peer0-org3,127.0.0.1

mv /var/artifacts/crypto-config/Org3MSP/peer0.org3.net/tls-msp/keystore/* /var/artifacts/crypto-config/Org3MSP/peer0.org3.net/tls-msp/keystore/key.pem

#############
# org3 peer1#
#############

# Copy certificate of the TLS CA for org3 peer1
mkdir -p /var/artifacts/crypto-config/Org3MSP/peer1.org3.net/assets/tls-ca
cp /var/artifacts/crypto-config/Org0MSP/tls/admin/msp/cacerts/0-0-0-0-5052.pem /var/artifacts/crypto-config/Org3MSP/peer1.org3.net/assets/tls-ca/tls-ca-cert.pem

# Enroll org3 peer1
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/Org3MSP/peer1.org3.net
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/Org3MSP/peer1.org3.net/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer1.org3.net:4KnyJmwB@0.0.0.0:5052 --enrollment.profile tls --csr.hosts peer1-org3,127.0.0.1

mv /var/artifacts/crypto-config/Org3MSP/peer1.org3.net/tls-msp/keystore/* /var/artifacts/crypto-config/Org3MSP/peer1.org3.net/tls-msp/keystore/key.pem


###########
# Orderer #
###########

# Copy certificate of tls-ca-org0 for org0 orderer0
mkdir -p /var/artifacts/crypto-config/Org0MSP/orderer0.org0.com/assets/tls-ca
cp /var/artifacts/crypto-config/Org0MSP/tls/admin/msp/cacerts/0-0-0-0-5052.pem /var/artifacts/crypto-config/Org0MSP/orderer0.org0.com/assets/tls-ca/tls-ca-cert.pem

# Enroll for org0 orderer0
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/Org0MSP/orderer0.org0.com
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/Org0MSP/orderer0.org0.com/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer0.org0.com:PCzEE5x2@0.0.0.0:5052 --enrollment.profile tls --csr.hosts orderer0-org0,127.0.0.1

mv /var/artifacts/crypto-config/Org0MSP/orderer0.org0.com/tls-msp/keystore/* /var/artifacts/crypto-config/Org0MSP/orderer0.org0.com/tls-msp/keystore/key.pem

# Copy certificate of tls-ca-org0 for org0 orderer1
mkdir -p /var/artifacts/crypto-config/Org0MSP/orderer1.org0.com/assets/tls-ca
cp /var/artifacts/crypto-config/Org0MSP/tls/admin/msp/cacerts/0-0-0-0-5052.pem /var/artifacts/crypto-config/Org0MSP/orderer1.org0.com/assets/tls-ca/tls-ca-cert.pem

# Enroll for org0 orderer1
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/Org0MSP/orderer1.org0.com
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/Org0MSP/orderer1.org0.com/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer1.org0.com:E9Rd54w2@0.0.0.0:5052 --enrollment.profile tls --csr.hosts orderer1-org0,127.0.0.1

mv /var/artifacts/crypto-config/Org0MSP/orderer1.org0.com/tls-msp/keystore/* /var/artifacts/crypto-config/Org0MSP/orderer1.org0.com/tls-msp/keystore/key.pem

# Copy certificate of tls-ca-org0 for org0 orderer2
mkdir -p /var/artifacts/crypto-config/Org0MSP/orderer2.org0.com/assets/tls-ca
cp /var/artifacts/crypto-config/Org0MSP/tls/admin/msp/cacerts/0-0-0-0-5052.pem /var/artifacts/crypto-config/Org0MSP/orderer2.org0.com/assets/tls-ca/tls-ca-cert.pem

# Enroll for org0 orderer2
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/Org0MSP/orderer2.org0.com
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/Org0MSP/orderer2.org0.com/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer2.org0.com:x4Y95QFC@0.0.0.0:5052 --enrollment.profile tls --csr.hosts orderer2-org0,127.0.0.1

mv /var/artifacts/crypto-config/Org0MSP/orderer2.org0.com/tls-msp/keystore/* /var/artifacts/crypto-config/Org0MSP/orderer2.org0.com/tls-msp/keystore/key.pem

# Copy certificate of tls-ca-org0 for org0 orderer3
mkdir -p /var/artifacts/crypto-config/Org0MSP/orderer3.org0.com/assets/tls-ca
cp /var/artifacts/crypto-config/Org0MSP/tls/admin/msp/cacerts/0-0-0-0-5052.pem /var/artifacts/crypto-config/Org0MSP/orderer3.org0.com/assets/tls-ca/tls-ca-cert.pem

# Enroll for org0 orderer3
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/Org0MSP/orderer3.org0.com
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/Org0MSP/orderer3.org0.com/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer3.org0.com:gf4ZKPSU@0.0.0.0:5052 --enrollment.profile tls --csr.hosts orderer3-org0,127.0.0.1

mv /var/artifacts/crypto-config/Org0MSP/orderer3.org0.com/tls-msp/keystore/* /var/artifacts/crypto-config/Org0MSP/orderer3.org0.com/tls-msp/keystore/key.pem

# Copy certificate of tls-ca-org0 for org0 orderer4
mkdir -p /var/artifacts/crypto-config/Org0MSP/orderer4.org0.com/assets/tls-ca
cp /var/artifacts/crypto-config/Org0MSP/tls/admin/msp/cacerts/0-0-0-0-5052.pem /var/artifacts/crypto-config/Org0MSP/orderer4.org0.com/assets/tls-ca/tls-ca-cert.pem

# Enroll for org0 orderer4
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/Org0MSP/orderer4.org0.com
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/Org0MSP/orderer4.org0.com/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer4.org0.com:NhZM2pLZ@0.0.0.0:5052 --enrollment.profile tls --csr.hosts orderer4-org0,127.0.0.1

mv /var/artifacts/crypto-config/Org0MSP/orderer4.org0.com/tls-msp/keystore/* /var/artifacts/crypto-config/Org0MSP/orderer4.org0.com/tls-msp/keystore/key.pem

print "enroll TLS Certs" $?