#!/bin/bash

# File backup script

backup_dir="/tmp/backup"
source_dir="/home/vagrant/Git-Lab/yml"
timestamp="$(date +%Y%m%d_%H%M%S)"
log_file="/tmp/backup_log.txt"

# Ensure the backup directory exists
mkdir -p "$backup_dir"

# Log the start of the backup
{
  echo "Backup started at $(date)"
  echo "Source Directory: $source_dir"
  echo "Backup Directory: $backup_dir"

  # Create a timestamped backup of the source directory
  tar -cvzf "$backup_dir/backup_$timestamp.tar.gz" "$source_dir"

  # Log the completion of the backup
  if [ $? -eq 0 ]; then
    echo "Backup successful: $backup_dir/backup_$timestamp.tar.gz"
  else
    echo "Backup failed"
  fi

  echo "Backup ended at $(date)"
  echo "---------------------------"
} >> "$log_file" 2>&1
