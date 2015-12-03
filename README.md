# Customer Nightly Backup

#### A simple nightly backup script for backing up one NFS mount to another directory.

#### Add this script to the crontab similar to the below
 
###### 1) Copy this file to /etc/daily_backup.sh

###### 2) Open crontab: sudo crontab -e 

###### 3) Add line to crontab: 01 23 * * * /etc/daily_backup.sh 

