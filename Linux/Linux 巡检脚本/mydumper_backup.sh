#!/bin/bash
#https://github.com/peijs/UnicomSMS
#还原脚本
#myloader -u root -p toortoor -P 3307 --socket=/data/UnicomSMS/Mysql8.0.27/mysql.sock -B zabbix -t 10 -v 3 -d ./mysql_backup/
# 设置备份目录和文件名
backup_dir="/data/backup"
backup_file="backup_$(date +'%Y%m%d-%H%M%S')"
baklog=$BACKUPDIR/var/log/mydumper.log
mkdir -p $backup_dir/$backup_file
FullBakDir=$backup_dir/$backup_file
mydumper_args="--user=root --password=toortoor -P 3306 --host=localhost --socket=/data/UnicomSMS/Mysql8.0.30/mysql.sock -B zabbix -t 4 -v 3 -G -R -E -o $FullBakDir"
# 执行备份
echo -e $(date) "开始备份..." | tee -a ${baklog} 2>&1
mydumper $mydumper_args >> ${baklog} 2>&1
cd $backup_dir
echo -e $(date) "$backup_file.tar.gz 备份打包完成" | tee -a ${baklog} 2>&1
tar -zcvf $backup_file.tar.gz $backup_file --remove-files

# 检查备份是否成功
if [ $? -eq 0 ]; then
    echo -e $(date) "备份完成！" | tee -a ${baklog} 2>&1
else
    echo -e $(date) "备份失败！" | tee -a ${baklog} 2>&1
fi
