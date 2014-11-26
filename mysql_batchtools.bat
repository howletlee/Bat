@echo off
:esc
::=====================================MySQL工具环境设置
:srevice_name
cls
set /p servnm=-^> 请输入MySQL的服务名: 
if "%servnm%"=="" goto srevice_name
reg query "HKLM\SYSTEM\ControlSet001\Services\%servnm%" /t REG_EXPAND_SZ |find /i "image" >C:\mysql.txt
if %errorlevel% neq 0 goto exit
FOR /F "tokens=2,3* delims= " %%i in (C:\mysql.txt) do echo %%j %%k >C:\mysqltemp.txt
FOR /F "tokens=1 delims=-" %%i in (C:\mysqltemp.txt) do set mysqlpath=%%i
del C:\mysql.txt /f
del C:\mysqltemp.txt /f
set mysqlpath=%mysqlpath:/=\%
set mysqlpath=%mysqlpath:"=%
set mysqlpath=%mysqlpath:~0,-6%
if %mysqlpath:~-1% neq \ set mysqlpath=%mysqlpath:~0,-1%
:pass
set /P password=-^>请输入数据库root密码：
if /I "%password%"=="" goto pass
:data
set /P data=-^>请输入数据库DATA目录路径：
if /I "%data%"=="" goto data
echo mysqlpath=%mysqlpath%
echo mysqldata=%data%
echo MySQL工具环境设置成功
set chs=0
echo.
pause
cls

:dosmenu
echo	#***************************#
echo.
echo		MySQL批量工具
echo.
echo	#***************************#
echo.
echo		【1】批量导出
echo.
echo		【2】批量导入
echo.
echo		【3】批量修复
echo.
echo		【4】环境设置
echo.
echo	任意键退出
echo.
echo	#***************************#
echo.
echo 选择后请按回车进行确认
echo.
set /P chs=请选择:

if /I "%chs%"=="1" goto dump
if /I "%chs%"=="2" goto in
if /I "%chs%"=="3" goto check
if /I "%chs%"=="4" goto esc
if /I "%chs%"==""  goto exit
goto exit


::=====================================数据库批量导出
:dump
::set /P password=请输入数据库root密码：
::set /P data=请输入数据库DATA目录路径：
set /P list=-^>请输入导出文件目录路径：
if /I "%list%"=="" goto :dump
dir %data% /a:d /b >dbname.txt
for /f %%i in (./dbname.txt) do "%mysqlpath%mysqldump.exe" -uroot -p%password% %%i >%list%\%%i.sql
del /Q dbname.txt
echo 数据库导出成功
set chs=0
pause
cls
goto dosmenu


::=====================================数据库批量导入
:in
::set /P password=请输入数据库root密码：
::set /P data=请输入数据库DATA目录路径：
set /P list=-^>请输入导入文件目录路径：
if /I "%list%"=="" goto in
dir %data% /a:d /b|find /v "mysql" >dbname.txt
for /f %%i in (./dbname.txt) do "%mysqlpath%mysql.exe" -uroot -p%password% %%i <%list%\%%i.sql
del /F dbname.txt
echo 数据库导出成功
set chs=0
pause
cls
goto dosmenu

::=====================================数据库批量修复
:check
::set /p password=请输入数据库root密码:
::set /P data=-^>请输入数据库DATA目录路径：
dir %data% /a:d /b >dbname.txt
for /f %%i in (./dbname.txt) do "%mysqlpath%mysqlcheck.exe" -o -r -uroot -p%password% %%i
del /Q dbname.txt
echo 数据库已经修复完成
set chs=0
pause
cls
goto dosmenu
pause