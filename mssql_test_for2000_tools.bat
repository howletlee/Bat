@Echo off
:dosmenu
::ȫ�ֱ���
set dbpath=D:\mssql\
set bakpath=D:

::��1�����������ݿ⡿

::----------------------------------------
::��2�����������ݿ⡿
set mdfsx=.mdf
set ldfsx=_log.ldf
::----------------------------------------

::��4�����������ݿ⡿

::----------------------------------------

::��5������ԭ���ݿ⡿

::----------------------------------------
::��6����ɾ�����ݿ⡿


::#**********************************************************************#
REM ѡ��˵�

Echo                                  MSSQL���ݿ����
Echo #*****************************************************************************#
Echo.
Echo   [1]�������ݿ�
Echo.        
Echo   [2]�������ݿ�    
Echo. 
Echo   [3]�鿴���ݿ�
Echo. 
Echo   [4]�������ݿ�
Echo. 
Echo   [5]��ԭ���ݿ�
Echo. 
Echo   [6]ɾ�����ݿ�
Echo. 
Echo   ������˳�
Echo.
Echo #*****************************************************************************#
Echo ѡ����밴�س�����ȷ��
Echo.
set /P CHS=��ѡ��: 

if /I "%CHS%"=="1" goto 1111
if /I "%CHS%"=="2" goto 2222
if /I "%CHS%"=="3" goto 3333
if /I "%CHS%"=="4" goto 4444
if /I "%CHS%"=="5" goto 5555
if /I "%CHS%"=="6" goto 6666
goto zzzz
::============================================================================�������ݿ�
:1111
set /p dbname=������������ݿ�����
set /p sapass=������sa���룺
cls
set XXX=%Temp%\1.sql
Echo ��������������ݿ�����ӣ���ȴ�����
::�������������д��.sql�ļ����棬��ͨ������ĵڶ���������ִ�����.sql�ļ������ݣ������������ɾ�����.sql�ļ�����������俪ʼ����
>"%XXX%" Echo alter database %dbname% set offline with rollback after 1;                                                                                 
Osql -U"sa" -P"%sapass%" -i %XXX%
del %XXX%
OSQL -E -Q "SP_DETACH_DB %dbname%"
Echo. 
Echo. 
Echo ����SQL����Ϊ%dbname%�����ݿ�ɹ�
Echo. 
set CHS=0
pause
cls
goto dosmenu
::============================================================================�������ݿ�
:2222
set /p dbname=�����븽�����ݿ���:
set /p sapass=������sa����:
cls
OSQL -U"sa" -P"%sapass%" -S"127.0.0.1" -Q "sp_attach_db '%dbname%','%dbpath%%dbname%\%dbname%%mdfsx%','%dbpath%%dbname%\%dbname%%ldfsx%'"
Echo. 
Echo. 
Echo ����%dbpath%%dbname%�µ����ݿ��ļ�%dbname%%mdfsx%��SQL�гɹ�
Echo. 
set CHS=0
pause
cls
goto dosmenu
::============================================================================�鿴���ݿ�
:3333
cls
OSQL -E -Q "SELECT NAME,FILENAME FROM MASTER..SYSDATABASES WHERE name<>'master' and name<>'tempdb' and name<>'model' and name<>'msdb' " 
::�������������FROM�����MASTER..SYSDATABASES��ʾϵͳ�Դ���MASTER���ݿ��е�SYSDATABASES��
set CHS=0
pause
cls
goto dosmenu
::============================================================================�������ݿ�
:4444
set /p sapass=������sa���룺
set /p dbname=���������ݿ����ƣ�
cls
del "%bakpath%\%dbname%.bak"
cls
::��������del "%HHH%\%III%"����������Ϊ�˷�ֹ��·��%III%���Ѿ�����ͬ�������ݿⱸ���ļ����������ļ����ӵ�һ�飬��Ҳ����SQL��һ��Bug
Echo ���ڱ���%dbname%���ݿ⣬�ڳ��ֱ��ݳɹ�����ʾ֮ǰ�������ĵȴ�����
Echo.
Echo.
OSQL -U"sa" -P"%sapass%" -S"127.0.0.1" -d"%dbname%"   -Q "Backup DataBase %dbname% to disk = '%bakpath%\%dbname%.bak'" 
Echo.
Echo.
Echo �ѳɹ���SQL�е����ݿ�"%dbname%"���ݳ�%bakpath%���ļ���Ϊ"%dbname%.bak"���ļ�
Echo.
set CHS=0
pause
cls
goto dosmenu
::============================================================================��ԭ���ݿ�
:5555
set /p bakdbname=�����뱸���ļ����ƣ�
set /p sapass=������sa���룺
set /p dbname=���������ݿ����ƣ�
cls
Echo ���ݿ��ļ����ڻ�ԭ���ڳ��ֻ�ԭ�ɹ�����ʾǰ�������ĵȴ�����
set XXX=%Temp%\1.sql
Echo.
Echo.
>"%XXX%"   Echo DECLARE @bakFile nvarchar(1024);                      --����@bakFile        
>>"%XXX%" Echo SET @bakFile = N'%bakpath%\%bakdbname%.bak';                                        
>>"%XXX%" Echo.                                 
>>"%XXX%" Echo DECLARE @restorePath nvarchar(1024);                             
>>"%XXX%" Echo SET @restorePath = N'%dbpath%';                                    
>>"%XXX%" Echo. 
>>"%XXX%" Echo DECLARE @dbname nvarchar(128);                                  
>>"%XXX%" Echo SET @dbname = N'%dbname%';                                         
>>"%XXX%" Echo. 
>>"%XXX%" Echo DECLARE @filename nvarchar(128);                                
>>"%XXX%" Echo SET @filename = @dbname;                                        
>>"%XXX%" Echo. 
>>"%XXX%" Echo CREATE TABLE #LogicalFileBak(LogicalName varchar(255), PhysicalName varchar(255),Type varchar(20), FileGroupName varchar(255), Size varchar(20), MaxSize varchar(20), Fileld VARCHAR(20), CreateLSN VARCHAR(20), DropLSN VARCHAR(20), Uniqueld uniqueidentifier, ReadOnlyLSN VARCHAR(20), ReadWriteLSN VARCHAR(20), BackupSizeInBytes VARCHAR(255), SourceBlockSize VARCHAR(20), FileGroupld VARCHAR(20), LogGroupGUID VARCHAR(20), DifferentialBaseLSN VARCHAR(20), DifferentialBaseGUID uniqueidentifier, IsReadOnly VARCHAR(20), IsPresent VARCHAR(20))        
>>"%XXX%" Echo    --��һ������#LogicalFileBak���±�ΪʲôҪ����ô���ֶε����ɼ��ݺ͢�
>>"%XXX%" Echo. 
>>"%XXX%" Echo INSERT #LogicalFileBak EXEC('RESTORE FILELISTONLY FROM DISK = ''' + @bakFile + '''');    --�ӱ����ļ��ж�ȡ�߼������浽#LogicalFileBak����           
>>"%XXX%" Echo. 
>>"%XXX%" Echo DECLARE cur CURSOR FOR SELECT LogicalName,Type,FileGroupName FROM #LogicalFileBak;    --����һ���α�cur(�൱�����ݼ�)������������ŵ�����              
>>"%XXX%" Echo DECLARE @LogicalName nvarchar(128),@Type char(1),@FileGroupName nvarchar(128);        --�����±���               
>>"%XXX%" Echo. 
>>"%XXX%" Echo DECLARE @cmd nvarchar(4000);                    --�����±���                                                    
>>"%XXX%" Echo SET @cmd = 'RESTORE DATABASE [' + @dbname + '] FROM DISK = ''' + @bakFile + '''';      --����һ����丳��@cmd             
>>"%XXX%" Echo SET @cmd = @cmd + ' WITH REPLACE'                                                      --���Ž���丳��@cmd             
>>"%XXX%" Echo. 
>>"%XXX%" Echo OPEN cur;                                --���α�                                                           
>>"%XXX%" Echo FETCH NEXT FROM cur INTO @LogicalName,@Type,@FileGroupName;             --��������µļ������������ԭ���ݿ� ,FETCH NEXT��ʾ������ȡ�α��е�����                           
>>"%XXX%" Echo WHILE @@FETCH_STATUS = 0                                                                            
>>"%XXX%" Echo       BEGIN                                                                                          
>>"%XXX%" Echo            SET @cmd = @cmd + ',MOVE ''' + @LogicalName + ''' TO ''' + @restorePath                   
>>"%XXX%" Echo                           + @filename + CASE WHEN @Type = 'D' AND @FileGroupName = 'PRIMARY'         
>>"%XXX%" Echo                                                   THEN '.mdf'                                         
>>"%XXX%" Echo                                               WHEN @Type = 'D' AND @FileGroupName ^<^> 'PRIMARY'      
>>"%XXX%" Echo                                                   THEN '.ndf'                                         
>>"%XXX%" Echo                                               ELSE '_log.ldf'                                         
>>"%XXX%" Echo                                               END + ''''                                              
>>"%XXX%" Echo            FETCH NEXT FROM cur INTO @LogicalName,@Type,@FileGroupName;                                
>>"%XXX%" Echo       END                                                                                             
>>"%XXX%" Echo CLOSE cur;                  --�ر��α�                                                                        
>>"%XXX%" Echo DEALLOCATE cur;             --�ͷ��α�                                                                      
>>"%XXX%" Echo. 
>>"%XXX%" Echo EXEC(@cmd);                                                                                         
>>"%XXX%" Echo. 
>>"%XXX%" Echo DROP TABLE #LogicalFileBak;       --ɾ��#LogicalFileBak��                                                               

Osql -U"sa" -P"%sapass%" -i "%XXX%"
del "%XXX%"

Echo.
Echo.
Echo ��ϲ!�ѳɹ���%bakpath%\%bakdbname%.bak��ԭ��%dbname%���һ�ԭ����ļ������%dbpath%��
Echo.
pause
set CHS=0
cls
goto dosmenu
::============================================================================ɾ�����ݿ�
:6666
set /p dbname=������ɾ�����ݿ����ƣ�
set /p sapass=������sa���룺
Echo ���Ҫɾ����ɾ���󽫲��ɻָ�
Echo.
set /P QR=ȷ��ɾ���밴y������ɾ���밴����������ѡ��?     
cls 
if /I "%QR%"=="y" (
Echo ����ɾ������ȴ�����
::���������������������
::>"%Temp%\1.sql" Echo alter database %MMM% set offline with rollback after 1;      
::Osql -U"%sa%" -P"%sapass%" -i %XXX%
cls
::������俪ʼɾ��
OSQL -U"sa" -P"%sapass%" -S"127.0.0.1" -Q "Drop DataBase %dbname%"
::�������ӣ�OSQL -U"sa" -P"sa" -S"127.0.0.1" -Q "Drop DataBase ����"
del "%Temp%\1.sql"
Echo.
Echo ɾ��SQL����Ϊ%dbname%�����ݿ⼰Դ�ļ��ɹ�
Echo.
pause
)
set QR=0
set CHS=0
cls
goto dosmenu
::============================================================================������˳�
:zzzz
REM �˳�
exit