#!/bin/sh
#Program:
# This program is to delete the files older than 183 days in inspectors' share folders
#10 Nov 2017 created by Jimmy Chu
# Shell script to monitor or watch the disk space
# -------------------------------------------------------------------------
# set alert level
ALERT1=30
ALERT2=85
ALERT3=95
ALERT4=98
# Exclude list of unwanted monitoring, if several partions then use "|" to separate the partitions.
# An example: EXCLUDE_LIST="/dev/hdd1|/dev/hdc5"
EXCLUDE_LIST="/dev/sda1"
#
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#


NOW=$(date +%Y-%m-%d_%H:%M:%S)

echo "program start @ $(date +%Y-%m-%d_%H:%M:%S)" >> /var/log/cron-result/$(date +%Y-%m-%d_RemovedFiles).log

main_prog()
{
while read output;
do
#echo $output
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1)
  partition=$(echo $output | awk '{print $2}')
  if [ $usep -ge $ALERT4 ] ; then
     echo "Running out of space \"$partition ($usep%)\" on server $(hostname), $(date), Alert=$ALERT4" >> /var/log/cron-result/$(date +%Y-%m-%d_RemovedFiles).log
     total="$(find /mnt/ftpspace/inspector/savehere/ -type f -ctime +31 | grep -c / )"
     echo "${total} files are older than 31 days!" >> /var/log/cron-result/$(date +%Y-%m-%d_RemovedFiles).log

     if [ $total -gt 0 ] ; then
        echo "${total} files are removed!" >> /var/log/cron-result/$(date +%Y-%m-%d_RemovedFiles).log
        find /mnt/ftpspace/inspector/savehere/ -type f -ctime +31 -print >> /var/log/cron-result/$(date +%Y-%m-%d_RemovedFiles).log -exec chattr -i {} \; -exec rm -f {} \;
     fi
  fi
  if [ $usep -ge $ALERT3 ] ; then
     echo "Running out of space \"$partition ($usep%)\" on server $(hostname), $(date), Alert=$ALERT3" >> /var/log/cron-result/$(date +%Y-%m-%d_RemovedFiles).log
     total="$(find /mnt/ftpspace/inspector/savehere/ -type f -ctime +90 | grep -c / )"
     echo "${total} files are older than 90 days!" >> /var/log/cron-result/$(date +%Y-%m-%d_RemovedFiles).log

     if [ $total -gt 0 ] ; then
        echo "${total} files are removed!" >> /var/log/cron-result/$(date +%Y-%m-%d_RemovedFiles).log
        find /mnt/ftpspace/inspector/savehere/ -type f -ctime +90 -print >> /var/log/cron-result/$(date +%Y-%m-%d_RemovedFiles).log -exec chattr -i {} \; -exec rm -f {} \;
     fi
  fi
  if [ $usep -ge $ALERT2 ] ; then
     echo "Running out of space \"$partition ($usep%)\" on server $(hostname), $(date), Alert=$ALERT2" >> /var/log/cron-result/$(date +%Y-%m-%d_RemovedFiles).log
     total="$(find /mnt/ftpspace/inspector/savehere/ -type f -ctime +150 | grep -c / )"
     echo "${total} files are older than 150 days!" >> /var/log/cron-result/$(date +%Y-%m-%d_RemovedFiles).log
	 
	      if [ $total -gt 0 ] ; then
        echo "${total} files are removed!" >> /var/log/cron-result/$(date +%Y-%m-%d_RemovedFiles).log
        find /mnt/ftpspace/inspector/savehere/ -type f -ctime +150 -print >> /var/log/cron-result/$(date +%Y-%m-%d_RemovedFiles).log -exec chattr$
     fi
  fi
  if [ $usep -ge $ALERT1 ] ; then
     echo "Running out of space \"$partition ($usep%)\" on server $(hostname), $(date), Alert=$ALERT1" >> /var/log/cron-result/$(date +%Y-%m-%d_RemovedFiles).log
     total="$(find /mnt/ftpspace/inspector/savehere/ -type f -ctime +183 | grep -c / )"
     echo "${total} files are older than 183 days!" >> /var/log/cron-result/$(date +%Y-%m-%d_RemovedFiles).log

     if [ $total -gt 0 ] ; then
        echo "${total} files are removed!" >> /var/log/cron-result/$(date +%Y-%m-%d_RemovedFiles).log
        find /mnt/ftpspace/inspector/savehere/ -type f -ctime +183 -print >> /var/log/cron-result/$(date +%Y-%m-%d_RemovedFiles).log -exec chattr$
     fi
  fi

done
}

if [ "$EXCLUDE_LIST" != "" ] ; then
  df -H | grep -vE "^Filesystem|tmpfs|cdrom|${EXCLUDE_LIST}" | awk '{print $5 " " $6}' | main_prog
else
  df -H | grep -vE "^Filesystem|tmpfs|cdrom" | awk '{print $5 " " $6}' | main_prog
fi

echo "program end @ $(date +%Y-%m-%d_%H:%M:%S)" >> /var/log/cron-result/$(date +%Y-%m-%d_RemovedFiles).log

echo "===========================" >> /var/log/cron-result/$(date +%Y-%m-%d_RemovedFiles).log
