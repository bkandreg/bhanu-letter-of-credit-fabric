
# fabric-samples/loc$ 
docker-compose -f docker-compose-cli.yaml up -d

# fabric-samples/loc$  
docker exec -it cli bash

export CHANNEL_NAME=fabnet-channel

# create peer channel
peer channel create -o orderer.fabnet.com:7050 -c fabnet-channel -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fabnet.com/orderers/orderer.fabnet.com/msp/tlscacerts/tlsca.fabnet.com-cert.pem

# join peer channel
peer channel join -b fabnet-channel.block

# update peer channel
peer channel update -o orderer.fabnet.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/ManufacturerMSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fabnet.com/orderers/orderer.fabnet.com/msp/tlscacerts/tlsca.fabnet.com-cert.pem



# 'Install & Instantiate Chaincode on the network'

# 'Installing chaincode..'
docker exec -e "CORE_PEER_LOCALMSPID=ManufacturerMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/manufacturer.fabnet.com/users/Admin@manufacturer.fabnet.com/msp" cli peer chaincode install -n "mycc" -v "1.0" -p "/opt/gopath/src/github.com/chaincode/newcc" -l "node"

# 'Instantiating chaincode..'
sudo docker exec -e "CORE_PEER_LOCALMSPID=ManufacturerMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/manufacturer.fabnet.com/users/Admin@manufacturer.fabnet.com/msp" cli peer chaincode instantiate -o orderer.fabnet.com:7050 -C fabnet-channel -n mycc -l "node" -v 1.0 -c '{"Args":[]}' --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fabnet.com/orderers/orderer.fabnet.com/msp/tlscacerts/tlsca.fabnet.com-cert.pem

# 'Adding Employee Details'
sudo docker exec -e “CORE_PEER_LOCALMSPID=ManufacturerMSP” -e “CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/manufacturer.fabnet.com/users/Admin@manufacturer.fabnet.com/msp” cli peer chaincode invoke -o orderer.fabnet.com:7050 -C fabnet-channel -n mycc -c '{"function":"addEmpDetails","Args":["4205","varshini","miracleHeights","InnovationLabs"]}' --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fabnet.com/orderers/orderer.fabnet.com/msp/tlscacerts/tlsca.fabnet.com-cert.pem

# 'Querying;.. 4205 Details'
sudo docker exec -e “CORE_PEER_LOCALMSPID=ManufacturerMSP” -e “CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/manufacturer.fabnet.com/users/Admin@manufacturer.fabnet.com/msp” cli peer chaincode invoke -o orderer.fabnet.com:7050 -C fabnet-channel -n mycc -c '{"function":"queryEmpDetails","Args":["4205"]}' --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fabnet.com/orderers/orderer.fabnet.com/msp/tlscacerts/tlsca.fabnet.com-cert.pem

# 'deleting 4205 Details'
sudo docker exec -e “CORE_PEER_LOCALMSPID=ManufacturerMSP” -e “CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/manufacturer.fabnet.com/users/Admin@manufacturer.fabnet.com/msp” cli peer chaincode invoke -o orderer.fabnet.com:7050 -C fabnet-channel -n mycc -c '{"function":"deleteEmpDetails","Args":["4205"]}' --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/fabnet.com/orderers/orderer.fabnet.com/msp/tlscacerts/tlsca.fabnet.com-cert.pem

