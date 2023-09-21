#/bin/sh
#3.200
#*/30 * * * * root /usr/local/bin/shanchushuju.sh >/var/log/shanchushuju 2>&1
#0 0 * * 6 root /usr/local/bin/shanchushuju.sh >/var/log/shanchushuju 2>&1
#0 0 * * 1,3,5 root /usr/local/bin/shanchushuju.sh >/var/log/shanchushuju 2>&1
start_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $start_timeecho "Begin to remove data before 365 days"
#echo "introcks"|sudo -S find /data1/store69_1/ImgWareHouse/ -mindepth 3 -maxdepth 4 -mtime +365 -name "*.jpg" -exec rm -rfv {} \; 
echo "toortoor"|sudo -S find /mnt/data1/eng1store200_1/ImgWareHouse/ -mindepth 3 -maxdepth 4 -mtime +365 -name "*.jpg" -exec rm -rfv {} \;
echo "toortoor"|sudo -S find /mnt/data1/engine1store200_2/ImgWareHouse/ -mindepth 3 -maxdepth 4 -mtime +365 -name "*.jpg" -exec rm -rfv {} \;
#or execute echo "introcks"|sudo -S find /data/fastdfs/intellif_store/data/ -mindepth 3 -maxdepth 4 -mtime +365 -name "*" -delete -print 
end_time=$(date "+%Y-%m-%d %H:%M:%S")
echo $end_time
