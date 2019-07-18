#!/bin/bash

# Usage:
# ./s3-autodelete.sh bucket/path "7 days"

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
dateToday=`date`
regexEndsInSql='^.*\.(sql)$'

source $DIR/secrets.conf

# Maximum date (will delete all files older than this date)
maxDate=`[ "$(uname)" = Linux ] && date --date="${dateToday} -${2} day" +%Y-%m-%d" "%T`
maxDate=`date -d"$maxDate" +%s`

# Loop thru files
AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY aws s3 ls s3://$1/ | while read -r line;  do
    # Get file creation date
    createDate=`echo $line|awk {'print $1" "$2'}`

    if [[ $line =~ $regexEndsInSql ]];
    then
        createDateCompare=`date -d"$createDate" +%s`
        # Get file name
        fileName=`echo $line|awk {'print $4'}`

        if [[ $createDateCompare -lt $maxDate ]];
        then
            if [[ $fileName != "" ]]
            then
                echo "* Delete $fileName";
                AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY  aws s3 rm s3://$1/$fileName
                continue
            fi
        else
            echo "$fileName skipped because it is not older than deletion date: $createDate";
            continue
        fi
    else
      echo "$createDate skipped because not a file";
      continue    
    fi
done;