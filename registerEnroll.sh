#!/bin/bash

function createManufacturer() {
  echo "Enrolling the CA admin for Manufacturer"
  mkdir -p organizations/peerOrganizations/manufacturer.carbon.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-manufacturer --tls.certfiles "${PWD}/organizations/fabric-ca/manufacturer/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-manufacturer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-manufacturer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-manufacturer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-manufacturer.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/msp/config.yaml"

  mkdir -p "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/manufacturer/ca-cert.pem" "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/manufacturer/ca-cert.pem" "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/tlsca/tlsca.manufacturer.carbon.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/ca"
  cp "${PWD}/organizations/fabric-ca/manufacturer/ca-cert.pem" "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/ca/ca.manufacturer.carbon.com-cert.pem"

  echo "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-manufacturer --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/manufacturer/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering peer1"
  set -x
  fabric-ca-client register --caname ca-manufacturer --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/manufacturer/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering user1"
  set -x
  fabric-ca-client register --caname ca-manufacturer --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/manufacturer/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering org admin"
  set -x
  fabric-ca-client register --caname ca-manufacturer --id.name manufactureradmin --id.secret manufactureradminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/manufacturer/ca-cert.pem"
  { set +x; } 2>/dev/null

  # Peer0 MSP and TLS certificates
  echo "Generating the peer0 MSP"
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-manufacturer -M "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/peers/peer0.manufacturer.carbon.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/manufacturer/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/peers/peer0.manufacturer.carbon.com/msp/config.yaml"

  echo "Generating the peer0 TLS certificates"
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-manufacturer -M "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/peers/peer0.manufacturer.carbon.com/tls" --enrollment.profile tls --csr.hosts peer0.manufacturer.carbon.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/manufacturer/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/peers/peer0.manufacturer.carbon.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/peers/peer0.manufacturer.carbon.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/peers/peer0.manufacturer.carbon.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/peers/peer0.manufacturer.carbon.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/peers/peer0.manufacturer.carbon.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/peers/peer0.manufacturer.carbon.com/tls/server.key"

  # Peer1 MSP and TLS certificates
  echo "Generating the peer1 MSP"
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-manufacturer -M "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/peers/peer1.manufacturer.carbon.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/manufacturer/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/peers/peer1.manufacturer.carbon.com/msp/config.yaml"

  echo "Generating the peer1 TLS certificates"
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-manufacturer -M "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/peers/peer1.manufacturer.carbon.com/tls" --enrollment.profile tls --csr.hosts peer1.manufacturer.carbon.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/manufacturer/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/peers/peer1.manufacturer.carbon.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/peers/peer1.manufacturer.carbon.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/peers/peer1.manufacturer.carbon.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/peers/peer1.manufacturer.carbon.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/peers/peer1.manufacturer.carbon.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/peers/peer1.manufacturer.carbon.com/tls/server.key"

  echo "Generating the user MSP"
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-manufacturer -M "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/users/User1@manufacturer.carbon.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/manufacturer/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/users/User1@manufacturer.carbon.com/msp/config.yaml"

  echo "Generating the org admin MSP"
  fabric-ca-client enroll -u https://manufactureradmin:manufactureradminpw@localhost:7054 --caname ca-manufacturer -M "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/users/Admin@manufacturer.carbon.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/manufacturer/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/manufacturer.carbon.com/users/Admin@manufacturer.carbon.com/msp/config.yaml"
}


function createWholesaler() {
  echo "Enrolling the CA admin for Wholesaler"
  mkdir -p organizations/peerOrganizations/wholesaler.carbon.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/wholesaler.carbon.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-wholesaler --tls.certfiles "${PWD}/organizations/fabric-ca/wholesaler/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-wholesaler.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-wholesaler.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-wholesaler.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-wholesaler.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/wholesaler.carbon.com/msp/config.yaml"

  mkdir -p "${PWD}/organizations/peerOrganizations/wholesaler.carbon.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/wholesaler/ca-cert.pem" "${PWD}/organizations/peerOrganizations/wholesaler.carbon.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/wholesaler.carbon.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/wholesaler/ca-cert.pem" "${PWD}/organizations/peerOrganizations/wholesaler.carbon.com/tlsca/tlsca.wholesaler.carbon.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/wholesaler.carbon.com/ca"
  cp "${PWD}/organizations/fabric-ca/wholesaler/ca-cert.pem" "${PWD}/organizations/peerOrganizations/wholesaler.carbon.com/ca/ca.wholesaler.carbon.com-cert.pem"

  echo "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-wholesaler --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/wholesaler/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering user1"
  set -x
  fabric-ca-client register --caname ca-wholesaler --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/wholesaler/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering org admin"
  set -x
  fabric-ca-client register --caname ca-wholesaler --id.name wholesaleradmin --id.secret wholesaleradminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/wholesaler/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Generating the peer0 MSP"
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-wholesaler -M "${PWD}/organizations/peerOrganizations/wholesaler.carbon.com/peers/peer0.wholesaler.carbon.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/wholesaler/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/wholesaler.carbon.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/wholesaler.carbon.com/peers/peer0.wholesaler.carbon.com/msp/config.yaml"

  echo "Generating the peer0 TLS certificates"
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-wholesaler -M "${PWD}/organizations/peerOrganizations/wholesaler.carbon.com/peers/peer0.wholesaler.carbon.com/tls" --enrollment.profile tls --csr.hosts peer0.wholesaler.carbon.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/wholesaler/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/wholesaler.carbon.com/peers/peer0.wholesaler.carbon.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/wholesaler.carbon.com/peers/peer0.wholesaler.carbon.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/wholesaler.carbon.com/peers/peer0.wholesaler.carbon.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/wholesaler.carbon.com/peers/peer0.wholesaler.carbon.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/wholesaler.carbon.com/peers/peer0.wholesaler.carbon.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/wholesaler.carbon.com/peers/peer0.wholesaler.carbon.com/tls/server.key"

  echo "Generating the user MSP"
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-wholesaler -M "${PWD}/organizations/peerOrganizations/wholesaler.carbon.com/users/User1@wholesaler.carbon.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/wholesaler/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/wholesaler.carbon.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/wholesaler.carbon.com/users/User1@wholesaler.carbon.com/msp/config.yaml"

  echo "Generating the org admin MSP"
  fabric-ca-client enroll -u https://wholesaleradmin:wholesaleradminpw@localhost:8054 --caname ca-wholesaler -M "${PWD}/organizations/peerOrganizations/wholesaler.carbon.com/users/Admin@wholesaler.carbon.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/wholesaler/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/wholesaler.carbon.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/wholesaler.carbon.com/users/Admin@wholesaler.carbon.com/msp/config.yaml"
}

function createcarbon() {
  echo "Enrolling the CA admin for carboncy"
  mkdir -p organizations/peerOrganizations/carbon.carbon.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/carbon.carbon.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ca-carbon --tls.certfiles "${PWD}/organizations/fabric-ca/carbon/ca-cert.pem"
  { set +x; } 2>/dev/null

echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-carbon.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-carbon.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-carbon.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-carbon.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/carbon.carbon.com/msp/config.yaml"

  mkdir -p "${PWD}/organizations/peerOrganizations/carbon.carbon.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/carbon/ca-cert.pem" "${PWD}/organizations/peerOrganizations/carbon.carbon.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/carbon.carbon.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/carbon/ca-cert.pem" "${PWD}/organizations/peerOrganizations/carbon.carbon.com/tlsca/tlsca.carbon.carbon.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/carbon.carbon.com/ca"
  cp "${PWD}/organizations/fabric-ca/carbon/ca-cert.pem" "${PWD}/organizations/peerOrganizations/carbon.carbon.com/ca/ca.carbon.carbon.com-cert.pem"

  echo "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-carbon --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/carbon/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering user1"
  set -x
  fabric-ca-client register --caname ca-carbon --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/carbon/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering org admin"
  set -x
  fabric-ca-client register --caname ca-carbon --id.name carbonadmin --id.secret carbonadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/carbon/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Generating the peer0 MSP" 
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-carbon -M "${PWD}/organizations/peerOrganizations/carbon.carbon.com/peers/peer0.carbon.carbon.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/carbon/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/carbon.carbon.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/carbon.carbon.com/peers/peer0.carbon.carbon.com/msp/config.yaml"

  echo "Generating the peer0 TLS certificates"
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-carbon -M "${PWD}/organizations/peerOrganizations/carbon.carbon.com/peers/peer0.carbon.carbon.com/tls" --enrollment.profile tls --csr.hosts peer0.carbon.carbon.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/carbon/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/carbon.carbon.com/peers/peer0.carbon.carbon.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/carbon.carbon.com/peers/peer0.carbon.carbon.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/carbon.carbon.com/peers/peer0.carbon.carbon.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/carbon.carbon.com/peers/peer0.carbon.carbon.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/carbon.carbon.com/peers/peer0.carbon.carbon.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/carbon.carbon.com/peers/peer0.carbon.carbon.com/tls/server.key"

  echo "Generating the user MSP"
  fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca-carbon -M "${PWD}/organizations/peerOrganizations/carbon.carbon.com/users/User1@carbon.carbon.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/carbon/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/carbon.carbon.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/carbon.carbon.com/users/User1@carbon.carbon.com/msp/config.yaml"

  echo "Generating the org admin MSP"
  fabric-ca-client enroll -u https://carbonadmin:carbonadminpw@localhost:11054 --caname ca-carbon -M "${PWD}/organizations/peerOrganizations/carbon.carbon.com/users/Admin@carbon.carbon.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/carbon/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/carbon.carbon.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/carbon.carbon.com/users/Admin@carbon.carbon.com/msp/config.yaml"


}

function createRegulators() {
  echo "Enrolling the CA admin for Regulators"
  mkdir -p organizations/peerOrganizations/regulators.carbon.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/regulators.carbon.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:12054 --caname ca-regulators --tls.certfiles "${PWD}/organizations/fabric-ca/regulators/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-12054-ca-regulators.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-12054-ca-regulators.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-12054-ca-regulators.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-12054-ca-regulators.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/regulators.carbon.com/msp/config.yaml"

  mkdir -p "${PWD}/organizations/peerOrganizations/regulators.carbon.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/regulators/ca-cert.pem" "${PWD}/organizations/peerOrganizations/regulators.carbon.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/regulators.carbon.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/regulators/ca-cert.pem" "${PWD}/organizations/peerOrganizations/regulators.carbon.com/tlsca/tlsca.regulators.carbon.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/regulators.carbon.com/ca"
  cp "${PWD}/organizations/fabric-ca/regulators/ca-cert.pem" "${PWD}/organizations/peerOrganizations/regulators.carbon.com/ca/ca.regulators.carbon.com-cert.pem"

  echo "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-regulators --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/regulators/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering user1"
  set -x
  fabric-ca-client register --caname ca-regulators --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/regulators/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering org admin"
  set -x
  fabric-ca-client register --caname ca-regulators --id.name regulatorsadmin --id.secret regulatorsadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/regulators/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Generating the peer0 MSP" 
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:12054 --caname ca-regulators -M "${PWD}/organizations/peerOrganizations/regulators.carbon.com/peers/peer0.regulators.carbon.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/regulators/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/regulators.carbon.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/regulators.carbon.com/peers/peer0.regulators.carbon.com/msp/config.yaml"

  echo "Generating the peer0 TLS certificates"
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:12054 --caname ca-regulators -M "${PWD}/organizations/peerOrganizations/regulators.carbon.com/peers/peer0.regulators.carbon.com/tls" --enrollment.profile tls --csr.hosts peer0.regulators.carbon.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/regulators/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/regulators.carbon.com/peers/peer0.regulators.carbon.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/regulators.carbon.com/peers/peer0.regulators.carbon.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/regulators.carbon.com/peers/peer0.regulators.carbon.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/regulators.carbon.com/peers/peer0.regulators.carbon.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/regulators.carbon.com/peers/peer0.regulators.carbon.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/regulators.carbon.com/peers/peer0.regulators.carbon.com/tls/server.key"

  echo "Generating the user MSP"
  fabric-ca-client enroll -u https://user1:user1pw@localhost:12054 --caname ca-regulators -M "${PWD}/organizations/peerOrganizations/regulators.carbon.com/users/User1@regulators.carbon.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/regulators/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/regulators.carbon.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/regulators.carbon.com/users/User1@regulators.carbon.com/msp/config.yaml"

  echo "Generating the org admin MSP"
  fabric-ca-client enroll -u https://regulatorsadmin:regulatorsadminpw@localhost:12054 --caname ca-regulators -M "${PWD}/organizations/peerOrganizations/regulators.carbon.com/users/Admin@regulators.carbon.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/regulators/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/regulators.carbon.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/regulators.carbon.com/users/Admin@regulators.carbon.com/msp/config.yaml"
}

function createOrderer() {
  echo "Enrolling the CA admin for Orderer"
  
  # Create directories for orderer organizations
  mkdir -p organizations/ordererOrganizations/carbon.com

  # Set the CA client home for the orderer organization
  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/carbon.com/

  # Enroll CA admin for the orderer organization
  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles "${PWD}/organizations/fabric-ca/orderer/ca-cert.pem"
  { set +x; } 2>/dev/null

  # Create the config.yaml file for the MSP
  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/ordererOrganizations/carbon.com/msp/config.yaml"

  # Copy the CA cert to MSP, TLSCA, and CA directories
  mkdir -p "${PWD}/organizations/ordererOrganizations/carbon.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/orderer/ca-cert.pem" "${PWD}/organizations/ordererOrganizations/carbon.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/ordererOrganizations/carbon.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/orderer/ca-cert.pem" "${PWD}/organizations/ordererOrganizations/carbon.com/tlsca/tlsca.orderer.carbon.com-cert.pem"

  mkdir -p "${PWD}/organizations/ordererOrganizations/carbon.com/ca"
  cp "${PWD}/organizations/fabric-ca/orderer/ca-cert.pem" "${PWD}/organizations/ordererOrganizations/carbon.com/ca/ca.orderer.carbon.com-cert.pem"

  # Register the orderer identity
  echo "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/orderer/ca-cert.pem"
  { set +x; } 2>/dev/null

  # Register the user identity for the orderer org
  echo "Registering user1"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/orderer/ca-cert.pem"
  { set +x; } 2>/dev/null

  # Register the orderer org admin
  echo "Registering org admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordereradmin --id.secret ordereradminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/orderer/ca-cert.pem"
  { set +x; } 2>/dev/null

  # Enroll the orderer to generate its MSP
  echo "Generating the orderer MSP"
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/carbon.com/orderers/orderer.carbon.com/msp" --csr.hosts orderer.carbon.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/orderer/ca-cert.pem"

  # Ensure the MSP config file is properly copied for the orderer
  cp "${PWD}/organizations/ordererOrganizations/carbon.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/carbon.com/orderers/orderer.carbon.com/msp/config.yaml"

  # Enroll the orderer to generate its TLS certificates
  echo "Generating the orderer TLS certificates"
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/carbon.com/orderers/orderer.carbon.com/tls" --enrollment.profile tls --csr.hosts orderer.carbon.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/orderer/ca-cert.pem"
  
  # Move the TLS certs to the appropriate location
  cp "${PWD}/organizations/ordererOrganizations/carbon.com/orderers/orderer.carbon.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/carbon.com/orderers/orderer.carbon.com/tls/ca.crt"
  cp "${PWD}/organizations/ordererOrganizations/carbon.com/orderers/orderer.carbon.com/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/carbon.com/orderers/orderer.carbon.com/tls/server.crt"
  cp "${PWD}/organizations/ordererOrganizations/carbon.com/orderers/orderer.carbon.com/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/carbon.com/orderers/orderer.carbon.com/tls/server.key"

  mkdir -p "${PWD}/organizations/ordererOrganizations/carbon.com/orderers/orderer.carbon.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/carbon.com/orderers/orderer.carbon.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/carbon.com/orderers/orderer.carbon.com/msp/tlscacerts/tlsca.carbon.com-cert.pem"

  # Enroll the user to generate its MSP
  echo "Generating the user MSP"
  fabric-ca-client enroll -u https://user1:user1pw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/carbon.com/users/User1@orderer.carbon.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/orderer/ca-cert.pem"

  # Ensure the MSP config file is properly copied for the user
  cp "${PWD}/organizations/ordererOrganizations/carbon.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/carbon.com/users/User1@orderer.carbon.com/msp/config.yaml"

  # Enroll the org admin to generate its MSP
  echo "Generating the org admin MSP"
  fabric-ca-client enroll -u https://ordereradmin:ordereradminpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/carbon.com/users/Admin@orderer.carbon.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/orderer/ca-cert.pem"

  # Ensure the MSP config file is properly copied for the org admin
  cp "${PWD}/organizations/ordererOrganizations/carbon.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/carbon.com/users/Admin@orderer.carbon.com/msp/config.yaml"
}





createManufacturer
createWholesaler
createcarbon
createRegulators
createOrderer
