

#!/bin/bash
#Program:
#version:v2
# This program is to backup /mnt/ftpspace/* into /mnt/md3200i
# 08 Aug 2018 created by Jimmy Chu
# -------------------------------------------------------------------------

## loop 5 times if it is not mounted. on contrary, it will start rsync to md3200i folder.

for counter in {1..100}
do
  ## check whether it is mounted or not.
  if grep -qs '/mnt/md3200i ' /proc/mounts; then
    echo "It's mounted and will start rsync. ${counter} " >> /var/log/cron-result/rsync-$(date +%F).log
    echo "----------------------------------" >> /var/log/cron-result/rsync-$(date +%F).log
    rsync -az --bwlimit=5000 --omit-dir-times --log-file=/var/log/cron-result/rsync-$(date +%F).log /mnt/ftpspace/ /mnt/md3200i
    break
  else
    echo "It's not mounted and will start mounting." >> /var/log/cron-result/rsync-$(date +%F).log
    mount -t cifs -o username=fileserver107,password=h8chATho,iocharset=utf8,noexec,vers=1.0  //192.168.0.17/fileserver-107 /mnt/md3200i
  fi

done

exit 0


