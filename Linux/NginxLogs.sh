#!/bin/bash
#������־�ļ����Ŀ¼
#crontab -e
#0 * * * * /data/sh/split_nginx_log.sh
logs_dir="/usr/local/nginx/logs"
# ����nginx reload���reload�Ż��ͷ��ļ��������Ȼ�ͻ�һֱд��mv֮�����־�ļ�
nginx_reload="/usr/local/nginx/sbin/nginx -s reload "
# �������ڸ�ʽ
date_format=$(date -d "1 hours" +%Y%m%d%H)
for i in `ls ${logs_dir}/*.log`
do
 mv $i ${i}_${date_format}
done
eval $nginx_reload