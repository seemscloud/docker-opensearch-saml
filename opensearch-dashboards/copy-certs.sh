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

copy_file /certs/dashboards.key.pem config/dashboards.key.pem
copy_file /certs/dashboards.crt.pem config/dashboards.crt.pem
copy_file /certs/ca.crt.pem config/ca.crt.pem