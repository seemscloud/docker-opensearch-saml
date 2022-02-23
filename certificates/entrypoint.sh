#!/bin/bash

rm -rf ./data/*

openssl req -nodes -x509 -days 3650 -newkey rsa:4096 -subj "/C=US/ST=Mazovia/L=Warsaw/O=Seems Cloud/OU=Root" \
  -keyout ca.key.pem -out ./data/ca.crt.pem

openssl req -nodes -new -newkey rsa:2048 -subj "/C=US/ST=Mazovia/L=Warsaw/O=Seems Cloud/OU=Root/CN=admin" \
  -keyout ./data/admin.key.pem -out admin.csr.pem

openssl x509 -req -days 365 \
  -CA ./data/ca.crt.pem -CAkey ca.key.pem -CAcreateserial \
  -in admin.csr.pem -out ./data/admin.crt.pem

for CERT_NAME in ${CERT_NAMES}; do
  openssl req -nodes -new -newkey rsa:2048 -subj "/C=US/ST=Mazovia/L=Warsaw/O=Seems Cloud/OU=Root/CN=${CERT_NAME}" \
    -keyout ./data/"${CERT_NAME}"-node.key.pem -out "${CERT_NAME}"-node.csr.pem

  openssl x509 -req -days 365 \
    -CA ./data/ca.crt.pem -CAkey ca.key.pem -CAcreateserial \
    -in "${CERT_NAME}"-node.csr.pem -out ./data/"${CERT_NAME}"-node.crt.pem
done

rm -f ./data/ca.crt.srl
