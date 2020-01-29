#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
# Exit on first error
set -e

# launch network; create channel and join peer to channel
cd ../fabnet
echo y | ./start.sh
 

set -x

echo "Installing chaincode.."
docker exec \
 -e "CORE_PEER_LOCALMSPID=ManufacturerMSP" \
 -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/manufacturer.fabnet.com/users/Admin@manufacturer.fabnet.com/msp" \
 cli \
 peer chaincode install \
  -n "mycc" \
  -l "node" \
  -v "1.0" \
  -p "/opt/gopath/src/github.com/chaincode/newcc" \
  --tls \
  --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fabnet.com/orderers/orderer.fabnet.com/msp/tlscacerts/tlsca.fabnet.com-cert.pem
echo "Installing of chaincode is done"

echo "Instantiating chaincode.."
docker exec \
 -e "CORE_PEER_LOCALMSPID=ManufacturerMSP" \
 -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/manufacturer.fabnet.com/users/Admin@manufacturer.fabnet.com/msp" \
 cli \
 peer chaincode instantiate \
  -o orderer.fabnet.com:7050 \
  -C fabnet-channel \
  -n mycc \
  -l "node" \
  -v 1.0 \
  -c '{"Args":[]}' \
  --tls \
  --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fabnet.com/orderers/orderer.fabnet.com/msp/tlscacerts/tlsca.fabnet.com-cert.pem
echo "Instantiating of chaincode is done"

echo "Waiting for instantiation request to be committed ..."
sleep 10

echo "Adding Employee Details.."
docker exec \
 -e "CORE_PEER_LOCALMSPID=ManufacturerMSP" \
 -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/manufacturer.fabnet.com/users/Admin@manufacturer.fabnet.com/msp" \
 cli \
 peer chaincode invoke \
  -o orderer.fabnet.com:7050 \
  -C fabnet-channel \
  -n mycc \
  -c '{"function":"addEmpDetails","Args":["4205","varshini","miracleHeights","InnovationLabs"]}' \
  --tls \
  --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fabnet.com/orderers/orderer.fabnet.com/msp/tlscacerts/tlsca.fabnet.com-cert.pem
echo "Successfully added Employee Details"

echo "Waiting for adding details request to be committed ..."
sleep 10

echo "Querying... 4205 Details"
docker exec \
 -e "CORE_PEER_LOCALMSPID=ManufacturerMSP" \
 -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/manufacturer.fabnet.com/users/Admin@manufacturer.fabnet.com/msp" \
 cli \
 peer chaincode invoke \
  -o orderer.fabnet.com:7050 \
  -C fabnet-channel \
  -n mycc \
  -c '{"function":"queryEmpDetails","Args":["4205"]}' \
  --tls \
  --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fabnet.com/orderers/orderer.fabnet.com/msp/tlscacerts/tlsca.fabnet.com-cert.pem
echo "Querying of 4205 Details is done"

echo "Waiting for quering details request to be committed ..."
sleep 10

echo "deleting 4205 Details..."
docker exec \
-e "CORE_PEER_LOCALMSPID=ManufacturerMSP" \
-e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/manufacturer.fabnet.com/users/Admin@manufacturer.fabnet.com/msp" \
cli \
peer chaincode invoke \
 -o orderer.fabnet.com:7050 \
 -C fabnet-channel \
 -n mycc \
 -c '{"function":"deleteEmpDetails","Args":["4205"]}' \
 --tls \
 --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fabnet.com/orderers/orderer.fabnet.com/msp/tlscacerts/tlsca.fabnet.com-cert.pem
echo "Successfully deleted 4205 Details"

echo "Waiting for deleting details request to be committed ..."
sleep 10

echo "Adding Employee Details.."
docker exec \
 -e "CORE_PEER_LOCALMSPID=ManufacturerMSP" \
 -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/manufacturer.fabnet.com/users/Admin@manufacturer.fabnet.com/msp" \
 cli \
 peer chaincode invoke \
  -o orderer.fabnet.com:7050 \
  -C fabnet-channel \
  -n mycc \
  -c '{"function":"addEmpDetails","Args":["4206","chandana","miracleCity","InnovationLabs"]}' \
  --tls \
  --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fabnet.com/orderers/orderer.fabnet.com/msp/tlscacerts/tlsca.fabnet.com-cert.pem
echo "Successfully added Employee Details"

echo "Waiting for adding details request to be committed ..."
sleep 10

echo "Querying... 4206 Details"
docker exec \
 -e "CORE_PEER_LOCALMSPID=ManufacturerMSP" \
 -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/manufacturer.fabnet.com/users/Admin@manufacturer.fabnet.com/msp" \
 cli \
 peer chaincode invoke \
  -o orderer.fabnet.com:7050 \
  -C fabnet-channel \
  -n mycc \
  -c '{"function":"queryEmpDetails","Args":["4206"]}' \
  --tls \
  --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fabnet.com/orderers/orderer.fabnet.com/msp/tlscacerts/tlsca.fabnet.com-cert.pem
echo "Querying of 4205 Details is done"


set +x

