#!/bin/sh

# func:自动监控tomcat脚本并且执行重启操作（http://blog.csdn.net/ygh_0912/article/details/11081219）
# author:danny
# date:02/20/2013
# DEFINE

# 获取tomcat进程ID
TomcatID=$(ps -ef |grep tomcat |grep -w '/data/UnicomSMS/Tomcat7/bin'|grep -v 'grep'|awk '{print $2}')

# tomcat启动程序(这里注意tomcat实际安装的路径)
StartTomcat=/data/UnicomSMS/Tomcat7/bin
#TomcatCache=/data/UnicomSMS/Tomcat7/work

# 定义要监控的页面地址
WebUrl=http://10.10.10.3:8080

# 日志输出
GetPageInfo=/dev/null
TomcatMonitorLog=/data/UnicomSMS/Monitor/TomcatMonitor.log
#JAVA_HOME变量
#jdk1.7.0_72
export JAVA_HOME=/data/UnicomSMS/jdk1.7.0_80
export ClASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$PATH:$JAVA_HOME/bin
export JDK_HOME=/data/UnicomSMS/jdk1.7.0_80
export JRE_HOME=/data/UnicomSMS/jdk1.7.0_80
#Tomcat7.0.62
export CLASSPATH=.:$CATALINA_HOME$/bin:$CATALNA_HOME$/commom/lib/servlet/jar
export CATALINA_BASE=/data/UnicomSMS/Tomcat7
export CATALINA_HOME=/data/UnicomSMS/Tomcat7
Monitor()
{
  echo "[info]开始监控tomcat...[$(date +'%F %H:%M:%S')]"
  if [[ $TomcatID ]];then # 这里判断TOMCAT进程是否存在
    echo "[info]当前tomcat进程ID为:$TomcatID,继续检测页面..."
    # 检测是否启动成功(成功的话页面会返回状态"200")
    TomcatServiceCode=$(curl -s -o $GetPageInfo -m 10 --connect-timeout 10 $WebUrl -w %{http_code})
    if [ $TomcatServiceCode -eq 200 ];then
        echo "[info]页面返回码为$TomcatServiceCode,tomcat启动成功,测试页面正常......"
    else
        echo "[error]tomcat页面出错,请注意......状态码为$TomcatServiceCode,错误日志已输出到$GetPageInfo"
        echo "[error]页面访问出错,开始重启tomcat"
        kill -9 $TomcatID  # 杀掉原tomcat进程
        #sleep 3
        #rm -rf $TomcatCache # 清理tomcat缓存
	sh $StartTomcat/startup.sh start
        #$StartTomcat
    fi
  else
    echo "[error]tomcat进程不存在!tomcat开始自动重启..."
    echo "[info]$StartTomcat,请稍候......"
    #rm -rf $TomcatCache
    sh $StartTomcat/startup.sh start
    #$StartTomcat
  fi
  echo "[info]Tomcat 已经启动成功,请查看!"
}
Monitor>>$TomcatMonitorLog
