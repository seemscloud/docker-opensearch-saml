#!/bin/bash

rm -rf ./data/*

openssl req -nodes -x509 -days 3650 -newkey rsa:4096 -subj "/C=US/ST=Mazovia/L=Warsaw/O=Seems Cloud/OU=Root" \
  -keyout ca.key.pem -out ./data/ca.crt.pem

openssl req -nodes -new -newkey rsa:2048 -subj "/C=US/ST=Mazovia/L=Warsaw/O=Seems Cloud/OU=Root/CN=admin" \
  -keyout ./data/admin.key.pem -out admin.csr.pem

openssl x509 -req -days 365 \
  -CA ./data/ca.crt.pem -CAkey ca.key.pem -CAcreateserial \
  -in admin.csr.pem -out ./data/admin.crt.pem

openssl req -nodes -new -newkey rsa:2048 -subj "/C=US/ST=Mazovia/L=Warsaw/O=Seems Cloud/OU=Root/CN=node" \
  -keyout ./data/node.key.pem -out node.csr.pem

openssl x509 -req -days 365 \
  -CA ./data/ca.crt.pem -CAkey ca.key.pem -CAcreateserial \
  -in node.csr.pem -out ./data/node.crt.pem

rm -f ./data/ca.crt.srl
