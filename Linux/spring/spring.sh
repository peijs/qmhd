#!/bin/bash
OPERATE=$1
APP_NAME=$2
SYSTEM=`uname`
RUNNING="false";
#https://github.com/liuhaimingcn/spring-boot-start-shell

# 启动：
# sh spring.sh start cmpp.sms.gateway-1.0.jar
# sh spring.sh start sgip.sms.gateway-1.0.jar
# sh spring.sh start smgp.sms.gateway-1.0.jar

# 停止：

# sh spring.sh stop cmpp
# sh spring.sh stop sgip
# sh spring.sh stop smgp

# 检查应用的状态

# sh spring.sh check cmpp
# sh spring.sh check sgip
# sh spring.sh check smgp


# 查看进程

# sh spring.sh list all
# 检查应用是否在运行
function check() {
	echo "check running status..."
	if [ "${SYSTEM}" == 'Linux' ]; then
		tpid=`ps -ef|grep -n " java.*--name=$APP_NAME$"|grep -v grep|grep -v kill|awk '{print $2}'`
	else
		tpid=`ps -ef|grep -n " java.*--name=$APP_NAME$"|grep -v grep|grep -v kill|awk '{print $3}'`
	fi
	if [ ${tpid} ]; then
    	echo 'App is running.'
    	RUNNING="true"
	else
	    echo 'App is NOT running.'
	    RUNNING="false"
	fi
}

# 启动程序
function start() {
	filePah=${APP_NAME}
	# 处理相对路径
	if [ ${filePah:0:1} != "/" ]; then
		filePah="`pwd`/${filePah}"
	fi
	# 用文件名作为 APP_NAME
	APP_NAME=${filePah##*/}
	APP_NAME=${APP_NAME%%.*}

	# 检查是否已经存在
	check
	if [ ${RUNNING} == "true" ]; then
		echo "App already running!"
	else
		echo "start..."
		`nohup java -server -Xms4096M -Xmx4096M -XX:PermSize=4096M -XX:MaxPermSize=4096M -XX:NewSize=4096M -XX:MaxNewSize=4096M -Xss2048k -Xmn1024m  -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+DisableExplicitGC -XX:SurvivorRatio=6 -XX:+UseCMSCompactAtFullCollection -XX:MaxTenuringThreshold=0 -XX:ParallelGCThreads=4 -jar ${filePah} --name=${APP_NAME} > /dev/null 2>&1 &`
		check
		echo "Start success!"
	fi
}

# 停止程序
function stop() {
	if [ ${SYSTEM} == 'Linux' ]; then
		tpid=`ps -ef|grep -n " java.*--name=$APP_NAME$"|grep -v grep|grep -v kill|awk '{print $2}'`
	else
		tpid=`ps -ef|grep -n " java.*--name=$APP_NAME$"|grep -v grep|grep -v kill|awk '{print $3}'`
	fi
	if [ ${tpid} ]; then
	    echo 'Stop Process...'
	    kill -15 ${tpid}
	    # 检查程序是否停止成功
	    for ((i=0; i<10; ++i))  
		do  
			sleep 1
			if [ ${SYSTEM} == 'Linux' ]; then
				tpid=`ps -ef|grep -n " java.*--name=$APP_NAME$"|grep -v grep|grep -v kill|awk '{print $2}'`
			else
				tpid=`ps -ef|grep -n " java.*--name=$APP_NAME$"|grep -v grep|grep -v kill|awk '{print $3}'`
			fi
			if [ ${tpid} ]; then
				echo -e ".\c"
			else
				echo 'Stop Success!'
				break;
			fi
		done
		# 强制杀死进程
		if [ ${SYSTEM} == 'Linux' ]; then
			tpid=`ps -ef|grep -n " java.*--name=$APP_NAME$"|grep -v grep|grep -v kill|awk '{print $2}'`
		else
			tpid=`ps -ef|grep -n " java.*--name=$APP_NAME$"|grep -v grep|grep -v kill|awk '{print $3}'`
		fi
		if [ ${tpid} ]; then
		    echo 'Kill Process!'
		    kill -9 ${tpid}
		fi
	else
		echo 'App already stop!'
	fi
}

# 重启程序
function restart() {
	filePah=${APP_NAME}
	# 处理相对路径
	if [ ${filePah:0:1} != "/" ]; then
		filePah="`pwd`/${filePah}"
	fi
	# 用文件名作为 APP_NAME
	APP_NAME=${filePah##*/}
	APP_NAME=${APP_NAME%%.*}

	# 检查是否已经存在
	check
	if [ ${RUNNING} == "true" ]; then
		echo "App already running!"
	else
		echo "restart..."
		stop
		start
		check
		echo "Retart success!"
	fi
}
function list () {
	if [ ${APP_NAME} == "all" ]; then
		if [ ${SYSTEM} == 'Linux' ]; then
			ps -ef | grep -n "java.*--name="|grep -v grep|grep -v kill|awk '{printf $2"\t"$8"\t"} {split($11,b,"=");print b[2]}'
			res=`ps -ef | grep -n "java.*--name="|grep -v grep|grep -v kill|awk '{printf $2"\t"$8"\t"} {split($11,b,"=");print b[2]}' `
		else
			ps -ef | grep -n "java.*--name="|grep -v grep|grep -v kill|awk '{printf $3"\t"$9"\t"} {split($12,b,"=");print b[2]}'
			res=`ps -ef | grep -n "java.*--name="|grep -v grep|grep -v kill|awk '{printf $3"\t"$9"\t"} {split($12,b,"=");print b[2]}' `
		fi
	else
		if [ ${SYSTEM} == 'Linux' ]; then
			ps -ef | grep -n "java.*--name=${APP_NAME}$"|grep -v grep|grep -v kill|awk '{printf $2"\t"$8"\t"} {split($11,b,"=");print b[2]}'
			res=`ps -ef | grep -n "java.*--name=${APP_NAME}$"|grep -v grep|grep -v kill|awk '{printf $2"\t"$8"\t"} {split($11,b,"=");print b[2]}' `
		else
			ps -ef | grep -n "java.*--name=${APP_NAME}$"|grep -v grep|grep -v kill|awk '{printf $3"\t"$9"\t"} {split($12,b,"=");print b[2]}'
			res=`ps -ef | grep -n "java.*--name=${APP_NAME}$"|grep -v grep|grep -v kill|awk '{printf $3"\t"$9"\t"} {split($12,b,"=");print b[2]}' `
		fi
	fi
	if [ -z "$res" ]; then
		echo "None app running!"
	fi
}

# 参数检查
if [ -z ${OPERATE} ] || [ -z ${APP_NAME} ];then
	if [ -z ${OPERATE} ];
		then
			echo "OPERATE can not be null."
		else
			echo "APP_NAME can not be null."
	fi
else
	# 启动程序
	if [ ${OPERATE} == "start" ]; then
		start
	# 停止程序
	elif [ ${OPERATE} == "stop" ]; then
		stop
	# 重启程序
	elif [ ${OPERATE} == "restart" ]; then
		restart
	# 检查查询运行状态
	elif [ ${OPERATE} == "check" ]; then
		check
	# 查询所有项目
	elif [ ${OPERATE} == "list" ]; then
		list
	else
		echo "Not supported the OPERATE."
	fi
fi