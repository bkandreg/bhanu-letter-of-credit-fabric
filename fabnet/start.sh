#!/bin/bash
#
# SPDX-License-Identifier: Apache-2.0
#
# Exit on first error, print all commands.
set -ev

docker-compose -f docker-compose-cli.yaml down

docker-compose -f docker-compose-cli.yaml up -d

# wait for Hyperledger Fabric to start
# incase of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
export FABRIC_START_TIMEOUT=10 
#echo ${FABRIC_START_TIMEOUT}
sleep ${FABRIC_START_TIMEOUT} 

export CHANNEL_NAME=fabnet-channel

# Create the channel
docker exec \
 cli \
 peer channel create \
  -o orderer.fabnet.com:7050 \
  -c fabnet-channel \
  -f ./channel-artifacts/channel.tx \
  --tls \
  --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fabnet.com/orderers/orderer.fabnet.com/msp/tlscacerts/tlsca.fabnet.com-cert.pem 

# Join the channel
docker exec \
 cli \
 peer channel join \
  -b fabnet-channel.block 

#   docker exec \
#  -e CORE_PEER_COMMITTER_LEDGER_ORDERER=orderer.fabnet.com:7050 \
#  -e CORE_PEER_ADDRESS=peer0.manufacturer.fabnet.com:7051 \
#  cli \
#  peer channel join \
#   -b fabnet-channel.block 

# Update the channel
docker exec \
 cli \
 peer channel update \
  -o orderer.fabnet.com:7050 \
  -c $CHANNEL_NAME \
  -f ./channel-artifacts/ManufacturerMSPanchors.tx \
  --tls \
  --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fabnet.com/orderers/orderer.fabnet.com/msp/tlscacerts/tlsca.fabnet.com-cert.pem 
