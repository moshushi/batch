@echo off
SET "PathDirs=\\BACKUPSRV01\DBBACKUP\CURRENT\"
SET "COMPSQL=DP-VB-01\VEST"
SET Bases=%1
SET BasesB="%1"
SET BasesB=%BasesB:(=^(%
SET BasesB=%BasesB:)=^)%
SET CompDirsData=D:\MLAB_DB\DATA\
SET CompDirsLog=D:\MLAB_DB\LOG\
SET CompDirsScript=D:\MLAB_DB\Script\
SET TypeBaseFiles=\*.BAK
SET "DestDirs=%PathDirs%%BasesB%%TypeBaseFiles%"

For /F "Delims=" %%J In ('date /T') Do Set Var1=%%~J
SET Var1
dir /T:A /A:-D /O:-D %DestDirs% | findstr %Var1%
For /F "tokens=4 Delims= " %%K In ('dir /T:A /A:-D /O:-D %DestDirs% ^| findstr %Var1%') Do Set Var2=%%~K
SET Var2
SET TargetFile=%PathDirs%%Bases%\%Var2%

sqlcmd -S %COMPSQL% -Q "ALTER DATABASE [%Bases%] SET SINGLE_USER WITH ROLLBACK IMMEDIATE"
sqlcmd -S %COMPSQL% -Q "RESTORE DATABASE [%Bases%] FROM DISK = N'%TargetFile%' WITH FILE = 1,  MOVE N'%Bases%' TO N'%CompDirsData%%Bases%.mdf',  MOVE N'%Bases%_log' TO N'%CompDirsLog%%Bases%_log.ldf',  NOUNLOAD,  REPLACE,  STATS = 5" -o %Bases%_resotre.log
sqlcmd -S %COMPSQL% -Q "ALTER DATABASE [%Bases%] SET MULTI_USER"
