#!/bin/bash
cat /var/log/secure|awk '/Failed/{print $(NF-3)}'|sort|uniq -c|awk '{print $2"="$1;}' > /var/log/black.txt
	for i in `cat  /var/log/black.txt`
		do
		IP=`echo $i |awk -F= '{print $1}'`
		NUM=`echo $i|awk -F= '{print $2}'`
		if [ $NUM -gt 5 ]; then
			grep $IP /etc/hosts.deny > /dev/null ##检索IP是否已存在于hosts.deny
			if [ $? -gt 0 ];then ##$?上一条命令的执行结果，0有正常输出，其他异常
				echo "sshd:$IP" >> /etc/hosts.deny ##增加屏蔽登录失败的IP
			fi
		fi
	done
