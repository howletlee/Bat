@echo off
:dosmenu
echo.
echo	 WIFI �ȵ㹤��/windows 7
echo.
echo #****************************#
echo.
echo	 ��1������wifi������Ϣ
echo.
echo	 ��2���鿴��������SSID
echo.
echo	 ��3���鿴������������
echo.
echo	 ��4��������������ģʽ
echo.
echo	 ��5���رճ�������ģʽ
echo.
echo	 ��6��������������
echo.
echo	 ��7��ֹͣ��������
echo.
echo	 ��8��������������
echo.
echo.
echo	������˳�
echo.
echo #****************************#
echo.
echo ѡ����밴�س�����ȷ��
echo.
set /P chs=��ѡ��:

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
::����wifi������Ϣ
set /P id=������SSID:
set /P passd=����������:
netsh wlan set hostednetwork ssid=%id% key=%passd% mode=allow
set chs=0
echo.
pause
cls
goto dosmenu

:setmodeon
::��������ģʽ������Ϊ����
netsh wlan set hostednetwork mode=allow
set chs=0
echo.
pause
cls
goto dosmenu

:setmodeoff
::��������ģʽ������Ϊ��ֹ��
netsh wlan set hostednetwork mode=disallow
set chs=0
echo.
pause
cls
goto dosmenu

:start
::�����������硣
netsh wlan start hostednetwork
set chs=0
echo.
pause
cls
goto dosmenu

:stop
::ֹͣ�������硣
netsh wlan stop hostednetwork
set chs=0
echo.
pause
cls
goto dosmenu

:restart
::������������
netsh wlan stop hostednetwork
netsh wlan start hostednetwork
set chs=0
echo.
pause
cls
goto dosmenu

:lookSSID
::�鿴��������SSID
netsh wlan show hostednetwork
set chs=0
echo.
pause
cls
goto dosmenu

:lookpassd
::�鿴������������
netsh wlan show hostednetwork s
set chs=0
echo.
pause
cls
goto dosmenu