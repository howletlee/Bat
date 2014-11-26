@Echo off
:dosmenu
::全局变量
set dbpath=D:\mssql\
set bakpath=D:

::★1、【分离数据库】

::----------------------------------------
::★2、【附加数据库】
set mdfsx=.mdf
set ldfsx=_log.ldf
::----------------------------------------

::★4、【备份数据库】

::----------------------------------------

::★5、【还原数据库】

::----------------------------------------
::★6、【删除数据库】


::#**********************************************************************#
REM 选择菜单

Echo                                  MSSQL数据库管理
Echo #*****************************************************************************#
Echo.
Echo   [1]分离数据库
Echo.        
Echo   [2]附加数据库    
Echo. 
Echo   [3]查看数据库
Echo. 
Echo   [4]备份数据库
Echo. 
Echo   [5]还原数据库
Echo. 
Echo   [6]删除数据库
Echo. 
Echo   任意键退出
Echo.
Echo #*****************************************************************************#
Echo 选择后请按回车进行确认
Echo.
set /P CHS=请选择: 

if /I "%CHS%"=="1" goto 1111
if /I "%CHS%"=="2" goto 2222
if /I "%CHS%"=="3" goto 3333
if /I "%CHS%"=="4" goto 4444
if /I "%CHS%"=="5" goto 5555
if /I "%CHS%"=="6" goto 6666
goto zzzz
::============================================================================分离数据库
:1111
set /p dbname=请输入分离数据库名：
set /p sapass=请输入sa密码：
cls
set XXX=%Temp%\1.sql
Echo 正在清理与此数据库的连接，请等待……
::将下面的这句语句写到.sql文件里面，再通过下面的第二条语句调用执行这个.sql文件的内容，第三条语句是删除这个.sql文件，第四条语句开始分离
>"%XXX%" Echo alter database %dbname% set offline with rollback after 1;                                                                                 
Osql -U"sa" -P"%sapass%" -i %XXX%
del %XXX%
OSQL -E -Q "SP_DETACH_DB %dbname%"
Echo. 
Echo. 
Echo 分离SQL中名为%dbname%的数据库成功
Echo. 
set CHS=0
pause
cls
goto dosmenu
::============================================================================附加数据库
:2222
set /p dbname=请输入附加数据库名:
set /p sapass=请输入sa密码:
cls
OSQL -U"sa" -P"%sapass%" -S"127.0.0.1" -Q "sp_attach_db '%dbname%','%dbpath%%dbname%\%dbname%%mdfsx%','%dbpath%%dbname%\%dbname%%ldfsx%'"
Echo. 
Echo. 
Echo 附加%dbpath%%dbname%下的数据库文件%dbname%%mdfsx%到SQL中成功
Echo. 
set CHS=0
pause
cls
goto dosmenu
::============================================================================查看数据库
:3333
cls
OSQL -E -Q "SELECT NAME,FILENAME FROM MASTER..SYSDATABASES WHERE name<>'master' and name<>'tempdb' and name<>'model' and name<>'msdb' " 
::★★★上面语句中FROM后面的MASTER..SYSDATABASES表示系统自带的MASTER数据库中的SYSDATABASES表
set CHS=0
pause
cls
goto dosmenu
::============================================================================备份数据库
:4444
set /p sapass=请输入sa密码：
set /p dbname=请输入数据库名称：
cls
del "%bakpath%\%dbname%.bak"
cls
::加上述的del "%HHH%\%III%"语句的作用是为了防止在路径%III%下已经存在同名的数据库备份文件，而导致文件叠加到一块，这也算是SQL的一个Bug
Echo 正在备份%dbname%数据库，在出现备份成功的提示之前请您耐心等待……
Echo.
Echo.
OSQL -U"sa" -P"%sapass%" -S"127.0.0.1" -d"%dbname%"   -Q "Backup DataBase %dbname% to disk = '%bakpath%\%dbname%.bak'" 
Echo.
Echo.
Echo 已成功将SQL中的数据库"%dbname%"备份成%bakpath%下文件名为"%dbname%.bak"的文件
Echo.
set CHS=0
pause
cls
goto dosmenu
::============================================================================还原数据库
:5555
set /p bakdbname=请输入备份文件名称：
set /p sapass=请输入sa密码：
set /p dbname=请输入数据库名称：
cls
Echo 数据库文件正在还原，在出现还原成功的提示前请您耐心等待……
set XXX=%Temp%\1.sql
Echo.
Echo.
>"%XXX%"   Echo DECLARE @bakFile nvarchar(1024);                      --定义@bakFile        
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
>>"%XXX%" Echo    --建一个名叫#LogicalFileBak的新表，为什么要建这么多字段的理由见⑤和⑥
>>"%XXX%" Echo. 
>>"%XXX%" Echo INSERT #LogicalFileBak EXEC('RESTORE FILELISTONLY FROM DISK = ''' + @bakFile + '''');    --从备份文件中读取逻辑名并存到#LogicalFileBak表中           
>>"%XXX%" Echo. 
>>"%XXX%" Echo DECLARE cur CURSOR FOR SELECT LogicalName,Type,FileGroupName FROM #LogicalFileBak;    --定义一个游标cur(相当于数据集)并将搜索结果放到其中              
>>"%XXX%" Echo DECLARE @LogicalName nvarchar(128),@Type char(1),@FileGroupName nvarchar(128);        --定义新变量               
>>"%XXX%" Echo. 
>>"%XXX%" Echo DECLARE @cmd nvarchar(4000);                    --定义新变量                                                    
>>"%XXX%" Echo SET @cmd = 'RESTORE DATABASE [' + @dbname + '] FROM DISK = ''' + @bakFile + '''';      --将这一串语句赋给@cmd             
>>"%XXX%" Echo SET @cmd = @cmd + ' WITH REPLACE'                                                      --接着将语句赋给@cmd             
>>"%XXX%" Echo. 
>>"%XXX%" Echo OPEN cur;                                --打开游标                                                           
>>"%XXX%" Echo FETCH NEXT FROM cur INTO @LogicalName,@Type,@FileGroupName;             --从这句往下的几句语句用来还原数据库 ,FETCH NEXT表示逐条读取游标中的数据                           
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
>>"%XXX%" Echo CLOSE cur;                  --关闭游标                                                                        
>>"%XXX%" Echo DEALLOCATE cur;             --释放游标                                                                      
>>"%XXX%" Echo. 
>>"%XXX%" Echo EXEC(@cmd);                                                                                         
>>"%XXX%" Echo. 
>>"%XXX%" Echo DROP TABLE #LogicalFileBak;       --删除#LogicalFileBak表                                                               

Osql -U"sa" -P"%sapass%" -i "%XXX%"
del "%XXX%"

Echo.
Echo.
Echo 恭喜!已成功将%bakpath%\%bakdbname%.bak还原成%dbname%，且还原后的文件存放在%dbpath%下
Echo.
pause
set CHS=0
cls
goto dosmenu
::============================================================================删除数据库
:6666
set /p dbname=请输入删除数据库名称：
set /p sapass=请输入sa密码：
Echo 真的要删除吗？删除后将不可恢复
Echo.
set /P QR=确定删除请按y，放弃删除请按其他键，请选择?     
cls 
if /I "%QR%"=="y" (
Echo 正在删除，请等待……
::下面这两句用于清除连接
::>"%Temp%\1.sql" Echo alter database %MMM% set offline with rollback after 1;      
::Osql -U"%sa%" -P"%sapass%" -i %XXX%
cls
::下面这句开始删除
OSQL -U"sa" -P"%sapass%" -S"127.0.0.1" -Q "Drop DataBase %dbname%"
::其他例子：OSQL -U"sa" -P"sa" -S"127.0.0.1" -Q "Drop DataBase 库名"
del "%Temp%\1.sql"
Echo.
Echo 删除SQL中名为%dbname%的数据库及源文件成功
Echo.
pause
)
set QR=0
set CHS=0
cls
goto dosmenu
::============================================================================任意键退出
:zzzz
REM 退出
exit