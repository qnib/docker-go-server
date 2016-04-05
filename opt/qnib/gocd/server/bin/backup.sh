#!/bin/bash

if [ ! -z ${GOCD_CREDENTIALS} ]then
    GOCD_AUTH="-u '${GOCD_CREDENTIALS}'" 
fi
curl 'http://localhost:8153/go/api/backups' \
      -H 'Accept: application/vnd.go.cd.v1+json' \
      -H 'Content-Type: application/json' \
      ${GOCD_AUTH} -X POST
