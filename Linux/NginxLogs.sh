#!/bin/bash
#设置日志文件存放目录
#crontab -e
#0 * * * * /data/sh/split_nginx_log.sh
logs_dir="/usr/local/nginx/logs"
# 设置nginx reload命令，reload才会释放文件句柄，不然就会一直写到mv之后的日志文件
nginx_reload="/usr/local/nginx/sbin/nginx -s reload "
# 设置日期格式
date_format=$(date -d "1 hours" +%Y%m%d%H)
for i in `ls ${logs_dir}/*.log`
do
 mv $i ${i}_${date_format}
done
eval $nginx_reload