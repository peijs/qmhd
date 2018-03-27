# 目录
[系统设置](#系统设置)

[系统清理](#系统清理)

[系统更新](#系统更新)

[系统美化](#系统美化)

[软件安装](#软件安装)

 1. VIM 
 2. Sublime-text-3
 3. Typora
 4. Bleachbit
 5. 为知笔记
 6. ss客户端
 7. LAMP开发框架
 8. JDK安装
 9. wps字体缺失
 10. easystroke手势软件
 11. node安装

# 系统设置

```shell
//Ubuntu的root密码是随机的，需要给其设置密码
sudo passwd
//Ubuntu 16的Grub2菜单的相关信息在/boot/grub/grub.cfg中，不过Ubuntu官方不建议直接修改这个文件，想要修改Grub2的等待时间还可以修改/etc/default/grub，将GRUB_TIMEOUT=10改为你想修改的等待时间，然后将GRUB_HIDDEN_TIMEOUT=0注释掉
sudo vim /etc/default/grub
sudo update-grub2//刷新/boot/grub/grub.cfg
//双系统时间不一致
sudo apt-get install ntpdate
sudo ntpdate time.windows.com
sudo hwclock --localtime --systohc
//将启动器移动到屏幕底部
gsettings set com.canonical.Unity.Launcher launcher-position Bottom
//启动“单击时最小化”
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ launcher-minimize-window true
//解决依赖报错
sudo apt-get -f install +
```


# 系统清理

```shell
//删除Firefox
dpkg --get-selections | grep firefox//查看firefox版本
sudo apt-get purge firefox firefox-locale-en unity-scope-firefoxbook
//删除libreoffice
sudo apt-get remove libreoffice-common 
//删除Amazon的链接
sudo apt-get remove unity-webapps-common 
//清理不常用的软件
sudo apt-get purge thunderbird totem rhythmbox empathy brasero simple-scan gnome-mahjongg aisleriot
sudo apt-get purge gnome-mines cheese transmission-common gnome-orca webbrowser-app gnome-sudoku  landscape-client-ui-install
sudo apt-get purge onboard deja-dup 
//清理旧版本的软件缓存
sudo apt-get autoclean
//清理所有软件缓存
sudo apt-get clean
//删除系统不再使用的孤立软件
sudo apt-get autoremove
```

# 系统更新

```shell
sudo apt-get update
sudo apt-get upgrade
```

# 系统美化

```shell
sudo apt-get install unity-tweak-tool //Unity 图形化管理工具
//Flatabulous主题
sudo add-apt-repository ppa:noobslab/themes
sudo apt-get update
sudo apt-get install flatabulous-theme
//Flatabulous主题有配套的图标
sudo add-apt-repository ppa:noobslab/icons
sudo apt-get update
sudo apt-get install ultra-flat-icons
```

# 软件安装

 1. Vim：`sudo apt-get install vim`
 2. Sublime-text-3：
```shell
sudo add-apt-repository ppa:webupd8team/sublime-text-3    
sudo apt-get update    
sudo apt-get install sublime-text
```
 3. Typora：
```shell
# optional, but recommended
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BA300B7755AFCFAE
# add Typora's repository
sudo add-apt-repository 'deb https://typora.io ./linux/'
sudo apt-get update
# install typora
sudo apt-get install typora
```
 4. Bleachbit
```shell
sudo apt-get install gdebi
wget katana.oooninja.com/bleachbit/sf/bleachbit_1.4_all_ubuntu1404.deb
sudo gdebi bleachbit_1.4_all_ubuntu1404.deb
sudo apt-get remove bleachbit//卸载命令
```
 5. 为知笔记
```
sudo add-apt-repository ppa:wiznote-team
sudo apt-get update
sudo apt-get install wiznote
```
 6. ss客户端 
```
sudo add-apt-repository ppa:hzwhuang/ss-qt5
sudo apt-get update
sudo apt-get install shadowsocks-qt5
```
7. LAMP开发框架
```shell
sudo apt install apache2#安装Apache2
sudo apt install php7.0#安装php7，继续按tab查看组建扩展
sudo apt install libapache2-mod-php7.0#整合Apache和php
sudo apt install mysql-server mysql-client#安装MySQL
sudo apt-get install php7.0-mysql#整合php和MySQL
sudo service mysql restart
sudo service apache2 restart
#之后修改/etc/mysql/my.cnf，添加如下配置节修改默认的字符集：
[client]
default-character-set=utf8
[mysql]
default-character-set=utf8
[mysqld]
collation-server = utf8_unicode_ci
init-connect='SET NAMES utf8'
character-set-server = utf8
# mysql> show variables like '%char%';
#选择安装phpmyadmin
sudo apt-get install phpmyadmin
sudo apt-get install php-mbstring
sudo apt-get install php-gettext
sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
nano /etc/php/7.0/apache2/php.ini#配置phpmyadmin
display_errors = On#显示错误日志，出现两次，都要改，不然无效
extension=php_mbstring.dll#开启mbstring
#测试LAMP是否整合安装成功
sudo touch /var/www/html/test.php#//默认apache网站root目录是/var/www
sudo vim /var/www/html/test.php#phpinfo();
#更改站点目录
sudo vim /etc/apache2/sites-enabled/0xxxxxx
DocumentRoot /home/windrivder/Documents/Web#这里配置完成后测试会报错：You don't have permission to access /test.php on this server.
sudo vim /etc/apache2/apache2.conf
<Directory /home/windrivder/Documents/Web>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
</Directory>
sudo service apache2 restart
#利用在网络服务配置与管理的知识，做一个本地域名解析，绑定虚拟目录
sudo vim /etc/hosts#修改hosts文件做本地解析
127.0.0.1    test.com#在文件中加入 127.0.0.1  test.com
touch /etc/apache2/sites-enabled/www.test.com#apache默认会加载/etc/apache2/sites-enabled目录下的所有配置文件,将0xxxxx配置文件的内容拷贝进www.test.com修改
#使用phpstorm
sudo apt-get install php-cgi
```
8. JDK安装
```shell
sudo mkdir /usr/lib/jvm 
sudo tar -C /usr/lib/jvm -xzf jdk.tar.gz 
sudo vim ~/.bashrc
export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_101   
export JRE_HOME=${JAVA_HOME}/jre  
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib  
export PATH=${JAVA_HOME}/bin:$PATH
```
9. wps字体缺失
```shell
sudo cp * /usr/share/fonts
cd /usr/share/fonts/
sudo mkfontscale
sudo mkfontdir
sudo fc-cache
```
10. easystroke手势软件
```shell
sudo apt-get install easystroke
```
11. node安装
```shell
tar -xf node-v6.10.1-linux-x64.tar 
cd node-v6.10.1-linux-x64/
sudo cp -r bin/* /usr/local/bin/ 
sudo cp -r lib/* /usr/local/lib/ 
sudo cp -r include/* /usr/local/include/
whereis node 
sudo ln -s /usr/local/bin/node /usr/bin/node 
sudo ln -s /usr/local/bin/npm /usr/bin/npm
node -v 
npm -v
```
