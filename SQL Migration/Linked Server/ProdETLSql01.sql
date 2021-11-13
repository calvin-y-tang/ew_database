USE [master]
GO

/****** Object:  LinkedServer [PRODETLSQL01]    Script Date: 3/24/2020 11:31:34 AM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'PRODETLSQL01', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'PRODETLSQL01',@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL
GO

EXEC master.dbo.sp_serveroption @server=N'PRODETLSQL01', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'PRODETLSQL01', @optname=N'data access', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'PRODETLSQL01', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'PRODETLSQL01', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'PRODETLSQL01', @optname=N'rpc', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'PRODETLSQL01', @optname=N'rpc out', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'PRODETLSQL01', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'PRODETLSQL01', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'PRODETLSQL01', @optname=N'collation name', @optvalue=NULL
GO

EXEC master.dbo.sp_serveroption @server=N'PRODETLSQL01', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'PRODETLSQL01', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'PRODETLSQL01', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'PRODETLSQL01', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO


