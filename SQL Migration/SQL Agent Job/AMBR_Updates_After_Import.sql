USE [msdb]
GO

/****** Object:  Job [AMBR_Updates_After_Import]    Script Date: 2/26/2020 10:30:11 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2/26/2020 10:30:11 PM ******/
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
/****** Object:  Step [Flip processed flag for unposted invoices]    Script Date: 2/26/2020 10:30:12 PM ******/
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
/****** Object:  Step [Flip processed flag for posted invoices]    Script Date: 2/26/2020 10:30:12 PM ******/
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

