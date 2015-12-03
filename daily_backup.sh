#!/bin/bash
#  Simple nightly backup of customer data directory.
#  
#  Add as cron job
#  1) Copy this file to /etc/daily_backup.sh
#  2) Open crontab: sudo crontab -e 
#  3) Add line to crontab: 01 23 * * * /etc/daily_backup.sh 

NFS_FS_LIVE="/mnt/live"
NFS_FS_BACKUP="/mnt/backup"
NFS_FS_LIVE_ADDR="127.0.0.1:/live"
NFS_FS_BACKUP_ADDR="127.0.0.1:/backup"
MNT_CMD="mount -t nfs -o proto=tcp,port=2049"
NFS_FS_LIVE_EXISTS=0
NFS_FS_BACKUP_EXISTS=0
DATE=`date +%Y-%m-%d:%H:%M:%S`

# Make sure user is superuser. By default mount works only with super user privilege
if [ $EUID -ne 0 ]; then
  echo "BACKUP FAILURE: Incorrect privileges" 
  return 1 
fi

# Create the directories if they don't exist
mkdir -p $NFS_FS_LIVE
mkdir -p $NFS_FS_BACKUP

# Check NS_FS_LIVE mount and if not mounted try to mount it
mountpoint -q $NFS_FS_LIVE || $MNT_CMD $NFS_FS_LIVE_ADDR $NFS_FS_LIVE
if [ $? -eq 0 ]; then
  NFS_FS_LIVE_EXISTS=1
fi

# Check NS_FS_BACKUP mount and if not mounted try to mount it
mountpoint -q $NFS_FS_BACKUP || $MNT_CMD $NFS_FS_BACKUP_ADDR $NFS_FS_BACKUP
if [ $? -eq 0 ]; then
  NFS_FS_BACKUP_EXISTS=1
fi

# If mounts are setup correctly attempt to copy data
if [ $NFS_FS_LIVE_EXISTS -eq "1" ] && [ $NFS_FS_LIVE_EXISTS -eq "1" ]; then
  cp -r $NFS_FS_LIVE $NFS_FS_BACKUP/daily-$DATE
  if [ $? -eq 0 ]; then
    echo "BACKUP SUCCESSFUL: Completed backup of $NFS_FS_LIVE to $NFS_FS_BACKUP/daily-$DATE"
    return 1
  fi
fi

echo "BACKUP FAILURE: Failed to copy $NFS_FS_LIVE to $NFS_FS_BACKUP/daily-$DATE"
