:: Script de relance Tomcat. Sauve et vide les logs ainsi que le cache
:: Auteur : Vincent OTTEVAERE vottevaere@esii.com
#https://github.com/wustrive2008/linux-bash-tools
@ECHO OFF
echo ---------------------------------------
echo - ESII - Script de redemarrage Tomcat -
echo ---------------------------------------

:Begin
echo:
SET Tomcat7=tomcat7.exe
SET java=java.exe
TASKLIST | FINDSTR /I "%Tomcat7%" >nul
IF ERRORLEVEL 1 (GOTO :TestJava) ELSE (GOTO :StopTomcat)

:TestJava
TASKLIST | FINDSTR /I "%java%" >nul
IF ERRORLEVEL 1 (GOTO :StartScripts) ELSE (GOTO :StopJava)

:StopTomcat
echo - Tomcat est en cours de fonctionnement. Tentative d'arret.
ping -n 3 127.0.0.1 >0
echo:
taskkill /F /IM tomcat7.exe >nul
ping -n 3 127.0.0.1 >0
TASKLIST | FINDSTR /I "%Tomcat7%" >nul
IF ERRORLEVEL 1 (GOTO :StartScripts) ELSE (GOTO :StopTomcat)
ping -n 3 127.0.0.1 >0
GOTO :Begin

:StopJava
echo - Tomcat est en cours de fonctionnement. Tentative d'arret.
ping -n 3 127.0.0.1 >0
echo:
taskkill /F /IM java.exe >nul
ping -n 3 127.0.0.1 >0
TASKLIST | FINDSTR /I "%java%" >nul
IF ERRORLEVEL 1 (GOTO :StartScripts) ELSE (GOTO :StopJava)
ping -n 3 127.0.0.1 >0
GOTO :Begin

:StartScripts 
TASKLIST | FINDSTR /I "%Tomcat7%" >nul
IF ERRORLEVEL 1 (echo - Tomcat est arrete.) ELSE (GOTO :StopTomcat)
ping -n 3 127.0.0.1 >0
echo:
if exist F:\WebServicesSoftware\Tomcat7\logs xcopy /E /I F:\WebServicesSoftware\Tomcat7\logs F:\WebServicesSoftware\Tomcat7\logs-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%%time:~6,2% > nul)
if exist F:\WebServicesSoftware\Tomcat7\logs echo - Un backup des logs a ete effectue.
if exist F:\WebServicesSoftware\Tomcat7\logs echo:
ping -n 3 127.0.0.1 >0
if exist F:\WebServicesSoftware\Tomcat7\logs RMDIR /S /Q "F:\WebServicesSoftware\Tomcat7\logs" > nul
if not exist F:\WebServicesSoftware\Tomcat7\logs (echo - Le dossier logs est vide.) ELSE (echo - Le dossier log Tomcat n'a pas ete efface.)
ping -n 3 127.0.0.1 >0
echo:
if exist F:\WebServicesSoftware\Tomcat7\work RMDIR /S /Q "F:\WebServicesSoftware\Tomcat7\work" > nul
if not exist F:\WebServicesSoftware\Tomcat7\work (echo - Le cache Tomcat est vide.) ELSE (echo - Le cache Tomcat n'a pas ete efface.)
echo:
ping -n 3 127.0.0.1 >0
echo - Tomcat est pret a demarrer. 
ping -n 30 127.0.0.1 >0
cls
echo ---------------------------------------
echo - ESII - Script de redemarrage Tomcat -
echo ---------------------------------------
echo:

:Question
echo ^>^>^> Merci de faire votre choix : 
echo:
set /p id="1 : Demarrage en service. 2 : Demarrage en debug."
IF "%id%"=="1" goto :StartService
IF "%id%"=="2" goto :StartDebug
goto :Question

:StartService
echo:
echo - Demarrage de Tomcat en service.
echo:
ping -n 3 127.0.0.1 >0
net start tomcat7 >nul
echo - Le service Tomcat demarre.
ping -n 6 127.0.0.1 >0
echo:
TASKLIST | FINDSTR /I "%Tomcat7%" >nul
IF ERRORLEVEL 1 (echo - Tomcat n'a pas demarre.) ELSE (echo - Tomcat a demarre.)
echo:
ping -n 30 127.0.0.1 >0
goto :TomcatIsRunning

:StartDebug
echo:
echo - Demarrage de Tomcat en mode debug.
echo:
ping -n 3 127.0.0.1 >0
set %JAVA_HOME%="F:\WebServicesSoftware\Tomcat7"
start "tomcat7" /MIN /B /D "F:\WebServicesSoftware\Tomcat7\bin\" "catalina.bat" jpda start /MIN
echo - Tomcat demarre en debug.
echo:
echo:
ping -n 6 127.0.0.1 >0
echo:
TASKLIST | FINDSTR /I "%java%" >nul
IF ERRORLEVEL 1 (echo - Tomcat n'a pas demarre.) ELSE (echo - Tomcat a demarre.)
echo:
ping -n 30 127.0.0.1 >0
goto :TomcatIsRunning

:TomcatIsRunning
cls
echo ---------------------------------------
echo - ESII - Script de redemarrage Tomcat -
echo ---------------------------------------
echo:
echo ^>^>^> Appuyer sur une touche pour arreter Tomcat.
pause >nul
GOTO :Begin