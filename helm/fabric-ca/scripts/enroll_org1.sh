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

# Copy TLS Cert
mkdir -p /var/artifacts/crypto-config/Org1MSP/ca/crypto
cp /var/artifacts/crypto-config/Org1MSP/ca/server/ca-cert.pem /var/artifacts/crypto-config/Org1MSP/ca/crypto

# Register and Enroll
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/Org1MSP/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/Org1MSP/ca/admin
fabric-ca-client enroll -d -u https://rca-org1-admin:rca-org1-adminPW@0.0.0.0:5054
fabric-ca-client register -d --id.name peer0.org1.net --id.secret Tt4g3KLH --id.type peer -u https://0.0.0.0:5054
fabric-ca-client register -d --id.name peer1.org1.net --id.secret C2npBNcf --id.type peer -u https://0.0.0.0:5054
fabric-ca-client register -d --id.name admin-org1.net --id.secret admin-org1.netPW --id.type admin --id.attrs "hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:5054

# Copy Trusted Root Cert of org1 to peer0
mkdir -p /var/artifacts/crypto-config/Org1MSP/peer0.org1.net/assets/ca
cp /var/artifacts/crypto-config/Org1MSP/ca/admin/msp/cacerts/0-0-0-0-5054.pem /var/artifacts/crypto-config/Org1MSP/peer0.org1.net/assets/ca/org1-ca-cert.pem

# Enroll peer0
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/Org1MSP/peer0.org1.net/assets/ca/org1-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/Org1MSP/peer0.org1.net
fabric-ca-client enroll -d -u https://peer0.org1.net:Tt4g3KLH@0.0.0.0:5054

# Copy Trusted Root Cert of org1 to peer1
mkdir -p /var/artifacts/crypto-config/Org1MSP/peer1.org1.net/assets/ca
cp /var/artifacts/crypto-config/Org1MSP/ca/admin/msp/cacerts/0-0-0-0-5054.pem /var/artifacts/crypto-config/Org1MSP/peer1.org1.net/assets/ca/org1-ca-cert.pem

# Enroll peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/Org1MSP/peer1.org1.net/assets/ca/org1-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/Org1MSP/peer1.org1.net
fabric-ca-client enroll -d -u https://peer1.org1.net:C2npBNcf@0.0.0.0:5054

# Enroll org1's Admin
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/Org1MSP/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/Org1MSP/peer0.org1.net/assets/ca/org1-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin-org1.net:admin-org1.netPW@0.0.0.0:5054

# Copy admin cert to peer0
mkdir -p /var/artifacts/crypto-config/Org1MSP/peer0.org1.net/msp/admincerts
cp /var/artifacts/crypto-config/Org1MSP/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/Org1MSP/peer0.org1.net/msp/admincerts/org1-admin-cert.pem
# Copy admin cert to peer1
mkdir -p /var/artifacts/crypto-config/Org1MSP/peer1.org1.net/msp/admincerts
cp /var/artifacts/crypto-config/Org1MSP/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/Org1MSP/peer1.org1.net/msp/admincerts/org1-admin-cert.pem

# Rename admin key
mv /var/artifacts/crypto-config/Org1MSP/admin/msp/keystore/* /var/artifacts/crypto-config/Org1MSP/admin/msp/keystore/key.pem

print "enroll for org1" $?