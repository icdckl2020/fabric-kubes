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
mkdir -p /var/artifacts/crypto-config/Org0MSP/ca/crypto
cp /var/artifacts/crypto-config/Org0MSP/ca/server/ca-cert.pem /var/artifacts/crypto-config/Org0MSP/ca/crypto

# Enroll Orderer Org's CA Admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/Org0MSP/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/Org0MSP/ca/admin

fabric-ca-client enroll -d -u https://rca-org0-admin:rca-org0-adminPW@0.0.0.0:5053
fabric-ca-client register -d --id.name orderer0.org0.com --id.secret DPCxKv8m --id.type orderer -u https://0.0.0.0:5053
fabric-ca-client register -d --id.name orderer1.org0.com --id.secret PCzEE5x2 --id.type orderer -u https://0.0.0.0:5053
fabric-ca-client register -d --id.name orderer2.org0.com --id.secret T2ZNRe8x --id.type orderer -u https://0.0.0.0:5053
fabric-ca-client register -d --id.name orderer3.org0.com --id.secret 7B5qMkhg --id.type orderer -u https://0.0.0.0:5053
fabric-ca-client register -d --id.name orderer4.org0.com --id.secret p8Maufjr --id.type orderer -u https://0.0.0.0:5053
fabric-ca-client register -d --id.name admin-org0 --id.secret admin-org0PW --id.type admin --id.attrs "hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:5053

# Copy Trusted Root Cert of org0 orderer0
mkdir -p /var/artifacts/crypto-config/Org0MSP/orderer0.org0.com/assets/ca
cp /var/artifacts/crypto-config/Org0MSP/ca/admin/msp/cacerts/0-0-0-0-5053.pem /var/artifacts/crypto-config/Org0MSP/orderer0.org0.com/assets/ca/org0-ca-cert.pem
# Copy Trusted Root Cert of org0 orderer1
mkdir -p /var/artifacts/crypto-config/Org0MSP/orderer1.org0.com/assets/ca
cp /var/artifacts/crypto-config/Org0MSP/ca/admin/msp/cacerts/0-0-0-0-5053.pem /var/artifacts/crypto-config/Org0MSP/orderer1.org0.com/assets/ca/org0-ca-cert.pem
# Copy Trusted Root Cert of org0 orderer2
mkdir -p /var/artifacts/crypto-config/Org0MSP/orderer2.org0.com/assets/ca
cp /var/artifacts/crypto-config/Org0MSP/ca/admin/msp/cacerts/0-0-0-0-5053.pem /var/artifacts/crypto-config/Org0MSP/orderer2.org0.com/assets/ca/org0-ca-cert.pem
# Copy Trusted Root Cert of org0 orderer3
mkdir -p /var/artifacts/crypto-config/Org0MSP/orderer3.org0.com/assets/ca
cp /var/artifacts/crypto-config/Org0MSP/ca/admin/msp/cacerts/0-0-0-0-5053.pem /var/artifacts/crypto-config/Org0MSP/orderer3.org0.com/assets/ca/org0-ca-cert.pem
# Copy Trusted Root Cert of org0 orderer4
mkdir -p /var/artifacts/crypto-config/Org0MSP/orderer4.org0.com/assets/ca
cp /var/artifacts/crypto-config/Org0MSP/ca/admin/msp/cacerts/0-0-0-0-5053.pem /var/artifacts/crypto-config/Org0MSP/orderer4.org0.com/assets/ca/org0-ca-cert.pem

# Enroll orderer0
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/Org0MSP/orderer0.org0.com/assets/ca/org0-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/Org0MSP/orderer0.org0.com
fabric-ca-client enroll -d -u https://orderer0.org0.com:DPCxKv8m@0.0.0.0:5053
# Enroll orderer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/Org0MSP/orderer1.org0.com/assets/ca/org0-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/Org0MSP/orderer1.org0.com
fabric-ca-client enroll -d -u https://orderer1.org0.com:PCzEE5x2@0.0.0.0:5053
# Enroll orderer2
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/Org0MSP/orderer2.org0.com/assets/ca/org0-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/Org0MSP/orderer2.org0.com
fabric-ca-client enroll -d -u https://orderer2.org0.com:T2ZNRe8x@0.0.0.0:5053
# Enroll orderer3
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/Org0MSP/orderer3.org0.com/assets/ca/org0-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/Org0MSP/orderer3.org0.com
fabric-ca-client enroll -d -u https://orderer3.org0.com:7B5qMkhg@0.0.0.0:5053
# Enroll orderer4
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/Org0MSP/orderer4.org0.com/assets/ca/org0-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/Org0MSP/orderer4.org0.com
fabric-ca-client enroll -d -u https://orderer4.org0.com:p8Maufjr@0.0.0.0:5053

# Enroll Org0's Admin
export FABRIC_CA_CLIENT_HOME=/var/artifacts/crypto-config/Org0MSP/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/var/artifacts/crypto-config/Org0MSP/orderer0.org0.com/assets/ca/org0-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin-org0:admin-org0PW@0.0.0.0:5053

# Copy admin cert to the org0 orderer0
mkdir -p /var/artifacts/crypto-config/Org0MSP/orderer0.org0.com/msp/admincerts
cp /var/artifacts/crypto-config/Org0MSP/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/Org0MSP/orderer0.org0.com/msp/admincerts/org0-admin-cert.pem

# Copy admin cert to the org0 orderer1
mkdir -p /var/artifacts/crypto-config/Org0MSP/orderer1.org0.com/msp/admincerts
cp /var/artifacts/crypto-config/Org0MSP/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/Org0MSP/orderer1.org0.com/msp/admincerts/org0-admin-cert.pem

# Copy admin cert to the org0 orderer2
mkdir -p /var/artifacts/crypto-config/Org0MSP/orderer2.org0.com/msp/admincerts
cp /var/artifacts/crypto-config/Org0MSP/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/Org0MSP/orderer2.org0.com/msp/admincerts/org0-admin-cert.pem

# Copy admin cert to the org0 orderer3
mkdir -p /var/artifacts/crypto-config/Org0MSP/orderer3.org0.com/msp/admincerts
cp /var/artifacts/crypto-config/Org0MSP/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/Org0MSP/orderer3.org0.com/msp/admincerts/org0-admin-cert.pem

# Copy admin cert to the org0 orderer4
mkdir -p /var/artifacts/crypto-config/Org0MSP/orderer4.org0.com/msp/admincerts
cp /var/artifacts/crypto-config/Org0MSP/admin/msp/signcerts/cert.pem /var/artifacts/crypto-config/Org0MSP/orderer4.org0.com/msp/admincerts/org0-admin-cert.pem

print "enroll for org0" $?