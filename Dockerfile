# Use the same PostgreSQL Alpine image as the base
FROM postgres:15.3-alpine

# Install AWS CLI and cron (instead of doing it at runtime)
RUN apk add --no-cache aws-cli

# Copy your backup script and crontab file
COPY ./backup.sh /backup.sh
COPY ./crontab /etc/crontabs/root

# Set permissions
RUN chmod 0644 /etc/crontabs/root && chmod +x /backup.sh
