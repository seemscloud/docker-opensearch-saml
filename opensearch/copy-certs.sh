#!/bin/bash

function copy_file {
  while true ; do
    if [ -f "${1}" ] ; then
      cp "${1}" "${2}" && break
    else
      sleep 1
    fi
  done
}

copy_file /certs/node.key.pem config/node.key.pem
copy_file /certs/node.crt.pem config/node.crt.pem
copy_file /certs/admin.key.pem config/admin.key.pem
copy_file /certs/admin.crt.pem config/admin.crt.pem
copy_file /certs/ca.crt.pem config/ca.crt.pem