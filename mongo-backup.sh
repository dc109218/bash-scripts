#!/bin/bash

DB_BACKUP_PATH="/data"

ROLEURI="mongodb://dcsurani:Ath9aeGaePhae4shaengeoLaeQu3eichee9weprodRoleitMuS1maifohDe1faeg6keisoobe0@10.0.1.238:27116,10.0.2.93:27117,10.0.1.209:27118/liveroleitapin?ssl=false&retryWrites=true&w=majority&readPreference=primary&replicaSet=reprit"
DEVURI="mongodb://devdcsurani:9aeGaePhae4shaengeoLaeQu3eichee9weprodRoleitMuS1maifohDe1faeg6keisoobe0Ath@10.0.1.238:27116,10.0.2.93:27117,10.0.1.209:27118/devappapin?ssl=false&retryWrites=true&w=majority&readPreference=primary&replicaSet=reprit"

# DATABASE_NAMES='ALL'
DBNMROLEIT='liveroleitapin'
DBNMDEVOPPS='devappapin'

RoleitFILE=liveroleitapin-prod-`date +"%d%m%y-%H%M%S"`.gz
DevopsFILE=devappapin-prod-`date +"%d%m%y-%H%M%S"`.gz

function roleitDB1 {
    if [ ${DBNMROLEIT} = "ALL" ]; then
        echo "You have choose to backup all databases"
        # mongodump --host ${MONGO_HOST} --port ${MONGO_PORT} ${AUTH_PARAM} --out ${DB_BACKUP_PATH}/${TODAY}/
        mongodump --uri ${ROLEURI} --gzip --archive ${DB_BACKUP_PATH}/${RoleitFILE}
    else
            echo "Running backup for selected databases"
        for DB_NAME in ${DBNMROLEIT}; do
            # mongodump --host ${MONGO_HOST} --port ${MONGO_PORT} --db ${DB_NAME} ${AUTH_PARAM} --out ${DB_BACKUP_PATH}/${TODAY}/
            mongodump --uri ${ROLEURI} --db ${DB_NAME} --gzip --archive=${DB_BACKUP_PATH}/${RoleitFILE}
        done
    fi
}
echo "Done=======DevOpsDB, $DBNMROLEIT"

function DevOpsDB2 {
    if [ ${DBNMDEVOPPS} = "ALL" ]; then
        echo "You have choose to backup all databases"
        # mongodump --host ${MONGO_HOST} --port ${MONGO_PORT} ${AUTH_PARAM} --out ${DB_BACKUP_PATH}/${TODAY}/
        mongodump --uri ${DEVURI} --gzip --archive ${DB_BACKUP_PATH}/${DevopsFILE}
    else
            echo "Running backup for selected databases"
        for DB_NAME in ${DBNMDEVOPPS}; do
            # mongodump --host ${MONGO_HOST} --port ${MONGO_PORT} --db ${DB_NAME} ${AUTH_PARAM} --out ${DB_BACKUP_PATH}/${TODAY}/
            mongodump --uri ${DEVURI} --db ${DB_NAME} --gzip --archive=${DB_BACKUP_PATH}/${DevopsFILE}
        done
    fi
}
echo "Done=======DevOpsDB, $DBNMDEVOPPS"

roleitDB1;
DevOpsDB2;

# /home/mongo-backup.sh
# 30 2 * * * bash /home/mongo-backup.sh >> /home/crontab.log 2>&1