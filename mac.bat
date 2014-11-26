@echo off
::用ipconfig /all命令获取网卡名称。 
FOR /F "tokens=1*" %%i IN ('ipconfig/all^|find /I "以太网适配器 "') DO set name=%%j
::用for命令删除网卡名称后面的冒号。 
FOR /F "tokens=1* delims=:" %%i in ("%name%") do set 网卡名称=%%i
echo 网卡名称:%网卡名称%
pause