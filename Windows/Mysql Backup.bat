@echo off
::mysql_backup.bat
set hour=%time:~0,2%
if "%time:~0,1%"==" " set hour=0%time:~1,1%
set now=%Date:~0,4%%Date:~5,2%%Date:~8,2%%hour%%Time:~3,2%%Time:~6,2%
::����ip
set host=127.0.0.1
::�˿�
set port=3306
::�û�
set username=root
::����
set password=esa@2011
::Ҫ�������ݿ�����֣�����ж�������ÿո�ָ� 
set databasename=hd_sms
:: MySQL Bin Ŀ¼ 
:: ����ڰ�װ����ʱ��� MySQL Bin Ŀ¼���˻�������(PATH) ���˴��������� 
set MYSQL=
::����SQL����·��
set DIR=D:\backup\db\
:: ��������MySQL�ı���Ŀ¼ 
if not exist %DIR% ( 
    mkdir %DIR% 2>nul 
) 
  
if not exist %DIR% ( 
    echo Backup path: %DIR% not exists, create dir failed. 
    goto exit
) 
  
echo start mysqldump ... 
  
for %%i in (%databasename%) do ( 
    %MYSQL%mysqldump -h%host% -P%port% -u%username% -p%password% %%i > %DIR%%%i-%now%.sql 2>nul 
) 
  
echo end mysqldump 
::��¼����״̬��������־��¼ 
%MYSQL%mysql -h%host% -P%port% -u%username% -p%password% -Bse "select now();show master status\G" > %DIR%MySQL_status-%now%.log 
echo delete files before 60 days 
::ɾ��60��ǰ�ı��� 
forfiles /p "D:\backup\db" /m *.* /d -60 /c "cmd /c del @file /f"
  
:exit