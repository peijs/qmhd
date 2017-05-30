@echo off
forfiles /p "E:\Softwareinstalllist\poweru\tomcat\logs" /s /m *.log.* /d -9 /c "cmd /c del @path
forfiles /p "E:\Softwareinstalllist\poweru\SMGW\logs" /s /m *.log.* /d -9 /c "cmd /c del @path