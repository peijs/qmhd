#!/bin/bash

LOG_FILE="/var/log/sync.log"  # 指定日志文件路径

while true; do
  sync
  echo "Sync command executed at $(date)" >> "$LOG_FILE"
  sleep 60
done
