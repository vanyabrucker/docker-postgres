#!/bin/bash

# Variables
DB_NAME="$POSTGRES_DB"
DB_USER="$POSTGRES_USER"
DB_PASSWORD="$POSTGRES_PASSWORD"
DB_HOST="$POSTGRES_HOST"  # Use the PostgreSQL container hostname
S3_BUCKET="$S3_BUCKET"
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
BACKUP_FILE="/backups/backup_${TIMESTAMP}.dump"

# Dump the database (connect to the PostgreSQL container)
PGPASSWORD="$DB_PASSWORD" pg_dump -h "$DB_HOST" -U "$DB_USER" -Fc "$DB_NAME" > "$BACKUP_FILE"

# Check if the dump succeeded
if [ $? -ne 0 ]; then
  echo "[ERROR] Database dump failed!"
  exit 1
fi

# Upload to S3
aws s3 cp "$BACKUP_FILE" "s3://${S3_BUCKET}/"

# Check if the upload succeeded
if [ $? -ne 0 ]; then
  echo "[ERROR] S3 upload failed!"
  exit 1
fi

# Clean up the local backup file
rm -f "$BACKUP_FILE"

echo "[SUCCESS] Backup completed and uploaded to S3!"
