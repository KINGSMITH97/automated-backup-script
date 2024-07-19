#!/bin/bash

SOURCE_DIR="/home/thenightbirde/Desktop/sourceData"
BACKUP_DIR="/home/thenightbirde/Desktop"
DATE=$(date +%Y-%m-%d)
BACKUP_FILE="$BACKUP_DIR/backup$DATE.tar.gz"
KEYPEM_DIR="/home/thenightbirde/Downloads/key1.pem"
BACKUP_SERVER_NAME="ubuntu"
BACKUP_SERVER_IP="54.160.254.238"
BACKUP_SERVER_DIR="/home/ubuntu/BACKUPS/"
ADMIN_EMAIL="smithwilson.ws@gmail.com"

send_email() {
	local subject=$1
	local message=$2
	echo "$message" | mutt -s "$subject" "$ADMIN_EMAIL"
}

mkdir -p "$SOURCE_DIR"


if [ $? -eq 0 ]; then
send_email "Creating Source Directory"  "Successfully created the SOURCE DIRECTORY"
else
send_email "Creating Source Directory" "Failed at creating SOURCE DIRECTORY" 
exit 1
fi

touch "$SOURCE_DIR/file1.txt" "$SOURCE_DIR/file1.pdf" "$SOURCE_DIR/file1.docx"
if [ $? -eq 0 ]; then
send_email "Creating Sub Directories" "Successfully created Subfiles"
else
send_email "Creating Sub Directories" "Failed at creating subdirectories"
exit 1
fi

sleep 10s

tar -czvf "$BACKUP_FILE" "$SOURCE_DIR"
if [ $? -eq 0 ]; then
send_email "Creating backup" "Successfully created a zipped file for he backup"
sleep 10s

	scp -i "$KEYPEM_DIR" "$BACKUP_FILE" "$BACKUP_SERVER_NAME@$BACKUP_SERVER_IP":"$BACKUP_SERVER_DIR"
	if [ $? -eq 0 ]; then
	send_email "Send Backup" "Backup successfully sent to remote server $BACKUP_SERVER_IP"
	else
	send_email "Send Backup" "Couldn't send backup to remote server"
	fi
else
send_email "Creating backup" "Failed at creating a backup file"
exit 1
fi
