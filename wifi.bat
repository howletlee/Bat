@echo off
:dosmenu
echo.
echo	 WIFI 热点工具/windows 7
echo.
echo #****************************#
echo.
echo	 【1】设置wifi连接信息
echo.
echo	 【2】查看承载网络SSID
echo.
echo	 【3】查看承载网络密码
echo.
echo	 【4】开启承载网络模式
echo.
echo	 【5】关闭承载网络模式
echo.
echo	 【6】启动承载网络
echo.
echo	 【7】停止承载网络
echo.
echo	 【8】重启承载网络
echo.
echo.
echo	任意键退出
echo.
echo #****************************#
echo.
echo 选择后请按回车进行确认
echo.
set /P chs=请选择:

if /I "%chs%"=="1" goto set
if /I "%chs%"=="2" goto lookSSID
if /I "%chs%"=="3" goto lookpassd
if /I "%chs%"=="4" goto setmodeon
if /I "%chs%"=="5" goto setmodeoff
if /I "%chs%"=="6" goto start
if /I "%chs%"=="7" goto stop
if /I "%chs%"=="8" goto restart
if /I "%chs%"==""  goto exit
goto exit

:set
::设置wifi连接信息
set /P id=请输入SSID:
set /P passd=请输入密码:
netsh wlan set hostednetwork ssid=%id% key=%passd% mode=allow
set chs=0
echo.
pause
cls
goto dosmenu

:setmodeon
::承载网络模式已设置为允许。
netsh wlan set hostednetwork mode=allow
set chs=0
echo.
pause
cls
goto dosmenu

:setmodeoff
::承载网络模式已设置为禁止。
netsh wlan set hostednetwork mode=disallow
set chs=0
echo.
pause
cls
goto dosmenu

:start
::启动承载网络。
netsh wlan start hostednetwork
set chs=0
echo.
pause
cls
goto dosmenu

:stop
::停止承载网络。
netsh wlan stop hostednetwork
set chs=0
echo.
pause
cls
goto dosmenu

:restart
::重启承载网络
netsh wlan stop hostednetwork
netsh wlan start hostednetwork
set chs=0
echo.
pause
cls
goto dosmenu

:lookSSID
::查看承载网络SSID
netsh wlan show hostednetwork
set chs=0
echo.
pause
cls
goto dosmenu

:lookpassd
::查看承载网络密码
netsh wlan show hostednetwork s
set chs=0
echo.
pause
cls
goto dosmenu