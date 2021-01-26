##############
# Environments
##############

export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export NC='\033[0m'

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

#############################
#
subject "Start CA Servers..."
#

helm install s1 helm/fabric-ca
print "helm install s1 helm/fabric-ca" $?

#############################
#
subject "Generate Certs..."
#

helm install s2 helm/cryptogen
kubectl wait --for=condition=complete --timeout=600s job/cryptogen
print "kubectl wait --for=condition=complete --timeout=600s job/cryptogen" $?

#############################
#
subject "Start Peer Nodes..."
#
helm install s3 helm/peers
print "helm install s3 helm/peers" $?

#############################

#
subject "Create Genesis Block..."
#
helm install s4 helm/genesis
kubectl wait --for=condition=complete --timeout=600s job/create-genesis
print "kubectl wait --for=condition=complete --timeout=600s job/create-genesis" $?

#############################
#
subject "Start Orderers..."
#
helm install s5 helm/orderers
print "helm install s3 helm/orderers" $?

#############################

#
subject "Join channels..."
#
helm install s6 helm/channel
kubectl wait --for=condition=complete --timeout=600s job/join-channel
print "kubectl wait --for=condition=complete --timeout=600s job/join-channel" $?

#############################

subject "Fabric network started!"