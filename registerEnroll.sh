#!/bin/bash

function createfarmer() {
  echo "Enrolling the CA admin for Farmer"
  mkdir -p organizations/peerOrganizations/farmer.carbon.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/farmer.carbon.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-farmer --tls.certfiles "${PWD}/organizations/fabric-ca/farmer/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-farmer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-farmer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-farmer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-farmer.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/farmer.carbon.com/msp/config.yaml"

  mkdir -p "${PWD}/organizations/peerOrganizations/farmer.carbon.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/farmer/ca-cert.pem" "${PWD}/organizations/peerOrganizations/farmer.carbon.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/farmer.carbon.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/farmer/ca-cert.pem" "${PWD}/organizations/peerOrganizations/farmer.carbon.com/tlsca/tlsca.farmer.carbon.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/farmer.carbon.com/ca"
  cp "${PWD}/organizations/fabric-ca/farmer/ca-cert.pem" "${PWD}/organizations/peerOrganizations/farmer.carbon.com/ca/ca.farmer.carbon.com-cert.pem"

  echo "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-farmer --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/farmer/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering peer1"
  set -x
  fabric-ca-client register --caname ca-farmer --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/farmer/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering user1"
  set -x
  fabric-ca-client register --caname ca-farmer --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/farmer/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering org admin"
  set -x
  fabric-ca-client register --caname ca-farmer --id.name farmeradmin --id.secret farmeradminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/farmer/ca-cert.pem"
  { set +x; } 2>/dev/null

  # Peer0 MSP and TLS certificates
  echo "Generating the peer0 MSP"
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-farmer -M "${PWD}/organizations/peerOrganizations/farmer.carbon.com/peers/peer0.farmer.carbon.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/farmer/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/farmer.carbon.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/farmer.carbon.com/peers/peer0.farmer.carbon.com/msp/config.yaml"

  echo "Generating the peer0 TLS certificates"
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-farmer -M "${PWD}/organizations/peerOrganizations/farmer.carbon.com/peers/peer0.farmer.carbon.com/tls" --enrollment.profile tls --csr.hosts peer0.farmer.carbon.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/farmer/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/farmer.carbon.com/peers/peer0.farmer.carbon.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/farmer.carbon.com/peers/peer0.farmer.carbon.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/farmer.carbon.com/peers/peer0.farmer.carbon.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/farmer.carbon.com/peers/peer0.farmer.carbon.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/farmer.carbon.com/peers/peer0.farmer.carbon.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/farmer.carbon.com/peers/peer0.farmer.carbon.com/tls/server.key"

  # Peer1 MSP and TLS certificates
  echo "Generating the peer1 MSP"
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-farmer -M "${PWD}/organizations/peerOrganizations/farmer.carbon.com/peers/peer1.farmer.carbon.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/farmer/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/farmer.carbon.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/farmer.carbon.com/peers/peer1.farmer.carbon.com/msp/config.yaml"

  echo "Generating the peer1 TLS certificates"
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca-farmer -M "${PWD}/organizations/peerOrganizations/farmer.carbon.com/peers/peer1.farmer.carbon.com/tls" --enrollment.profile tls --csr.hosts peer1.farmer.carbon.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/farmer/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/farmer.carbon.com/peers/peer1.farmer.carbon.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/farmer.carbon.com/peers/peer1.farmer.carbon.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/farmer.carbon.com/peers/peer1.farmer.carbon.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/farmer.carbon.com/peers/peer1.farmer.carbon.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/farmer.carbon.com/peers/peer1.farmer.carbon.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/farmer.carbon.com/peers/peer1.farmer.carbon.com/tls/server.key"

  echo "Generating the user MSP"
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-farmer -M "${PWD}/organizations/peerOrganizations/farmer.carbon.com/users/User1@farmer.carbon.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/farmer/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/farmer.carbon.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/farmer.carbon.com/users/User1@farmer.carbon.com/msp/config.yaml"

  echo "Generating the org admin MSP"
  fabric-ca-client enroll -u https://farmeradmin:farmeradminpw@localhost:7054 --caname ca-farmer -M "${PWD}/organizations/peerOrganizations/farmer.carbon.com/users/Admin@farmer.carbon.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/farmer/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/farmer.carbon.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/farmer.carbon.com/users/Admin@farmer.carbon.com/msp/config.yaml"
}


function createbuyer() {
  echo "Enrolling the CA admin for buyer"
  mkdir -p organizations/peerOrganizations/buyer.carbon.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/buyer.carbon.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-buyer --tls.certfiles "${PWD}/organizations/fabric-ca/buyer/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-buyer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-buyer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-buyer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-buyer.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/buyer.carbon.com/msp/config.yaml"

  mkdir -p "${PWD}/organizations/peerOrganizations/buyer.carbon.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/buyer/ca-cert.pem" "${PWD}/organizations/peerOrganizations/buyer.carbon.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/buyer.carbon.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/buyer/ca-cert.pem" "${PWD}/organizations/peerOrganizations/buyer.carbon.com/tlsca/tlsca.buyer.carbon.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/buyer.carbon.com/ca"
  cp "${PWD}/organizations/fabric-ca/buyer/ca-cert.pem" "${PWD}/organizations/peerOrganizations/buyer.carbon.com/ca/ca.buyer.carbon.com-cert.pem"

  echo "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-buyer --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/buyer/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering user1"
  set -x
  fabric-ca-client register --caname ca-buyer --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/buyer/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering org admin"
  set -x
  fabric-ca-client register --caname ca-buyer --id.name buyeradmin --id.secret buyeradminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/buyer/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Generating the peer0 MSP"
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-buyer -M "${PWD}/organizations/peerOrganizations/buyer.carbon.com/peers/peer0.buyer.carbon.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/buyer/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/buyer.carbon.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/buyer.carbon.com/peers/peer0.buyer.carbon.com/msp/config.yaml"

  echo "Generating the peer0 TLS certificates"
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-buyer -M "${PWD}/organizations/peerOrganizations/buyer.carbon.com/peers/peer0.buyer.carbon.com/tls" --enrollment.profile tls --csr.hosts peer0.buyer.carbon.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/buyer/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/buyer.carbon.com/peers/peer0.buyer.carbon.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/buyer.carbon.com/peers/peer0.buyer.carbon.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/buyer.carbon.com/peers/peer0.buyer.carbon.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/buyer.carbon.com/peers/peer0.buyer.carbon.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/buyer.carbon.com/peers/peer0.buyer.carbon.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/buyer.carbon.com/peers/peer0.buyer.carbon.com/tls/server.key"

  echo "Generating the user MSP"
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-buyer -M "${PWD}/organizations/peerOrganizations/buyer.carbon.com/users/User1@buyer.carbon.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/buyer/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/buyer.carbon.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/buyer.carbon.com/users/User1@buyer.carbon.com/msp/config.yaml"

  echo "Generating the org admin MSP"
  fabric-ca-client enroll -u https://buyeradmin:buyeradminpw@localhost:8054 --caname ca-buyer -M "${PWD}/organizations/peerOrganizations/buyer.carbon.com/users/Admin@buyer.carbon.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/buyer/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/buyer.carbon.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/buyer.carbon.com/users/Admin@buyer.carbon.com/msp/config.yaml"
}

function createcertAuth() {
  echo "Enrolling the CA admin for CertiftyingAuth credit"
  mkdir -p organizations/peerOrganizations/certifyingAuth.carbon.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/certifyingAuth.carbon.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ca-certifyingAuth --tls.certfiles "${PWD}/organizations/fabric-ca/certifyingAuth/ca-cert.pem"
  { set +x; } 2>/dev/null

echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-certifyingAuth.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-certifyingAuth.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-certifyingAuth.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-certifyingAuth.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/certifyingAuth.carbon.com/msp/config.yaml"

  mkdir -p "${PWD}/organizations/peerOrganizations/certifyingAuth.carbon.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/certifyingAuth/ca-cert.pem" "${PWD}/organizations/peerOrganizations/certifyingAuth.carbon.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/certifyingAuth.carbon.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/certifyingAuth/ca-cert.pem" "${PWD}/organizations/peerOrganizations/certifyingAuth.carbon.com/tlsca/tlsca.certifyingAuth.carbon.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/certifyingAuth.carbon.com/ca"
  cp "${PWD}/organizations/fabric-ca/certifyingAuth/ca-cert.pem" "${PWD}/organizations/peerOrganizations/certifyingAuth.carbon.com/ca/ca.certifyingAuth.carbon.com-cert.pem"

  echo "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-certifyingAuth --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/certifyingAuth/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering user1"
  set -x
  fabric-ca-client register --caname ca-certifyingAuth --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/certifyingAuth/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Registering org admin"
  set -x
  fabric-ca-client register --caname ca-certifyingAuth --id.name carbonadmin --id.secret carbonadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/certifyingAuth/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo "Generating the peer0 MSP" 
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-certifyingAuth -M "${PWD}/organizations/peerOrganizations/certifyingAuth.carbon.com/peers/peer0.certifyingAuth.carbon.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/certifyingAuth/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/certifyingAuth.carbon.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/certifyingAuth.carbon.com/peers/peer0.certifyingAuth.carbon.com/msp/config.yaml"

  echo "Generating the peer0 TLS certificates"
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-certifyingAuth -M "${PWD}/organizations/peerOrganizations/certifyingAuth.carbon.com/peers/peer0.certifyingAuth.carbon.com/tls" --enrollment.profile tls --csr.hosts peer0.certifyingAuth.carbon.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/certifyingAuth/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/certifyingAuth.carbon.com/peers/peer0.certifyingAuth.carbon.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/certifyingAuth.carbon.com/peers/peer0.certifyingAuth.carbon.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/certifyingAuth.carbon.com/peers/peer0.certifyingAuth.carbon.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/certifyingAuth.carbon.com/peers/peer0.certifyingAuth.carbon.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/certifyingAuth.carbon.com/peers/peer0.certifyingAuth.carbon.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/certifyingAuth.carbon.com/peers/peer0.certifyingAuth.carbon.com/tls/server.key"

  echo "Generating the user MSP"
  fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca-certifyingAuth -M "${PWD}/organizations/peerOrganizations/certifyingAuth.carbon.com/users/User1@certifyingAuth.carbon.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/certifyingAuth/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/certifyingAuth.carbon.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/certifyingAuth.carbon.com/users/User1@certifyingAuth.carbon.com/msp/config.yaml"

  echo "Generating the org admin MSP"
  fabric-ca-client enroll -u https://carbonadmin:carbonadminpw@localhost:11054 --caname ca-certifyingAuth -M "${PWD}/organizations/peerOrganizations/certifyingAuth.carbon.com/users/Admin@certifyingAuth.carbon.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/certifyingAuth/ca-cert.pem"

  cp "${PWD}/organizations/peerOrganizations/certifyingAuth.carbon.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/certifyingAuth.carbon.com/users/Admin@certifyingAuth.carbon.com/msp/config.yaml"


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





createfarmer
createbuyer
createcertAuth
createRegulators
createOrderer
