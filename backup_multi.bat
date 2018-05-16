@echo off

REM  Multiple Server Backups

REM  Compresses backup contents using cabarc.exe and moves zips to Backup server.
REM  Use Windows Task Scheduler to schedule.

SET ZIPDEST=d:\backup
SET ZIPTEMP=%ZIPDEST%\TEMP
SET /A num=1
SET WeeLog=Backup.log

:MakeLogFile
SET logfile=backup%num%.log
IF NOT EXIST %ZIPTEMP%\%logfile% GOTO begin
SET /A num=%num%+1
GOTO MakeLogFile

:begin

REM Names of compressed files to be created - must coincide to order of "ZIPSRC_" variables.
SET CAB1=APACHE.cab
SET CAB2=CruiseCfg.cab
SET CAB3=CruiseMainBin.cab
SET CAB4=
SET CAB5=
SET CAB6=

REM Execution path and parameters for cabarc.exe
SET CABARC=%ZIPDEST%\batfile\cabarc -r -p n %ZIPTEMP%\

REM Source directories to be backed up - must coincide to order of "CAB_" variables.
SET ZIPSRCA=D:\APACHE\APACHE2\CONF\*.*
SET ZIPSRCB=D:\CRUISE~1\CONFIG\*.*
SET ZIPSRCC=D:\CRUISE~1\MAIN\BIN\*.*
SET ZIPSRCD=Z:\NOTAREALFILE
SET ZIPSRCE=Z:\NOTAREALFILE
SET ZIPSRCF=Z:\NOTAREALFILE

ECHO %DATE% %TIME% > %ZIPTEMP%\%WeeLog%

IF NOT EXIST %ZIPTEMP% MKDIR %ZIPTEMP%
ECHO.
IF EXIST %ZIPSRCA% ECHO Backing Up %ZIPSRCA% ... Please Wait...
IF EXIST %ZIPSRCA% ECHO.  >> %ZIPTEMP%\%logfile%
IF EXIST %ZIPSRCA% ECHO %DATE% %TIME% >> %ZIPTEMP%\%logfile%
IF EXIST %ZIPSRCA% ECHO.  >> %ZIPTEMP%\%logfile%
IF EXIST %ZIPSRCA% ECHO *********** COMPRESSING %ZIPSRCA% ***************** >> %ZIPTEMP%\%logfile%
IF EXIST %ZIPSRCA% %CABARC%%CAB1% %ZIPSRCA% >> %ZIPTEMP%\%logfile%
ECHO.
IF EXIST %ZIPSRCB% ECHO Backing Up %ZIPSRCB% ... Please Wait...
IF EXIST %ZIPSRCB% ECHO.  >> %ZIPTEMP%\%logfile%
IF EXIST %ZIPSRCB% ECHO %DATE% %TIME% >> %ZIPTEMP%\%logfile%
IF EXIST %ZIPSRCB% ECHO.  >> %ZIPTEMP%\%logfile%
IF EXIST %ZIPSRCB% ECHO *********** COMPRESSING %ZIPSRCB% ***************** >> %ZIPTEMP%\%logfile%
IF EXIST %ZIPSRCB% %CABARC%%CAB2% %ZIPSRCB% >> %ZIPTEMP%\%logfile%
ECHO.
IF EXIST %ZIPSRCC% ECHO Backing Up %ZIPSRCC% ... Please Wait...
IF EXIST %ZIPSRCC% ECHO.  >> %ZIPTEMP%\%logfile%
IF EXIST %ZIPSRCC% ECHO %DATE% %TIME% >> %ZIPTEMP%\%logfile%
IF EXIST %ZIPSRCC% ECHO.  >> %ZIPTEMP%\%logfile%
IF EXIST %ZIPSRCC% ECHO *********** COMPRESSING %ZIPSRCC% ***************** >> %ZIPTEMP%\%logfile%
IF EXIST %ZIPSRCC% %CABARC%%CAB3% %ZIPSRCC% >> %ZIPTEMP%\%logfile%
ECHO.
IF EXIST %ZIPSRCD% ECHO Backing Up %ZIPSRCD% ... Please Wait...
IF EXIST %ZIPSRCD% ECHO.  >> %ZIPTEMP%\%logfile%
IF EXIST %ZIPSRCD% ECHO %DATE% %TIME% >> %ZIPTEMP%\%logfile%
IF EXIST %ZIPSRCD% ECHO.  >> %ZIPTEMP%\%logfile%
IF EXIST %ZIPSRCD% ECHO *********** COMPRESSING %ZIPSRCD% ***************** >> %ZIPTEMP%\%logfile%
IF EXIST %ZIPSRCD% %CABARC%%CAB4% %ZIPSRCD% >> %ZIPTEMP%\%logfile%
ECHO.
IF EXIST %ZIPSRCE% ECHO Backing Up %ZIPSRCE% ... Please Wait...
IF EXIST %ZIPSRCE% ECHO.  >> %ZIPTEMP%\%logfile%
IF EXIST %ZIPSRCE% ECHO %DATE% %TIME% >> %ZIPTEMP%\%logfile%
IF EXIST %ZIPSRCE% ECHO.  >> %ZIPTEMP%\%logfile%
IF EXIST %ZIPSRCE% ECHO *********** COMPRESSING %ZIPSRCE% ***************** >> %ZIPTEMP%\%logfile%
IF EXIST %ZIPSRCE% %CABARC%%CAB5% %ZIPSRCE% >> %ZIPTEMP%\%logfile%
ECHO.
IF EXIST %ZIPSRCF% ECHO Backing Up %ZIPSRCF% ... Please Wait...
IF EXIST %ZIPSRCF% ECHO.  >> %ZIPTEMP%\%logfile%
IF EXIST %ZIPSRCF% ECHO %DATE% %TIME% >> %ZIPTEMP%\%logfile%
IF EXIST %ZIPSRCF% ECHO.  >> %ZIPTEMP%\%logfile%
IF EXIST %ZIPSRCF% ECHO *********** COMPRESSING %ZIPSRCF% ***************** >> %ZIPTEMP%\%logfile%
IF EXIST %ZIPSRCF% %CABARC%%CAB6% %ZIPSRCF% >> %ZIPTEMP%\%logfile%
ECHO.
ECHO.  >> %ZIPTEMP%\%logfile%
GOTO VerifyCabs

:VerifyCabs
ECHO. >> %ZIPTEMP%\%WeeLog%
ECHO ****** CRUISE CONTROL BACKUP - LOCAL PROCESS ****** >> %ZIPTEMP%\%WeeLog%
ECHO. >> %ZIPTEMP%\%WeeLog%
IF EXIST %ZIPTEMP%\%CAB1% (ECHO %CAB1% CREATED SUCCESSFULLY >> %ZIPTEMP%\%WeeLog%) ELSE (ECHO ERROR FOUND WITH %CAB1% >> %ZIPTEMP%\%WeeLog%) 
ECHO. >> %ZIPTEMP%\%WeeLog%
IF EXIST %ZIPTEMP%\%CAB2% (ECHO %CAB2% CREATED SUCCESSFULLY >> %ZIPTEMP%\%WeeLog%) ELSE (ECHO ERROR FOUND WITH %CAB2% >> %ZIPTEMP%\%WeeLog%)
ECHO. >> %ZIPTEMP%\%WeeLog%
IF EXIST %ZIPTEMP%\%CAB3% (ECHO %CAB3% CREATED SUCCESSFULLY >> %ZIPTEMP%\%WeeLog%) ELSE (ECHO ERROR FOUND WITH %CAB3% >> %ZIPTEMP%\%WeeLog%)
ECHO. >> %ZIPTEMP%\%WeeLog%

GOTO MoveCabs

:MoveCabs
MOVE /Y %ZIPTEMP%\*.CAB %ZIPDEST%

GOTO SendToBUSvr

:SendToBUSvr
IF EXIST M:\*.* (NET USE M: /DELETE)
NET USE M: \\<server_name>\D$ /USER:<userid> <password>
IF EXIST M:\Backups\LOGS (DEL /Q /F M:\Backups\LOGS\*.*)
IF NOT EXIST M:\CrsCrl_BU\LOGS (MD M:\Backups\LOGS)
COPY /Y %ZIPDEST%\TEMP\*.log M:\Backups\LOGS\ >> %ZIPTEMP%\%WeeLog%
IF "%ERRORLEVEL%"=="0" ECHO Copied Log Files to Backup Server >> %ZIPTEMP%\%WeeLog%
MOVE /Y %ZIPDEST%\*.* M:\Backups\ >> %ZIPTEMP%\%WeeLog%
IF "%ERRORLEVEL%"=="0" ECHO Moved %ZIPDEST%\*.* to Backup Server >> %ZIPTEMP%\%WeeLog%
NET USE M: /DELETE
GOTO SendMail

:SendMail
d:\backup\batfile\blat %ZIPTEMP%\%WeeLog% -to jpicard@starfleet.com -cc jkirk@starfleet.com
GOTO end

:end
