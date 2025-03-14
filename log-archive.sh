# # Log Archival Script

# This is a Bash script designed to archive and compress log files from a specified directory. It also clears the original log files after archiving them. The script is useful for managing log files by backing them up and freeing up disk space.


# ## **Script Overview**

# The script performs the following tasks:
# 1. **Archives Log Files**:
#    - Copies all `.log` files from `/opt/log/` to `/opt/log/backup/` with a timestamp appended to the filename.
# 2. **Clears Original Log Files**:
#    - After copying, the script truncates the original log files to free up space.
# 3. **Compresses Archived Logs**:
#    - Compresses the archived log files using the `xz` compression tool.
# 4. **Logs Start and End Timestamps**:
#    - Outputs start and end timestamps to the console for tracking script execution.



## **Script Code**

#!/bin/bash

DATE=`date +"%m_%d_%Y_%H"`
echo -e  "\n==========  $DATE log-archive.sh START ==========" 

# Archive and clear log files
for f in /opt/log/*.log; do
  target=${f#/opt/log/}
  cp "$f" /opt/log/backup/"${target%.log}_$DATE.log"
  cat /dev/null > "$f"
done

# Compress archived logs
xz /opt/log/backup/*.log

echo -e  "\n==========  $DATE log-archive.sh END =========="
