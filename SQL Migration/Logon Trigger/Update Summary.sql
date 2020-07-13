USE master
GO
DISABLE TRIGGER ServerLogonAuditTrigger ON ALL SERVER
GO


USE DBA
GO
SELECT
	   'SqlServer7' AS ServerName,	
       L.AppName,
       L.LoginName,
       L.HostName,
       MAX(L.ClientHost) AS ClientHost,
	   MIN(L.LogonTime) AS FirstLogin,
       MAX(L.LogonTime) AS LastLogin,
       COUNT(L.PrimaryKey) AS LoginCount
 INTO ctNewLogin
 FROM DBA.dbo.ServerLogonAuditing AS L WITH (NOLOCK)
 GROUP BY L.AppName, L.LoginName, L.HostName
 GO
 
UPDATE L SET L.LastLogin=N.LastLogin, L.LoginCount=L.LoginCount+N.LoginCount, L.ClientHost=N.ClientHost, L.ServerName = N.ServerName
  FROM ctNewLogin AS N
  INNER JOIN ServerLogonSummary AS L
   ON L.AppName = N.AppName
   --AND L.ClientHost = N.ClientHost
   AND L.HostName = N.HostName
   AND L.LoginName = N.LoginName
GO

INSERT INTO ServerLogonSummary
(
    ServerName,
    AppName,
    LoginName,
    HostName,
    ClientHost,
    FirstLogin,
    LastLogin,
    LoginCount
)
SELECT N.ServerName,
       N.AppName,
       N.LoginName,
       N.HostName,
       N.ClientHost,
       N.FirstLogin,
       N.LastLogin,
       N.LoginCount
  FROM ctNewLogin AS N
  LEFT OUTER JOIN ServerLogonSummary AS L
   ON L.AppName = N.AppName
   --AND L.ClientHost = N.ClientHost
   AND L.HostName = N.HostName
   AND L.LoginName = N.LoginName
   --AND L.ServerName = N.ServerName
WHERE L.PrimaryKey IS NULL
GO

DROP TABLE ctNewLogin
GO


USE master
GO
TRUNCATE TABLE DBA.dbo.ServerLogonAuditing
GO
ENABLE TRIGGER ServerLogonAuditTrigger ON ALL SERVER
GO



UPDATE s SET s.AppGroup=(SELECT MAX(app.AppGroup) FROM DBA.dbo.ServerLogonSummary AS app WHERE app.AppName=s.appname)
FROM DBA.dbo.ServerLogonSummary AS s
WHERE s.AppGroup IS NULL

