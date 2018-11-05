
#!/bin/sh
#Program:
# This program is to change the file access right under ftpspace/inspector/savehere
# This program will search all the files in every 5 minutes. If owner is inspector, this program will change to manager.
# inspector can only upload files to server

#10 Nov 2017 created by Jimmy Chu

total="$(find /mnt/ftpspace/inspector/savehere/ -type f -name "*" -user inspector | grep -c / )"

NOW=$(date +%Y-%m-%d_%H:%M:%S)

if [ $total -gt 0 ]
then

echo "==========================" >> /var/log/cron-result/$(date +%Y-%m-%d_ChangePermissonFiles).log

echo "$NOW  |  ${total} files's permission are applied!" >> /var/log/cron-result/$(date +%Y-%m-%d_ChangePermissonFiles).log

echo "==========================" >> /var/log/cron-result/$(date +%Y-%m-%d_ChangePermissonFiles).log

find /mnt/ftpspace/inspector/savehere/ -type f -name "*" -user inspector -print >> /var/log/cron-result/$(date +%Y-%m-%d_ChangePermissonFiles).log -exec chown managers: {} \; -exec chmod 700 {} \;

fi
