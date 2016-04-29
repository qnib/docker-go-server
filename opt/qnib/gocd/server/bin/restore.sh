#!/usr/local/bin/dumb-init /bin/bash
set -ex

SERVER_INSTALLATION_DIR=/opt/go-server
SERVER_BKP_DIR=/opt/go-server/artifacts/serverBackups/
## find latest backup
LATEST=$(ls ${SERVER_BKP_DIR} |grep ^backup |tail -n1)

## check if all files are present
test -f ${SERVER_BKP_DIR}/${LATEST}/db.zip
test -f ${SERVER_BKP_DIR}/${LATEST}/config-dir.zip
test -f ${SERVER_BKP_DIR}/${LATEST}/config-repo.zip

## db.zip
mkdir -p ${SERVER_INSTALLATION_DIR}/db/h2db
unzip -o -d ${SERVER_INSTALLATION_DIR}/db/h2db/ ${SERVER_BKP_DIR}/${LATEST}/db.zip
## config-dir.zip
mkdir -p ${SERVER_INSTALLATION_DIR}/config/
unzip -o -d ${SERVER_INSTALLATION_DIR}/config/ ${SERVER_BKP_DIR}/${LATEST}/config-dir.zip
## config-repo.zip
mkdir -p ${SERVER_INSTALLATION_DIR}/db/config.git/
unzip -o -d ${SERVER_INSTALLATION_DIR}/db/config.git/ ${SERVER_BKP_DIR}/${LATEST}/config-repo.zip
