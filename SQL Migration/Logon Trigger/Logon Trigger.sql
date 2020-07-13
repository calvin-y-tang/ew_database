USE DBA
GO

DROP TABLE ServerLogonAuditing
GO
CREATE TABLE ServerLogonAuditing
    (
	  PrimaryKey INT NOT NULL IDENTITY(1, 1),
      SessionId INT ,
      LogonTime DATETIME ,
      HostName VARCHAR(50) ,
	  DatabaseName VARCHAR(100) ,
      AppName VARCHAR(500) ,
      LoginName VARCHAR(50) ,
      ClientHost VARCHAR(50)
    )
GO
ALTER TABLE ServerLogonAuditing ADD CONSTRAINT PK_ServerLogonAuditing PRIMARY KEY CLUSTERED (PrimaryKey) ON [PRIMARY]
GO



-- Creating DDL trigger for logon
USE master
GO
DROP TRIGGER ServerLogonAuditTrigger ON ALL SERVER
GO
CREATE TRIGGER ServerLogonAuditTrigger ON ALL SERVER
    FOR LOGON
AS
    BEGIN
        DECLARE @LogonTriggerData XML ,
            @EventTime datetime ,
            @LoginName varchar(50) ,
            @ClientHost varchar(50) ,
            @LoginType varchar(50) ,
            @HostName varchar(50) ,
            @AppName varchar(500) ,
			@DatabaseName varchar(100)
 
        SET @LogonTriggerData = EVENTDATA()
 
        SET @EventTime = @LogonTriggerData.value('(/EVENT_INSTANCE/PostTime)[1]',
                                                 'datetime')
        SET @LoginName = @LogonTriggerData.value('(/EVENT_INSTANCE/LoginName)[1]',
                                                 'varchar(50)')
        SET @ClientHost = @LogonTriggerData.value('(/EVENT_INSTANCE/ClientHost)[1]',
                                                  'varchar(50)')
        SET @HostName = HOST_NAME()
        SET @AppName = APP_NAME()
		SET @DatabaseName = DB_NAME()
 
		IF @LoginName NOT IN ('DOMAIN\SQLSentry') --AND @AppName NOT IN ('EWIntegrationServer')
        BEGIN TRY
            INSERT  INTO DBA.dbo.ServerLogonAuditing
                    ( SessionId ,
                      LogonTime ,
                      HostName ,
                      AppName ,
                      LoginName ,
                      ClientHost ,
					  DatabaseName
                    )
                    SELECT  @@spid ,
                            @EventTime ,
                            @HostName ,
                            @AppName ,
                            @LoginName ,
                            @ClientHost	,
							@DatabaseName
        END TRY
        BEGIN CATCH
        END CATCH
    END
GO