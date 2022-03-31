rem @echo off


rem Require VS2017, SSMS
rem Last Revision 2021/11/12



rem Manually set version information here
set lastVer=4.03
set nextVer=4.04

echo Building %nextVer%...




rem EXE/Folder Location
set msbEXE="C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin\MSBuild.exe"
set sqlEXE="C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\150\SqlPackage.exe"

set    projFld=E:\Database\IMECentricDB
set    baseFld=E:\Database\Builds\Temp
set  dacPacFld=E:\Database\Builds\IMECentricDB
set scriptsFld=E:\Database\Builds\IMECentricDB

rem Create the DacPac files
%msbEXE% "%projFld%\IMECentricDB.sqlproj" -t:rebuild


rem Copy DacPac files into Temp folder
if not exist "%baseFld%" mkdir "%baseFld%"
del "%baseFld%\*.*" /q
copy "%projFld%\bin\Debug\*.dacpac" "%baseFld%\*.dacpac"
ren "%baseFld%\IMECentricDB.dacpac" "nextVer.dacpac"
copy "%dacPacFld%\Release %lastVer%.dacpac" "%baseFld%\lastVer.dacpac"

rem Generate schema and data script
%sqlEXE% /a:Script /sf:"%baseFld%\nextVer.dacpac" /tf:"%baseFld%\lastVer.dacpac" /tdn:sTargetDB /op:"%baseFld%\Schema.sql" /p:BackupDatabaseBeforeChanges=False /p:BlockOnPossibleDataLoss=False /p:CommentOutSetVarDeclarations=True /p:IgnoreColumnOrder=True /p:IgnoreComments=True /p:ScriptRefreshModule=False /p:IncludeTransactionalScripts=True
copy "%projFld%\Data\NextRelease.sql" "%baseFld%\Data.sql"
copy "%baseFld%\Schema.sql" + "%baseFld%\Data.sql" "%scriptsFld%\%nextVer%.sql"



rem copy final DapPac into release folder
copy "%baseFld%\nextVer.dacpac" "%dacPacFld%\Release %nextVer%.dacpac"



rem Clean up Temp folder
del "%baseFld%\*.*" /q


rem Done
pause

