#!/bin/sh

#vmware 192.168.0.118
# run in /etc/rc.local.d/monitor_file_server.sh
# /vmfs/volumes/59005b72-67add064-00b1-14187747a94a/ubuntu16-webmin/monitor_file_server.sh
# local configuration options

# Note: modify at your own risk!  If you do/use anything in this
# script that is not part of a stable API (relying on files to be in
# specific places, specific tools, specific output, etc) there is a
# possibility you will end up with a broken system after patching or
# upgrading.  Changes are not supported unless under direction of
# VMware support.

# Note: This script will not be run when UEFI secure boot is enabled.

#Program:
# This program is to monitor 192.168.0.107/101.78.241.186 file server, if down, machine will be rebooted.
#15 Jan 2018 created by Jimmy Chu


NOW=$(date +%Y-%m-%d_%H:%M:%S)

ping -c8 192.168.0.107 &> /dev/null

if [ $? -gt 0 ]; then

    echo "==========================" >> /vmfs/volumes/59005b72-67add064-00b1-14187747a94a/ubuntu16-webmin/error-reboot.log

    echo "$NOW  |  + 8 hours is HKT - 192.168.0.107 VM reboot" >> /vmfs/volumes/59005b72-67add064-00b1-14187747a94a/ubuntu16-webmin/error-reboot.log

    echo "==========================" >> /vmfs/volumes/59005b72-67add064-00b1-14187747a94a/ubuntu16-webmin/error-reboot.log

    vim-cmd vmsvc/power.off 6

    vim-cmd vmsvc/power.on 6

fi

exit 0
