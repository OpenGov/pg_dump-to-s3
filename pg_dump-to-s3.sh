#!/bin/bash
set -e

# Vars
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
NOW=$(date +"%m-%d-%Y-at-%H-%M-%S")

source $DIR/secrets.conf

# Get databases list
dbs=("$@")

for db in "${dbs[@]}"; do
    FILENAME="$NOW"-"$db"    

    # Dump database
    pg_dump $PG_DB/$db --format=c  > /tmp/"$FILENAME".dump

    # Copy to S3
    AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY aws s3 cp /tmp/"$FILENAME".dump s3://$S3_PATH/"$FILENAME".dump --storage-class STANDARD_IA

    # Delete local file
    rm /tmp/"$FILENAME".dump

    # Log
    echo "Database $db is archived"
done

# Delete old files
# These following command will only work in a Linux environment
echo "Delete old backups";
$DIR/s3-autodelete.sh $S3_PATH "$MAX_DAYS days"

