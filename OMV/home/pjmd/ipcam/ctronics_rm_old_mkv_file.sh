#!/bin/bash

# Run as cron jobs every day 9AM (keep 14 days of recordings)
# 0 9 * * * /home/pjmd/ipcam/ctronics_rm_old_mkv_file.sh

IPCAM_REPO=/srv/dev-disk-by-uuid-a77d5d6f-f6d9-436a-a5a7-12810fa8cc53/data/ipcam_repo/

# find $IPCAM_REPO/ -maxdepth 1 -type d -mtime +14 -print
find  $IPCAM_REPO/ -maxdepth 1 -type f -mtime +14 -exec rm -rf {} \;
