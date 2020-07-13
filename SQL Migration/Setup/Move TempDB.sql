USE tempdb
GO
sys.sp_helpfile @filename = NULL -- sysname
GO


SELECT 'ALTER DATABASE tempdb MODIFY FILE (NAME = [' + f.name + '],'
	+ ' FILENAME = ''F:\SQLTemp\tempdb_mssql_' + f.name
	+ CASE WHEN f.type = 1 THEN '.ldf' ELSE '.ndf' END
	+ ''');'
FROM sys.master_files f
WHERE f.database_id = DB_ID(N'tempdb');


ALTER DATABASE tempdb MODIFY FILE (NAME = [tempdev], FILENAME = 'F:\SQLTemp\tempdb.mdf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [templog], FILENAME = 'F:\SQLTemp\templog.ldf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [temp2], FILENAME = 'F:\SQLTemp\tempdb_mssql_2.ndf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [temp3], FILENAME = 'F:\SQLTemp\tempdb_mssql_3.ndf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [temp4], FILENAME = 'F:\SQLTemp\tempdb_mssql_4.ndf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [temp5], FILENAME = 'F:\SQLTemp\tempdb_mssql_5.ndf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [temp6], FILENAME = 'F:\SQLTemp\tempdb_mssql_6.ndf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [temp7], FILENAME = 'F:\SQLTemp\tempdb_mssql_7.ndf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [temp8], FILENAME = 'F:\SQLTemp\tempdb_mssql_8.ndf');