#!/bin/bash

set -euo pipefail

S3_BUCKET='my-backup-db-bucket'

# Endpoint URL (в примере: Hotbox, горячие данные)
S3_ENDPOINT='https://hb.bizmrg.com'

MYSQL_USER='root'

MYSQL_PWD='passw0rd'

MYSQL_DB='cooldb'

SYNC_DIR='/backups/mysql'

ARCHIVE_PREFIX='db'

DATE="$(date +%Y-%m-%d_%H-%M)"

mkdir -p "${SYNC_DIR}"

find "${SYNC_DIR}/${ARCHIVE_PREFIX}*" -mtime +7 -exec rm {} \;

rm -rf "${SYNC_DIR}/_current"
mkdir -p "${SYNC_DIR}/_current"

mysqldump -u "${MYSQL_USER}" -p${MYSQL_PWD} --quote-names --create-options --force --no-data --databases "${MYSQL_DB}" > "${SYNC_DIR}/_current/dump.sql"

mysqldump -u "${MYSQL_USER}" -p${MYSQL_PWD} --quote-names --no-create-info  --force --databases "${MYSQL_DB}" >> "${SYNC_DIR}/_current/dump.sql"
# https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html

tar -czf "${SYNC_DIR}/${ARCHIVE_PREFIX}_${DATE}.tar.gz" "${SYNC_DIR}/_current"

rm -rf "${SYNC_DIR}/_current"

/usr/local/bin/aws s3 sync --delete "${SYNC_DIR}" "s3://${S3_BUCKET}" --endpoint-url="${S3_ENDPOINT}