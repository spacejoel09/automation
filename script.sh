#!/bin/bash

REMOTE_IP="192.168.0.9"
CURRENT_TIME=$(date "+%Y-%m-%d_%H-%M")
REMOTE_USER="onos"
REMOTE_DIR="~/backups"
MAX_BACKUPS=5
TMP_DIR="/tmp/backup_logs"
mkdir -p "$TMP_DIR"
LOG_FILE="/home/ubuntu/backup.log"
cp /var/log/auth.log "$TMP_DIR/"
journalctl --no-pager --since "1 day ago" > "$TMP_DIR/journal.log"

ARCHIVE_NAME="backup-${CURRENT_TIME}.tar.gz"
tar -czf "/tmp/${ARCHIVE_NAME}" -C "$TMP_DIR" .




scp "/tmp/${ARCHIVE_NAME}" "${REMOTE_USER}@${REMOTE_IP}:backups/"

if [ $? -eq 0 ]; then
       echo "$(date '+%F %T') OK" >> "$LOG_FILE"
       ssh "$REMOTE_USER@$REMOTE_IP" "cd backups && ls -t | tail -n +$((MAX_BACKUPS + 1)) | xargs -r rm"
       
   else
       echo "$(date '+%F %T') ERROR" >> "$LOG_FILE"
fi


rm -r "$TMP_DIR"
rm "/tmp/$ARCHIVE_NAME"






