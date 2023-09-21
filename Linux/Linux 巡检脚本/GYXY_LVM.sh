#!/bin/bash
# Function:使用一整块硬盘创建LVM逻辑卷
lsblk
echo "注意！查看需要分区的磁盘编号，以及提前确认挂载的路径是否和下面一样"
read -p "请输入你要做成逻辑卷的硬盘(写绝对路径，如：/dev/sda)：" path
if [ -e $path ];then
  echo "true"
else
  echo "该设备不存在！！"
  exit
fi
pvcreate $path
echo "该硬盘已做成物理卷！"
vgcreate Vg_gyxy $path
echo "该物理卷已加入卷组 Vg_gyxy 中"
vgs
free=`vgs| awk '$1~/Vg_gyxy/{print}'|awk '{print $6}'`
echo "该物理卷剩余的空间大小为：$free "
read -p "请输入你要创建逻辑卷的大小(如：1G)：" repy2
lvcreate -L $repy2 -n Lv_gyxy Vg_gyxy
echo "已成功创建逻辑卷Lv_gyxy"
echo "------------------------"
lvs
echo "------------------------"
echo "你想对新分区设定什么类型的文件系统？有以下选项："
echo "A：ext4文件系统"
echo "B：xfs文件系统"
read -p "请输入你的选择：" repy3
case $repy3 in
        a|A)
           mkfs.ext4 /dev/mapper/Vg_gyxy-Lv_gyxy
           echo "该分区将被挂载在 "/data" 下" 
           m=`ls / |grep -w data | wc -l`
           if [ $m -eq 0 ];then
            mkdir /data
           fi
           echo "/dev/mapper/Vg_gyxy-Lv_gyxy     /data    ext4         defaults          0      0" >> /etc/fstab
           mount -a
           df -Th
;;
        b|B)
           mkfs.xfs -f /dev/mapper/Vg_gyxy-Lv_gyxy
           echo "该分区将被挂载在 "/data" 下" 
           m=`ls / |grep -w data | wc -l`
           if [ $m -eq 0 ];then
              mkdir /data
           fi
           echo "/dev/mapper/Vg_gyxy-Lv_gyxy     /data     xfs       defaults          0      0" >> /etc/fstab
           mount -a
           df -Th
;;
        *)
           echo "你的输入有误！！"
esac