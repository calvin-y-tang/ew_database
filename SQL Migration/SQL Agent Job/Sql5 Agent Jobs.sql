USE [msdb]
GO

/****** Object:  Job [Agent history clean up: distribution]    Script Date: 2/26/2020 10:02:48 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [REPL-History Cleanup]    Script Date: 2/26/2020 10:02:48 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'REPL-History Cleanup' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'REPL-History Cleanup'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Agent history clean up: distribution', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Removes replication agent history from the distribution database.', 
		@category_name=N'REPL-History Cleanup', 
		@owner_login_name=N'DOMAIN\Ashley.Fuqua-Smith', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Run agent.]    Script Date: 2/26/2020 10:02:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Run agent.', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC dbo.sp_MShistory_cleanup @history_retention = 48', 
		@server=N'SQLSERVER5\EW_IME_CENTRIC', 
		@database_name=N'distribution', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Replication agent schedule.', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=10, 
		@freq_relative_interval=1, 
		@freq_recurrence_factor=0, 
		@active_start_date=20190415, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'ca7c937b-1496-4c49-bbbe-8f2a129bdd53'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [AMBR_Updates_After_Import]    Script Date: 2/26/2020 10:02:48 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2/26/2020 10:02:48 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'AMBR_Updates_After_Import', 
		@enabled=0, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'imeCentric', 
		@notify_email_operator_name=N'DBA', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Flip processed flag for unposted invoices]    Script Date: 2/26/2020 10:02:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Flip processed flag for unposted invoices', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'UPDATE AMBRInvoice
SET ProcessedFlag = 1
WHERE     (ProcessedFlag = 0) AND (InvoiceTotal <> 0) AND ((''230-'' + InvoiceID) IN
                          (SELECT     SOPNUMBE
                            FROM          [GPSQLSERVER2].EW.dbo.SOP10100 AS SOP10100_1))

', 
		@database_name=N'IMECentricMaster', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Flip processed flag for posted invoices]    Script Date: 2/26/2020 10:02:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Flip processed flag for posted invoices', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'UPDATE AMBRInvoice
SET ProcessedFlag = 1
WHERE     (ProcessedFlag = 0) AND (InvoiceTotal <> 0) AND ((''230-'' + InvoiceID) IN
                          (SELECT     SOPNUMBE
                            FROM          [GPSQLSERVER2].EW.dbo.SOP30200 AS SOP30200_1))', 
		@database_name=N'IMECentricMaster', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Daily 8:30 AM', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=62, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20161004, 
		@active_end_date=99991231, 
		@active_start_time=83000, 
		@active_end_time=235959, 
		@schedule_uid=N'9fd62b3e-56cb-4557-8773-9d911daf8b21'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [Daily Backup Copy]    Script Date: 2/26/2020 10:02:48 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2/26/2020 10:02:48 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
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
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'imeCentric', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [IMECentricMaster]    Script Date: 2/26/2020 10:02:48 PM ******/
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
/****** Object:  Step [EWDataRepository]    Script Date: 2/26/2020 10:02:48 PM ******/
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
/****** Object:  Step [IMECentricEW]    Script Date: 2/26/2020 10:02:48 PM ******/
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

/****** Object:  Job [DBA - DatabaseIntegrityCheck - SYSTEM_DATABASES]    Script Date: 2/26/2020 10:02:48 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Database Maintenance]    Script Date: 2/26/2020 10:02:48 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DBA - DatabaseIntegrityCheck - SYSTEM_DATABASES', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Source: https://ola.hallengren.com', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'imeCentric', 
		@notify_email_operator_name=N'DBA', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [DatabaseIntegrityCheck - SYSTEM_DATABASES]    Script Date: 2/26/2020 10:02:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'DatabaseIntegrityCheck - SYSTEM_DATABASES', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.DatabaseIntegrityCheck
@Databases = ''SYSTEM_DATABASES'',
@CheckCommands = ''CHECKDB'',
@NoIndex = ''Y'',
@LogToTable = ''Y''', 
		@database_name=N'DBA', 
		@output_file_name=N'C:\Program Files\Microsoft SQL Server\MSSQL11.EW_IME_CENTRIC\MSSQL\LOG\DatabaseIntegrityCheck_$(ESCAPE_SQUOTE(JOBID))_$(ESCAPE_SQUOTE(STEPID))_$(ESCAPE_SQUOTE(STRTDT))_$(ESCAPE_SQUOTE(STRTTM)).txt', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Sstep 1', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20180829, 
		@active_end_date=99991231, 
		@active_start_time=100000, 
		@active_end_time=235959, 
		@schedule_uid=N'f626a1a9-9057-46c0-92d5-1e30c26b3cc7'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [DBA - DatabaseIntegrityCheck - USER_DATABASES]    Script Date: 2/26/2020 10:02:48 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Database Maintenance]    Script Date: 2/26/2020 10:02:48 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DBA - DatabaseIntegrityCheck - USER_DATABASES', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Source: https://ola.hallengren.com', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'imeCentric', 
		@notify_email_operator_name=N'DBA', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [DatabaseIntegrityCheck - USER_DATABASES]    Script Date: 2/26/2020 10:02:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'DatabaseIntegrityCheck - USER_DATABASES', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.DatabaseIntegrityCheck
@Databases = ''USER_DATABASES'',
@CheckCommands = ''CHECKDB'',
@NoIndex = ''Y'',
@LogToTable = ''Y''', 
		@database_name=N'DBA', 
		@output_file_name=N'C:\Program Files\Microsoft SQL Server\MSSQL11.EW_IME_CENTRIC\MSSQL\LOG\DatabaseIntegrityCheck_$(ESCAPE_SQUOTE(JOBID))_$(ESCAPE_SQUOTE(STEPID))_$(ESCAPE_SQUOTE(STRTDT))_$(ESCAPE_SQUOTE(STRTTM)).txt', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'step 1', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20180914, 
		@active_end_date=99991231, 
		@active_start_time=100000, 
		@active_end_time=235959, 
		@schedule_uid=N'6d50f06e-be9d-4f90-ae5d-ec026b77dd7e'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [DBA - Index Defragmentation (Tuesday & Thursday)]    Script Date: 2/26/2020 10:02:48 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2/26/2020 10:02:48 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DBA - Index Defragmentation (Tuesday & Thursday)', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'DBA', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Index Maintenance]    Script Date: 2/26/2020 10:02:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Index Maintenance', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=4, 
		@on_fail_step_id=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.dba_indexDefrag_sp
              @executeSQL           = 1
            , @printCommands        = 1
            , @debugMode            = 1
            , @printFragmentation   = 1
            , @forceRescan          = 1
            , @maxDopRestriction    = 1
            , @minPageCount         = 8
            , @maxPageCount         = NULL
            , @minFragmentation     = 1
            , @rebuildThreshold     = 30
            , @defragDelay          = ''00:00:05''
            , @defragOrderColumn    = ''page_count''
            , @defragSortOrder      = ''DESC''
            , @excludeMaxPartition  = 1
            , @timeLimit            = NULL
            , @database             = NULL;', 
		@database_name=N'DBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Update Statistics]    Script Date: 2/26/2020 10:02:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Update Statistics', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC dba_SPUpdateStats', 
		@database_name=N'DBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'schedule 1', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=20, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20180906, 
		@active_end_date=99991231, 
		@active_start_time=30000, 
		@active_end_time=235959, 
		@schedule_uid=N'2e742505-ccfb-48d9-b659-80e230398ef8'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [DBA - Long Running Queries]    Script Date: 2/26/2020 10:02:48 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2/26/2020 10:02:48 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DBA - Long Running Queries', 
		@enabled=0, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'imeCentric', 
		@notify_email_operator_name=N'DBA', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [step 1]    Script Date: 2/26/2020 10:02:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'step 1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC  [DBA].[dbo].[sp_LongRunningQueries]
', 
		@database_name=N'DBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'schedule 1', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=5, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20180904, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'c2f5e17e-d83d-49d1-b3db-56e1699d5e61'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [DBA - Monitor Log File Growth]    Script Date: 2/26/2020 10:02:48 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2/26/2020 10:02:48 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DBA - Monitor Log File Growth', 
		@enabled=0, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'imeCentric', 
		@notify_email_operator_name=N'DBA', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [step 1]    Script Date: 2/26/2020 10:02:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'step 1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'
USE [DBA];
GO

-- This part has been ran once to create the staging Table

/* 
IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = ''dbo'' 
                 AND  TABLE_NAME = ''SQLskills_TrackLogSpace''))
 
BEGIN
	CREATE TABLE [dbo].[SQLskills_TrackLogSpace](
		[DatabaseName] [VARCHAR](250) NULL,
		[LogSizeMB] [DECIMAL](38, 0) NULL,
		[LogSpaceUsed] [DECIMAL](38, 0) NULL,
		[LogStatus] [TINYINT] NULL,
		[CaptureDate] [DATETIME2](7) NULL
	) ON [PRIMARY];
 
	ALTER TABLE [dbo].[SQLskills_TrackLogSpace] ADD  DEFAULT (SYSDATETIME()) FOR [CaptureDate];
 
END

*/
 
CREATE TABLE #LogSpace_Temp (
	DatabaseName VARCHAR(100),
	LogSizeMB DECIMAL(10,2),
	LogSpaceUsed DECIMAL(10,2),
	LogStatus VARCHAR(1)
	);
 
INSERT INTO #LogSpace_Temp EXEC(''dbcc sqlperf(logspace)'');
 
INSERT INTO DBA.dbo.SQLskills_TrackLogSpace 
	(DatabaseName, LogSizeMB, LogSpaceUsed, LogStatus)
	SELECT DatabaseName, LogSizeMB, LogSpaceUsed, LogStatus
	FROM #LogSpace_Temp;
 
-- remove records older than 7 days but adjust accordingly for your needs

DELETE
FROM [DBA].dbo.SQLskills_TrackLogSpace 
WHERE CaptureDate < dateadd(dd, -30, getdate())

DROP TABLE #LogSpace_Temp;', 
		@database_name=N'DBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'schedule 1', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20180829, 
		@active_end_date=99991231, 
		@active_start_time=70000, 
		@active_end_time=235959, 
		@schedule_uid=N'7ce99099-7f5b-4d82-8915-d754079d98f1'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [DBA - SQL Server Health Check]    Script Date: 2/26/2020 10:02:48 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2/26/2020 10:02:49 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DBA - SQL Server Health Check', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'DBA', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [SQL Server HealthCheck]    Script Date: 2/26/2020 10:02:49 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'SQL Server HealthCheck', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC [dba].[dbo].[sp_ServerHealthCheck]', 
		@database_name=N'DBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'schedule 1', 
		@enabled=1, 
		@freq_type=32, 
		@freq_interval=2, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=1, 
		@freq_recurrence_factor=1, 
		@active_start_date=20180827, 
		@active_end_date=99991231, 
		@active_start_time=90000, 
		@active_end_time=235959, 
		@schedule_uid=N'8f03bdbd-ebdc-45af-a489-ddd12a3327df'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [DBA_CommandLog Cleanup]    Script Date: 2/26/2020 10:02:49 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Database Maintenance]    Script Date: 2/26/2020 10:02:49 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DBA_CommandLog Cleanup', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Source: https://ola.hallengren.com', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'imeCentric', 
		@notify_email_operator_name=N'DBA', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [CommandLog Cleanup]    Script Date: 2/26/2020 10:02:49 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'CommandLog Cleanup', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DELETE FROM [dbo].[CommandLog]
WHERE StartTime < DATEADD(dd,-30,GETDATE())', 
		@database_name=N'DBA', 
		@output_file_name=N'C:\Program Files\Microsoft SQL Server\MSSQL11.EW_IME_CENTRIC\MSSQL\LOG\CommandLogCleanup_$(ESCAPE_SQUOTE(JOBID))_$(ESCAPE_SQUOTE(STEPID))_$(ESCAPE_SQUOTE(STRTDT))_$(ESCAPE_SQUOTE(STRTTM)).txt', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'schedule 1', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=2, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20180829, 
		@active_end_date=99991231, 
		@active_start_time=70000, 
		@active_end_time=235959, 
		@schedule_uid=N'3da76091-b7a0-43d7-a821-e657338fce5e'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [Disk Space Monitor Job]    Script Date: 2/26/2020 10:02:49 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2/26/2020 10:02:49 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Disk Space Monitor Job', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'SQL Sentry Placeholder job.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'imeCentric', 
		@notify_email_operator_name=N'DBA', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [simulate delay]    Script Date: 2/26/2020 10:02:49 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'simulate delay', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'WAITFOR DELAY ''00:00:05''', 
		@database_name=N'msdb', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Disk Space Monitor Schedule', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20131127, 
		@active_end_date=99991231, 
		@active_start_time=230000, 
		@active_end_time=235959, 
		@schedule_uid=N'375211bc-b1a6-461e-9d8d-fa63a030bd04'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [Distribution clean up: distribution]    Script Date: 2/26/2020 10:02:49 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [REPL-Distribution Cleanup]    Script Date: 2/26/2020 10:02:49 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'REPL-Distribution Cleanup' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'REPL-Distribution Cleanup'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Distribution clean up: distribution', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Removes replicated transactions from the distribution database.', 
		@category_name=N'REPL-Distribution Cleanup', 
		@owner_login_name=N'DOMAIN\Ashley.Fuqua-Smith', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Run agent.]    Script Date: 2/26/2020 10:02:49 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Run agent.', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC dbo.sp_MSdistribution_cleanup @min_distretention = 0, @max_distretention = 72', 
		@server=N'SQLSERVER5\EW_IME_CENTRIC', 
		@database_name=N'distribution', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Replication agent schedule.', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=10, 
		@freq_relative_interval=1, 
		@freq_recurrence_factor=0, 
		@active_start_date=20190415, 
		@active_end_date=99991231, 
		@active_start_time=500, 
		@active_end_time=459, 
		@schedule_uid=N'08d8fbb0-26a8-4e60-a5ab-febd4e9fcd1e'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [Expired subscription clean up]    Script Date: 2/26/2020 10:02:49 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [REPL-Subscription Cleanup]    Script Date: 2/26/2020 10:02:49 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'REPL-Subscription Cleanup' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'REPL-Subscription Cleanup'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Expired subscription clean up', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Detects and removes expired subscriptions from published databases or distribution databases.', 
		@category_name=N'REPL-Subscription Cleanup', 
		@owner_login_name=N'DOMAIN\Ashley.Fuqua-Smith', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Run agent.]    Script Date: 2/26/2020 10:02:49 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Run agent.', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC sys.sp_expired_subscription_cleanup', 
		@server=N'SQLSERVER5\EW_IME_CENTRIC', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Replication agent schedule.', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=1, 
		@freq_relative_interval=1, 
		@freq_recurrence_factor=0, 
		@active_start_date=20190415, 
		@active_end_date=99991231, 
		@active_start_time=10000, 
		@active_end_time=235959, 
		@schedule_uid=N'e6697f3d-b4c9-4fcc-a4a8-ea8bf413dd8f'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [GPInvoice Info Changed]    Script Date: 2/26/2020 10:02:49 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2/26/2020 10:02:49 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
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
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'imeCentric', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Insert Data]    Script Date: 2/26/2020 10:02:49 PM ******/
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

/****** Object:  Job [Index Fragmentation (Every Saturday)]    Script Date: 2/26/2020 10:02:49 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2/26/2020 10:02:49 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Index Fragmentation (Every Saturday)', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'DBA', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Index Maintenance]    Script Date: 2/26/2020 10:02:49 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Index Maintenance', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=4, 
		@on_fail_step_id=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXECUTE dbo.dba_indexDefrag_sp
              @executeSQL           = 1
            , @printCommands        = 1
            , @debugMode            = 1
            , @printFragmentation   = 1
            , @forceRescan          = 1
            , @maxDopRestriction    = 1
            , @minPageCount         = 8
            , @maxPageCount         = NULL
            , @minFragmentation     = 1
            , @rebuildThreshold     = 30
            , @defragDelay          = ''00:00:05''
            , @defragOrderColumn    = ''page_count''
            , @defragSortOrder      = ''DESC''
            , @excludeMaxPartition  = 1
            , @timeLimit            = NULL
            , @database             = NULL;', 
		@database_name=N'DBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Update Statistics]    Script Date: 2/26/2020 10:02:49 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Update Statistics', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC dba_SPUpdateStats', 
		@database_name=N'DBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'schedule 1', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=64, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20181009, 
		@active_end_date=99991231, 
		@active_start_time=30000, 
		@active_end_time=235959, 
		@schedule_uid=N'b279a1f5-0f89-48dc-aceb-10595402070e'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [Output File Cleanup]    Script Date: 2/26/2020 10:02:49 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Database Maintenance]    Script Date: 2/26/2020 10:02:49 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Output File Cleanup', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Source: https://ola.hallengren.com', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'imeCentric', 
		@notify_email_operator_name=N'DBA', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Output File Cleanup]    Script Date: 2/26/2020 10:02:49 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Output File Cleanup', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'cmd /q /c "For /F "tokens=1 delims=" %v In (''ForFiles /P "C:\Program Files\Microsoft SQL Server\MSSQL11.EW_IME_CENTRIC\MSSQL\LOG" /m *_*_*_*.txt /d -30 2^>^&1'') do if EXIST "C:\Program Files\Microsoft SQL Server\MSSQL11.EW_IME_CENTRIC\MSSQL\LOG"\%v echo del "C:\Program Files\Microsoft SQL Server\MSSQL11.EW_IME_CENTRIC\MSSQL\LOG"\%v& del "C:\Program Files\Microsoft SQL Server\MSSQL11.EW_IME_CENTRIC\MSSQL\LOG"\%v"', 
		@output_file_name=N'C:\Program Files\Microsoft SQL Server\MSSQL11.EW_IME_CENTRIC\MSSQL\LOG\OutputFileCleanup_$(ESCAPE_SQUOTE(JOBID))_$(ESCAPE_SQUOTE(STEPID))_$(ESCAPE_SQUOTE(STRTDT))_$(ESCAPE_SQUOTE(STRTTM)).txt', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [Refresh OMS Doctor Integration]    Script Date: 2/26/2020 10:02:49 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2/26/2020 10:02:49 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
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
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'imeCentric', 
		@notify_email_operator_name=N'DBA', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Refresh EWDoctorExt]    Script Date: 2/26/2020 10:02:49 PM ******/
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
/****** Object:  Step [Refresh Notes]    Script Date: 2/26/2020 10:02:49 PM ******/
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
/****** Object:  Step [Refresh License Status]    Script Date: 2/26/2020 10:02:49 PM ******/
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
/****** Object:  Step [Refresh Databases]    Script Date: 2/26/2020 10:02:49 PM ******/
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
/****** Object:  Step [Refresh Accreditations]    Script Date: 2/26/2020 10:02:49 PM ******/
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
/****** Object:  Step [Refresh Specialties]    Script Date: 2/26/2020 10:02:49 PM ******/
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
/****** Object:  Step [Refresh Keywords]    Script Date: 2/26/2020 10:02:49 PM ******/
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
/****** Object:  Step [Refresh Languages]    Script Date: 2/26/2020 10:02:49 PM ******/
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
/****** Object:  Step [Refresh Business Lines]    Script Date: 2/26/2020 10:02:49 PM ******/
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
/****** Object:  Step [Refresh Offices]    Script Date: 2/26/2020 10:02:49 PM ******/
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
/****** Object:  Step [Refresh Exam Locations]    Script Date: 2/26/2020 10:02:49 PM ******/
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

/****** Object:  Job [Reinitialize subscriptions having data validation failures]    Script Date: 2/26/2020 10:02:49 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [REPL-Alert Response]    Script Date: 2/26/2020 10:02:49 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'REPL-Alert Response' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'REPL-Alert Response'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Reinitialize subscriptions having data validation failures', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Reinitializes all subscriptions that have data validation failures.', 
		@category_name=N'REPL-Alert Response', 
		@owner_login_name=N'DOMAIN\Ashley.Fuqua-Smith', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Run agent.]    Script Date: 2/26/2020 10:02:49 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Run agent.', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec sys.sp_MSreinit_failed_subscriptions @failure_level = 1', 
		@server=N'SQLSERVER5\EW_IME_CENTRIC', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [Replication agents checkup]    Script Date: 2/26/2020 10:02:49 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [REPL-Checkup]    Script Date: 2/26/2020 10:02:49 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'REPL-Checkup' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'REPL-Checkup'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Replication agents checkup', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Detects replication agents that are not logging history actively.', 
		@category_name=N'REPL-Checkup', 
		@owner_login_name=N'DOMAIN\Ashley.Fuqua-Smith', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Run agent.]    Script Date: 2/26/2020 10:02:49 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Run agent.', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'sys.sp_replication_agent_checkup @heartbeat_interval = 10', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Replication agent schedule.', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=10, 
		@freq_relative_interval=1, 
		@freq_recurrence_factor=0, 
		@active_start_date=20190415, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'f7aa5cea-104e-4fbe-a487-d64cc39942b3'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [Replication monitoring refresher for distribution.]    Script Date: 2/26/2020 10:02:49 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [REPL-Alert Response]    Script Date: 2/26/2020 10:02:49 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'REPL-Alert Response' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'REPL-Alert Response'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Replication monitoring refresher for distribution.', 
		@enabled=0, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Replication monitoring refresher for distribution.', 
		@category_name=N'REPL-Alert Response', 
		@owner_login_name=N'DOMAIN\Ashley.Fuqua-Smith', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Run agent.]    Script Date: 2/26/2020 10:02:49 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Run agent.', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=2147483647, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec dbo.sp_replmonitorrefreshjob  ', 
		@server=N'SQLSERVER5\EW_IME_CENTRIC', 
		@database_name=N'distribution', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Replication agent schedule.', 
		@enabled=1, 
		@freq_type=64, 
		@freq_interval=0, 
		@freq_subday_type=0, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20190415, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'340c1849-364a-471c-b85b-cf646aec7589'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

/****** Object:  Job [sp_purge_jobhistory]    Script Date: 2/26/2020 10:02:49 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Database Maintenance]    Script Date: 2/26/2020 10:02:49 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'sp_purge_jobhistory', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Source: https://ola.hallengren.com', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'imeCentric', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [sp_purge_jobhistory]    Script Date: 2/26/2020 10:02:49 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'sp_purge_jobhistory', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @CleanupDate datetime
SET @CleanupDate = DATEADD(dd,-30,GETDATE())
EXECUTE dbo.sp_purge_jobhistory @oldest_date = @CleanupDate', 
		@database_name=N'msdb', 
		@output_file_name=N'C:\Program Files\Microsoft SQL Server\MSSQL11.EW_IME_CENTRIC\MSSQL\LOG\sp_purge_jobhistory_$(ESCAPE_SQUOTE(JOBID))_$(ESCAPE_SQUOTE(STEPID))_$(ESCAPE_SQUOTE(STRTDT))_$(ESCAPE_SQUOTE(STRTTM)).txt', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

