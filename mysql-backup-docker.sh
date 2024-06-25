#!/bin/bash -       

## Settings
MYSQL_ROOT_PASSWORD="password"
DOCKER_IMAGE="mysql"
BACKUP_DATE=`date +%d-%m-%Y`
BACKUP_PATH="$PWD/backup"
BACKUP_RETENTION_DAYS="3"

## Go! 
echo "INFO: Started Backup Script"

if [ ! -d $BACKUP_PATH ]; then
	mkdir -p $BACKUP_PATH
    echo "Directory created"
else
    echo "Directory Already created"
fi

## Get a docker container running MySQL
DOCKER_CONTAINER=`docker ps | grep -w $DOCKER_IMAGE | awk '{ print $1 }'`
if [[ -z $DOCKER_CONTAINER ]]; then
	echo " ERROR: Container not found, check image filter on settings: DOCKER_IMAGE=$DOCKER_IMAGE"
	exit
else
	echo "INFO: Docker container found: $DOCKER_CONTAINER"
fi

## Get a list MySQL databases
MYSQL_DATABASES=`docker exec -it $DOCKER_CONTAINER mysql -p$MYSQL_ROOT_PASSWORD -e "show databases;" \
			| egrep -v -w -e information_schema -e performance_schema -e sys -e Database \
			| awk '{ print $2 }' | grep -v '^$' | egrep -v "Warning"`

echo "$MYSQL_DATABASES"

## Backup databases 
echo " INFO: Backuping databases"
for DATABASE_NAME in $MYSQL_DATABASES; do
	docker exec -it $DOCKER_CONTAINER mysqldump -p$MYSQL_ROOT_PASSWORD $DATABASE_NAME | gzip -9 > $BACKUP_PATH/$DATABASE_NAME-$BACKUP_DATE.sql.gz
	echo " INFO: Database $DATABASE_NAME dumped on $BACKUP_PATH/$DATABASE_NAME-$BACKUP_DATE.sql.gz"
done

## Backup retention clear
if [ $BACKUP_RETENTION_DAYS ]; then
	echo " INFO: Remove $BACKUP_RETENTION_DAYS old days backup"
	find $BACKUP_PATH -type f -mtime +$BACKUP_RETENTION_DAYS -exec rm {} \;
fi

echo " INFO: Finished Backup Script"


# Backup
# docker exec ms /usr/bin/mysqldump -u root --password=password test > backup.sql

# Restore
# docker exec -i ms /usr/bin/mysql -u root --password=password -e "CREATE DATABASE IF NOT EXISTS test"
# cat backup.sql | docker exec -i ms /usr/bin/mysql -u root --password=password test