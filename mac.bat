@echo off
::��ipconfig /all�����ȡ�������ơ� 
FOR /F "tokens=1*" %%i IN ('ipconfig/all^|find /I "��̫�������� "') DO set name=%%j
::��for����ɾ���������ƺ����ð�š� 
FOR /F "tokens=1* delims=:" %%i in ("%name%") do set ��������=%%i
echo ��������:%��������%
pause