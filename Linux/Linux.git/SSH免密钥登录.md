### 创建密钥
```shell
# 首先在本机上创建 SSH KEY 密钥对：
$ ssh-keygen    # -t 加密方式
$ ssh-keygen -t RSA -b 4096        # RSA密钥默认长度是2048
```

### 上传密钥
```shell
# 将id_rsa.pub密钥上传至服务器中
# 方式一：
$ ssh-copy-id username@remote-server

# 方式二：
# 若服务器端没有.ssh目录，需要手动创建：
$ mkdir ~/.ssh
$ chmod 700 ~/.ssh
$ touch ~/.ssh/authorized_keys 
$ chmod 600 ~/.ssh/authorized_keys
# 将id_rsa.pub复制到authorized_keys中
$ scp ~/.ssh/id_rsa.pub root@remote-server: ~/.ssh
# 以上scp命令远程拷贝命令
# 公钥追加到授权KEY里面
$ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```
