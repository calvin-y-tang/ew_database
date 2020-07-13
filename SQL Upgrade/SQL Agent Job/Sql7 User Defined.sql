USE [msdb]
GO

/****** Object:  Job [Daily Backup Copy]    Script Date: 3/24/2020 3:46:57 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [User Defined]    Script Date: 3/24/2020 3:46:57 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'User Defined' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'User Defined'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Daily Backup Copy', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'User Defined', 
		@owner_login_name=N'imeCentric', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [IMECentricMaster]    Script Date: 3/24/2020 3:46:57 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'IMECentricMaster', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BACKUP DATABASE [IMECentricMaster]
 TO  DISK = N''G:\Backup\IMECentricMaster_Copy.bak''
 WITH NOFORMAT, INIT,
 COPY_ONLY, SKIP, NOREWIND, NOUNLOAD,  STATS = 25
GO', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [EWDataRepository]    Script Date: 3/24/2020 3:46:58 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'EWDataRepository', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BACKUP DATABASE [EWDataRepository]
 TO  DISK = N''G:\Backup\EWDataRepository_Copy.bak''
 WITH NOFORMAT, INIT,
 COPY_ONLY, SKIP, NOREWIND, NOUNLOAD,  STATS = 25
GO', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [IMECentricEW]    Script Date: 3/24/2020 3:46:58 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'IMECentricEW', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BACKUP DATABASE [IMECentricEW]
 TO  DISK = N''G:\Backup\IMECentricEW_Copy.bak''
 WITH NOFORMAT, INIT,
 COPY_ONLY, SKIP, NOREWIND, NOUNLOAD,  STATS = 25
GO', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Daily 4am', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20190205, 
		@active_end_date=99991231, 
		@active_start_time=40000, 
		@active_end_time=235959, 
		@schedule_uid=N'1f80d0e5-d9de-41a0-b756-68084745f586'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [GPInvoice Info Changed]    Script Date: 3/24/2020 3:46:58 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [User Defined]    Script Date: 3/24/2020 3:46:58 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'User Defined' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'User Defined'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'GPInvoice Info Changed', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'User Defined', 
		@owner_login_name=N'imeCentric', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Insert Data]    Script Date: 3/24/2020 3:46:58 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Insert Data', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @date DATETIME
SET @date=GETDATE()

INSERT INTO IMECentricMaster.dbo.GPInvoiceUpdt
(
    ProcessedFlag,
    ExportDate,
    GPFacilityID,
    DocumentNo,
    CaseNo,
    EventDesc,
    ClaimNbr,
    NewGPCustomerID,
	OldGPCustomerID,
    NewClient,
    OldClient,
    NewClientCode,
    OldClientCode,
    EventDate
)
SELECT DISTINCT
       0 AS ProcessedFlag,
       GETDATE() AS ExportDate,
       F.GPFacility AS GPFacilityID,
       AH.DocumentNbr AS DocumentNo,
       C.ExtCaseNbr AS CaseNo,
       IIF(CH.Eventdesc = ''Claim Nbr Change'', CH.Eventdesc, IIF(CO.GPCustomerID<>AHCO.GPCustomerID, ''Company Change'', ''Client Code Change'')) AS EventDesc,
       C.ClaimNbr,
       AHCO.GPCustomerID AS NewGPCustomerID,
       CO.GPCustomerID AS OldGPCustomerID,
       ISNULL(CL.FirstName, '''') + '' '' + ISNULL(CL.LastName, '''') AS NewClient,
       ISNULL(AHCL.FirstName, '''') + '' '' + ISNULL(AHCL.LastName, '''') AS OldClient,
       CL.ClientCode AS NewClientCode,
       AH.ClientCode AS OldClientCode,
       CH.EventDate
FROM IMECentricEW.dbo.tblCaseHistory AS CH WITH (NOLOCK)
INNER JOIN IMECentricEW.dbo.tblCase AS C WITH (NOLOCK) ON C.CaseNbr = CH.CaseNbr
INNER JOIN IMECentricEW.dbo.tblClient AS CL WITH (NOLOCK) ON CL.ClientCode = ISNULL(C.BillClientCode, C.ClientCode)
INNER JOIN IMECentricEW.dbo.tblCompany AS CO WITH (NOLOCK) ON CO.CompanyCode = CL.CompanyCode
INNER JOIN IMECentricEW.dbo.tblAcctHeader AS AH WITH (NOLOCK) ON AH.CaseNbr = C.CaseNbr
INNER JOIN IMECentricEW.dbo.tblClient AS AHCL WITH (NOLOCK) ON AHCL.ClientCode = AH.ClientCode
INNER JOIN IMECentricEW.dbo.tblCompany AS AHCO WITH (NOLOCK) ON AHCO.CompanyCode = AH.CompanyCode
INNER JOIN IMECentricEW.dbo.tblEWFacility AS F WITH (NOLOCK) ON F.EWFacilityID = AH.EWFacilityID
INNER JOIN IMECentricEW.dbo.tblGPInvoice AS I WITH (NOLOCK) ON I.InvHeaderID = AH.HeaderID
WHERE CH.EventDate >= dateadd(day,datediff(day,1,@date),0)
        AND CH.EventDate < dateadd(day,datediff(day,0,@date),0)
AND CH.EventDate>=AH.Finalized
AND
(
((CH.Eventdesc=''Client Changed'' OR CH.Eventdesc=''Third Party Billing Change'') AND AH.ClientCode<>CL.ClientCode)
OR
CH.Eventdesc=''Claim Nbr Change''
)

', 
		@database_name=N'IMECentricMaster', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Daily 3:05am', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=127, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20190612, 
		@active_end_date=99991231, 
		@active_start_time=30500, 
		@active_end_time=235959, 
		@schedule_uid=N'a2f3845a-9c63-4b3a-9c6e-509216016829'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [Refresh OMS Doctor Integration]    Script Date: 3/24/2020 3:46:58 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [User Defined]    Script Date: 3/24/2020 3:46:58 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'User Defined' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'User Defined'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Refresh OMS Doctor Integration', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'User Defined', 
		@owner_login_name=N'imeCentric', 
		@notify_email_operator_name=N'DBA', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Refresh EWDoctorExt]    Script Date: 3/24/2020 3:46:58 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Refresh EWDoctorExt', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--Clear existing records
DELETE FROM EWDoctorExt
GO

--Refresh EWDoctorExt with all Active doctors from EWDoctor
INSERT INTO EWDoctorExt (EWDoctorID)
SELECT DR.EWDoctorID FROM EWDoctor AS DR LEFT OUTER JOIN EWDoctorExt AS Ext ON Ext.EWDoctorID = DR.EWDoctorID WHERE Ext.EWDoctorID IS NULL
GO

', 
		@database_name=N'IMECentricMaster', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Refresh Notes]    Script Date: 3/24/2020 3:46:58 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Refresh Notes', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--Get Local DB data
DECLARE @sql VARCHAR(8000)
DECLARE @dbName VARCHAR(25)
DECLARE @dbDescrip VARCHAR(20)

SET ANSI_WARNINGS OFF

DECLARE dbList CURSOR
FOR
    SELECT SQLDatabaseName, Descrip
    FROM DB
    WHERE NDB=1
OPEN dbList
FETCH NEXT FROM dbList INTO @dbName, @dbDescrip
WHILE @@FETCH_STATUS=0
    BEGIN


--Doctor Notes
        SET @sql=''
UPDATE Ext SET
    Ext.Notes=CAST(ISNULL(Ext.Notes,'''''''') AS VARCHAR(MAX))+
    IIF(DR.Notes IS NULL, '''''''', REPLICATE(''''_'''', 80)+CHAR(13)+''''FROM ''''+
    DB.Descrip+'''':''''+CHAR(13)+CAST(DR.Notes AS VARCHAR(MAX))+CHAR(13)),
    Ext.QANotes=CAST(ISNULL(Ext.QANotes,'''''''') AS VARCHAR(MAX))+
    IIF(DR.QANotes IS NULL, '''''''', REPLICATE(''''_'''', 80)+CHAR(13)+''''FROM ''''+
    DB.Descrip+'''':''''+CHAR(13)+CAST(DR.QANotes AS VARCHAR(MAX))+CHAR(13)),
    Ext.MedRecordReqNotes=CAST(ISNULL(Ext.MedRecordReqNotes,'''''''') AS VARCHAR(MAX))+
    IIF(DR.MedRecordReqNotes IS NULL, '''''''', REPLICATE(''''_'''', 80)+CHAR(13)+''''FROM ''''+
    DB.Descrip+'''':''''+CHAR(13)+CAST(DR.MedRecordReqNotes AS VARCHAR(MAX))+CHAR(13))
FROM
	EWDoctorExt AS Ext
    INNER JOIN ''+@dbName+''.dbo.tblDoctor AS DR ON DR.EWDoctorID = Ext.EWDoctorID
	INNER JOIN ''+@dbName+''.dbo.tblControl AS CTRL ON 1=1
	INNER JOIN DB ON DB.DBID = CTRL.DBID
''
        EXEC (@sql) 

		FETCH NEXT FROM dbList INTO @dbName, @dbDescrip
    END
CLOSE dbList
DEALLOCATE dbList

SET ANSI_WARNINGS ON


GO
', 
		@database_name=N'IMECentricMaster', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Refresh License Status]    Script Date: 3/24/2020 3:46:58 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Refresh License Status', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--Get LicenseStatus from Doctor Document
UPDATE Ext SET LicenseStatus=
  ISNULL(
  (SELECT TOP 1 IIF(Doc.ExpireDate<=GETDATE(), ''N'', ''Y'') FROM EWDoctorDocument AS Doc WHERE Doc.EWDoctorID = Ext.EWDoctorID AND Doc.EWDrDocTypeID=11 ORDER BY Doc.ExpireDate DESC),
  ''N'')
FROM EWDoctorExt AS Ext
GO

', 
		@database_name=N'IMECentricMaster', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Refresh Databases]    Script Date: 3/24/2020 3:46:58 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Refresh Databases', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--Get Databases (Multi records to one text string)
SET QUOTED_IDENTIFIER OFF
UPDATE Ext SET Ext.Databases=
ISNULL((STUFF((
        SELECT '', ''+ CAST(DB.Descrip AS VARCHAR)
		FROM EWDoctorDB AS DDB
		INNER JOIN DB ON DB.DBID = DDB.DBID
		WHERE DDB.EWDoctorID=Ext.EWDoctorID
        FOR XML PATH(''''), TYPE, ROOT).value(''root[1]'', ''varchar(100)''),1,2,'''')),'''')
 FROM EWDoctorExt AS Ext
SET QUOTED_IDENTIFIER ON
GO', 
		@database_name=N'IMECentricMaster', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Refresh Accreditations]    Script Date: 3/24/2020 3:46:58 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Refresh Accreditations', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--Get Accreditations (Multi records to one text string)
SET QUOTED_IDENTIFIER OFF
UPDATE Ext SET Accreditations=
ISNULL((STUFF((
        SELECT '', ''+ CAST(A.Name AS VARCHAR)
		FROM EWDoctorAccreditation DA
		INNER JOIN EWAccreditation AS A ON A.EWAccreditationID = DA.EWAccreditationID
		WHERE DA.EWDoctorID=Ext.EWDoctorID
        FOR XML PATH(''''), TYPE, ROOT).value(''root[1]'', ''varchar(100)''),1,2,'''')),'''')
 FROM EWDoctorExt AS Ext
SET QUOTED_IDENTIFIER ON
GO
', 
		@database_name=N'IMECentricMaster', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Refresh Specialties]    Script Date: 3/24/2020 3:46:58 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Refresh Specialties', 
		@step_id=6, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--Get Specialties (Multi records to one text string)
SET QUOTED_IDENTIFIER OFF
UPDATE Ext SET Ext.Specialties=
ISNULL((STUFF((
        SELECT '', ''+ CAST(S.SpecialtyCode AS VARCHAR)
		FROM EWDoctorSpecialty DS
		INNER JOIN EWSpecialty AS S ON S.EWSpecialtyID = DS.EWSpecialtyID
		WHERE DS.EWDoctorID=Ext.EWDoctorID
        FOR XML PATH(''''), TYPE, ROOT).value(''root[1]'', ''varchar(300)''),1,2,'''')),'''')
 FROM EWDoctorExt AS Ext
SET QUOTED_IDENTIFIER ON
GO
', 
		@database_name=N'IMECentricMaster', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Refresh Keywords]    Script Date: 3/24/2020 3:46:58 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Refresh Keywords', 
		@step_id=7, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--Clear existing records
DELETE FROM EWDoctorKeyword
GO


--Get Local DB data
DECLARE @sql VARCHAR(8000)
DECLARE @dbName VARCHAR(25)
DECLARE @dbDescrip VARCHAR(20)

SET ANSI_WARNINGS OFF

DECLARE dbList CURSOR
FOR
    SELECT SQLDatabaseName, Descrip
    FROM DB
    WHERE NDB=1
OPEN dbList
FETCH NEXT FROM dbList INTO @dbName, @dbDescrip
WHILE @@FETCH_STATUS=0
    BEGIN


--Get Keywords
        SET @sql=''
INSERT INTO EWDoctorKeyword
SELECT DR.EWDoctorID,
 CTRL.DBID,
 K.KeywordID,
 K.Keyword
 FROM ''+@dbName+''.dbo.tblDoctor AS DR
 INNER JOIN ''+@dbName+''.dbo.tblControl AS CTRL ON 1=1
 INNER JOIN ''+@dbName+''.dbo.tblDoctorKeyWord AS DRK ON DRK.DoctorCode = DR.DoctorCode
 INNER JOIN ''+@dbName+''.dbo.tblKeyWord AS K ON K.KeywordID = DRK.KeywordID
 WHERE K.Status=''''Active''''
''
        EXEC (@sql) 




		FETCH NEXT FROM dbList INTO @dbName, @dbDescrip
    END
CLOSE dbList
DEALLOCATE dbList

SET ANSI_WARNINGS ON


GO
', 
		@database_name=N'IMECentricMaster', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Refresh Languages]    Script Date: 3/24/2020 3:46:58 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Refresh Languages', 
		@step_id=8, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'SET QUOTED_IDENTIFIER OFF
UPDATE Ext SET Ext.Languages=
ISNULL((STUFF((
        SELECT '', ''+ CAST(LN.Lang AS VARCHAR)
		FROM (SELECT EWDoctorID, REPLACE(Keyword, ''Language: '', '''') AS Lang FROM EWDoctorKeyword WHERE Keyword LIKE ''Language:%'' AND Keyword<>''Language: English'') AS LN
		WHERE LN.EWDoctorID=Ext.EWDoctorID
        FOR XML PATH(''''), TYPE, ROOT).value(''root[1]'', ''varchar(300)''),1,2,'''')),'''')
 FROM EWDoctorExt AS Ext
SET QUOTED_IDENTIFIER ON
GO', 
		@database_name=N'IMECentricMaster', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Refresh Business Lines]    Script Date: 3/24/2020 3:46:58 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Refresh Business Lines', 
		@step_id=9, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'SET QUOTED_IDENTIFIER OFF
UPDATE Ext SET Ext.BusLines=
ISNULL((STUFF((
        SELECT '', ''+ CAST(BL.Name AS VARCHAR)
		FROM EWDoctorBusLine DBL
		INNER JOIN EWBusLine AS BL ON BL.EWBusLineID = DBL.EWBusLineID
		WHERE DBL.EWDoctorID=Ext.EWDoctorID
        FOR XML PATH(''''), TYPE, ROOT).value(''root[1]'', ''varchar(100)''),1,2,'''')),'''')
 FROM EWDoctorExt AS Ext
SET QUOTED_IDENTIFIER ON
GO', 
		@database_name=N'IMECentricMaster', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Refresh Offices]    Script Date: 3/24/2020 3:46:58 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Refresh Offices', 
		@step_id=10, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--Clear existing records
DELETE FROM EWDoctorOffice
GO



--Get Local DB data
DECLARE @sql VARCHAR(8000)
DECLARE @dbName VARCHAR(25)
DECLARE @dbDescrip VARCHAR(20)

SET ANSI_WARNINGS OFF

DECLARE dbList CURSOR
FOR
    SELECT SQLDatabaseName, Descrip
    FROM DB
    WHERE NDB=1
OPEN dbList
FETCH NEXT FROM dbList INTO @dbName, @dbDescrip
WHILE @@FETCH_STATUS=0
    BEGIN


--Get Exam Locations
        SET @sql=''
INSERT INTO EWDoctorOffice
SELECT
 DISTINCT
 DR.EWDoctorID,
 CTRL.DBID,
 O.OfficeCode,
 O.Description

 FROM ''+@dbName+''.dbo.tblDoctor AS DR
 INNER JOIN ''+@dbName+''.dbo.tblControl AS CTRL ON 1=1
 INNER JOIN ''+@dbName+
            ''.dbo.tblDoctorOffice AS DO ON DO.DoctorCode=DR.DoctorCode
 INNER JOIN ''+@dbName+''.dbo.tblOffice AS O ON O.OfficeCode=DO.OfficeCode
 WHERE DR.EWDoctorID IS NOT NULL
 ''
        EXEC (@sql) 


		FETCH NEXT FROM dbList INTO @dbName, @dbDescrip
    END
CLOSE dbList
DEALLOCATE dbList

SET ANSI_WARNINGS ON


GO


--Get Offices (Multi records to one text string)
SET QUOTED_IDENTIFIER OFF
UPDATE Ext SET Ext.Offices=
ISNULL((STUFF((
        SELECT '', ''+ CAST(DO.OfficeName AS VARCHAR)
		FROM EWDoctorOffice AS DO
		WHERE DO.EWDoctorID=Ext.EWDoctorID
        FOR XML PATH(''''), TYPE, ROOT).value(''root[1]'', ''varchar(100)''),1,2,'''')),'''')
 FROM EWDoctorExt AS Ext
SET QUOTED_IDENTIFIER ON
GO
', 
		@database_name=N'IMECentricMaster', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Refresh Exam Locations]    Script Date: 3/24/2020 3:46:58 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Refresh Exam Locations', 
		@step_id=11, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--Clear existing records
DELETE FROM EWDoctorLocation
GO



--Get Local DB data
DECLARE @sql VARCHAR(8000)
DECLARE @dbName VARCHAR(25)
DECLARE @dbDescrip VARCHAR(20)

SET ANSI_WARNINGS OFF

DECLARE dbList CURSOR
FOR
    SELECT SQLDatabaseName, Descrip
    FROM DB
    WHERE NDB=1
OPEN dbList
FETCH NEXT FROM dbList INTO @dbName, @dbDescrip
WHILE @@FETCH_STATUS=0
    BEGIN


--Get Exam Locations
        SET @sql=''
INSERT INTO EWDoctorLocation
SELECT
 DISTINCT
 DR.EWDoctorID,
 CTRL.DBID,
 L.LocationCode,
 L.Addr1,
 L.Addr2,
 L.City,
 L.State,
 L.Zip AS ZipCode,
 L.County,
 Z.fLongitude AS Longitude,
 Z.fLatitude AS Latitude

 FROM ''+@dbName+''.dbo.tblDoctor AS DR
 INNER JOIN ''+@dbName+''.dbo.tblControl AS CTRL ON 1=1
 INNER JOIN ''+@dbName+
            ''.dbo.tblDoctorLocation AS DL ON DL.DoctorCode=DR.DoctorCode
 INNER JOIN ''+@dbName+''.dbo.tblLocation AS L ON L.LocationCode=DL.LocationCode
 INNER JOIN ''+@dbName+''.dbo.tblZipCode AS Z ON L.Zip=Z.sZip
 WHERE DR.EWDoctorID IS NOT NULL AND DL.Status=''''Active'''' AND L.Status=''''ACTIVE''''
 ''
        EXEC (@sql) 


		FETCH NEXT FROM dbList INTO @dbName, @dbDescrip
    END
CLOSE dbList
DEALLOCATE dbList

SET ANSI_WARNINGS ON


GO
', 
		@database_name=N'IMECentricMaster', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Daily', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=127, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20160722, 
		@active_end_date=99991231, 
		@active_start_time=50000, 
		@active_end_time=235959, 
		@schedule_uid=N'a2eb9ef3-7e50-46b1-b605-f091dc13b871'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


