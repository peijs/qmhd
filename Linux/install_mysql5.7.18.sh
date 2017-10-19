#!/bin/bash
# author:letian 
# Email:412166174@qq.com
if [ $UID -ne 0 ];then
   echo "Must be use ROOT"
   exit 1
fi 
port=3306
ip_last=20
#Linux限制更改centos6
#sed -i 's@1024@20480@g' /etc/security/limits.d/90-nproc.conf
#Linux限制更改centos7
sed -i 's@1024@20480@g' /etc/security/limits.d/20-nproc.conf 
#set system 
cat >>/etc/profile <<EOF
# PS1
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\W\[\033[00m\]\$ '
LS_COLORS='di=36:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
alias dstat='dstat -tclmsdnpyg'
alias grep='grep --color=auto'

# history command.
export HISTFILESIZE=1000000000
export HISTSIZE=1000000
export PROMPT_COMMAND="history -a"
export HISTTIMEFORMAT="%Y-%m-%d_%H:%M:%S "

#system 
ulimit -u 20480
ulimit -n 20480
ulimit -d unlimited
ulimit -m unlimited
ulimit -s unlimited
ulimit -t unlimited
ulimit -v unlimited
EOF
#yum -y update
#yum -y install gcc gcc-c++ openssl openssl-devel zlib zlib-devel libaio wget lsof vim-enhanced sysstat ntpdate
sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
setenforce 0
 
ntpdate time.nist.gov;hwclock -w
timedatectl set-timezone "Asia/Shanghai"
 
groupadd mysql
useradd -r -g mysql -s /sbin/nologin mysql
 
mkdir /opt/mysql /data/mysql/mysql${port}/{data,logs,tmp} -p
 
cd /opt
tar xf mysql-5.7.18-linux-glibc2.5-x86_64.tar.gz -C /opt/mysql
ln -s /opt/mysql/mysql-5.7.18-linux-glibc2.5-x86_64 /usr/local/mysql
chown mysql.mysql /opt/mysql /usr/local/mysql /data/mysql -R
echo 'PATH=$PATH:/usr/local/mysql/bin' > /etc/profile.d/mysql.sh
source /etc/profile
 
cat > /etc/my.cnf << EOF
#my.cnf
[client]
port = ${port}
socket = /tmp/mysql${port}.sock
 
[mysql]
prompt="\u@\h [\d]>" 
 
[mysqld]
user = mysql
basedir = /usr/local/mysql
datadir = /data/mysql/mysql${port}/data
port = ${port}
socket = /tmp/mysql${port}.sock
event_scheduler = 0
explicit-defaults-for-timestamp=on
tmpdir = /data/mysql/mysql${port}/tmp

#timeout
interactive_timeout = 300
wait_timeout = 300
 
#character set
character-set-server = utf8mb4

lower_case_table_names=1
open_files_limit = 65535
max_connections = 2000
max_connect_errors = 100000

#logs
log-output=file
slow_query_log = 1
slow_query_log_file = slow.log
log-error = error.log
log_error_verbosity=3
pid-file = mysql.pid
long_query_time = 1
log-slow-slave-statements = 1
 
#binlog
auto_increment_increment = 1
auto_increment_offset = 1
binlog_format = row
server-id = ${port}${ip_last}
log-bin = /data/mysql/mysql${port}/logs/mysql-bin
binlog_cache_size = 4M
max_binlog_size = 512M
max_binlog_cache_size = 1M
sync_binlog = 1
expire_logs_days = 10
#procedure 
log_bin_trust_function_creators=1
 
#
gtid-mode=on
binlog_gtid_simple_recovery = 1
enforce_gtid_consistency = 1
log_slave_updates
 
#relay log
skip_slave_start = 1
max_relay_log_size = 500M
relay_log_purge = 1
relay_log_recovery = 1
relay-log=relay-bin
relay-log-index=relay-bin.index
#slave-skip-errors=1032,1053,1062
 
#buffers & cache
table_open_cache = 2048
table_definition_cache = 2048
table_open_cache = 2048
max_heap_table_size = 96M
sort_buffer_size = 16M
join_buffer_size = 16M
thread_cache_size = 3000
query_cache_size = 0
query_cache_type = 0
query_cache_limit = 256K
query_cache_min_res_unit = 512
thread_stack = 192K
tmp_table_size = 96M
key_buffer_size = 8M
read_buffer_size = 2M
read_rnd_buffer_size = 16M
bulk_insert_buffer_size = 32M
 
#myisam
myisam_sort_buffer_size = 128M
myisam_max_sort_file_size = 10G
myisam_repair_threads = 1
 
#innodb
innodb_buffer_pool_size = 4G
innodb_buffer_pool_instances = 1
innodb_data_file_path = ibdata1:1G:autoextend
innodb_flush_log_at_trx_commit = 1
innodb_log_buffer_size = 1G
innodb_log_file_size = 100M
innodb_log_files_in_group = 3
innodb_max_dirty_pages_pct = 50
innodb_file_per_table = 1
innodb_rollback_on_timeout
innodb_status_file = 1
transaction_isolation = REPEATABLE-READ
innodb_flush_method = O_DIRECT
innodb_lock_wait_timeout = 10
innodb_rollback_on_timeout = 1
innodb_print_all_deadlocks = 1
innodb_file_per_table = 1
innodb_online_alter_log_max_size = 1G
internal_tmp_disk_storage_engine = InnoDB
innodb_stats_on_metadata = 0

#io
innodb_io_capacity = 4000
innodb_io_capacity_max = 8000
innodb_flush_neighbors = 0
innodb_write_io_threads = 8
innodb_read_io_threads = 8
innodb_purge_threads = 4
innodb_page_cleaners = 4


#innodb monitor
innodb_monitor_enable="module_innodb"
innodb_monitor_enable="module_server"
innodb_monitor_enable="module_dml"
innodb_monitor_enable="module_ddl"
innodb_monitor_enable="module_trx"
innodb_monitor_enable="module_os"
innodb_monitor_enable="module_purge"
innodb_monitor_enable="module_log"
innodb_monitor_enable="module_lock"
innodb_monitor_enable="module_buffer"
innodb_monitor_enable="module_index"
innodb_monitor_enable="module_ibuf_system"
innodb_monitor_enable="module_buffer_page"
innodb_monitor_enable="module_adaptive_hash"
EOF
 
cd /usr/local/mysql/
./bin/mysqld --initialize-insecure
cp support-files/mysql.server /etc/init.d/mysqld
echo 'export PATH=/usr/local/mysql/bin:$PATH' >>/etc/profile
source /etc/profile
/etc/init.d/mysql start
