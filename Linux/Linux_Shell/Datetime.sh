#!/bin/bash
#让时间静止
timedatectl set-ntp false 
step=1 #间隔的秒数，不能大于60 
for (( i = 0; i < 60; i=(i+step) )); do
  timedatectl set-time "2022-12-12 14:25:00" 
  sleep $step
done
exit 0
