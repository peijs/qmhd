#!/bin/sh
 
GREEN="\\033[32m"
 
print_info(){
	    echo -e ${GREEN}"####################################################### $1 ##################################################################"${BLACK}
    }
     
     
	CA_COMMON_NAME=qmhd.com.cn

	COUNTRY_NAME=CN
	COMMON_NAME=zabbix.qmhd.com.cn
	PASSWORD=toortoor
	EMAIL_ADDR=Anonymous@an.com
	STAT_NAME=BEIJING
	LOCALITY_NAME=BEIJING
	ORGANIZATIN_NAME=Anonymous
	ORGANIZATIN_UNIT_NAME=Anonymous

     
     
     
    print_info "
    Country Name (2 letter code) [XX]:${COUNTRY_NAME}
    State or Province Name (full name) []:${STAT_NAME}
    Locality Name (eg, city) [Default City]:${LOCALITY_NAME}
    Organization Name (eg, company) [Default Company Ltd]:${ORGANIZATIN_NAME}
    Organizational Unit Name (eg, section) []:${ORGANIZATIN_UNIT_NAME}
    Common Name (eg, your name or your server's hostname) []:${COMMON_NAME}
    Email Address []:${EMAIL_ADDR}
    "
     
    print_info "begin gen root certifate"
    # create root private key
    openssl genrsa -out root-ca.key 2048
    # create root CSR
    openssl req -new -passin pass:${PASSWORD} -out root-ca.csr -key root-ca.key -subj /C=${COUNTRY_NAME}/ST=${STAT_NAME}/L=${LOCALITY_NAME}/O=${ORGANIZATIN_NAME}/OU=${ORGANIZATIN_UNIT_NAME}/CN=${CA_COMMON_NAME}/emailAddress=${EMAIL_ADDR}
    # create self-signed root key
    openssl x509 -req -in root-ca.csr -out root-ca.crt -signkey root-ca.key -CAcreateserial -days 3650
     
     
    print_info "begin gen server certificate"
    # create server private key
    openssl genrsa -out server.key 2048
    # create server CSR
    openssl req -new -passin pass:${PASSWORD} -out server.csr -key server.key -subj /C=${COUNTRY_NAME}/ST=${STAT_NAME}/L=${LOCALITY_NAME}/O=${ORGANIZATIN_NAME}/OU=${ORGANIZATIN_UNIT_NAME}/CN=${COMMON_NAME}/emailAddress=${EMAIL_ADDR}
    # create server key with root certificate signed
    openssl x509 -req -in server.csr -out server.crt -CA root-ca.crt -CAkey root-ca.key -CAcreateserial -days 3650
     
     
    print_info "begin gen client certificate"
    # create client private key
    openssl genrsa -out client.key 2048
    # create client CSR
    openssl req -new -passin pass:${PASSWORD} -out client.csr -key client.key -subj /C=${COUNTRY_NAME}/ST=${STAT_NAME}/L=${LOCALITY_NAME}/O=${ORGANIZATIN_NAME}/OU=${ORGANIZATIN_UNIT_NAME}/CN=${COMMON_NAME}/emailAddress=${EMAIL_ADDR}
    # create client key with root certificate signed
    openssl x509 -req -in client.csr -out client.crt -CA root-ca.crt -CAkey root-ca.key -CAcreateserial -days 3650
     
    print_info "begin gen p12 for browser"
    # gen p12 format certificate for browser
    openssl pkcs12 -export -clcerts -password pass:${PASSWORD} -in client.crt -inkey client.key -out client.p12
