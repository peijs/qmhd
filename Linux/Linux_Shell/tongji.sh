#!/bin/bash
#巡检报告

#system
system_cpu_use=`top -bn 1 -i -c |grep -w sy|awk '{print $3}'` #取cpu使用率
#echo 1 > /proc/sys/vm/drop_caches #清理缓存
system_mem_use=`free -m | sed -n '2p' | awk '{print $3}'` #取内存使用量
system_mem_total=`free -m | sed -n '2p' | awk '{print $2}'` #取内存总大小
system_mem_b=`free -m | sed -n '2p' | awk '{print $3/$2*100"%"}'` #计算使用量比例
system_process=`ps -ef  | wc -l` #取进程数
system_root=`df -h |grep -w / |awk '{print $4,$1}'` #系统盘根的可用，总量取值
system_data=`df -h |grep -w /data |awk '{print $4,$1}'` #/data盘的可用，总量取值

#data/UnicomSMS
tomcat_log=`du -sh /data/UnicomSMS/SGIP/logs/ |awk '{print $1}'` #tomcat日志量

#输出
echo "
+==================================+
             system                
+----------------------------------+
  cpu    | 使用率：$system_cpu_use 
+----------------------------------+
  内存   | 使用率：$system_mem_b   
+----------------------------------+
  进程   | 进程数：$system_process 
+----------------------------------+
   /     | 已用+总共：$system_root 
+----------------------------------+
  /data  | 已用+总共：$system_data 
+----------------------------------+

          华丽的分割线

+===================================+
    /data/UnicomSMS/SGIP/logs
+-----------------------------------+
 logs   | 日志量：$tomcat_log
+-----------------------------------+
"
