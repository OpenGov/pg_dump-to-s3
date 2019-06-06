# pg_dump-to-s3
Automatically dump and archive PostgreSQL backups to Amazon S3

## Requirements

 - [AWS cli](https://aws.amazon.com/cli): ```pip install awscli```


## Setup

Add secrets.conf:
  - PG_DB - pg connection string
  - MAX_DAYS -  number of days before backups deleted
  - S3_PATH - your Amazon S3 bucket and path
  - AWS_ACCESS_KEY_ID - aws credential
  - AWS_SECRET_ACCESS_KEY - aws credentials

## Usage

```
./pg_to_s3.sh database1 database2 database3 [...]
```

## Credentials

### AWS credentials

AWS credentials should be stored in a file called `~/.aws`. A documentation is available here: http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html

### PostgreSQL password

The PostgreSQL password can be stored in a file called `~/.pgpass`, see: https://www.postgresql.org/docs/current/static/libpq-pgpass.html


### Restore:
pg_restore -d DB_NAME -Fc --clean PATH_TO_YOUR_DB_DUMP_FILE
