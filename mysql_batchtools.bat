@echo off
:esc
::=====================================MySQL���߻�������
:srevice_name
cls
set /p servnm=-^> ������MySQL�ķ�����: 
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
set /P password=-^>���������ݿ�root���룺
if /I "%password%"=="" goto pass
:data
set /P data=-^>���������ݿ�DATAĿ¼·����
if /I "%data%"=="" goto data
echo mysqlpath=%mysqlpath%
echo mysqldata=%data%
echo MySQL���߻������óɹ�
set chs=0
echo.
pause
cls

:dosmenu
echo	#***************************#
echo.
echo		MySQL��������
echo.
echo	#***************************#
echo.
echo		��1����������
echo.
echo		��2����������
echo.
echo		��3�������޸�
echo.
echo		��4����������
echo.
echo	������˳�
echo.
echo	#***************************#
echo.
echo ѡ����밴�س�����ȷ��
echo.
set /P chs=��ѡ��:

if /I "%chs%"=="1" goto dump
if /I "%chs%"=="2" goto in
if /I "%chs%"=="3" goto check
if /I "%chs%"=="4" goto esc
if /I "%chs%"==""  goto exit
goto exit


::=====================================���ݿ���������
:dump
::set /P password=���������ݿ�root���룺
::set /P data=���������ݿ�DATAĿ¼·����
set /P list=-^>�����뵼���ļ�Ŀ¼·����
if /I "%list%"=="" goto :dump
dir %data% /a:d /b >dbname.txt
for /f %%i in (./dbname.txt) do "%mysqlpath%mysqldump.exe" -uroot -p%password% %%i >%list%\%%i.sql
del /Q dbname.txt
echo ���ݿ⵼���ɹ�
set chs=0
pause
cls
goto dosmenu


::=====================================���ݿ���������
:in
::set /P password=���������ݿ�root���룺
::set /P data=���������ݿ�DATAĿ¼·����
set /P list=-^>�����뵼���ļ�Ŀ¼·����
if /I "%list%"=="" goto in
dir %data% /a:d /b|find /v "mysql" >dbname.txt
for /f %%i in (./dbname.txt) do "%mysqlpath%mysql.exe" -uroot -p%password% %%i <%list%\%%i.sql
del /F dbname.txt
echo ���ݿ⵼���ɹ�
set chs=0
pause
cls
goto dosmenu

::=====================================���ݿ������޸�
:check
::set /p password=���������ݿ�root����:
::set /P data=-^>���������ݿ�DATAĿ¼·����
dir %data% /a:d /b >dbname.txt
for /f %%i in (./dbname.txt) do "%mysqlpath%mysqlcheck.exe" -o -r -uroot -p%password% %%i
del /Q dbname.txt
echo ���ݿ��Ѿ��޸����
set chs=0
pause
cls
goto dosmenu
pause