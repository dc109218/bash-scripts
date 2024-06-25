#!/bin/bash

DB_BACKUP_PATH="/data"
RESTOREFILE_R="liveroleitapin-prod-150423-171419.gz"
RESTOREFILE_D="devappapin-prod-150423-171419.gz"

ROLEURI="mongodb://dcsurani:Ath9aeGaePhae4shaengeoLaeQu3eichee9weprodRoleitMuS1maifohDe1faeg6keisoobe0@10.10.10.10:6390/liveroleitapin?directConnection=true"
# DEVURI="mongodb://devdcsurani:9aeGaePhae4shaengeoLaeQu3eichee9weprodRoleitMuS1maifohDe1faeg6keisoobe0Ath@10.10.10.10:6390/devappapin?ssl=false&retryWrites=true&w=majority&readPreference=primary&replicaSet=rep-role"
DEVURI="mongodb://devdcsurani:9aeGaePhae4shaengeoLaeQu3eichee9weprodRoleitMuS1maifohDe1faeg6keisoobe0Ath@10.10.10.10:6390/devappapin?directConnection=true"

DBNMROLEIT='liveroleitapin'
DBNMDEVOPPS='devappapin'

######################################################################
function roleitDB {
  if [ ${DBNMROLEIT} = "ALL" ]; then
    echo "You have choose to restore ALL databases"
    mongorestore --uri ${ROLEURI} --db ${DBNM} --drop --gzip --archive=${DB_BACKUP_PATH}/${RESTOREFILE_R}
    # mongorestore --host=$HOST --port=$PORT -u=$USER -p=$PASS --drop --gzip --archive=${DB_BACKUP_PATH}/${RESTOREFILE_R}
  else
      echo "Running restore for selected $DBNMROLEIT databases"
    for DB_NAME in $DBNMROLEIT; do
      mongorestore --uri ${ROLEURI} --drop --gzip --archive=${DB_BACKUP_PATH}/${RESTOREFILE_R}
    #   mongorestore --host=$HOST --port=$PORT -u=$USER -p=$PASS --drop --gzip --archive=${DB_BACKUP_PATH}/${RESTOREFILE_R}
x-mongo-replication-ok/READme.md    done
  fi
}
echo "Done=======DevOpsDB, $DBNMROLEIT"

function DevOpsDB {
  if [ $DBNMDEVOPPS = "ALL" ]; then
    echo "You have choose to restore ALL databases"
    mongorestore --uri ${DEVURI} --db ${DBNM} --drop --gzip --archive=${DB_BACKUP_PATH}/${RESTOREFILE_D}
    # mongorestore --host=$HOST --port=$PORT -u=$USER -p=$PASS --drop --gzip --archive=${DB_BACKUP_PATH}/${RESTOREFILE_D}
  else
      echo "Running restore for selected $DBNMDEVOPPS databases"
    for DB_NAME in $DBNMDEVOPPS; do
      mongorestore --uri ${DEVURI} --drop --gzip --archive=${DB_BACKUP_PATH}/${RESTOREFILE_D}
    #   mongorestore --host=$HOST --port=$PORT -u=$USER -p=$PASS --drop --gzip --archive=${DB_BACKUP_PATH}/${RESTOREFILE_D}
    done
  fi
}
echo "Done=======DevOpsDB, $DBNMDEVOPPS"

roleitDB;
DevOpsDB;
