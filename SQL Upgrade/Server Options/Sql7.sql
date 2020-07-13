EXEC sys.sp_configure N'backup compression default', N'1'
GO
RECONFIGURE WITH OVERRIDE
GO
USE [master]
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'BackupDirectory', REG_SZ, N'G:\Backup'
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'DefaultData', REG_SZ, N'D:\SQLData'
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'DefaultLog', REG_SZ, N'E:\SQLLog'
GO
EXEC sys.sp_configure N'cost threshold for parallelism', N'25'
GO
EXEC sys.sp_configure N'max degree of parallelism', N'4'
GO
EXEC sys.sp_configure N'backup compression default', N'1'
GO
EXEC sys.sp_configure N'optimize for ad hoc workloads', N'1'
GO
EXEC sys.sp_configure N'max text repl size (B)', N'-1'
GO
RECONFIGURE WITH OVERRIDE
GO
