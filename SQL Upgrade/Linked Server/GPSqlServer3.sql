USE [master]
GO

/****** Object:  LinkedServer [GPSQLSERVER3\GP2018]    Script Date: 3/24/2020 11:30:25 AM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'GPSQLSERVER3\GP2018', @srvproduct=N'SQL Server'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'GPSQLSERVER3\GP2018',@useself=N'False',@locallogin=NULL,@rmtuser=N'inquiry',@rmtpassword='########'
GO

EXEC master.dbo.sp_serveroption @server=N'GPSQLSERVER3\GP2018', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'GPSQLSERVER3\GP2018', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'GPSQLSERVER3\GP2018', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'GPSQLSERVER3\GP2018', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'GPSQLSERVER3\GP2018', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'GPSQLSERVER3\GP2018', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'GPSQLSERVER3\GP2018', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'GPSQLSERVER3\GP2018', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'GPSQLSERVER3\GP2018', @optname=N'collation name', @optvalue=NULL
GO

EXEC master.dbo.sp_serveroption @server=N'GPSQLSERVER3\GP2018', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'GPSQLSERVER3\GP2018', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'GPSQLSERVER3\GP2018', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'GPSQLSERVER3\GP2018', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO


