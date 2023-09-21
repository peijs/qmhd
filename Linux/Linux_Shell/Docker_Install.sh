#!/bin/bash
#https://blog.csdn.net/qq_44535093/article/details/125147632
#https://blog.csdn.net/weixin_39168541/article/details/129408077
#https://blog.csdn.net/weixin_45894220/article/details/129242510
echo "(1/8): 关闭Selinux"
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
#临时关闭，不用重启
setenforce 0
echo "(2/8): 解压Docker安装文件..."
#https://download.docker.com/linux/static/stable/x86_64/
tar -zxvf docker-24.0.2.tgz
sleep 5
echo "(2/8): Docker安装文件解压完毕"
echo "(3/8): 迁移Docker文件..."
mv docker/* /usr/bin
echo "(3/8): Docker文件迁移完成"
echo "(4/8): 创建新的Docker数据目录"
mkdir -p /data/DockerData/
echo "(4/8): Docker数据目录创建完成"
echo "(5/8): 将Docker添加到service服务..."
cat << EOF > /usr/lib/systemd/system/docker.service
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker
ExecStart=/usr/bin/dockerd -H unix:///var/run/docker.sock --log-opt max-size=50m --log-opt max-file=10 --data-root=/data/DockerData
ExecReload=/bin/kill -s HUP $MAINPID
TimeoutStartSec=0
RestartSec=2
Restart=always

# Note that StartLimit* options were moved from "Service" to "Unit" in systemd 229.
# Both the old, and new location are accepted by systemd 229 and up, so using the old location
# to make them work for either version of systemd.
StartLimitBurst=3

# Note that StartLimitInterval was renamed to StartLimitIntervalSec in systemd 230.
# Both the old, and new name are accepted by systemd 230 and up, so using the old name to make
# this option work for either version of systemd.
StartLimitInterval=60s

# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity

# Comment TasksMax if your systemd version does not support it.
# Only systemd 226 and above support this option.
TasksMax=infinity

# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes

# kill only the docker process, not all processes in the cgroup
KillMode=process
OOMScoreAdjust=-500

[Install]
WantedBy=multi-user.target
EOF
sleep 3
systemctl daemon-reload
echo "(5/8): Docker添加到service服务完成"
echo "(6/8): 首次启动Docker..."
systemctl start docker
sleep 2
echo "(6/8): Docker首次启动完毕"
echo "(7/8): 查看Docker状态..."
systemctl status docker
echo "(7/8): Docker状态查看完毕"
echo "(8/8): 添加开机自启动..."
systemctl enable docker.service
echo "(8/8): 已添加到开机自启动中..."