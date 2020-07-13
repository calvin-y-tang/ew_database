-- Enabling the replication database
use master
exec sp_replicationdboption @dbname = N'IMECentricEW', @optname = N'publish', @value = N'true'
GO

exec [IMECentricEW].sys.sp_addlogreader_agent @job_login = N'DOMAIN\SQL_IMEC_Replication', @job_password = N'$qLiM3cR3p', @publisher_security_mode = 1
GO
-- Adding the transactional publication
use [IMECentricEW]
exec sp_addpublication @publication = N'IMECentricEW', @description = N'Transactional publication of database ''IMECentricEW'' from Publisher ''SQLSERVER7\EW_IME_CENTRIC''.', @sync_method = N'concurrent', @retention = 0, @allow_push = N'true', @allow_pull = N'true', @allow_anonymous = N'false', @enabled_for_internet = N'false', @snapshot_in_defaultfolder = N'true', @compress_snapshot = N'false', @ftp_port = 21, @ftp_login = N'anonymous', @allow_subscription_copy = N'false', @add_to_active_directory = N'false', @repl_freq = N'continuous', @status = N'active', @independent_agent = N'true', @immediate_sync = N'true', @allow_sync_tran = N'false', @autogen_sync_procs = N'false', @allow_queued_tran = N'false', @allow_dts = N'false', @replicate_ddl = 1, @allow_initialize_from_backup = N'false', @enabled_for_p2p = N'false', @enabled_for_het_sub = N'false'
GO


exec sp_addpublication_snapshot @publication = N'IMECentricEW', @frequency_type = 1, @frequency_interval = 0, @frequency_relative_interval = 0, @frequency_recurrence_factor = 0, @frequency_subday = 0, @frequency_subday_interval = 0, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 0, @active_end_date = 0, @job_login = N'DOMAIN\SQL_IMEC_Replication', @job_password = N'$qLiM3cR3p', @publisher_security_mode = 1
GO

exec sp_grant_publication_access @publication = N'IMECentricEW', @login = N'sa'
GO
exec sp_grant_publication_access @publication = N'IMECentricEW', @login = N'NT SERVICE\SQLWriter'
GO
exec sp_grant_publication_access @publication = N'IMECentricEW', @login = N'NT SERVICE\Winmgmt'
GO
exec sp_grant_publication_access @publication = N'IMECentricEW', @login = N'NT Service\MSSQL$EW_IME_CENTRIC'
GO
exec sp_grant_publication_access @publication = N'IMECentricEW', @login = N'NT SERVICE\SQLAgent$EW_IME_CENTRIC'
GO
exec sp_grant_publication_access @publication = N'IMECentricEW', @login = N'sys-admin'
GO
exec sp_grant_publication_access @publication = N'IMECentricEW', @login = N'imeCentric'
GO
exec sp_grant_publication_access @publication = N'IMECentricEW', @login = N'DOMAIN\commvault.sqlservice'
GO
exec sp_grant_publication_access @publication = N'IMECentricEW', @login = N'DOMAIN\SQLSentry'
GO
exec sp_grant_publication_access @publication = N'IMECentricEW', @login = N'EW\ISEWIS-DL'
GO
exec sp_grant_publication_access @publication = N'IMECentricEW', @login = N'DOMAIN\EWIntegrationServer'
GO
exec sp_grant_publication_access @publication = N'IMECentricEW', @login = N'EW\ISSQLAdmin-DL'
GO
exec sp_grant_publication_access @publication = N'IMECentricEW', @login = N'distributor_admin'
GO
exec sp_grant_publication_access @publication = N'IMECentricEW', @login = N'DOMAIN\SQL_IMEC_Replication'
GO

-- Adding the transactional articles
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'fnDateValue', @source_owner = N'dbo', @source_object = N'fnDateValue', @type = N'func schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'fnDateValue', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'fnGetBusinessDays', @source_owner = N'dbo', @source_object = N'fnGetBusinessDays', @type = N'func schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'fnGetBusinessDays', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'fnGetCaseDocument', @source_owner = N'dbo', @source_object = N'fnGetCaseDocument', @type = N'func schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'fnGetCaseDocument', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'fnGetCaseDocumentPath', @source_owner = N'dbo', @source_object = N'fnGetCaseDocumentPath', @type = N'func schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'fnGetCaseDocumentPath', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'fnGetDoctorDocumentPath', @source_owner = N'dbo', @source_object = N'fnGetDoctorDocumentPath', @type = N'func schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'fnGetDoctorDocumentPath', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'fnGetFirstWeekdayInMonth', @source_owner = N'dbo', @source_object = N'fnGetFirstWeekdayInMonth', @type = N'func schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'fnGetFirstWeekdayInMonth', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'fnGetLastWeekdayInMonth', @source_owner = N'dbo', @source_object = N'fnGetLastWeekdayInMonth', @type = N'func schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'fnGetLastWeekdayInMonth', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'fnGetOfficeDateTime', @source_owner = N'dbo', @source_object = N'fnGetOfficeDateTime', @type = N'func schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'fnGetOfficeDateTime', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'fnGetParamValue', @source_owner = N'dbo', @source_object = N'fnGetParamValue', @type = N'func schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'fnGetParamValue', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'fnGetTATMins', @source_owner = N'dbo', @source_object = N'fnGetTATMins', @type = N'func schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'fnGetTATMins', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'fnGetTATString', @source_owner = N'dbo', @source_object = N'fnGetTATString', @type = N'func schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'fnGetTATString', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'fnGetTranscriptionDocumentPath', @source_owner = N'dbo', @source_object = N'fnGetTranscriptionDocumentPath', @type = N'func schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'fnGetTranscriptionDocumentPath', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'fnGetUTCOffset', @source_owner = N'dbo', @source_object = N'fnGetUTCOffset', @type = N'func schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'fnGetUTCOffset', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'fnIsAddressComplete', @source_owner = N'dbo', @source_object = N'fnIsAddressComplete', @type = N'func schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'fnIsAddressComplete', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'fnIsWorkDay', @source_owner = N'dbo', @source_object = N'fnIsWorkDay', @type = N'func schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'fnIsWorkDay', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'fnParseKeyValueStringForKey', @source_owner = N'dbo', @source_object = N'fnParseKeyValueStringForKey', @type = N'func schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'fnParseKeyValueStringForKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'GetZipDistanceMiles', @source_owner = N'dbo', @source_object = N'GetZipDistanceMiles', @type = N'func schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'GetZipDistanceMiles', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_AdminCheckDupeWebUser', @source_owner = N'dbo', @source_object = N'proc_AdminCheckDupeWebUser', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_AdminCheckDupeWebUser', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_AdminGetUserGrid', @source_owner = N'dbo', @source_object = N'proc_AdminGetUserGrid', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_AdminGetUserGrid', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_AdminGetWebUserDataByWebUserID', @source_owner = N'dbo', @source_object = N'proc_AdminGetWebUserDataByWebUserID', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_AdminGetWebUserDataByWebUserID', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_AdminWebUserUpdate', @source_owner = N'dbo', @source_object = N'proc_AdminWebUserUpdate', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_AdminWebUserUpdate', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_AreNPCasesPresentByUser', @source_owner = N'dbo', @source_object = N'proc_AreNPCasesPresentByUser', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_AreNPCasesPresentByUser', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CalcNonWorkDay', @source_owner = N'dbo', @source_object = N'proc_CalcNonWorkDay', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CalcNonWorkDay', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CancelCase', @source_owner = N'dbo', @source_object = N'proc_CancelCase', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CancelCase', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseAccredidation_Insert', @source_owner = N'dbo', @source_object = N'proc_CaseAccredidation_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseAccredidation_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseAccredidation_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_CaseAccredidation_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseAccredidation_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseAppt_Delete', @source_owner = N'dbo', @source_object = N'proc_CaseAppt_Delete', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseAppt_Delete', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseAppt_Insert', @source_owner = N'dbo', @source_object = N'proc_CaseAppt_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseAppt_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseAppt_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_CaseAppt_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseAppt_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseDefDocument_Delete', @source_owner = N'dbo', @source_object = N'proc_CaseDefDocument_Delete', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseDefDocument_Delete', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseDefDocument_Insert', @source_owner = N'dbo', @source_object = N'proc_CaseDefDocument_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseDefDocument_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseDefDocument_LoadAll', @source_owner = N'dbo', @source_object = N'proc_CaseDefDocument_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseDefDocument_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseDefDocument_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_CaseDefDocument_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseDefDocument_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseDefDocument_Update', @source_owner = N'dbo', @source_object = N'proc_CaseDefDocument_Update', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseDefDocument_Update', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseDocument_LoadExprtGridByCaseNbr', @source_owner = N'dbo', @source_object = N'proc_CaseDocument_LoadExprtGridByCaseNbr', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseDocument_LoadExprtGridByCaseNbr', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseDocuments_CheckIfExists', @source_owner = N'dbo', @source_object = N'proc_CaseDocuments_CheckIfExists', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseDocuments_CheckIfExists', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseDocuments_Delete', @source_owner = N'dbo', @source_object = N'proc_CaseDocuments_Delete', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseDocuments_Delete', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseDocuments_Insert', @source_owner = N'dbo', @source_object = N'proc_CaseDocuments_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseDocuments_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseDocuments_LoadAll', @source_owner = N'dbo', @source_object = N'proc_CaseDocuments_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseDocuments_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseDocuments_LoadByCaseNbrAndWebUserID', @source_owner = N'dbo', @source_object = N'proc_CaseDocuments_LoadByCaseNbrAndWebUserID', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseDocuments_LoadByCaseNbrAndWebUserID', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseDocuments_LoadByCaseNbrProgressive', @source_owner = N'dbo', @source_object = N'proc_CaseDocuments_LoadByCaseNbrProgressive', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseDocuments_LoadByCaseNbrProgressive', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseDocuments_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_CaseDocuments_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseDocuments_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseDocuments_LoadByWebUserIDAndLastLoginDate', @source_owner = N'dbo', @source_object = N'proc_CaseDocuments_LoadByWebUserIDAndLastLoginDate', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseDocuments_LoadByWebUserIDAndLastLoginDate', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseDocuments_LoadByWebUserIDAndLastLoginDateCount', @source_owner = N'dbo', @source_object = N'proc_CaseDocuments_LoadByWebUserIDAndLastLoginDateCount', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseDocuments_LoadByWebUserIDAndLastLoginDateCount', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseDocuments_LoadByWebUserIDAndLastLoginDateCountProgressive', @source_owner = N'dbo', @source_object = N'proc_CaseDocuments_LoadByWebUserIDAndLastLoginDateCountProgressive', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseDocuments_LoadByWebUserIDAndLastLoginDateCountProgressive', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseDocuments_LoadByWebUserIDAndLastLoginDateProgressive', @source_owner = N'dbo', @source_object = N'proc_CaseDocuments_LoadByWebUserIDAndLastLoginDateProgressive', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseDocuments_LoadByWebUserIDAndLastLoginDateProgressive', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseDocuments_Update', @source_owner = N'dbo', @source_object = N'proc_CaseDocuments_Update', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseDocuments_Update', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseHistory_Delete', @source_owner = N'dbo', @source_object = N'proc_CaseHistory_Delete', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseHistory_Delete', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseHistory_Insert', @source_owner = N'dbo', @source_object = N'proc_CaseHistory_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseHistory_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseHistory_LoadAll', @source_owner = N'dbo', @source_object = N'proc_CaseHistory_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseHistory_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseHistory_LoadByCaseNbrAndType', @source_owner = N'dbo', @source_object = N'proc_CaseHistory_LoadByCaseNbrAndType', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseHistory_LoadByCaseNbrAndType', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseHistory_LoadByCaseNbrAndWebUserID', @source_owner = N'dbo', @source_object = N'proc_CaseHistory_LoadByCaseNbrAndWebUserID', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseHistory_LoadByCaseNbrAndWebUserID', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseHistory_LoadByCaseNbrProgressive', @source_owner = N'dbo', @source_object = N'proc_CaseHistory_LoadByCaseNbrProgressive', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseHistory_LoadByCaseNbrProgressive', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseHistory_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_CaseHistory_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseHistory_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseHistory_LoadByWebUserIDAndLastLoginDate', @source_owner = N'dbo', @source_object = N'proc_CaseHistory_LoadByWebUserIDAndLastLoginDate', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseHistory_LoadByWebUserIDAndLastLoginDate', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseHistory_LoadByWebUserIDAndLastLoginDateCount', @source_owner = N'dbo', @source_object = N'proc_CaseHistory_LoadByWebUserIDAndLastLoginDateCount', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseHistory_LoadByWebUserIDAndLastLoginDateCount', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseHistory_LoadByWebUserIDAndViewed', @source_owner = N'dbo', @source_object = N'proc_CaseHistory_LoadByWebUserIDAndViewed', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseHistory_LoadByWebUserIDAndViewed', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseHistory_LoadByWebUserIDAndViewedCount', @source_owner = N'dbo', @source_object = N'proc_CaseHistory_LoadByWebUserIDAndViewedCount', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseHistory_LoadByWebUserIDAndViewedCount', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseHistory_LoadExprtGridByCaseNbr', @source_owner = N'dbo', @source_object = N'proc_CaseHistory_LoadExprtGridByCaseNbr', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseHistory_LoadExprtGridByCaseNbr', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseHistory_Update', @source_owner = N'dbo', @source_object = N'proc_CaseHistory_Update', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseHistory_Update', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseHistory_UpdateViewed', @source_owner = N'dbo', @source_object = N'proc_CaseHistory_UpdateViewed', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseHistory_UpdateViewed', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseICDRequest_Delete', @source_owner = N'dbo', @source_object = N'proc_CaseICDRequest_Delete', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseICDRequest_Delete', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseICDRequest_Insert', @source_owner = N'dbo', @source_object = N'proc_CaseICDRequest_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseICDRequest_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseICDRequest_LoadAll', @source_owner = N'dbo', @source_object = N'proc_CaseICDRequest_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseICDRequest_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseICDRequest_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_CaseICDRequest_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseICDRequest_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseIssue_Delete', @source_owner = N'dbo', @source_object = N'proc_CaseIssue_Delete', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseIssue_Delete', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseIssue_Insert', @source_owner = N'dbo', @source_object = N'proc_CaseIssue_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseIssue_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseIssue_LoadAll', @source_owner = N'dbo', @source_object = N'proc_CaseIssue_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseIssue_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseIssue_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_CaseIssue_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseIssue_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseIssue_Update', @source_owner = N'dbo', @source_object = N'proc_CaseIssue_Update', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseIssue_Update', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CasePeerBill_Insert', @source_owner = N'dbo', @source_object = N'proc_CasePeerBill_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CasePeerBill_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CasePeerBill_LoadByCaseNbr', @source_owner = N'dbo', @source_object = N'proc_CasePeerBill_LoadByCaseNbr', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CasePeerBill_LoadByCaseNbr', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CasePeerBill_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_CasePeerBill_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CasePeerBill_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseProblem_Delete', @source_owner = N'dbo', @source_object = N'proc_CaseProblem_Delete', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseProblem_Delete', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseProblem_Insert', @source_owner = N'dbo', @source_object = N'proc_CaseProblem_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseProblem_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseProblem_LoadAll', @source_owner = N'dbo', @source_object = N'proc_CaseProblem_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseProblem_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseProblem_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_CaseProblem_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseProblem_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseProblem_Update', @source_owner = N'dbo', @source_object = N'proc_CaseProblem_Update', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseProblem_Update', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseReason_LoadByCaseNbr', @source_owner = N'dbo', @source_object = N'proc_CaseReason_LoadByCaseNbr', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseReason_LoadByCaseNbr', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseRelatedParty_Insert', @source_owner = N'dbo', @source_object = N'proc_CaseRelatedParty_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseRelatedParty_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseRelatedParty_LoadAll', @source_owner = N'dbo', @source_object = N'proc_CaseRelatedParty_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseRelatedParty_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseRelatedParty_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_CaseRelatedParty_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseRelatedParty_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseReviewItem_Insert', @source_owner = N'dbo', @source_object = N'proc_CaseReviewItem_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseReviewItem_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseReviewItem_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_CaseReviewItem_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseReviewItem_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseReviewItem_Update', @source_owner = N'dbo', @source_object = N'proc_CaseReviewItem_Update', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseReviewItem_Update', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseSpecialty_Insert', @source_owner = N'dbo', @source_object = N'proc_CaseSpecialty_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseSpecialty_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseSpecialty_LoadByCaseNbr', @source_owner = N'dbo', @source_object = N'proc_CaseSpecialty_LoadByCaseNbr', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseSpecialty_LoadByCaseNbr', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseSpecialty_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_CaseSpecialty_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseSpecialty_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseType_LoadAll', @source_owner = N'dbo', @source_object = N'proc_CaseType_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseType_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseType_LoadAllOrderByCode', @source_owner = N'dbo', @source_object = N'proc_CaseType_LoadAllOrderByCode', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseType_LoadAllOrderByCode', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseType_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_CaseType_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseType_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseType_LoadComboByOfficeCode', @source_owner = N'dbo', @source_object = N'proc_CaseType_LoadComboByOfficeCode', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseType_LoadComboByOfficeCode', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseUpdateICDCodeFields', @source_owner = N'dbo', @source_object = N'proc_CaseUpdateICDCodeFields', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseUpdateICDCodeFields', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseVerifyAccess', @source_owner = N'dbo', @source_object = N'proc_CaseVerifyAccess', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseVerifyAccess', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CaseVerifyAccessNP', @source_owner = N'dbo', @source_object = N'proc_CaseVerifyAccessNP', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CaseVerifyAccessNP', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CCAddress_Delete', @source_owner = N'dbo', @source_object = N'proc_CCAddress_Delete', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CCAddress_Delete', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CCAddress_GetDefaultOffice', @source_owner = N'dbo', @source_object = N'proc_CCAddress_GetDefaultOffice', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CCAddress_GetDefaultOffice', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CCAddress_Insert', @source_owner = N'dbo', @source_object = N'proc_CCAddress_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CCAddress_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CCAddress_LoadAll', @source_owner = N'dbo', @source_object = N'proc_CCAddress_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CCAddress_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CCAddress_LoadByName', @source_owner = N'dbo', @source_object = N'proc_CCAddress_LoadByName', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CCAddress_LoadByName', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CCAddress_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_CCAddress_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CCAddress_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CCAddress_Update', @source_owner = N'dbo', @source_object = N'proc_CCAddress_Update', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CCAddress_Update', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CCAddressCheckForDupe', @source_owner = N'dbo', @source_object = N'proc_CCAddressCheckForDupe', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CCAddressCheckForDupe', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CheckAssignedPendingTranscriptionsByTransCode', @source_owner = N'dbo', @source_object = N'proc_CheckAssignedPendingTranscriptionsByTransCode', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CheckAssignedPendingTranscriptionsByTransCode', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CheckForExamineeDupeProgressive', @source_owner = N'dbo', @source_object = N'proc_CheckForExamineeDupeProgressive', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CheckForExamineeDupeProgressive', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CheckForWebEventOverride', @source_owner = N'dbo', @source_object = N'proc_CheckForWebEventOverride', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CheckForWebEventOverride', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Client_GetDefaultOffice', @source_owner = N'dbo', @source_object = N'proc_Client_GetDefaultOffice', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Client_GetDefaultOffice', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Client_IsPhotoRqd', @source_owner = N'dbo', @source_object = N'proc_Client_IsPhotoRqd', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Client_IsPhotoRqd', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Client_LoadAll', @source_owner = N'dbo', @source_object = N'proc_Client_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Client_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Client_LoadByParentCompany', @source_owner = N'dbo', @source_object = N'proc_Client_LoadByParentCompany', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Client_LoadByParentCompany', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Client_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_Client_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Client_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Client_LoadByUserIDAndEmail', @source_owner = N'dbo', @source_object = N'proc_Client_LoadByUserIDAndEmail', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Client_LoadByUserIDAndEmail', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_ClientDefDocument_LoadAll', @source_owner = N'dbo', @source_object = N'proc_ClientDefDocument_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_ClientDefDocument_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_ClientDefDocument_LoadByClientCode', @source_owner = N'dbo', @source_object = N'proc_ClientDefDocument_LoadByClientCode', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_ClientDefDocument_LoadByClientCode', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_ClientDefDocument_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_ClientDefDocument_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_ClientDefDocument_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Company_IsCaseAcknowledgment', @source_owner = N'dbo', @source_object = N'proc_Company_IsCaseAcknowledgment', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Company_IsCaseAcknowledgment', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Company_LoadAll', @source_owner = N'dbo', @source_object = N'proc_Company_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Company_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Company_LoadByEWCompanyID', @source_owner = N'dbo', @source_object = N'proc_Company_LoadByEWCompanyID', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Company_LoadByEWCompanyID', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Company_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_Company_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Company_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Control_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_Control_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Control_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CoverLetterGetBookmarkValuesByCase', @source_owner = N'dbo', @source_object = N'proc_CoverLetterGetBookmarkValuesByCase', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CoverLetterGetBookmarkValuesByCase', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CustomerData_Insert', @source_owner = N'dbo', @source_object = N'proc_CustomerData_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CustomerData_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_CustomerData_LoadByTableKey', @source_owner = N'dbo', @source_object = N'proc_CustomerData_LoadByTableKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_CustomerData_LoadByTableKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Doctor_GetActiveDoctors', @source_owner = N'dbo', @source_object = N'proc_Doctor_GetActiveDoctors', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Doctor_GetActiveDoctors', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Doctor_GetApptCount', @source_owner = N'dbo', @source_object = N'proc_Doctor_GetApptCount', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Doctor_GetApptCount', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Doctor_GetDefaultOffice', @source_owner = N'dbo', @source_object = N'proc_Doctor_GetDefaultOffice', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Doctor_GetDefaultOffice', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Doctor_GetDocuments', @source_owner = N'dbo', @source_object = N'proc_Doctor_GetDocuments', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Doctor_GetDocuments', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Doctor_LoadAll', @source_owner = N'dbo', @source_object = N'proc_Doctor_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Doctor_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Doctor_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_Doctor_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Doctor_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_DoctorAssistant_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_DoctorAssistant_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_DoctorAssistant_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_DoctorSchedule_Delete', @source_owner = N'dbo', @source_object = N'proc_DoctorSchedule_Delete', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_DoctorSchedule_Delete', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_DoctorSchedule_Insert', @source_owner = N'dbo', @source_object = N'proc_DoctorSchedule_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_DoctorSchedule_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_DoctorSchedule_LoadAll', @source_owner = N'dbo', @source_object = N'proc_DoctorSchedule_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_DoctorSchedule_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_DoctorSchedule_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_DoctorSchedule_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_DoctorSchedule_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_DoctorSchedule_Update', @source_owner = N'dbo', @source_object = N'proc_DoctorSchedule_Update', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_DoctorSchedule_Update', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_DoctorSchedulePortalCalendarDays', @source_owner = N'dbo', @source_object = N'proc_DoctorSchedulePortalCalendarDays', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_DoctorSchedulePortalCalendarDays', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_DoctorSchedulePortalCalendarMonth', @source_owner = N'dbo', @source_object = N'proc_DoctorSchedulePortalCalendarMonth', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_DoctorSchedulePortalCalendarMonth', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_EDIDetermination', @source_owner = N'dbo', @source_object = N'proc_EDIDetermination', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_EDIDetermination', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_EWCoverLetter_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_EWCoverLetter_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_EWCoverLetter_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_EWCoverLetterClientSpecData_LoadByEWCoverLetterID', @source_owner = N'dbo', @source_object = N'proc_EWCoverLetterClientSpecData_LoadByEWCoverLetterID', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_EWCoverLetterClientSpecData_LoadByEWCoverLetterID', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_EWCoverLetterClientSpecData_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_EWCoverLetterClientSpecData_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_EWCoverLetterClientSpecData_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_EWCoverLetterCompanyName_LoadByEWCoverLetterID', @source_owner = N'dbo', @source_object = N'proc_EWCoverLetterCompanyName_LoadByEWCoverLetterID', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_EWCoverLetterCompanyName_LoadByEWCoverLetterID', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_EWCoverLetterQuestion_LoadByEWCoverLetterID', @source_owner = N'dbo', @source_object = N'proc_EWCoverLetterQuestion_LoadByEWCoverLetterID', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_EWCoverLetterQuestion_LoadByEWCoverLetterID', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_EWCoverLetterQuestion_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_EWCoverLetterQuestion_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_EWCoverLetterQuestion_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_EWFolderDef_LoadByName', @source_owner = N'dbo', @source_object = N'proc_EWFolderDef_LoadByName', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_EWFolderDef_LoadByName', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_EWFolderDef_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_EWFolderDef_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_EWFolderDef_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_EWSecurityProfile_LoadByCompanyCode', @source_owner = N'dbo', @source_object = N'proc_EWSecurityProfile_LoadByCompanyCode', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_EWSecurityProfile_LoadByCompanyCode', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_EWSecurityProfile_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_EWSecurityProfile_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_EWSecurityProfile_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_EWTransDept_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_EWTransDept_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_EWTransDept_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Examinee_Delete', @source_owner = N'dbo', @source_object = N'proc_Examinee_Delete', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Examinee_Delete', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Examinee_Insert', @source_owner = N'dbo', @source_object = N'proc_Examinee_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Examinee_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Examinee_LoadAll', @source_owner = N'dbo', @source_object = N'proc_Examinee_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Examinee_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Examinee_LoadByName', @source_owner = N'dbo', @source_object = N'proc_Examinee_LoadByName', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Examinee_LoadByName', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Examinee_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_Examinee_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Examinee_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Examinee_Update', @source_owner = N'dbo', @source_object = N'proc_Examinee_Update', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Examinee_Update', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_ExamineeAddress_Insert', @source_owner = N'dbo', @source_object = N'proc_ExamineeAddress_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_ExamineeAddress_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_ExamineeCheckForDupe', @source_owner = N'dbo', @source_object = N'proc_ExamineeCheckForDupe', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_ExamineeCheckForDupe', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_ExamineeUpdatePrimaryAddress', @source_owner = N'dbo', @source_object = N'proc_ExamineeUpdatePrimaryAddress', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_ExamineeUpdatePrimaryAddress', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_FixWebUsers', @source_owner = N'dbo', @source_object = N'proc_FixWebUsers', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_FixWebUsers', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_getActiveAdminCases', @source_owner = N'dbo', @source_object = N'proc_getActiveAdminCases', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_getActiveAdminCases', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_getActiveCases', @source_owner = N'dbo', @source_object = N'proc_getActiveCases', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_getActiveCases', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetActiveCasesProgressive', @source_owner = N'dbo', @source_object = N'proc_GetActiveCasesProgressive', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetActiveCasesProgressive', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetAdminReferralSummaryNew', @source_owner = N'dbo', @source_object = N'proc_GetAdminReferralSummaryNew', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetAdminReferralSummaryNew', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetApptCountByCase', @source_owner = N'dbo', @source_object = N'proc_GetApptCountByCase', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetApptCountByCase', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetCaseAccredidationByCaseNbr', @source_owner = N'dbo', @source_object = N'proc_GetCaseAccredidationByCaseNbr', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetCaseAccredidationByCaseNbr', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetCaseDetails', @source_owner = N'dbo', @source_object = N'proc_GetCaseDetails', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetCaseDetails', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetCaseDetailsProgressive', @source_owner = N'dbo', @source_object = N'proc_GetCaseDetailsProgressive', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetCaseDetailsProgressive', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetCaseDocTypeComboItems', @source_owner = N'dbo', @source_object = N'proc_GetCaseDocTypeComboItems', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetCaseDocTypeComboItems', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetCaseICDRequestsByCase', @source_owner = N'dbo', @source_object = N'proc_GetCaseICDRequestsByCase', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetCaseICDRequestsByCase', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetCaseIssuesByCase', @source_owner = N'dbo', @source_object = N'proc_GetCaseIssuesByCase', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetCaseIssuesByCase', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetCaseProblemsByCase', @source_owner = N'dbo', @source_object = N'proc_GetCaseProblemsByCase', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetCaseProblemsByCase', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetCaseTypeComboItems', @source_owner = N'dbo', @source_object = N'proc_GetCaseTypeComboItems', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetCaseTypeComboItems', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetClientDetailsByUserIDNew', @source_owner = N'dbo', @source_object = N'proc_GetClientDetailsByUserIDNew', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetClientDetailsByUserIDNew', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetClientsByCompany', @source_owner = N'dbo', @source_object = N'proc_GetClientsByCompany', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetClientsByCompany', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetClientSubordinates', @source_owner = N'dbo', @source_object = N'proc_GetClientSubordinates', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetClientSubordinates', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetCompanyComboItems', @source_owner = N'dbo', @source_object = N'proc_GetCompanyComboItems', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetCompanyComboItems', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetDefaultOffice', @source_owner = N'dbo', @source_object = N'proc_GetDefaultOffice', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetDefaultOffice', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetDefaultOfficeByDefaultFlag', @source_owner = N'dbo', @source_object = N'proc_GetDefaultOfficeByDefaultFlag', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetDefaultOfficeByDefaultFlag', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetDefaultOfficeByDefaultFlagByMin', @source_owner = N'dbo', @source_object = N'proc_GetDefaultOfficeByDefaultFlagByMin', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetDefaultOfficeByDefaultFlagByMin', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetDegreeComboItems', @source_owner = N'dbo', @source_object = N'proc_GetDegreeComboItems', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetDegreeComboItems', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetDoctorLocationsAndSchedule', @source_owner = N'dbo', @source_object = N'proc_GetDoctorLocationsAndSchedule', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetDoctorLocationsAndSchedule', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetDoctorLocationsAndScheduleWithSpec', @source_owner = N'dbo', @source_object = N'proc_GetDoctorLocationsAndScheduleWithSpec', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetDoctorLocationsAndScheduleWithSpec', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetDoctorScheduleByDate', @source_owner = N'dbo', @source_object = N'proc_GetDoctorScheduleByDate', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetDoctorScheduleByDate', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetDoctorScheduleByDocCodeAndDate', @source_owner = N'dbo', @source_object = N'proc_GetDoctorScheduleByDocCodeAndDate', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetDoctorScheduleByDocCodeAndDate', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetDoctorScheduleDatesByDoctorCode', @source_owner = N'dbo', @source_object = N'proc_GetDoctorScheduleDatesByDoctorCode', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetDoctorScheduleDatesByDoctorCode', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetDocumentShareByGuid', @source_owner = N'dbo', @source_object = N'proc_GetDocumentShareByGuid', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetDocumentShareByGuid', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetEWCoverLetterComboItems', @source_owner = N'dbo', @source_object = N'proc_GetEWCoverLetterComboItems', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetEWCoverLetterComboItems', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetExamineeAddressesByChartNbr', @source_owner = N'dbo', @source_object = N'proc_GetExamineeAddressesByChartNbr', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetExamineeAddressesByChartNbr', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetExamineeComboItems', @source_owner = N'dbo', @source_object = N'proc_GetExamineeComboItems', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetExamineeComboItems', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetExamineeComboItemsByWebUserIDNew', @source_owner = N'dbo', @source_object = N'proc_GetExamineeComboItemsByWebUserIDNew', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetExamineeComboItemsByWebUserIDNew', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetExternalCommunication', @source_owner = N'dbo', @source_object = N'proc_GetExternalCommunication', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetExternalCommunication', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetFirstAvailApptByDoctor', @source_owner = N'dbo', @source_object = N'proc_GetFirstAvailApptByDoctor', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetFirstAvailApptByDoctor', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetFirstAvailApptByLocation', @source_owner = N'dbo', @source_object = N'proc_GetFirstAvailApptByLocation', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetFirstAvailApptByLocation', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetIssueComboItems', @source_owner = N'dbo', @source_object = N'proc_GetIssueComboItems', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetIssueComboItems', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetLanguageComboItems', @source_owner = N'dbo', @source_object = N'proc_GetLanguageComboItems', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetLanguageComboItems', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetLatLon', @source_owner = N'dbo', @source_object = N'proc_GetLatLon', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetLatLon', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetMMISummaryNew', @source_owner = N'dbo', @source_object = N'proc_GetMMISummaryNew', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetMMISummaryNew', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetMostRecentCoverLetterRecord', @source_owner = N'dbo', @source_object = N'proc_GetMostRecentCoverLetterRecord', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetMostRecentCoverLetterRecord', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetMostUsedOffice', @source_owner = N'dbo', @source_object = N'proc_GetMostUsedOffice', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetMostUsedOffice', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetNewBatchNbr', @source_owner = N'dbo', @source_object = N'proc_GetNewBatchNbr', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetNewBatchNbr', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetNextAvailableTranscription', @source_owner = N'dbo', @source_object = N'proc_GetNextAvailableTranscription', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetNextAvailableTranscription', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetOfficeComboItems', @source_owner = N'dbo', @source_object = N'proc_GetOfficeComboItems', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetOfficeComboItems', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetOfficeFacilityInfo', @source_owner = N'dbo', @source_object = N'proc_GetOfficeFacilityInfo', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetOfficeFacilityInfo', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetOfficeInfoByUserCode', @source_owner = N'dbo', @source_object = N'proc_GetOfficeInfoByUserCode', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetOfficeInfoByUserCode', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetParentCompany', @source_owner = N'dbo', @source_object = N'proc_GetParentCompany', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetParentCompany', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetPrefixComboItems', @source_owner = N'dbo', @source_object = N'proc_GetPrefixComboItems', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetPrefixComboItems', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetProblemComboItems', @source_owner = N'dbo', @source_object = N'proc_GetProblemComboItems', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetProblemComboItems', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetProgressiveClientCodeByName', @source_owner = N'dbo', @source_object = N'proc_GetProgressiveClientCodeByName', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetProgressiveClientCodeByName', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetProgressiveClients', @source_owner = N'dbo', @source_object = N'proc_GetProgressiveClients', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetProgressiveClients', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetProviderSearch', @source_owner = N'dbo', @source_object = N'proc_GetProviderSearch', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetProviderSearch', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetPublishOnWebRecordsByCaseNbr', @source_owner = N'dbo', @source_object = N'proc_GetPublishOnWebRecordsByCaseNbr', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetPublishOnWebRecordsByCaseNbr', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetRecordStatusComboItems', @source_owner = N'dbo', @source_object = N'proc_GetRecordStatusComboItems', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetRecordStatusComboItems', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetReferralDocs', @source_owner = N'dbo', @source_object = N'proc_GetReferralDocs', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetReferralDocs', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetReferralDocsNew', @source_owner = N'dbo', @source_object = N'proc_GetReferralDocsNew', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetReferralDocsNew', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetReferralsByClaimantAndClaim', @source_owner = N'dbo', @source_object = N'proc_GetReferralsByClaimantAndClaim', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetReferralsByClaimantAndClaim', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetReferralSearch', @source_owner = N'dbo', @source_object = N'proc_GetReferralSearch', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetReferralSearch', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetReferralSearchProgressive', @source_owner = N'dbo', @source_object = N'proc_GetReferralSearchProgressive', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetReferralSearchProgressive', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetReferralSummaryByWebStatusDesc', @source_owner = N'dbo', @source_object = N'proc_GetReferralSummaryByWebStatusDesc', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetReferralSummaryByWebStatusDesc', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetReferralSummaryNew', @source_owner = N'dbo', @source_object = N'proc_GetReferralSummaryNew', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetReferralSummaryNew', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetReferralSummaryNewProgressive', @source_owner = N'dbo', @source_object = N'proc_GetReferralSummaryNewProgressive', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetReferralSummaryNewProgressive', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetReferralSummarySinceLastLoginDate', @source_owner = N'dbo', @source_object = N'proc_GetReferralSummarySinceLastLoginDate', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetReferralSummarySinceLastLoginDate', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetReferralSummarySinceLastLoginDateCount', @source_owner = N'dbo', @source_object = N'proc_GetReferralSummarySinceLastLoginDateCount', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetReferralSummarySinceLastLoginDateCount', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetSaveDateTimeByEWTimeZoneID', @source_owner = N'dbo', @source_object = N'proc_GetSaveDateTimeByEWTimeZoneID', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetSaveDateTimeByEWTimeZoneID', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetSaveDateTimeByOffice', @source_owner = N'dbo', @source_object = N'proc_GetSaveDateTimeByOffice', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetSaveDateTimeByOffice', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetServiceComboItems', @source_owner = N'dbo', @source_object = N'proc_GetServiceComboItems', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetServiceComboItems', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetServWorkflowId', @source_owner = N'dbo', @source_object = N'proc_GetServWorkflowId', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetServWorkflowId', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetSpecialtyByCaseNbr', @source_owner = N'dbo', @source_object = N'proc_GetSpecialtyByCaseNbr', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetSpecialtyByCaseNbr', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetSpecialtyComboItems', @source_owner = N'dbo', @source_object = N'proc_GetSpecialtyComboItems', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetSpecialtyComboItems', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetStateComboItems', @source_owner = N'dbo', @source_object = N'proc_GetStateComboItems', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetStateComboItems', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetStatusFromServiceWorkflow', @source_owner = N'dbo', @source_object = N'proc_GetStatusFromServiceWorkflow', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetStatusFromServiceWorkflow', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetSuperUserAvailUserListItems', @source_owner = N'dbo', @source_object = N'proc_GetSuperUserAvailUserListItems', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetSuperUserAvailUserListItems', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetSuperUserAvailUserListItemsNew', @source_owner = N'dbo', @source_object = N'proc_GetSuperUserAvailUserListItemsNew', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetSuperUserAvailUserListItemsNew', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetSuperUserComboItems', @source_owner = N'dbo', @source_object = N'proc_GetSuperUserComboItems', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetSuperUserComboItems', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetSuperUserGridItems', @source_owner = N'dbo', @source_object = N'proc_GetSuperUserGridItems', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetSuperUserGridItems', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetSuperUserSelUserListItems', @source_owner = N'dbo', @source_object = N'proc_GetSuperUserSelUserListItems', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetSuperUserSelUserListItems', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetVenueComboItems', @source_owner = N'dbo', @source_object = N'proc_GetVenueComboItems', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetVenueComboItems', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetWebUserData', @source_owner = N'dbo', @source_object = N'proc_GetWebUserData', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetWebUserData', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetWebUserPassword', @source_owner = N'dbo', @source_object = N'proc_GetWebUserPassword', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetWebUserPassword', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetWebUserUserName', @source_owner = N'dbo', @source_object = N'proc_GetWebUserUserName', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetWebUserUserName', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_GetZipDistanceInMiles', @source_owner = N'dbo', @source_object = N'proc_GetZipDistanceInMiles', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_GetZipDistanceInMiles', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_HCAIControl_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_HCAIControl_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_HCAIControl_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_ICD_GetDescByCode', @source_owner = N'dbo', @source_object = N'proc_ICD_GetDescByCode', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_ICD_GetDescByCode', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_IMECase_CheckForDupe', @source_owner = N'dbo', @source_object = N'proc_IMECase_CheckForDupe', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_IMECase_CheckForDupe', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_IMECase_Delete', @source_owner = N'dbo', @source_object = N'proc_IMECase_Delete', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_IMECase_Delete', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_IMECase_DeleteComplete', @source_owner = N'dbo', @source_object = N'proc_IMECase_DeleteComplete', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_IMECase_DeleteComplete', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_IMECase_Insert', @source_owner = N'dbo', @source_object = N'proc_IMECase_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_IMECase_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_IMECase_LoadAll', @source_owner = N'dbo', @source_object = N'proc_IMECase_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_IMECase_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_IMECase_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_IMECase_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_IMECase_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_IMECase_Update', @source_owner = N'dbo', @source_object = N'proc_IMECase_Update', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_IMECase_Update', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_IMECase_UpdateDateEdited', @source_owner = N'dbo', @source_object = N'proc_IMECase_UpdateDateEdited', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_IMECase_UpdateDateEdited', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_IMECase_UpdateTransCode', @source_owner = N'dbo', @source_object = N'proc_IMECase_UpdateTransCode', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_IMECase_UpdateTransCode', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_IMEData_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_IMEData_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_IMEData_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_IMEException', @source_owner = N'dbo', @source_object = N'proc_IMEException', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_IMEException', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Info_Generic_MgtRpt', @source_owner = N'dbo', @source_object = N'proc_Info_Generic_MgtRpt', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Info_Generic_MgtRpt', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Info_Generic_MgtRpt_PatchData', @source_owner = N'dbo', @source_object = N'proc_Info_Generic_MgtRpt_PatchData', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Info_Generic_MgtRpt_PatchData', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Info_Generic_MgtRpt_QueryData', @source_owner = N'dbo', @source_object = N'proc_Info_Generic_MgtRpt_QueryData', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Info_Generic_MgtRpt_QueryData', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Info_Hartford_MgtRpt', @source_owner = N'dbo', @source_object = N'proc_Info_Hartford_MgtRpt', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Info_Hartford_MgtRpt', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Info_Hartford_MgtRpt_InitData', @source_owner = N'dbo', @source_object = N'proc_Info_Hartford_MgtRpt_InitData', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Info_Hartford_MgtRpt_InitData', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Info_Hartford_MgtRpt_PatchData', @source_owner = N'dbo', @source_object = N'proc_Info_Hartford_MgtRpt_PatchData', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Info_Hartford_MgtRpt_PatchData', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Info_Hartford_MgtRpt_QueryData', @source_owner = N'dbo', @source_object = N'proc_Info_Hartford_MgtRpt_QueryData', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Info_Hartford_MgtRpt_QueryData', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Info_Liberty_BulkBilling', @source_owner = N'dbo', @source_object = N'proc_Info_Liberty_BulkBilling', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Info_Liberty_BulkBilling', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Info_Liberty_BulkBilling_PatchData', @source_owner = N'dbo', @source_object = N'proc_Info_Liberty_BulkBilling_PatchData', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Info_Liberty_BulkBilling_PatchData', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Info_Liberty_BulkBilling_QueryData', @source_owner = N'dbo', @source_object = N'proc_Info_Liberty_BulkBilling_QueryData', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Info_Liberty_BulkBilling_QueryData', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Info_Progressive_MgtRpt', @source_owner = N'dbo', @source_object = N'proc_Info_Progressive_MgtRpt', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Info_Progressive_MgtRpt', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Info_Progressive_MgtRpt_PatchData', @source_owner = N'dbo', @source_object = N'proc_Info_Progressive_MgtRpt_PatchData', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Info_Progressive_MgtRpt_PatchData', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Info_Progressive_MgtRpt_QueryData', @source_owner = N'dbo', @source_object = N'proc_Info_Progressive_MgtRpt_QueryData', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Info_Progressive_MgtRpt_QueryData', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Info_Travelers_MgtRpt', @source_owner = N'dbo', @source_object = N'proc_Info_Travelers_MgtRpt', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Info_Travelers_MgtRpt', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Info_Travelers_MgtRpt_PatchData', @source_owner = N'dbo', @source_object = N'proc_Info_Travelers_MgtRpt_PatchData', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Info_Travelers_MgtRpt_PatchData', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Info_Travelers_MgtRpt_QueryData', @source_owner = N'dbo', @source_object = N'proc_Info_Travelers_MgtRpt_QueryData', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Info_Travelers_MgtRpt_QueryData', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_InfoHartfordMgtRpt', @source_owner = N'dbo', @source_object = N'proc_InfoHartfordMgtRpt', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_InfoHartfordMgtRpt', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_IsGBArchClaim', @source_owner = N'dbo', @source_object = N'proc_IsGBArchClaim', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_IsGBArchClaim', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Issue_LoadAll', @source_owner = N'dbo', @source_object = N'proc_Issue_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Issue_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Issue_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_Issue_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Issue_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Keyword_LoadAll', @source_owner = N'dbo', @source_object = N'proc_Keyword_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Keyword_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_LoadCaseSearchProgressive', @source_owner = N'dbo', @source_object = N'proc_LoadCaseSearchProgressive', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_LoadCaseSearchProgressive', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_LoadWebEventsByDescription', @source_owner = N'dbo', @source_object = N'proc_LoadWebEventsByDescription', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_LoadWebEventsByDescription', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Location_LoadAll', @source_owner = N'dbo', @source_object = N'proc_Location_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Location_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Location_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_Location_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Location_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Office_LoadAll', @source_owner = N'dbo', @source_object = N'proc_Office_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Office_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Office_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_Office_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Office_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_OfficeGetWebDocPrintSaveFlag', @source_owner = N'dbo', @source_object = N'proc_OfficeGetWebDocPrintSaveFlag', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_OfficeGetWebDocPrintSaveFlag', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Problem_LoadAll', @source_owner = N'dbo', @source_object = N'proc_Problem_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Problem_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Problem_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_Problem_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Problem_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_ProblemArea_LoadByProblemCode', @source_owner = N'dbo', @source_object = N'proc_ProblemArea_LoadByProblemCode', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_ProblemArea_LoadByProblemCode', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_ProviderType_LoadAll', @source_owner = N'dbo', @source_object = N'proc_ProviderType_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_ProviderType_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_PublishOnWeb_CheckForDupe', @source_owner = N'dbo', @source_object = N'proc_PublishOnWeb_CheckForDupe', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_PublishOnWeb_CheckForDupe', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_PublishOnWeb_Delete', @source_owner = N'dbo', @source_object = N'proc_PublishOnWeb_Delete', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_PublishOnWeb_Delete', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_PublishOnWeb_Insert', @source_owner = N'dbo', @source_object = N'proc_PublishOnWeb_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_PublishOnWeb_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_PublishOnWeb_LoadAll', @source_owner = N'dbo', @source_object = N'proc_PublishOnWeb_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_PublishOnWeb_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_PublishOnWeb_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_PublishOnWeb_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_PublishOnWeb_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_PublishOnWeb_LoadByTableKeyTableType', @source_owner = N'dbo', @source_object = N'proc_PublishOnWeb_LoadByTableKeyTableType', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_PublishOnWeb_LoadByTableKeyTableType', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_PublishOnWeb_Update', @source_owner = N'dbo', @source_object = N'proc_PublishOnWeb_Update', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_PublishOnWeb_Update', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Queues_LoadAll', @source_owner = N'dbo', @source_object = N'proc_Queues_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Queues_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Queues_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_Queues_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Queues_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_RelatedParty_Delete', @source_owner = N'dbo', @source_object = N'proc_RelatedParty_Delete', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_RelatedParty_Delete', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_RelatedParty_Insert', @source_owner = N'dbo', @source_object = N'proc_RelatedParty_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_RelatedParty_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_RelatedParty_LoadAll', @source_owner = N'dbo', @source_object = N'proc_RelatedParty_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_RelatedParty_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_RelatedParty_LoadByCaseNbr', @source_owner = N'dbo', @source_object = N'proc_RelatedParty_LoadByCaseNbr', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_RelatedParty_LoadByCaseNbr', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_RelatedParty_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_RelatedParty_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_RelatedParty_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_RelatedParty_Update', @source_owner = N'dbo', @source_object = N'proc_RelatedParty_Update', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_RelatedParty_Update', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_RelatedPartyCheckForDupe', @source_owner = N'dbo', @source_object = N'proc_RelatedPartyCheckForDupe', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_RelatedPartyCheckForDupe', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_RequestNextTranscriptionJob', @source_owner = N'dbo', @source_object = N'proc_RequestNextTranscriptionJob', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_RequestNextTranscriptionJob', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Service_LoadComboByOfficeCode', @source_owner = N'dbo', @source_object = N'proc_Service_LoadComboByOfficeCode', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Service_LoadComboByOfficeCode', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Services_LoadAll', @source_owner = N'dbo', @source_object = N'proc_Services_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Services_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Services_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_Services_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Services_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_SetLoginDateByWebUserID', @source_owner = N'dbo', @source_object = N'proc_SetLoginDateByWebUserID', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_SetLoginDateByWebUserID', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Specialty_LoadAll', @source_owner = N'dbo', @source_object = N'proc_Specialty_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Specialty_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Specialty_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_Specialty_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Specialty_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_tblActionsInsert', @source_owner = N'dbo', @source_object = N'proc_tblActionsInsert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_tblActionsInsert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_tblcaseissueInsert', @source_owner = N'dbo', @source_object = N'proc_tblcaseissueInsert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_tblcaseissueInsert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_tblcaseproblemInsert', @source_owner = N'dbo', @source_object = N'proc_tblcaseproblemInsert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_tblcaseproblemInsert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_tblCCAddressInsert', @source_owner = N'dbo', @source_object = N'proc_tblCCAddressInsert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_tblCCAddressInsert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_tblCCAddressUpdate', @source_owner = N'dbo', @source_object = N'proc_tblCCAddressUpdate', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_tblCCAddressUpdate', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_tblCompanyInsert', @source_owner = N'dbo', @source_object = N'proc_tblCompanyInsert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_tblCompanyInsert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_tblCompanyUpdate', @source_owner = N'dbo', @source_object = N'proc_tblCompanyUpdate', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_tblCompanyUpdate', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_tblExamineeInsert', @source_owner = N'dbo', @source_object = N'proc_tblExamineeInsert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_tblExamineeInsert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_tblExamineeUpdate', @source_owner = N'dbo', @source_object = N'proc_tblExamineeUpdate', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_tblExamineeUpdate', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_tblHCAIBatch_Insert', @source_owner = N'dbo', @source_object = N'proc_tblHCAIBatch_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_tblHCAIBatch_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_tblPublishOnWebInsert', @source_owner = N'dbo', @source_object = N'proc_tblPublishOnWebInsert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_tblPublishOnWebInsert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_tblPublishOnWebUpdate', @source_owner = N'dbo', @source_object = N'proc_tblPublishOnWebUpdate', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_tblPublishOnWebUpdate', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_tblSyncLogsInsert', @source_owner = N'dbo', @source_object = N'proc_tblSyncLogsInsert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_tblSyncLogsInsert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_tblSyncLogsUpdate', @source_owner = N'dbo', @source_object = N'proc_tblSyncLogsUpdate', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_tblSyncLogsUpdate', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_tblWebUserAccountInsert', @source_owner = N'dbo', @source_object = N'proc_tblWebUserAccountInsert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_tblWebUserAccountInsert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_tblWebUserAccountUpdate', @source_owner = N'dbo', @source_object = N'proc_tblWebUserAccountUpdate', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_tblWebUserAccountUpdate', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_tblWebUserInsert', @source_owner = N'dbo', @source_object = N'proc_tblWebUserInsert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_tblWebUserInsert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_tblWebUserUpdate', @source_owner = N'dbo', @source_object = N'proc_tblWebUserUpdate', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_tblWebUserUpdate', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_Transcription_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_Transcription_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_Transcription_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_TranscriptionJob_Delete', @source_owner = N'dbo', @source_object = N'proc_TranscriptionJob_Delete', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_TranscriptionJob_Delete', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_TranscriptionJob_Insert', @source_owner = N'dbo', @source_object = N'proc_TranscriptionJob_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_TranscriptionJob_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_TranscriptionJob_LoadByCaseNbr', @source_owner = N'dbo', @source_object = N'proc_TranscriptionJob_LoadByCaseNbr', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_TranscriptionJob_LoadByCaseNbr', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_TranscriptionJob_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_TranscriptionJob_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_TranscriptionJob_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_TranscriptionJob_LoadByStatusCode', @source_owner = N'dbo', @source_object = N'proc_TranscriptionJob_LoadByStatusCode', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_TranscriptionJob_LoadByStatusCode', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_TranscriptionJob_LoadByTransCode', @source_owner = N'dbo', @source_object = N'proc_TranscriptionJob_LoadByTransCode', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_TranscriptionJob_LoadByTransCode', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_TranscriptionJob_LoadByTranscriptionJobID', @source_owner = N'dbo', @source_object = N'proc_TranscriptionJob_LoadByTranscriptionJobID', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_TranscriptionJob_LoadByTranscriptionJobID', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_TranscriptionJob_Update', @source_owner = N'dbo', @source_object = N'proc_TranscriptionJob_Update', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_TranscriptionJob_Update', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_TranscriptionJobDictation_Insert', @source_owner = N'dbo', @source_object = N'proc_TranscriptionJobDictation_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_TranscriptionJobDictation_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_TranscriptionJobDictation_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_TranscriptionJobDictation_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_TranscriptionJobDictation_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_TranscriptionJobDictation_LoadByTranscriptionJobID', @source_owner = N'dbo', @source_object = N'proc_TranscriptionJobDictation_LoadByTranscriptionJobID', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_TranscriptionJobDictation_LoadByTranscriptionJobID', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_TranscriptionJobDictation_Update', @source_owner = N'dbo', @source_object = N'proc_TranscriptionJobDictation_Update', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_TranscriptionJobDictation_Update', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_UpdateCaseStatus', @source_owner = N'dbo', @source_object = N'proc_UpdateCaseStatus', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_UpdateCaseStatus', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_User_LoadAll', @source_owner = N'dbo', @source_object = N'proc_User_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_User_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_User_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_User_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_User_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_ValidateAdminUser', @source_owner = N'dbo', @source_object = N'proc_ValidateAdminUser', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_ValidateAdminUser', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebActivation_Delete', @source_owner = N'dbo', @source_object = N'proc_WebActivation_Delete', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebActivation_Delete', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebActivation_Insert', @source_owner = N'dbo', @source_object = N'proc_WebActivation_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebActivation_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebActivation_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_WebActivation_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebActivation_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebActivation_LoadByWebUserID', @source_owner = N'dbo', @source_object = N'proc_WebActivation_LoadByWebUserID', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebActivation_LoadByWebUserID', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebActivation_Update', @source_owner = N'dbo', @source_object = N'proc_WebActivation_Update', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebActivation_Update', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebNotification_Insert', @source_owner = N'dbo', @source_object = N'proc_WebNotification_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebNotification_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebNotification_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_WebNotification_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebNotification_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebNotification_Update', @source_owner = N'dbo', @source_object = N'proc_WebNotification_Update', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebNotification_Update', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebPasswordHistory_Delete', @source_owner = N'dbo', @source_object = N'proc_WebPasswordHistory_Delete', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebPasswordHistory_Delete', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebPasswordHistory_Insert', @source_owner = N'dbo', @source_object = N'proc_WebPasswordHistory_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebPasswordHistory_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebPasswordHistory_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_WebPasswordHistory_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebPasswordHistory_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebPasswordHistory_LoadByWebUserID', @source_owner = N'dbo', @source_object = N'proc_WebPasswordHistory_LoadByWebUserID', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebPasswordHistory_LoadByWebUserID', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebPasswordHistory_Update', @source_owner = N'dbo', @source_object = N'proc_WebPasswordHistory_Update', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebPasswordHistory_Update', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebQRConfig_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_WebQRConfig_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebQRConfig_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebQRRequest_Insert', @source_owner = N'dbo', @source_object = N'proc_WebQRRequest_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebQRRequest_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebQRRequest_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_WebQRRequest_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebQRRequest_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebQueues_LoadAll', @source_owner = N'dbo', @source_object = N'proc_WebQueues_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebQueues_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebQueues_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_WebQueues_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebQueues_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebUser_CheckIfSupervisor', @source_owner = N'dbo', @source_object = N'proc_WebUser_CheckIfSupervisor', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebUser_CheckIfSupervisor', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebUser_Delete', @source_owner = N'dbo', @source_object = N'proc_WebUser_Delete', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebUser_Delete', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebUser_Insert', @source_owner = N'dbo', @source_object = N'proc_WebUser_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebUser_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebUser_LoadAll', @source_owner = N'dbo', @source_object = N'proc_WebUser_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebUser_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebUser_LoadByEWWebUserID', @source_owner = N'dbo', @source_object = N'proc_WebUser_LoadByEWWebUserID', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebUser_LoadByEWWebUserID', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebUser_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_WebUser_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebUser_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebUser_LoadByUserID', @source_owner = N'dbo', @source_object = N'proc_WebUser_LoadByUserID', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebUser_LoadByUserID', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebUser_Update', @source_owner = N'dbo', @source_object = N'proc_WebUser_Update', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebUser_Update', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebUserAccount_Delete', @source_owner = N'dbo', @source_object = N'proc_WebUserAccount_Delete', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebUserAccount_Delete', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebUserAccount_Insert', @source_owner = N'dbo', @source_object = N'proc_WebUserAccount_Insert', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebUserAccount_Insert', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebUserAccount_LoadAll', @source_owner = N'dbo', @source_object = N'proc_WebUserAccount_LoadAll', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebUserAccount_LoadAll', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebUserAccount_LoadByPrimaryKey', @source_owner = N'dbo', @source_object = N'proc_WebUserAccount_LoadByPrimaryKey', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebUserAccount_LoadByPrimaryKey', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebUserAccount_Update', @source_owner = N'dbo', @source_object = N'proc_WebUserAccount_Update', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebUserAccount_Update', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'proc_WebUserSubordinate_Delete', @source_owner = N'dbo', @source_object = N'proc_WebUserSubordinate_Delete', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'proc_WebUserSubordinate_Delete', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'sp_tblsynclogs', @source_owner = N'dbo', @source_object = N'sp_tblsynclogs', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'sp_tblsynclogs', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'spAttorneyCases', @source_owner = N'dbo', @source_object = N'spAttorneyCases', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'spAttorneyCases', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'spCase_GetDocumentPath', @source_owner = N'dbo', @source_object = N'spCase_GetDocumentPath', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'spCase_GetDocumentPath', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'spCaseDocuments', @source_owner = N'dbo', @source_object = N'spCaseDocuments', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'spCaseDocuments', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'spCaseHistory', @source_owner = N'dbo', @source_object = N'spCaseHistory', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'spCaseHistory', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'spCaseReports', @source_owner = N'dbo', @source_object = N'spCaseReports', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'spCaseReports', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'spClientCases', @source_owner = N'dbo', @source_object = N'spClientCases', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'spClientCases', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'spCompanyCases', @source_owner = N'dbo', @source_object = N'spCompanyCases', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'spCompanyCases', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'spCRN_Export', @source_owner = N'dbo', @source_object = N'spCRN_Export', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'spCRN_Export', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'spDoctorCases', @source_owner = N'dbo', @source_object = N'spDoctorCases', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'spDoctorCases', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'spDoctorSearch', @source_owner = N'dbo', @source_object = N'spDoctorSearch', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'spDoctorSearch', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'spExamineeCases', @source_owner = N'dbo', @source_object = N'spExamineeCases', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'spExamineeCases', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'spGetBusinessRules', @source_owner = N'dbo', @source_object = N'spGetBusinessRules', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'spGetBusinessRules', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'spInsertActionTableRecords', @source_owner = N'dbo', @source_object = N'spInsertActionTableRecords', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'spInsertActionTableRecords', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'spLock_Create', @source_owner = N'dbo', @source_object = N'spLock_Create', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'spLock_Create', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'spOtherParty', @source_owner = N'dbo', @source_object = N'spOtherParty', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'spOtherParty', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'spRptDoctorListing', @source_owner = N'dbo', @source_object = N'spRptDoctorListing', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'spRptDoctorListing', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'spRptDrDistribution', @source_owner = N'dbo', @source_object = N'spRptDrDistribution', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'spRptDrDistribution', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'spRptFlashReport', @source_owner = N'dbo', @source_object = N'spRptFlashReport', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'spRptFlashReport', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblAbetonProviderFees', @source_owner = N'dbo', @source_object = N'tblAbetonProviderFees', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblAbetonProviderFees', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblAbetonProviderFees]', @del_cmd = N'CALL [sp_MSdel_dbotblAbetonProviderFees]', @upd_cmd = N'SCALL [sp_MSupd_dbotblAbetonProviderFees]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblAcctDetail', @source_owner = N'dbo', @source_object = N'tblAcctDetail', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblAcctDetail', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblAcctDetail]', @del_cmd = N'CALL [sp_MSdel_dbotblAcctDetail]', @upd_cmd = N'SCALL [sp_MSupd_dbotblAcctDetail]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblAcctHeader', @source_owner = N'dbo', @source_object = N'tblAcctHeader', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblAcctHeader', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblAcctHeader]', @del_cmd = N'CALL [sp_MSdel_dbotblAcctHeader]', @upd_cmd = N'SCALL [sp_MSupd_dbotblAcctHeader]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblAcctingTrans', @source_owner = N'dbo', @source_object = N'tblAcctingTrans', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblAcctingTrans', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblAcctingTrans]', @del_cmd = N'CALL [sp_MSdel_dbotblAcctingTrans]', @upd_cmd = N'SCALL [sp_MSupd_dbotblAcctingTrans]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblAcctMargin', @source_owner = N'dbo', @source_object = N'tblAcctMargin', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblAcctMargin', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblAcctMargin]', @del_cmd = N'CALL [sp_MSdel_dbotblAcctMargin]', @upd_cmd = N'SCALL [sp_MSupd_dbotblAcctMargin]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblAcctQuote', @source_owner = N'dbo', @source_object = N'tblAcctQuote', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblAcctQuote', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblAcctQuote]', @del_cmd = N'CALL [sp_MSdel_dbotblAcctQuote]', @upd_cmd = N'SCALL [sp_MSupd_dbotblAcctQuote]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblAcctQuoteFee', @source_owner = N'dbo', @source_object = N'tblAcctQuoteFee', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblAcctQuoteFee', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblAcctQuoteFee]', @del_cmd = N'CALL [sp_MSdel_dbotblAcctQuoteFee]', @upd_cmd = N'SCALL [sp_MSupd_dbotblAcctQuoteFee]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblActions', @source_owner = N'dbo', @source_object = N'tblActions', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblActions', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblActions]', @del_cmd = N'CALL [sp_MSdel_dbotblActions]', @upd_cmd = N'SCALL [sp_MSupd_dbotblActions]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblAddressAbbreviation', @source_owner = N'dbo', @source_object = N'tblAddressAbbreviation', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblAddressAbbreviation', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblAddressAbbreviation]', @del_cmd = N'CALL [sp_MSdel_dbotblAddressAbbreviation]', @upd_cmd = N'SCALL [sp_MSupd_dbotblAddressAbbreviation]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblAll', @source_owner = N'dbo', @source_object = N'tblAll', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblAll', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblAll]', @del_cmd = N'CALL [sp_MSdel_dbotblAll]', @upd_cmd = N'SCALL [sp_MSupd_dbotblAll]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblApptStatus', @source_owner = N'dbo', @source_object = N'tblApptStatus', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblApptStatus', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblApptStatus]', @del_cmd = N'CALL [sp_MSdel_dbotblApptStatus]', @upd_cmd = N'SCALL [sp_MSupd_dbotblApptStatus]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblAuditLog', @source_owner = N'dbo', @source_object = N'tblAuditLog', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblAuditLog', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblAuditLog]', @del_cmd = N'CALL [sp_MSdel_dbotblAuditLog]', @upd_cmd = N'SCALL [sp_MSupd_dbotblAuditLog]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblBatch', @source_owner = N'dbo', @source_object = N'tblBatch', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblBatch', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblBatch]', @del_cmd = N'CALL [sp_MSdel_dbotblBatch]', @upd_cmd = N'SCALL [sp_MSupd_dbotblBatch]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblBlank', @source_owner = N'dbo', @source_object = N'tblBlank', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblBlank', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblBlank]', @del_cmd = N'CALL [sp_MSdel_dbotblBlank]', @upd_cmd = N'SCALL [sp_MSupd_dbotblBlank]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblBusinessRule', @source_owner = N'dbo', @source_object = N'tblBusinessRule', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblBusinessRule', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblBusinessRule]', @del_cmd = N'CALL [sp_MSdel_dbotblBusinessRule]', @upd_cmd = N'SCALL [sp_MSupd_dbotblBusinessRule]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblBusinessRuleCondition', @source_owner = N'dbo', @source_object = N'tblBusinessRuleCondition', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblBusinessRuleCondition', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblBusinessRuleCondition]', @del_cmd = N'CALL [sp_MSdel_dbotblBusinessRuleCondition]', @upd_cmd = N'SCALL [sp_MSupd_dbotblBusinessRuleCondition]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCanceledBy', @source_owner = N'dbo', @source_object = N'tblCanceledBy', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblCanceledBy', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCanceledBy]', @del_cmd = N'CALL [sp_MSdel_dbotblCanceledBy]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCanceledBy]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCancelReasonDetail', @source_owner = N'dbo', @source_object = N'tblCancelReasonDetail', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCancelReasonDetail', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCancelReasonDetail]', @del_cmd = N'CALL [sp_MSdel_dbotblCancelReasonDetail]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCancelReasonDetail]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCancelReasonGroup', @source_owner = N'dbo', @source_object = N'tblCancelReasonGroup', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCancelReasonGroup', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCancelReasonGroup]', @del_cmd = N'CALL [sp_MSdel_dbotblCancelReasonGroup]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCancelReasonGroup]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCase', @source_owner = N'dbo', @source_object = N'tblCase', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCase', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCase]', @del_cmd = N'CALL [sp_MSdel_dbotblCase]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCase]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseAccredidation', @source_owner = N'dbo', @source_object = N'tblCaseAccredidation', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCaseAccredidation', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseAccredidation]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseAccredidation]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseAccredidation]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseAppt', @source_owner = N'dbo', @source_object = N'tblCaseAppt', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCaseAppt', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseAppt]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseAppt]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseAppt]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseApptPanel', @source_owner = N'dbo', @source_object = N'tblCaseApptPanel', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblCaseApptPanel', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseApptPanel]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseApptPanel]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseApptPanel]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseContactRequest', @source_owner = N'dbo', @source_object = N'tblCaseContactRequest', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCaseContactRequest', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseContactRequest]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseContactRequest]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseContactRequest]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseDefDocument', @source_owner = N'dbo', @source_object = N'tblCaseDefDocument', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblCaseDefDocument', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseDefDocument]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseDefDocument]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseDefDocument]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseDocType', @source_owner = N'dbo', @source_object = N'tblCaseDocType', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCaseDocType', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseDocType]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseDocType]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseDocType]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseDocuments', @source_owner = N'dbo', @source_object = N'tblCaseDocuments', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCaseDocuments', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseDocuments]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseDocuments]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseDocuments]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseDocumentsDicom', @source_owner = N'dbo', @source_object = N'tblCaseDocumentsDicom', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCaseDocumentsDicom', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseDocumentsDicom]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseDocumentsDicom]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseDocumentsDicom]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseDocumentTransfer', @source_owner = N'dbo', @source_object = N'tblCaseDocumentTransfer', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCaseDocumentTransfer', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseDocumentTransfer]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseDocumentTransfer]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseDocumentTransfer]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseEnvelope', @source_owner = N'dbo', @source_object = N'tblCaseEnvelope', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCaseEnvelope', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseEnvelope]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseEnvelope]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseEnvelope]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseHistory', @source_owner = N'dbo', @source_object = N'tblCaseHistory', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCaseHistory', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseHistory]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseHistory]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseHistory]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseICDRequest', @source_owner = N'dbo', @source_object = N'tblCaseICDRequest', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCaseICDRequest', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseICDRequest]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseICDRequest]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseICDRequest]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseIssue', @source_owner = N'dbo', @source_object = N'tblCaseIssue', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblCaseIssue', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseIssue]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseIssue]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseIssue]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseIssueQuestion', @source_owner = N'dbo', @source_object = N'tblCaseIssueQuestion', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCaseIssueQuestion', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseIssueQuestion]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseIssueQuestion]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseIssueQuestion]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseNF10', @source_owner = N'dbo', @source_object = N'tblCaseNF10', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblCaseNF10', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseNF10]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseNF10]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseNF10]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseOtherParty', @source_owner = N'dbo', @source_object = N'tblCaseOtherParty', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblCaseOtherParty', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseOtherParty]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseOtherParty]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseOtherParty]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseOtherTreatingDoctor', @source_owner = N'dbo', @source_object = N'tblCaseOtherTreatingDoctor', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblCaseOtherTreatingDoctor', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseOtherTreatingDoctor]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseOtherTreatingDoctor]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseOtherTreatingDoctor]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCasePanel', @source_owner = N'dbo', @source_object = N'tblCasePanel', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblCasePanel', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCasePanel]', @del_cmd = N'CALL [sp_MSdel_dbotblCasePanel]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCasePanel]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCasePeerBill', @source_owner = N'dbo', @source_object = N'tblCasePeerBill', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCasePeerBill', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCasePeerBill]', @del_cmd = N'CALL [sp_MSdel_dbotblCasePeerBill]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCasePeerBill]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseProblem', @source_owner = N'dbo', @source_object = N'tblCaseProblem', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblCaseProblem', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseProblem]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseProblem]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseProblem]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseRelatedParty', @source_owner = N'dbo', @source_object = N'tblCaseRelatedParty', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCaseRelatedParty', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseRelatedParty]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseRelatedParty]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseRelatedParty]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseReviewItem', @source_owner = N'dbo', @source_object = N'tblCaseReviewItem', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCaseReviewItem', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseReviewItem]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseReviewItem]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseReviewItem]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseSLARuleDetail', @source_owner = N'dbo', @source_object = N'tblCaseSLARuleDetail', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblCaseSLARuleDetail', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseSLARuleDetail]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseSLARuleDetail]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseSLARuleDetail]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseSpecialty', @source_owner = N'dbo', @source_object = N'tblCaseSpecialty', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCaseSpecialty', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseSpecialty]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseSpecialty]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseSpecialty]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseTrans', @source_owner = N'dbo', @source_object = N'tblCaseTrans', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCaseTrans', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseTrans]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseTrans]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseTrans]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseType', @source_owner = N'dbo', @source_object = N'tblCaseType', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCaseType', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseType]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseType]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseType]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseTypeOffice', @source_owner = N'dbo', @source_object = N'tblCaseTypeOffice', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblCaseTypeOffice', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseTypeOffice]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseTypeOffice]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseTypeOffice]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCaseUnknownClient', @source_owner = N'dbo', @source_object = N'tblCaseUnknownClient', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblCaseUnknownClient', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCaseUnknownClient]', @del_cmd = N'CALL [sp_MSdel_dbotblCaseUnknownClient]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCaseUnknownClient]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCCAddress', @source_owner = N'dbo', @source_object = N'tblCCAddress', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCCAddress', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCCAddress]', @del_cmd = N'CALL [sp_MSdel_dbotblCCAddress]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCCAddress]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCCAddressOffice', @source_owner = N'dbo', @source_object = N'tblCCAddressOffice', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblCCAddressOffice', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCCAddressOffice]', @del_cmd = N'CALL [sp_MSdel_dbotblCCAddressOffice]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCCAddressOffice]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblClaimInfo', @source_owner = N'dbo', @source_object = N'tblClaimInfo', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblClaimInfo', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblClaimInfo]', @del_cmd = N'CALL [sp_MSdel_dbotblClaimInfo]', @upd_cmd = N'SCALL [sp_MSupd_dbotblClaimInfo]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblClient', @source_owner = N'dbo', @source_object = N'tblClient', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblClient', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblClient]', @del_cmd = N'CALL [sp_MSdel_dbotblClient]', @upd_cmd = N'SCALL [sp_MSupd_dbotblClient]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblClientDefDocument', @source_owner = N'dbo', @source_object = N'tblClientDefDocument', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblClientDefDocument', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblClientDefDocument]', @del_cmd = N'CALL [sp_MSdel_dbotblClientDefDocument]', @upd_cmd = N'SCALL [sp_MSupd_dbotblClientDefDocument]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblClientOffice', @source_owner = N'dbo', @source_object = N'tblClientOffice', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblClientOffice', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblClientOffice]', @del_cmd = N'CALL [sp_MSdel_dbotblClientOffice]', @upd_cmd = N'SCALL [sp_MSupd_dbotblClientOffice]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblClientType', @source_owner = N'dbo', @source_object = N'tblClientType', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblClientType', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblClientType]', @del_cmd = N'CALL [sp_MSdel_dbotblClientType]', @upd_cmd = N'SCALL [sp_MSupd_dbotblClientType]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCodes', @source_owner = N'dbo', @source_object = N'tblCodes', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCodes', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCodes]', @del_cmd = N'CALL [sp_MSdel_dbotblCodes]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCodes]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCompany', @source_owner = N'dbo', @source_object = N'tblCompany', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCompany', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCompany]', @del_cmd = N'CALL [sp_MSdel_dbotblCompany]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCompany]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCompanyBulkBilling', @source_owner = N'dbo', @source_object = N'tblCompanyBulkBilling', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCompanyBulkBilling', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCompanyBulkBilling]', @del_cmd = N'CALL [sp_MSdel_dbotblCompanyBulkBilling]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCompanyBulkBilling]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCompanyCertifiedMail', @source_owner = N'dbo', @source_object = N'tblCompanyCertifiedMail', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCompanyCertifiedMail', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCompanyCertifiedMail]', @del_cmd = N'CALL [sp_MSdel_dbotblCompanyCertifiedMail]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCompanyCertifiedMail]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCompanyCoverLetter', @source_owner = N'dbo', @source_object = N'tblCompanyCoverLetter', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCompanyCoverLetter', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCompanyCoverLetter]', @del_cmd = N'CALL [sp_MSdel_dbotblCompanyCoverLetter]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCompanyCoverLetter]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCompanyCPTCode', @source_owner = N'dbo', @source_object = N'tblCompanyCPTCode', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblCompanyCPTCode', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCompanyCPTCode]', @del_cmd = N'CALL [sp_MSdel_dbotblCompanyCPTCode]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCompanyCPTCode]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCompanyDefDocument', @source_owner = N'dbo', @source_object = N'tblCompanyDefDocument', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblCompanyDefDocument', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCompanyDefDocument]', @del_cmd = N'CALL [sp_MSdel_dbotblCompanyDefDocument]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCompanyDefDocument]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCompanyDocuments', @source_owner = N'dbo', @source_object = N'tblCompanyDocuments', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCompanyDocuments', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCompanyDocuments]', @del_cmd = N'CALL [sp_MSdel_dbotblCompanyDocuments]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCompanyDocuments]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCompanyNetwork', @source_owner = N'dbo', @source_object = N'tblCompanyNetwork', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblCompanyNetwork', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCompanyNetwork]', @del_cmd = N'CALL [sp_MSdel_dbotblCompanyNetwork]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCompanyNetwork]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCompanyNF10Template', @source_owner = N'dbo', @source_object = N'tblCompanyNF10Template', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCompanyNF10Template', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCompanyNF10Template]', @del_cmd = N'CALL [sp_MSdel_dbotblCompanyNF10Template]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCompanyNF10Template]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCompanyOffice', @source_owner = N'dbo', @source_object = N'tblCompanyOffice', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblCompanyOffice', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCompanyOffice]', @del_cmd = N'CALL [sp_MSdel_dbotblCompanyOffice]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCompanyOffice]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblConfiguration', @source_owner = N'dbo', @source_object = N'tblConfiguration', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblConfiguration', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblConfiguration]', @del_cmd = N'CALL [sp_MSdel_dbotblConfiguration]', @upd_cmd = N'SCALL [sp_MSupd_dbotblConfiguration]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblConfirmationBatch', @source_owner = N'dbo', @source_object = N'tblConfirmationBatch', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblConfirmationBatch', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblConfirmationBatch]', @del_cmd = N'CALL [sp_MSdel_dbotblConfirmationBatch]', @upd_cmd = N'SCALL [sp_MSupd_dbotblConfirmationBatch]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblConfirmationDoctor', @source_owner = N'dbo', @source_object = N'tblConfirmationDoctor', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblConfirmationDoctor', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblConfirmationDoctor]', @del_cmd = N'CALL [sp_MSdel_dbotblConfirmationDoctor]', @upd_cmd = N'SCALL [sp_MSupd_dbotblConfirmationDoctor]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblConfirmationList', @source_owner = N'dbo', @source_object = N'tblConfirmationList', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblConfirmationList', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblConfirmationList]', @del_cmd = N'CALL [sp_MSdel_dbotblConfirmationList]', @upd_cmd = N'SCALL [sp_MSupd_dbotblConfirmationList]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblConfirmationLocation', @source_owner = N'dbo', @source_object = N'tblConfirmationLocation', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblConfirmationLocation', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblConfirmationLocation]', @del_cmd = N'CALL [sp_MSdel_dbotblConfirmationLocation]', @upd_cmd = N'SCALL [sp_MSupd_dbotblConfirmationLocation]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblConfirmationMessage', @source_owner = N'dbo', @source_object = N'tblConfirmationMessage', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblConfirmationMessage', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblConfirmationMessage]', @del_cmd = N'CALL [sp_MSdel_dbotblConfirmationMessage]', @upd_cmd = N'SCALL [sp_MSupd_dbotblConfirmationMessage]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblConfirmationResult', @source_owner = N'dbo', @source_object = N'tblConfirmationResult', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblConfirmationResult', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblConfirmationResult]', @del_cmd = N'CALL [sp_MSdel_dbotblConfirmationResult]', @upd_cmd = N'SCALL [sp_MSupd_dbotblConfirmationResult]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblConfirmationRule', @source_owner = N'dbo', @source_object = N'tblConfirmationRule', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblConfirmationRule', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblConfirmationRule]', @del_cmd = N'CALL [sp_MSdel_dbotblConfirmationRule]', @upd_cmd = N'SCALL [sp_MSupd_dbotblConfirmationRule]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblConfirmationRuleDetail', @source_owner = N'dbo', @source_object = N'tblConfirmationRuleDetail', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblConfirmationRuleDetail', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblConfirmationRuleDetail]', @del_cmd = N'CALL [sp_MSdel_dbotblConfirmationRuleDetail]', @upd_cmd = N'SCALL [sp_MSupd_dbotblConfirmationRuleDetail]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblConfirmationSetup', @source_owner = N'dbo', @source_object = N'tblConfirmationSetup', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblConfirmationSetup', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblConfirmationSetup]', @del_cmd = N'CALL [sp_MSdel_dbotblConfirmationSetup]', @upd_cmd = N'SCALL [sp_MSupd_dbotblConfirmationSetup]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblConfirmationStatus', @source_owner = N'dbo', @source_object = N'tblConfirmationStatus', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblConfirmationStatus', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblConfirmationStatus]', @del_cmd = N'CALL [sp_MSdel_dbotblConfirmationStatus]', @upd_cmd = N'SCALL [sp_MSupd_dbotblConfirmationStatus]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblControl', @source_owner = N'dbo', @source_object = N'tblControl', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblControl', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblControl]', @del_cmd = N'CALL [sp_MSdel_dbotblControl]', @upd_cmd = N'SCALL [sp_MSupd_dbotblControl]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCustomerData', @source_owner = N'dbo', @source_object = N'tblCustomerData', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCustomerData', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCustomerData]', @del_cmd = N'CALL [sp_MSdel_dbotblCustomerData]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCustomerData]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCustomerFeeDetail', @source_owner = N'dbo', @source_object = N'tblCustomerFeeDetail', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCustomerFeeDetail', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCustomerFeeDetail]', @del_cmd = N'CALL [sp_MSdel_dbotblCustomerFeeDetail]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCustomerFeeDetail]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCustomerFeeHeader', @source_owner = N'dbo', @source_object = N'tblCustomerFeeHeader', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCustomerFeeHeader', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCustomerFeeHeader]', @del_cmd = N'CALL [sp_MSdel_dbotblCustomerFeeHeader]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCustomerFeeHeader]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblCustomerMapping', @source_owner = N'dbo', @source_object = N'tblCustomerMapping', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblCustomerMapping', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblCustomerMapping]', @del_cmd = N'CALL [sp_MSdel_dbotblCustomerMapping]', @upd_cmd = N'SCALL [sp_MSupd_dbotblCustomerMapping]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDataField', @source_owner = N'dbo', @source_object = N'tblDataField', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblDataField', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDataField]', @del_cmd = N'CALL [sp_MSdel_dbotblDataField]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDataField]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDegree', @source_owner = N'dbo', @source_object = N'tblDegree', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblDegree', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDegree]', @del_cmd = N'CALL [sp_MSdel_dbotblDegree]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDegree]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDoctor', @source_owner = N'dbo', @source_object = N'tblDoctor', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblDoctor', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDoctor]', @del_cmd = N'CALL [sp_MSdel_dbotblDoctor]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDoctor]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDoctorAccreditation', @source_owner = N'dbo', @source_object = N'tblDoctorAccreditation', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblDoctorAccreditation', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDoctorAccreditation]', @del_cmd = N'CALL [sp_MSdel_dbotblDoctorAccreditation]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDoctorAccreditation]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDoctorAuthor', @source_owner = N'dbo', @source_object = N'tblDoctorAuthor', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblDoctorAuthor', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDoctorAuthor]', @del_cmd = N'CALL [sp_MSdel_dbotblDoctorAuthor]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDoctorAuthor]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDoctorBusLine', @source_owner = N'dbo', @source_object = N'tblDoctorBusLine', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblDoctorBusLine', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDoctorBusLine]', @del_cmd = N'CALL [sp_MSdel_dbotblDoctorBusLine]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDoctorBusLine]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDoctorCancelationPolicy', @source_owner = N'dbo', @source_object = N'tblDoctorCancelationPolicy', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblDoctorCancelationPolicy', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDoctorCancelationPolicy]', @del_cmd = N'CALL [sp_MSdel_dbotblDoctorCancelationPolicy]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDoctorCancelationPolicy]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDoctorCheckRequest', @source_owner = N'dbo', @source_object = N'tblDoctorCheckRequest', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblDoctorCheckRequest', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDoctorCheckRequest]', @del_cmd = N'CALL [sp_MSdel_dbotblDoctorCheckRequest]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDoctorCheckRequest]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDoctorDocuments', @source_owner = N'dbo', @source_object = N'tblDoctorDocuments', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblDoctorDocuments', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDoctorDocuments]', @del_cmd = N'CALL [sp_MSdel_dbotblDoctorDocuments]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDoctorDocuments]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDoctorDPSSortModel', @source_owner = N'dbo', @source_object = N'tblDoctorDPSSortModel', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblDoctorDPSSortModel', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDoctorDPSSortModel]', @del_cmd = N'CALL [sp_MSdel_dbotblDoctorDPSSortModel]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDoctorDPSSortModel]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDoctorDrAssistant', @source_owner = N'dbo', @source_object = N'tblDoctorDrAssistant', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblDoctorDrAssistant', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDoctorDrAssistant]', @del_cmd = N'CALL [sp_MSdel_dbotblDoctorDrAssistant]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDoctorDrAssistant]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDoctorFeeSchedule', @source_owner = N'dbo', @source_object = N'tblDoctorFeeSchedule', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblDoctorFeeSchedule', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDoctorFeeSchedule]', @del_cmd = N'CALL [sp_MSdel_dbotblDoctorFeeSchedule]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDoctorFeeSchedule]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDoctorKeyWord', @source_owner = N'dbo', @source_object = N'tblDoctorKeyWord', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblDoctorKeyWord', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDoctorKeyWord]', @del_cmd = N'CALL [sp_MSdel_dbotblDoctorKeyWord]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDoctorKeyWord]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDoctorLocation', @source_owner = N'dbo', @source_object = N'tblDoctorLocation', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblDoctorLocation', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDoctorLocation]', @del_cmd = N'CALL [sp_MSdel_dbotblDoctorLocation]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDoctorLocation]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDoctorMargin', @source_owner = N'dbo', @source_object = N'tblDoctorMargin', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblDoctorMargin', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDoctorMargin]', @del_cmd = N'CALL [sp_MSdel_dbotblDoctorMargin]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDoctorMargin]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDoctorNetwork', @source_owner = N'dbo', @source_object = N'tblDoctorNetwork', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblDoctorNetwork', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDoctorNetwork]', @del_cmd = N'CALL [sp_MSdel_dbotblDoctorNetwork]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDoctorNetwork]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDoctorOffice', @source_owner = N'dbo', @source_object = N'tblDoctorOffice', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblDoctorOffice', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDoctorOffice]', @del_cmd = N'CALL [sp_MSdel_dbotblDoctorOffice]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDoctorOffice]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDoctorReason', @source_owner = N'dbo', @source_object = N'tblDoctorReason', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblDoctorReason', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDoctorReason]', @del_cmd = N'CALL [sp_MSdel_dbotblDoctorReason]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDoctorReason]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDoctorRecommend', @source_owner = N'dbo', @source_object = N'tblDoctorRecommend', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblDoctorRecommend', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDoctorRecommend]', @del_cmd = N'CALL [sp_MSdel_dbotblDoctorRecommend]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDoctorRecommend]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDoctorSchedule', @source_owner = N'dbo', @source_object = N'tblDoctorSchedule', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblDoctorSchedule', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDoctorSchedule]', @del_cmd = N'CALL [sp_MSdel_dbotblDoctorSchedule]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDoctorSchedule]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDoctorScheduleSummary', @source_owner = N'dbo', @source_object = N'tblDoctorScheduleSummary', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblDoctorScheduleSummary', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDoctorScheduleSummary]', @del_cmd = N'CALL [sp_MSdel_dbotblDoctorScheduleSummary]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDoctorScheduleSummary]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDoctorSearchResult', @source_owner = N'dbo', @source_object = N'tblDoctorSearchResult', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblDoctorSearchResult', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDoctorSearchResult]', @del_cmd = N'CALL [sp_MSdel_dbotblDoctorSearchResult]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDoctorSearchResult]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDoctorSearchWeightedCriteria', @source_owner = N'dbo', @source_object = N'tblDoctorSearchWeightedCriteria', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblDoctorSearchWeightedCriteria', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDoctorSearchWeightedCriteria]', @del_cmd = N'CALL [sp_MSdel_dbotblDoctorSearchWeightedCriteria]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDoctorSearchWeightedCriteria]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDoctorSpecialty', @source_owner = N'dbo', @source_object = N'tblDoctorSpecialty', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblDoctorSpecialty', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDoctorSpecialty]', @del_cmd = N'CALL [sp_MSdel_dbotblDoctorSpecialty]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDoctorSpecialty]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDoctorTemplate', @source_owner = N'dbo', @source_object = N'tblDoctorTemplate', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblDoctorTemplate', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDoctorTemplate]', @del_cmd = N'CALL [sp_MSdel_dbotblDoctorTemplate]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDoctorTemplate]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDocument', @source_owner = N'dbo', @source_object = N'tblDocument', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblDocument', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDocument]', @del_cmd = N'CALL [sp_MSdel_dbotblDocument]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDocument]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDocumentOffice', @source_owner = N'dbo', @source_object = N'tblDocumentOffice', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblDocumentOffice', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDocumentOffice]', @del_cmd = N'CALL [sp_MSdel_dbotblDocumentOffice]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDocumentOffice]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDPSBundle', @source_owner = N'dbo', @source_object = N'tblDPSBundle', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblDPSBundle', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDPSBundle]', @del_cmd = N'CALL [sp_MSdel_dbotblDPSBundle]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDPSBundle]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDPSBundleCaseDocument', @source_owner = N'dbo', @source_object = N'tblDPSBundleCaseDocument', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblDPSBundleCaseDocument', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDPSBundleCaseDocument]', @del_cmd = N'CALL [sp_MSdel_dbotblDPSBundleCaseDocument]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDPSBundleCaseDocument]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDPSNote', @source_owner = N'dbo', @source_object = N'tblDPSNote', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblDPSNote', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDPSNote]', @del_cmd = N'CALL [sp_MSdel_dbotblDPSNote]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDPSNote]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDPSPriority', @source_owner = N'dbo', @source_object = N'tblDPSPriority', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblDPSPriority', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDPSPriority]', @del_cmd = N'CALL [sp_MSdel_dbotblDPSPriority]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDPSPriority]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDPSSortModel', @source_owner = N'dbo', @source_object = N'tblDPSSortModel', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblDPSSortModel', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDPSSortModel]', @del_cmd = N'CALL [sp_MSdel_dbotblDPSSortModel]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDPSSortModel]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDPSStatus', @source_owner = N'dbo', @source_object = N'tblDPSStatus', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblDPSStatus', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDPSStatus]', @del_cmd = N'CALL [sp_MSdel_dbotblDPSStatus]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDPSStatus]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDrAssistant', @source_owner = N'dbo', @source_object = N'tblDrAssistant', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblDrAssistant', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDrAssistant]', @del_cmd = N'CALL [sp_MSdel_dbotblDrAssistant]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDrAssistant]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblDrDoNotUse', @source_owner = N'dbo', @source_object = N'tblDrDoNotUse', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblDrDoNotUse', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblDrDoNotUse]', @del_cmd = N'CALL [sp_MSdel_dbotblDrDoNotUse]', @upd_cmd = N'SCALL [sp_MSupd_dbotblDrDoNotUse]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEmployer', @source_owner = N'dbo', @source_object = N'tblEmployer', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblEmployer', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEmployer]', @del_cmd = N'CALL [sp_MSdel_dbotblEmployer]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEmployer]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEmployerAddress', @source_owner = N'dbo', @source_object = N'tblEmployerAddress', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblEmployerAddress', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEmployerAddress]', @del_cmd = N'CALL [sp_MSdel_dbotblEmployerAddress]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEmployerAddress]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEmployerDefDocument', @source_owner = N'dbo', @source_object = N'tblEmployerDefDocument', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEmployerDefDocument', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEmployerDefDocument]', @del_cmd = N'CALL [sp_MSdel_dbotblEmployerDefDocument]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEmployerDefDocument]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEvent', @source_owner = N'dbo', @source_object = N'tblEvent', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEvent', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEvent]', @del_cmd = N'CALL [sp_MSdel_dbotblEvent]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEvent]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWAccreditation', @source_owner = N'dbo', @source_object = N'tblEWAccreditation', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWAccreditation', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWAccreditation]', @del_cmd = N'CALL [sp_MSdel_dbotblEWAccreditation]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWAccreditation]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWAuditEntity', @source_owner = N'dbo', @source_object = N'tblEWAuditEntity', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWAuditEntity', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWAuditEntity]', @del_cmd = N'CALL [sp_MSdel_dbotblEWAuditEntity]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWAuditEntity]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWBulkBilling', @source_owner = N'dbo', @source_object = N'tblEWBulkBilling', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWBulkBilling', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWBulkBilling]', @del_cmd = N'CALL [sp_MSdel_dbotblEWBulkBilling]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWBulkBilling]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWBusLine', @source_owner = N'dbo', @source_object = N'tblEWBusLine', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWBusLine', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWBusLine]', @del_cmd = N'CALL [sp_MSdel_dbotblEWBusLine]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWBusLine]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWClient', @source_owner = N'dbo', @source_object = N'tblEWClient', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWClient', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWClient]', @del_cmd = N'CALL [sp_MSdel_dbotblEWClient]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWClient]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWCompany', @source_owner = N'dbo', @source_object = N'tblEWCompany', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWCompany', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWCompany]', @del_cmd = N'CALL [sp_MSdel_dbotblEWCompany]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWCompany]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWCompanyType', @source_owner = N'dbo', @source_object = N'tblEWCompanyType', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWCompanyType', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWCompanyType]', @del_cmd = N'CALL [sp_MSdel_dbotblEWCompanyType]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWCompanyType]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWCoverLetter', @source_owner = N'dbo', @source_object = N'tblEWCoverLetter', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWCoverLetter', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWCoverLetter]', @del_cmd = N'CALL [sp_MSdel_dbotblEWCoverLetter]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWCoverLetter]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWCoverLetterBusLine', @source_owner = N'dbo', @source_object = N'tblEWCoverLetterBusLine', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWCoverLetterBusLine', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWCoverLetterBusLine]', @del_cmd = N'CALL [sp_MSdel_dbotblEWCoverLetterBusLine]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWCoverLetterBusLine]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWCoverLetterClientSpecData', @source_owner = N'dbo', @source_object = N'tblEWCoverLetterClientSpecData', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWCoverLetterClientSpecData', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWCoverLetterClientSpecData]', @del_cmd = N'CALL [sp_MSdel_dbotblEWCoverLetterClientSpecData]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWCoverLetterClientSpecData]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWCoverLetterCompanyName', @source_owner = N'dbo', @source_object = N'tblEWCoverLetterCompanyName', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWCoverLetterCompanyName', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWCoverLetterCompanyName]', @del_cmd = N'CALL [sp_MSdel_dbotblEWCoverLetterCompanyName]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWCoverLetterCompanyName]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWCoverLetterQuestion', @source_owner = N'dbo', @source_object = N'tblEWCoverLetterQuestion', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWCoverLetterQuestion', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWCoverLetterQuestion]', @del_cmd = N'CALL [sp_MSdel_dbotblEWCoverLetterQuestion]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWCoverLetterQuestion]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWCoverLetterState', @source_owner = N'dbo', @source_object = N'tblEWCoverLetterState', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWCoverLetterState', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWCoverLetterState]', @del_cmd = N'CALL [sp_MSdel_dbotblEWCoverLetterState]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWCoverLetterState]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWDrDocType', @source_owner = N'dbo', @source_object = N'tblEWDrDocType', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWDrDocType', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWDrDocType]', @del_cmd = N'CALL [sp_MSdel_dbotblEWDrDocType]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWDrDocType]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWExchangeRate', @source_owner = N'dbo', @source_object = N'tblEWExchangeRate', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblEWExchangeRate', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWExchangeRate]', @del_cmd = N'CALL [sp_MSdel_dbotblEWExchangeRate]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWExchangeRate]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWFacility', @source_owner = N'dbo', @source_object = N'tblEWFacility', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWFacility', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWFacility]', @del_cmd = N'CALL [sp_MSdel_dbotblEWFacility]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWFacility]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWFacilityGroup', @source_owner = N'dbo', @source_object = N'tblEWFacilityGroup', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblEWFacilityGroup', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWFacilityGroup]', @del_cmd = N'CALL [sp_MSdel_dbotblEWFacilityGroup]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWFacilityGroup]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWFacilityGroupCategory', @source_owner = N'dbo', @source_object = N'tblEWFacilityGroupCategory', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWFacilityGroupCategory', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWFacilityGroupCategory]', @del_cmd = N'CALL [sp_MSdel_dbotblEWFacilityGroupCategory]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWFacilityGroupCategory]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWFacilityGroupDetail', @source_owner = N'dbo', @source_object = N'tblEWFacilityGroupDetail', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWFacilityGroupDetail', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWFacilityGroupDetail]', @del_cmd = N'CALL [sp_MSdel_dbotblEWFacilityGroupDetail]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWFacilityGroupDetail]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWFacilityGroupSummary', @source_owner = N'dbo', @source_object = N'tblEWFacilityGroupSummary', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWFacilityGroupSummary', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWFacilityGroupSummary]', @del_cmd = N'CALL [sp_MSdel_dbotblEWFacilityGroupSummary]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWFacilityGroupSummary]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWFaxCoverPage', @source_owner = N'dbo', @source_object = N'tblEWFaxCoverPage', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWFaxCoverPage', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWFaxCoverPage]', @del_cmd = N'CALL [sp_MSdel_dbotblEWFaxCoverPage]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWFaxCoverPage]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWFaxCoverPageDB', @source_owner = N'dbo', @source_object = N'tblEWFaxCoverPageDB', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWFaxCoverPageDB', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWFaxCoverPageDB]', @del_cmd = N'CALL [sp_MSdel_dbotblEWFaxCoverPageDB]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWFaxCoverPageDB]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWFeeZone', @source_owner = N'dbo', @source_object = N'tblEWFeeZone', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWFeeZone', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWFeeZone]', @del_cmd = N'CALL [sp_MSdel_dbotblEWFeeZone]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWFeeZone]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWFlashCategory', @source_owner = N'dbo', @source_object = N'tblEWFlashCategory', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWFlashCategory', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWFlashCategory]', @del_cmd = N'CALL [sp_MSdel_dbotblEWFlashCategory]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWFlashCategory]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWFolderDef', @source_owner = N'dbo', @source_object = N'tblEWFolderDef', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWFolderDef', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWFolderDef]', @del_cmd = N'CALL [sp_MSdel_dbotblEWFolderDef]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWFolderDef]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWFolderType', @source_owner = N'dbo', @source_object = N'tblEWFolderType', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWFolderType', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWFolderType]', @del_cmd = N'CALL [sp_MSdel_dbotblEWFolderType]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWFolderType]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWGLAcct', @source_owner = N'dbo', @source_object = N'tblEWGLAcct', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWGLAcct', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWGLAcct]', @del_cmd = N'CALL [sp_MSdel_dbotblEWGLAcct]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWGLAcct]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWGLAcctCategory', @source_owner = N'dbo', @source_object = N'tblEWGLAcctCategory', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWGLAcctCategory', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWGLAcctCategory]', @del_cmd = N'CALL [sp_MSdel_dbotblEWGLAcctCategory]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWGLAcctCategory]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWInputSource', @source_owner = N'dbo', @source_object = N'tblEWInputSource', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWInputSource', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWInputSource]', @del_cmd = N'CALL [sp_MSdel_dbotblEWInputSource]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWInputSource]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWLocation', @source_owner = N'dbo', @source_object = N'tblEWLocation', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWLocation', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWLocation]', @del_cmd = N'CALL [sp_MSdel_dbotblEWLocation]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWLocation]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWNetwork', @source_owner = N'dbo', @source_object = N'tblEWNetwork', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblEWNetwork', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWNetwork]', @del_cmd = N'CALL [sp_MSdel_dbotblEWNetwork]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWNetwork]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWParentCompany', @source_owner = N'dbo', @source_object = N'tblEWParentCompany', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWParentCompany', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWParentCompany]', @del_cmd = N'CALL [sp_MSdel_dbotblEWParentCompany]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWParentCompany]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWParentCompanyDocuments', @source_owner = N'dbo', @source_object = N'tblEWParentCompanyDocuments', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWParentCompanyDocuments', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWParentCompanyDocuments]', @del_cmd = N'CALL [sp_MSdel_dbotblEWParentCompanyDocuments]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWParentCompanyDocuments]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWParentEmployer', @source_owner = N'dbo', @source_object = N'tblEWParentEmployer', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblEWParentEmployer', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWParentEmployer]', @del_cmd = N'CALL [sp_MSdel_dbotblEWParentEmployer]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWParentEmployer]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWPostingPeriod', @source_owner = N'dbo', @source_object = N'tblEWPostingPeriod', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblEWPostingPeriod', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWPostingPeriod]', @del_cmd = N'CALL [sp_MSdel_dbotblEWPostingPeriod]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWPostingPeriod]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWSecurityProfile', @source_owner = N'dbo', @source_object = N'tblEWSecurityProfile', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWSecurityProfile', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWSecurityProfile]', @del_cmd = N'CALL [sp_MSdel_dbotblEWSecurityProfile]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWSecurityProfile]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWServiceType', @source_owner = N'dbo', @source_object = N'tblEWServiceType', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWServiceType', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWServiceType]', @del_cmd = N'CALL [sp_MSdel_dbotblEWServiceType]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWServiceType]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWTimeZone', @source_owner = N'dbo', @source_object = N'tblEWTimeZone', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWTimeZone', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWTimeZone]', @del_cmd = N'CALL [sp_MSdel_dbotblEWTimeZone]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWTimeZone]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWTimeZoneAdjustmentRule', @source_owner = N'dbo', @source_object = N'tblEWTimeZoneAdjustmentRule', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWTimeZoneAdjustmentRule', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWTimeZoneAdjustmentRule]', @del_cmd = N'CALL [sp_MSdel_dbotblEWTimeZoneAdjustmentRule]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWTimeZoneAdjustmentRule]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWTransDept', @source_owner = N'dbo', @source_object = N'tblEWTransDept', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWTransDept', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWTransDept]', @del_cmd = N'CALL [sp_MSdel_dbotblEWTransDept]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWTransDept]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWUnitOfMeasure', @source_owner = N'dbo', @source_object = N'tblEWUnitOfMeasure', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWUnitOfMeasure', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWUnitOfMeasure]', @del_cmd = N'CALL [sp_MSdel_dbotblEWUnitOfMeasure]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWUnitOfMeasure]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWWebUser', @source_owner = N'dbo', @source_object = N'tblEWWebUser', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWWebUser', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWWebUser]', @del_cmd = N'CALL [sp_MSdel_dbotblEWWebUser]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWWebUser]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblEWWebUserAccount', @source_owner = N'dbo', @source_object = N'tblEWWebUserAccount', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblEWWebUserAccount', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblEWWebUserAccount]', @del_cmd = N'CALL [sp_MSdel_dbotblEWWebUserAccount]', @upd_cmd = N'SCALL [sp_MSupd_dbotblEWWebUserAccount]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblExaminee', @source_owner = N'dbo', @source_object = N'tblExaminee', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblExaminee', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblExaminee]', @del_cmd = N'CALL [sp_MSdel_dbotblExaminee]', @upd_cmd = N'SCALL [sp_MSupd_dbotblExaminee]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblExamineeAddresses', @source_owner = N'dbo', @source_object = N'tblExamineeAddresses', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblExamineeAddresses', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblExamineeAddresses]', @del_cmd = N'CALL [sp_MSdel_dbotblExamineeAddresses]', @upd_cmd = N'SCALL [sp_MSupd_dbotblExamineeAddresses]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblExamineeCC', @source_owner = N'dbo', @source_object = N'tblExamineeCC', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblExamineeCC', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblExamineeCC]', @del_cmd = N'CALL [sp_MSdel_dbotblExamineeCC]', @upd_cmd = N'SCALL [sp_MSupd_dbotblExamineeCC]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblExceptionDefCaseType', @source_owner = N'dbo', @source_object = N'tblExceptionDefCaseType', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblExceptionDefCaseType', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblExceptionDefCaseType]', @del_cmd = N'CALL [sp_MSdel_dbotblExceptionDefCaseType]', @upd_cmd = N'SCALL [sp_MSupd_dbotblExceptionDefCaseType]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblExceptionDefEntity', @source_owner = N'dbo', @source_object = N'tblExceptionDefEntity', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblExceptionDefEntity', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblExceptionDefEntity]', @del_cmd = N'CALL [sp_MSdel_dbotblExceptionDefEntity]', @upd_cmd = N'SCALL [sp_MSupd_dbotblExceptionDefEntity]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblExceptionDefEWServiceType', @source_owner = N'dbo', @source_object = N'tblExceptionDefEWServiceType', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblExceptionDefEWServiceType', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblExceptionDefEWServiceType]', @del_cmd = N'CALL [sp_MSdel_dbotblExceptionDefEWServiceType]', @upd_cmd = N'SCALL [sp_MSupd_dbotblExceptionDefEWServiceType]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblExceptionDefinition', @source_owner = N'dbo', @source_object = N'tblExceptionDefinition', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblExceptionDefinition', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblExceptionDefinition]', @del_cmd = N'CALL [sp_MSdel_dbotblExceptionDefinition]', @upd_cmd = N'SCALL [sp_MSupd_dbotblExceptionDefinition]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblExceptionDefOffice', @source_owner = N'dbo', @source_object = N'tblExceptionDefOffice', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblExceptionDefOffice', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblExceptionDefOffice]', @del_cmd = N'CALL [sp_MSdel_dbotblExceptionDefOffice]', @upd_cmd = N'SCALL [sp_MSupd_dbotblExceptionDefOffice]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblExceptionDefService', @source_owner = N'dbo', @source_object = N'tblExceptionDefService', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblExceptionDefService', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblExceptionDefService]', @del_cmd = N'CALL [sp_MSdel_dbotblExceptionDefService]', @upd_cmd = N'SCALL [sp_MSupd_dbotblExceptionDefService]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblExceptionDefSLARuleDetail', @source_owner = N'dbo', @source_object = N'tblExceptionDefSLARuleDetail', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblExceptionDefSLARuleDetail', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblExceptionDefSLARuleDetail]', @del_cmd = N'CALL [sp_MSdel_dbotblExceptionDefSLARuleDetail]', @upd_cmd = N'SCALL [sp_MSupd_dbotblExceptionDefSLARuleDetail]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblExceptionList', @source_owner = N'dbo', @source_object = N'tblExceptionList', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblExceptionList', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblExceptionList]', @del_cmd = N'CALL [sp_MSdel_dbotblExceptionList]', @upd_cmd = N'SCALL [sp_MSupd_dbotblExceptionList]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblExternalCommunications', @source_owner = N'dbo', @source_object = N'tblExternalCommunications', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblExternalCommunications', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblExternalCommunications]', @del_cmd = N'CALL [sp_MSdel_dbotblExternalCommunications]', @upd_cmd = N'SCALL [sp_MSupd_dbotblExternalCommunications]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblFacility', @source_owner = N'dbo', @source_object = N'tblFacility', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblFacility', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblFacility]', @del_cmd = N'CALL [sp_MSdel_dbotblFacility]', @upd_cmd = N'SCALL [sp_MSupd_dbotblFacility]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblFacilityOffice', @source_owner = N'dbo', @source_object = N'tblFacilityOffice', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblFacilityOffice', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblFacilityOffice]', @del_cmd = N'CALL [sp_MSdel_dbotblFacilityOffice]', @upd_cmd = N'SCALL [sp_MSupd_dbotblFacilityOffice]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblFeeDetail', @source_owner = N'dbo', @source_object = N'tblFeeDetail', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblFeeDetail', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblFeeDetail]', @del_cmd = N'CALL [sp_MSdel_dbotblFeeDetail]', @upd_cmd = N'SCALL [sp_MSupd_dbotblFeeDetail]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblFeeDetailAbeton', @source_owner = N'dbo', @source_object = N'tblFeeDetailAbeton', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblFeeDetailAbeton', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblFeeDetailAbeton]', @del_cmd = N'CALL [sp_MSdel_dbotblFeeDetailAbeton]', @upd_cmd = N'SCALL [sp_MSupd_dbotblFeeDetailAbeton]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblFeeHeader', @source_owner = N'dbo', @source_object = N'tblFeeHeader', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblFeeHeader', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblFeeHeader]', @del_cmd = N'CALL [sp_MSdel_dbotblFeeHeader]', @upd_cmd = N'SCALL [sp_MSupd_dbotblFeeHeader]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblFeeHeaderOffice', @source_owner = N'dbo', @source_object = N'tblFeeHeaderOffice', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblFeeHeaderOffice', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblFeeHeaderOffice]', @del_cmd = N'CALL [sp_MSdel_dbotblFeeHeaderOffice]', @upd_cmd = N'SCALL [sp_MSupd_dbotblFeeHeaderOffice]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblFilePattern', @source_owner = N'dbo', @source_object = N'tblFilePattern', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblFilePattern', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblFilePattern]', @del_cmd = N'CALL [sp_MSdel_dbotblFilePattern]', @upd_cmd = N'SCALL [sp_MSupd_dbotblFilePattern]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblFolderFilePattern', @source_owner = N'dbo', @source_object = N'tblFolderFilePattern', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblFolderFilePattern', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblFolderFilePattern]', @del_cmd = N'CALL [sp_MSdel_dbotblFolderFilePattern]', @upd_cmd = N'SCALL [sp_MSupd_dbotblFolderFilePattern]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblFolderOffice', @source_owner = N'dbo', @source_object = N'tblFolderOffice', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblFolderOffice', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblFolderOffice]', @del_cmd = N'CALL [sp_MSdel_dbotblFolderOffice]', @upd_cmd = N'SCALL [sp_MSupd_dbotblFolderOffice]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblFRCategory', @source_owner = N'dbo', @source_object = N'tblFRCategory', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblFRCategory', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblFRCategory]', @del_cmd = N'CALL [sp_MSdel_dbotblFRCategory]', @upd_cmd = N'SCALL [sp_MSupd_dbotblFRCategory]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblFRCategorySetup', @source_owner = N'dbo', @source_object = N'tblFRCategorySetup', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblFRCategorySetup', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblFRCategorySetup]', @del_cmd = N'CALL [sp_MSdel_dbotblFRCategorySetup]', @upd_cmd = N'SCALL [sp_MSupd_dbotblFRCategorySetup]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblGPInvoice', @source_owner = N'dbo', @source_object = N'tblGPInvoice', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblGPInvoice', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblGPInvoice]', @del_cmd = N'CALL [sp_MSdel_dbotblGPInvoice]', @upd_cmd = N'SCALL [sp_MSupd_dbotblGPInvoice]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblGPInvoiceEDIStatus', @source_owner = N'dbo', @source_object = N'tblGPInvoiceEDIStatus', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblGPInvoiceEDIStatus', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblGPInvoiceEDIStatus]', @del_cmd = N'CALL [sp_MSdel_dbotblGPInvoiceEDIStatus]', @upd_cmd = N'SCALL [sp_MSupd_dbotblGPInvoiceEDIStatus]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblGPVoucher', @source_owner = N'dbo', @source_object = N'tblGPVoucher', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblGPVoucher', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblGPVoucher]', @del_cmd = N'CALL [sp_MSdel_dbotblGPVoucher]', @upd_cmd = N'SCALL [sp_MSupd_dbotblGPVoucher]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblGroupFunction', @source_owner = N'dbo', @source_object = N'tblGroupFunction', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblGroupFunction', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblGroupFunction]', @del_cmd = N'CALL [sp_MSdel_dbotblGroupFunction]', @upd_cmd = N'SCALL [sp_MSupd_dbotblGroupFunction]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblHCAIBatch', @source_owner = N'dbo', @source_object = N'tblHCAIBatch', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblHCAIBatch', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblHCAIBatch]', @del_cmd = N'CALL [sp_MSdel_dbotblHCAIBatch]', @upd_cmd = N'SCALL [sp_MSupd_dbotblHCAIBatch]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblHCAIControl', @source_owner = N'dbo', @source_object = N'tblHCAIControl', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblHCAIControl', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblHCAIControl]', @del_cmd = N'CALL [sp_MSdel_dbotblHCAIControl]', @upd_cmd = N'SCALL [sp_MSupd_dbotblHCAIControl]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblHCAIInsurer', @source_owner = N'dbo', @source_object = N'tblHCAIInsurer', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblHCAIInsurer', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblHCAIInsurer]', @del_cmd = N'CALL [sp_MSdel_dbotblHCAIInsurer]', @upd_cmd = N'SCALL [sp_MSupd_dbotblHCAIInsurer]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblHCAIProvider', @source_owner = N'dbo', @source_object = N'tblHCAIProvider', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblHCAIProvider', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblHCAIProvider]', @del_cmd = N'CALL [sp_MSdel_dbotblHCAIProvider]', @upd_cmd = N'SCALL [sp_MSupd_dbotblHCAIProvider]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblICDCode', @source_owner = N'dbo', @source_object = N'tblICDCode', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblICDCode', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblICDCode]', @del_cmd = N'CALL [sp_MSdel_dbotblICDCode]', @upd_cmd = N'SCALL [sp_MSupd_dbotblICDCode]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblIMEData', @source_owner = N'dbo', @source_object = N'tblIMEData', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblIMEData', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblIMEData]', @del_cmd = N'CALL [sp_MSdel_dbotblIMEData]', @upd_cmd = N'SCALL [sp_MSupd_dbotblIMEData]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblInvoiceAttachments', @source_owner = N'dbo', @source_object = N'tblInvoiceAttachments', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblInvoiceAttachments', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblInvoiceAttachments]', @del_cmd = N'CALL [sp_MSdel_dbotblInvoiceAttachments]', @upd_cmd = N'SCALL [sp_MSupd_dbotblInvoiceAttachments]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblIssue', @source_owner = N'dbo', @source_object = N'tblIssue', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblIssue', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblIssue]', @del_cmd = N'CALL [sp_MSdel_dbotblIssue]', @upd_cmd = N'SCALL [sp_MSupd_dbotblIssue]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblIssueQuestion', @source_owner = N'dbo', @source_object = N'tblIssueQuestion', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblIssueQuestion', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblIssueQuestion]', @del_cmd = N'CALL [sp_MSdel_dbotblIssueQuestion]', @upd_cmd = N'SCALL [sp_MSupd_dbotblIssueQuestion]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblKeyWord', @source_owner = N'dbo', @source_object = N'tblKeyWord', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblKeyWord', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblKeyWord]', @del_cmd = N'CALL [sp_MSdel_dbotblKeyWord]', @upd_cmd = N'SCALL [sp_MSupd_dbotblKeyWord]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblLabelFile', @source_owner = N'dbo', @source_object = N'tblLabelFile', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblLabelFile', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblLabelFile]', @del_cmd = N'CALL [sp_MSdel_dbotblLabelFile]', @upd_cmd = N'SCALL [sp_MSupd_dbotblLabelFile]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblLanguage', @source_owner = N'dbo', @source_object = N'tblLanguage', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblLanguage', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblLanguage]', @del_cmd = N'CALL [sp_MSdel_dbotblLanguage]', @upd_cmd = N'SCALL [sp_MSupd_dbotblLanguage]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblLocation', @source_owner = N'dbo', @source_object = N'tblLocation', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblLocation', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblLocation]', @del_cmd = N'CALL [sp_MSdel_dbotblLocation]', @upd_cmd = N'SCALL [sp_MSupd_dbotblLocation]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblLocationOffice', @source_owner = N'dbo', @source_object = N'tblLocationOffice', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblLocationOffice', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblLocationOffice]', @del_cmd = N'CALL [sp_MSdel_dbotblLocationOffice]', @upd_cmd = N'SCALL [sp_MSupd_dbotblLocationOffice]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblLock', @source_owner = N'dbo', @source_object = N'tblLock', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblLock', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblLock]', @del_cmd = N'CALL [sp_MSdel_dbotblLock]', @upd_cmd = N'SCALL [sp_MSupd_dbotblLock]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblLogUsage', @source_owner = N'dbo', @source_object = N'tblLogUsage', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblLogUsage', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblLogUsage]', @del_cmd = N'CALL [sp_MSdel_dbotblLogUsage]', @upd_cmd = N'SCALL [sp_MSupd_dbotblLogUsage]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblMerge', @source_owner = N'dbo', @source_object = N'tblMerge', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblMerge', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblMerge]', @del_cmd = N'CALL [sp_MSdel_dbotblMerge]', @upd_cmd = N'SCALL [sp_MSupd_dbotblMerge]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblMergeLog', @source_owner = N'dbo', @source_object = N'tblMergeLog', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblMergeLog', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblMergeLog]', @del_cmd = N'CALL [sp_MSdel_dbotblMergeLog]', @upd_cmd = N'SCALL [sp_MSupd_dbotblMergeLog]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblMessageToken', @source_owner = N'dbo', @source_object = N'tblMessageToken', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblMessageToken', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblMessageToken]', @del_cmd = N'CALL [sp_MSdel_dbotblMessageToken]', @upd_cmd = N'SCALL [sp_MSupd_dbotblMessageToken]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblNamePrefix', @source_owner = N'dbo', @source_object = N'tblNamePrefix', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblNamePrefix', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblNamePrefix]', @del_cmd = N'CALL [sp_MSdel_dbotblNamePrefix]', @upd_cmd = N'SCALL [sp_MSupd_dbotblNamePrefix]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblNonWorkDays', @source_owner = N'dbo', @source_object = N'tblNonWorkDays', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblNonWorkDays', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblNonWorkDays]', @del_cmd = N'CALL [sp_MSdel_dbotblNonWorkDays]', @upd_cmd = N'SCALL [sp_MSupd_dbotblNonWorkDays]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblNotify', @source_owner = N'dbo', @source_object = N'tblNotify', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblNotify', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblNotify]', @del_cmd = N'CALL [sp_MSdel_dbotblNotify]', @upd_cmd = N'SCALL [sp_MSupd_dbotblNotify]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblNotifyAudience', @source_owner = N'dbo', @source_object = N'tblNotifyAudience', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblNotifyAudience', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblNotifyAudience]', @del_cmd = N'CALL [sp_MSdel_dbotblNotifyAudience]', @upd_cmd = N'SCALL [sp_MSupd_dbotblNotifyAudience]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblNotifyDetail', @source_owner = N'dbo', @source_object = N'tblNotifyDetail', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblNotifyDetail', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblNotifyDetail]', @del_cmd = N'CALL [sp_MSdel_dbotblNotifyDetail]', @upd_cmd = N'SCALL [sp_MSupd_dbotblNotifyDetail]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblNotifyEvent', @source_owner = N'dbo', @source_object = N'tblNotifyEvent', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblNotifyEvent', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblNotifyEvent]', @del_cmd = N'CALL [sp_MSdel_dbotblNotifyEvent]', @upd_cmd = N'SCALL [sp_MSupd_dbotblNotifyEvent]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblNotifyMethod', @source_owner = N'dbo', @source_object = N'tblNotifyMethod', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblNotifyMethod', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblNotifyMethod]', @del_cmd = N'CALL [sp_MSdel_dbotblNotifyMethod]', @upd_cmd = N'SCALL [sp_MSupd_dbotblNotifyMethod]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblNotifyPreference', @source_owner = N'dbo', @source_object = N'tblNotifyPreference', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblNotifyPreference', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblNotifyPreference]', @del_cmd = N'CALL [sp_MSdel_dbotblNotifyPreference]', @upd_cmd = N'SCALL [sp_MSupd_dbotblNotifyPreference]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblObtainmentType', @source_owner = N'dbo', @source_object = N'tblObtainmentType', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblObtainmentType', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblObtainmentType]', @del_cmd = N'CALL [sp_MSdel_dbotblObtainmentType]', @upd_cmd = N'SCALL [sp_MSupd_dbotblObtainmentType]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblObtainmentTypeDetail', @source_owner = N'dbo', @source_object = N'tblObtainmentTypeDetail', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblObtainmentTypeDetail', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblObtainmentTypeDetail]', @del_cmd = N'CALL [sp_MSdel_dbotblObtainmentTypeDetail]', @upd_cmd = N'SCALL [sp_MSupd_dbotblObtainmentTypeDetail]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblOffice', @source_owner = N'dbo', @source_object = N'tblOffice', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblOffice', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblOffice]', @del_cmd = N'CALL [sp_MSdel_dbotblOffice]', @upd_cmd = N'SCALL [sp_MSupd_dbotblOffice]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblOfficeContact', @source_owner = N'dbo', @source_object = N'tblOfficeContact', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblOfficeContact', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblOfficeContact]', @del_cmd = N'CALL [sp_MSdel_dbotblOfficeContact]', @upd_cmd = N'SCALL [sp_MSupd_dbotblOfficeContact]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblOfficeDPSSortModel', @source_owner = N'dbo', @source_object = N'tblOfficeDPSSortModel', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblOfficeDPSSortModel', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblOfficeDPSSortModel]', @del_cmd = N'CALL [sp_MSdel_dbotblOfficeDPSSortModel]', @upd_cmd = N'SCALL [sp_MSupd_dbotblOfficeDPSSortModel]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblOtherPartyType', @source_owner = N'dbo', @source_object = N'tblOtherPartyType', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblOtherPartyType', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblOtherPartyType]', @del_cmd = N'CALL [sp_MSdel_dbotblOtherPartyType]', @upd_cmd = N'SCALL [sp_MSupd_dbotblOtherPartyType]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblOutOfNetworkReason', @source_owner = N'dbo', @source_object = N'tblOutOfNetworkReason', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblOutOfNetworkReason', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblOutOfNetworkReason]', @del_cmd = N'CALL [sp_MSdel_dbotblOutOfNetworkReason]', @upd_cmd = N'SCALL [sp_MSupd_dbotblOutOfNetworkReason]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblParamProperty', @source_owner = N'dbo', @source_object = N'tblParamProperty', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblParamProperty', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblParamProperty]', @del_cmd = N'CALL [sp_MSdel_dbotblParamProperty]', @upd_cmd = N'SCALL [sp_MSupd_dbotblParamProperty]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblParamPropertyGroup', @source_owner = N'dbo', @source_object = N'tblParamPropertyGroup', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblParamPropertyGroup', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblParamPropertyGroup]', @del_cmd = N'CALL [sp_MSdel_dbotblParamPropertyGroup]', @upd_cmd = N'SCALL [sp_MSupd_dbotblParamPropertyGroup]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblPriority', @source_owner = N'dbo', @source_object = N'tblPriority', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblPriority', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblPriority]', @del_cmd = N'CALL [sp_MSdel_dbotblPriority]', @upd_cmd = N'SCALL [sp_MSupd_dbotblPriority]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblProblem', @source_owner = N'dbo', @source_object = N'tblProblem', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblProblem', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblProblem]', @del_cmd = N'CALL [sp_MSdel_dbotblProblem]', @upd_cmd = N'SCALL [sp_MSupd_dbotblProblem]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblProblemArea', @source_owner = N'dbo', @source_object = N'tblProblemArea', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblProblemArea', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblProblemArea]', @del_cmd = N'CALL [sp_MSdel_dbotblProblemArea]', @upd_cmd = N'SCALL [sp_MSupd_dbotblProblemArea]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblProblemDetail', @source_owner = N'dbo', @source_object = N'tblProblemDetail', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblProblemDetail', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblProblemDetail]', @del_cmd = N'CALL [sp_MSdel_dbotblProblemDetail]', @upd_cmd = N'SCALL [sp_MSupd_dbotblProblemDetail]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblProduct', @source_owner = N'dbo', @source_object = N'tblProduct', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblProduct', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblProduct]', @del_cmd = N'CALL [sp_MSdel_dbotblProduct]', @upd_cmd = N'SCALL [sp_MSupd_dbotblProduct]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblProductCPTCode', @source_owner = N'dbo', @source_object = N'tblProductCPTCode', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblProductCPTCode', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblProductCPTCode]', @del_cmd = N'CALL [sp_MSdel_dbotblProductCPTCode]', @upd_cmd = N'SCALL [sp_MSupd_dbotblProductCPTCode]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblProductOffice', @source_owner = N'dbo', @source_object = N'tblProductOffice', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblProductOffice', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblProductOffice]', @del_cmd = N'CALL [sp_MSdel_dbotblProductOffice]', @upd_cmd = N'SCALL [sp_MSupd_dbotblProductOffice]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblProviderType', @source_owner = N'dbo', @source_object = N'tblProviderType', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblProviderType', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblProviderType]', @del_cmd = N'CALL [sp_MSdel_dbotblProviderType]', @upd_cmd = N'SCALL [sp_MSupd_dbotblProviderType]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblPublishOnWeb', @source_owner = N'dbo', @source_object = N'tblPublishOnWeb', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblPublishOnWeb', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblPublishOnWeb]', @del_cmd = N'CALL [sp_MSdel_dbotblPublishOnWeb]', @upd_cmd = N'SCALL [sp_MSupd_dbotblPublishOnWeb]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblQuestionRule', @source_owner = N'dbo', @source_object = N'tblQuestionRule', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblQuestionRule', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblQuestionRule]', @del_cmd = N'CALL [sp_MSdel_dbotblQuestionRule]', @upd_cmd = N'SCALL [sp_MSupd_dbotblQuestionRule]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblQuestionSet', @source_owner = N'dbo', @source_object = N'tblQuestionSet', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblQuestionSet', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblQuestionSet]', @del_cmd = N'CALL [sp_MSdel_dbotblQuestionSet]', @upd_cmd = N'SCALL [sp_MSupd_dbotblQuestionSet]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblQuestionSetDetail', @source_owner = N'dbo', @source_object = N'tblQuestionSetDetail', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblQuestionSetDetail', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblQuestionSetDetail]', @del_cmd = N'CALL [sp_MSdel_dbotblQuestionSetDetail]', @upd_cmd = N'SCALL [sp_MSupd_dbotblQuestionSetDetail]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblQueueForms', @source_owner = N'dbo', @source_object = N'tblQueueForms', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblQueueForms', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblQueueForms]', @del_cmd = N'CALL [sp_MSdel_dbotblQueueForms]', @upd_cmd = N'SCALL [sp_MSupd_dbotblQueueForms]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblQueues', @source_owner = N'dbo', @source_object = N'tblQueues', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblQueues', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblQueues]', @del_cmd = N'CALL [sp_MSdel_dbotblQueues]', @upd_cmd = N'SCALL [sp_MSupd_dbotblQueues]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblQuoteFeeConfig', @source_owner = N'dbo', @source_object = N'tblQuoteFeeConfig', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblQuoteFeeConfig', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblQuoteFeeConfig]', @del_cmd = N'CALL [sp_MSdel_dbotblQuoteFeeConfig]', @upd_cmd = N'SCALL [sp_MSupd_dbotblQuoteFeeConfig]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblQuoteHandling', @source_owner = N'dbo', @source_object = N'tblQuoteHandling', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblQuoteHandling', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblQuoteHandling]', @del_cmd = N'CALL [sp_MSdel_dbotblQuoteHandling]', @upd_cmd = N'SCALL [sp_MSupd_dbotblQuoteHandling]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblQuoteRule', @source_owner = N'dbo', @source_object = N'tblQuoteRule', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblQuoteRule', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblQuoteRule]', @del_cmd = N'CALL [sp_MSdel_dbotblQuoteRule]', @upd_cmd = N'SCALL [sp_MSupd_dbotblQuoteRule]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblQuoteStatus', @source_owner = N'dbo', @source_object = N'tblQuoteStatus', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblQuoteStatus', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblQuoteStatus]', @del_cmd = N'CALL [sp_MSdel_dbotblQuoteStatus]', @upd_cmd = N'SCALL [sp_MSupd_dbotblQuoteStatus]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblRecordActions', @source_owner = N'dbo', @source_object = N'tblRecordActions', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblRecordActions', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblRecordActions]', @del_cmd = N'CALL [sp_MSdel_dbotblRecordActions]', @upd_cmd = N'SCALL [sp_MSupd_dbotblRecordActions]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblRecordHistory', @source_owner = N'dbo', @source_object = N'tblRecordHistory', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblRecordHistory', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblRecordHistory]', @del_cmd = N'CALL [sp_MSdel_dbotblRecordHistory]', @upd_cmd = N'SCALL [sp_MSupd_dbotblRecordHistory]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblRecordsObtainment', @source_owner = N'dbo', @source_object = N'tblRecordsObtainment', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblRecordsObtainment', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblRecordsObtainment]', @del_cmd = N'CALL [sp_MSdel_dbotblRecordsObtainment]', @upd_cmd = N'SCALL [sp_MSupd_dbotblRecordsObtainment]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblRecordsObtainmentDetail', @source_owner = N'dbo', @source_object = N'tblRecordsObtainmentDetail', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblRecordsObtainmentDetail', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblRecordsObtainmentDetail]', @del_cmd = N'CALL [sp_MSdel_dbotblRecordsObtainmentDetail]', @upd_cmd = N'SCALL [sp_MSupd_dbotblRecordsObtainmentDetail]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblRecordStatus', @source_owner = N'dbo', @source_object = N'tblRecordStatus', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblRecordStatus', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblRecordStatus]', @del_cmd = N'CALL [sp_MSdel_dbotblRecordStatus]', @upd_cmd = N'SCALL [sp_MSupd_dbotblRecordStatus]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblReferralAssignmentRule', @source_owner = N'dbo', @source_object = N'tblReferralAssignmentRule', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblReferralAssignmentRule', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblReferralAssignmentRule]', @del_cmd = N'CALL [sp_MSdel_dbotblReferralAssignmentRule]', @upd_cmd = N'SCALL [sp_MSupd_dbotblReferralAssignmentRule]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblRelatedParty', @source_owner = N'dbo', @source_object = N'tblRelatedParty', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblRelatedParty', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblRelatedParty]', @del_cmd = N'CALL [sp_MSdel_dbotblRelatedParty]', @upd_cmd = N'SCALL [sp_MSupd_dbotblRelatedParty]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblRptStatus', @source_owner = N'dbo', @source_object = N'tblRptStatus', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblRptStatus', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblRptStatus]', @del_cmd = N'CALL [sp_MSdel_dbotblRptStatus]', @upd_cmd = N'SCALL [sp_MSupd_dbotblRptStatus]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblScanSetting', @source_owner = N'dbo', @source_object = N'tblScanSetting', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblScanSetting', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblScanSetting]', @del_cmd = N'CALL [sp_MSdel_dbotblScanSetting]', @upd_cmd = N'SCALL [sp_MSupd_dbotblScanSetting]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblScanSettingWorkstation', @source_owner = N'dbo', @source_object = N'tblScanSettingWorkstation', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblScanSettingWorkstation', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblScanSettingWorkstation]', @del_cmd = N'CALL [sp_MSdel_dbotblScanSettingWorkstation]', @upd_cmd = N'SCALL [sp_MSupd_dbotblScanSettingWorkstation]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblServiceDoNotUse', @source_owner = N'dbo', @source_object = N'tblServiceDoNotUse', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblServiceDoNotUse', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblServiceDoNotUse]', @del_cmd = N'CALL [sp_MSdel_dbotblServiceDoNotUse]', @upd_cmd = N'SCALL [sp_MSupd_dbotblServiceDoNotUse]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblServiceIncludeExclude', @source_owner = N'dbo', @source_object = N'tblServiceIncludeExclude', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblServiceIncludeExclude', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblServiceIncludeExclude]', @del_cmd = N'CALL [sp_MSdel_dbotblServiceIncludeExclude]', @upd_cmd = N'SCALL [sp_MSupd_dbotblServiceIncludeExclude]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblServiceOffice', @source_owner = N'dbo', @source_object = N'tblServiceOffice', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblServiceOffice', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblServiceOffice]', @del_cmd = N'CALL [sp_MSdel_dbotblServiceOffice]', @upd_cmd = N'SCALL [sp_MSupd_dbotblServiceOffice]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblServices', @source_owner = N'dbo', @source_object = N'tblServices', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblServices', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblServices]', @del_cmd = N'CALL [sp_MSdel_dbotblServices]', @upd_cmd = N'SCALL [sp_MSupd_dbotblServices]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblServicesJurisdictions', @source_owner = N'dbo', @source_object = N'tblServicesJurisdictions', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblServicesJurisdictions', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblServicesJurisdictions]', @del_cmd = N'CALL [sp_MSdel_dbotblServicesJurisdictions]', @upd_cmd = N'SCALL [sp_MSupd_dbotblServicesJurisdictions]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblServiceWorkflow', @source_owner = N'dbo', @source_object = N'tblServiceWorkflow', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblServiceWorkflow', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblServiceWorkflow]', @del_cmd = N'CALL [sp_MSdel_dbotblServiceWorkflow]', @upd_cmd = N'SCALL [sp_MSupd_dbotblServiceWorkflow]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblServiceWorkflowQueue', @source_owner = N'dbo', @source_object = N'tblServiceWorkflowQueue', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblServiceWorkflowQueue', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblServiceWorkflowQueue]', @del_cmd = N'CALL [sp_MSdel_dbotblServiceWorkflowQueue]', @upd_cmd = N'SCALL [sp_MSupd_dbotblServiceWorkflowQueue]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblServiceWorkflowQueueDocument', @source_owner = N'dbo', @source_object = N'tblServiceWorkflowQueueDocument', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblServiceWorkflowQueueDocument', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblServiceWorkflowQueueDocument]', @del_cmd = N'CALL [sp_MSdel_dbotblServiceWorkflowQueueDocument]', @upd_cmd = N'SCALL [sp_MSupd_dbotblServiceWorkflowQueueDocument]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblSession', @source_owner = N'dbo', @source_object = N'tblSession', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblSession', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblSession]', @del_cmd = N'CALL [sp_MSdel_dbotblSession]', @upd_cmd = N'SCALL [sp_MSupd_dbotblSession]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblSetting', @source_owner = N'dbo', @source_object = N'tblSetting', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblSetting', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblSetting]', @del_cmd = N'CALL [sp_MSdel_dbotblSetting]', @upd_cmd = N'SCALL [sp_MSupd_dbotblSetting]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblSLAException', @source_owner = N'dbo', @source_object = N'tblSLAException', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblSLAException', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblSLAException]', @del_cmd = N'CALL [sp_MSdel_dbotblSLAException]', @upd_cmd = N'SCALL [sp_MSupd_dbotblSLAException]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblSLAExceptionGroup', @source_owner = N'dbo', @source_object = N'tblSLAExceptionGroup', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblSLAExceptionGroup', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblSLAExceptionGroup]', @del_cmd = N'CALL [sp_MSdel_dbotblSLAExceptionGroup]', @upd_cmd = N'SCALL [sp_MSupd_dbotblSLAExceptionGroup]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblSLARule', @source_owner = N'dbo', @source_object = N'tblSLARule', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblSLARule', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblSLARule]', @del_cmd = N'CALL [sp_MSdel_dbotblSLARule]', @upd_cmd = N'SCALL [sp_MSupd_dbotblSLARule]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblSLARuleCondition', @source_owner = N'dbo', @source_object = N'tblSLARuleCondition', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblSLARuleCondition', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblSLARuleCondition]', @del_cmd = N'CALL [sp_MSdel_dbotblSLARuleCondition]', @upd_cmd = N'SCALL [sp_MSupd_dbotblSLARuleCondition]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblSLARuleDetail', @source_owner = N'dbo', @source_object = N'tblSLARuleDetail', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblSLARuleDetail', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblSLARuleDetail]', @del_cmd = N'CALL [sp_MSdel_dbotblSLARuleDetail]', @upd_cmd = N'SCALL [sp_MSupd_dbotblSLARuleDetail]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblSpecialty', @source_owner = N'dbo', @source_object = N'tblSpecialty', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblSpecialty', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblSpecialty]', @del_cmd = N'CALL [sp_MSdel_dbotblSpecialty]', @upd_cmd = N'SCALL [sp_MSupd_dbotblSpecialty]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblStandardCaseHistoryNotes', @source_owner = N'dbo', @source_object = N'tblStandardCaseHistoryNotes', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblStandardCaseHistoryNotes', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblStandardCaseHistoryNotes]', @del_cmd = N'CALL [sp_MSdel_dbotblStandardCaseHistoryNotes]', @upd_cmd = N'SCALL [sp_MSupd_dbotblStandardCaseHistoryNotes]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblState', @source_owner = N'dbo', @source_object = N'tblState', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblState', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblState]', @del_cmd = N'CALL [sp_MSdel_dbotblState]', @upd_cmd = N'SCALL [sp_MSupd_dbotblState]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblStorage', @source_owner = N'dbo', @source_object = N'tblStorage', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblStorage', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblStorage]', @del_cmd = N'CALL [sp_MSdel_dbotblStorage]', @upd_cmd = N'SCALL [sp_MSupd_dbotblStorage]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblStorageRetentionRule', @source_owner = N'dbo', @source_object = N'tblStorageRetentionRule', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000000030073, @identityrangemanagementoption = N'none', @destination_table = N'tblStorageRetentionRule', @destination_owner = N'dbo', @status = 16, @vertical_partition = N'false', @ins_cmd = N'CALL [dbo].[sp_MSins_dbotblStorageRetentionRule]', @del_cmd = N'CALL [dbo].[sp_MSdel_dbotblStorageRetentionRule]', @upd_cmd = N'SCALL [dbo].[sp_MSupd_dbotblStorageRetentionRule]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblSyncLogs', @source_owner = N'dbo', @source_object = N'tblSyncLogs', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblSyncLogs', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblSyncLogs]', @del_cmd = N'CALL [sp_MSdel_dbotblSyncLogs]', @upd_cmd = N'SCALL [sp_MSupd_dbotblSyncLogs]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblTATCalculationGroup', @source_owner = N'dbo', @source_object = N'tblTATCalculationGroup', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblTATCalculationGroup', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblTATCalculationGroup]', @del_cmd = N'CALL [sp_MSdel_dbotblTATCalculationGroup]', @upd_cmd = N'SCALL [sp_MSupd_dbotblTATCalculationGroup]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblTATCalculationGroupDetail', @source_owner = N'dbo', @source_object = N'tblTATCalculationGroupDetail', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblTATCalculationGroupDetail', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblTATCalculationGroupDetail]', @del_cmd = N'CALL [sp_MSdel_dbotblTATCalculationGroupDetail]', @upd_cmd = N'SCALL [sp_MSupd_dbotblTATCalculationGroupDetail]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblTATCalculationMethod', @source_owner = N'dbo', @source_object = N'tblTATCalculationMethod', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblTATCalculationMethod', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblTATCalculationMethod]', @del_cmd = N'CALL [sp_MSdel_dbotblTATCalculationMethod]', @upd_cmd = N'SCALL [sp_MSupd_dbotblTATCalculationMethod]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblTATCalculationMethodEvent', @source_owner = N'dbo', @source_object = N'tblTATCalculationMethodEvent', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblTATCalculationMethodEvent', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblTATCalculationMethodEvent]', @del_cmd = N'CALL [sp_MSdel_dbotblTATCalculationMethodEvent]', @upd_cmd = N'SCALL [sp_MSupd_dbotblTATCalculationMethodEvent]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblTaxState', @source_owner = N'dbo', @source_object = N'tblTaxState', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblTaxState', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblTaxState]', @del_cmd = N'CALL [sp_MSdel_dbotblTaxState]', @upd_cmd = N'SCALL [sp_MSupd_dbotblTaxState]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblTaxTable', @source_owner = N'dbo', @source_object = N'tblTaxTable', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblTaxTable', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblTaxTable]', @del_cmd = N'CALL [sp_MSdel_dbotblTaxTable]', @upd_cmd = N'SCALL [sp_MSupd_dbotblTaxTable]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblTempData', @source_owner = N'dbo', @source_object = N'tblTempData', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblTempData', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblTempData]', @del_cmd = N'CALL [sp_MSdel_dbotblTempData]', @upd_cmd = N'SCALL [sp_MSupd_dbotblTempData]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblTempVendorVoucher', @source_owner = N'dbo', @source_object = N'tblTempVendorVoucher', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblTempVendorVoucher', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblTempVendorVoucher]', @del_cmd = N'CALL [sp_MSdel_dbotblTempVendorVoucher]', @upd_cmd = N'SCALL [sp_MSupd_dbotblTempVendorVoucher]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblTerms', @source_owner = N'dbo', @source_object = N'tblTerms', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblTerms', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblTerms]', @del_cmd = N'CALL [sp_MSdel_dbotblTerms]', @upd_cmd = N'SCALL [sp_MSupd_dbotblTerms]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblTranscription', @source_owner = N'dbo', @source_object = N'tblTranscription', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblTranscription', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblTranscription]', @del_cmd = N'CALL [sp_MSdel_dbotblTranscription]', @upd_cmd = N'SCALL [sp_MSupd_dbotblTranscription]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblTranscriptionJob', @source_owner = N'dbo', @source_object = N'tblTranscriptionJob', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblTranscriptionJob', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblTranscriptionJob]', @del_cmd = N'CALL [sp_MSdel_dbotblTranscriptionJob]', @upd_cmd = N'SCALL [sp_MSupd_dbotblTranscriptionJob]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblTranscriptionJobDictation', @source_owner = N'dbo', @source_object = N'tblTranscriptionJobDictation', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblTranscriptionJobDictation', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblTranscriptionJobDictation]', @del_cmd = N'CALL [sp_MSdel_dbotblTranscriptionJobDictation]', @upd_cmd = N'SCALL [sp_MSupd_dbotblTranscriptionJobDictation]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblTranscriptionJobFile', @source_owner = N'dbo', @source_object = N'tblTranscriptionJobFile', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblTranscriptionJobFile', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblTranscriptionJobFile]', @del_cmd = N'CALL [sp_MSdel_dbotblTranscriptionJobFile]', @upd_cmd = N'SCALL [sp_MSupd_dbotblTranscriptionJobFile]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblTranscriptionStatus', @source_owner = N'dbo', @source_object = N'tblTranscriptionStatus', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblTranscriptionStatus', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblTranscriptionStatus]', @del_cmd = N'CALL [sp_MSdel_dbotblTranscriptionStatus]', @upd_cmd = N'SCALL [sp_MSupd_dbotblTranscriptionStatus]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblTreatingDoctor', @source_owner = N'dbo', @source_object = N'tblTreatingDoctor', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblTreatingDoctor', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblTreatingDoctor]', @del_cmd = N'CALL [sp_MSdel_dbotblTreatingDoctor]', @upd_cmd = N'SCALL [sp_MSupd_dbotblTreatingDoctor]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblUser', @source_owner = N'dbo', @source_object = N'tblUser', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblUser', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblUser]', @del_cmd = N'CALL [sp_MSdel_dbotblUser]', @upd_cmd = N'SCALL [sp_MSupd_dbotblUser]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblUserActivity', @source_owner = N'dbo', @source_object = N'tblUserActivity', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblUserActivity', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblUserActivity]', @del_cmd = N'CALL [sp_MSdel_dbotblUserActivity]', @upd_cmd = N'SCALL [sp_MSupd_dbotblUserActivity]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblUserDefined', @source_owner = N'dbo', @source_object = N'tblUserDefined', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblUserDefined', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblUserDefined]', @del_cmd = N'CALL [sp_MSdel_dbotblUserDefined]', @upd_cmd = N'SCALL [sp_MSupd_dbotblUserDefined]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblUserFunction', @source_owner = N'dbo', @source_object = N'tblUserFunction', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblUserFunction', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblUserFunction]', @del_cmd = N'CALL [sp_MSdel_dbotblUserFunction]', @upd_cmd = N'SCALL [sp_MSupd_dbotblUserFunction]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblUserGroup', @source_owner = N'dbo', @source_object = N'tblUserGroup', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblUserGroup', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblUserGroup]', @del_cmd = N'CALL [sp_MSdel_dbotblUserGroup]', @upd_cmd = N'SCALL [sp_MSupd_dbotblUserGroup]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblUserOffice', @source_owner = N'dbo', @source_object = N'tblUserOffice', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblUserOffice', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblUserOffice]', @del_cmd = N'CALL [sp_MSdel_dbotblUserOffice]', @upd_cmd = N'SCALL [sp_MSupd_dbotblUserOffice]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblUserSecurity', @source_owner = N'dbo', @source_object = N'tblUserSecurity', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblUserSecurity', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblUserSecurity]', @del_cmd = N'CALL [sp_MSdel_dbotblUserSecurity]', @upd_cmd = N'SCALL [sp_MSupd_dbotblUserSecurity]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblVenue', @source_owner = N'dbo', @source_object = N'tblVenue', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblVenue', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblVenue]', @del_cmd = N'CALL [sp_MSdel_dbotblVenue]', @upd_cmd = N'SCALL [sp_MSupd_dbotblVenue]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblWebActionLink', @source_owner = N'dbo', @source_object = N'tblWebActionLink', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblWebActionLink', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblWebActionLink]', @del_cmd = N'CALL [sp_MSdel_dbotblWebActionLink]', @upd_cmd = N'SCALL [sp_MSupd_dbotblWebActionLink]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblWebActionLinkItem', @source_owner = N'dbo', @source_object = N'tblWebActionLinkItem', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblWebActionLinkItem', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblWebActionLinkItem]', @del_cmd = N'CALL [sp_MSdel_dbotblWebActionLinkItem]', @upd_cmd = N'SCALL [sp_MSupd_dbotblWebActionLinkItem]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblWebActivation', @source_owner = N'dbo', @source_object = N'tblWebActivation', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblWebActivation', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblWebActivation]', @del_cmd = N'CALL [sp_MSdel_dbotblWebActivation]', @upd_cmd = N'SCALL [sp_MSupd_dbotblWebActivation]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblWebCompany', @source_owner = N'dbo', @source_object = N'tblWebCompany', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblWebCompany', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblWebCompany]', @del_cmd = N'CALL [sp_MSdel_dbotblWebCompany]', @upd_cmd = N'SCALL [sp_MSupd_dbotblWebCompany]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblWebDictationStatus', @source_owner = N'dbo', @source_object = N'tblWebDictationStatus', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblWebDictationStatus', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblWebDictationStatus]', @del_cmd = N'CALL [sp_MSdel_dbotblWebDictationStatus]', @upd_cmd = N'SCALL [sp_MSupd_dbotblWebDictationStatus]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblWebEvents', @source_owner = N'dbo', @source_object = N'tblWebEvents', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblWebEvents', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblWebEvents]', @del_cmd = N'CALL [sp_MSdel_dbotblWebEvents]', @upd_cmd = N'SCALL [sp_MSupd_dbotblWebEvents]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblWebEventsOverride', @source_owner = N'dbo', @source_object = N'tblWebEventsOverride', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblWebEventsOverride', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblWebEventsOverride]', @del_cmd = N'CALL [sp_MSdel_dbotblWebEventsOverride]', @upd_cmd = N'SCALL [sp_MSupd_dbotblWebEventsOverride]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblWebMobileUser', @source_owner = N'dbo', @source_object = N'tblWebMobileUser', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblWebMobileUser', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblWebMobileUser]', @del_cmd = N'CALL [sp_MSdel_dbotblWebMobileUser]', @upd_cmd = N'SCALL [sp_MSupd_dbotblWebMobileUser]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblWebNotification', @source_owner = N'dbo', @source_object = N'tblWebNotification', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblWebNotification', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblWebNotification]', @del_cmd = N'CALL [sp_MSdel_dbotblWebNotification]', @upd_cmd = N'SCALL [sp_MSupd_dbotblWebNotification]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblWebNotifyReason', @source_owner = N'dbo', @source_object = N'tblWebNotifyReason', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblWebNotifyReason', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblWebNotifyReason]', @del_cmd = N'CALL [sp_MSdel_dbotblWebNotifyReason]', @upd_cmd = N'SCALL [sp_MSupd_dbotblWebNotifyReason]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblWebPasswordHistory', @source_owner = N'dbo', @source_object = N'tblWebPasswordHistory', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblWebPasswordHistory', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblWebPasswordHistory]', @del_cmd = N'CALL [sp_MSdel_dbotblWebPasswordHistory]', @upd_cmd = N'SCALL [sp_MSupd_dbotblWebPasswordHistory]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblWebQRConfig', @source_owner = N'dbo', @source_object = N'tblWebQRConfig', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblWebQRConfig', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblWebQRConfig]', @del_cmd = N'CALL [sp_MSdel_dbotblWebQRConfig]', @upd_cmd = N'SCALL [sp_MSupd_dbotblWebQRConfig]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblWebQRRequest', @source_owner = N'dbo', @source_object = N'tblWebQRRequest', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblWebQRRequest', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblWebQRRequest]', @del_cmd = N'CALL [sp_MSdel_dbotblWebQRRequest]', @upd_cmd = N'SCALL [sp_MSupd_dbotblWebQRRequest]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblWebQueues', @source_owner = N'dbo', @source_object = N'tblWebQueues', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblWebQueues', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblWebQueues]', @del_cmd = N'CALL [sp_MSdel_dbotblWebQueues]', @upd_cmd = N'SCALL [sp_MSupd_dbotblWebQueues]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblWebQueuesV2', @source_owner = N'dbo', @source_object = N'tblWebQueuesV2', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblWebQueuesV2', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblWebQueuesV2]', @del_cmd = N'CALL [sp_MSdel_dbotblWebQueuesV2]', @upd_cmd = N'SCALL [sp_MSupd_dbotblWebQueuesV2]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblWebReferral', @source_owner = N'dbo', @source_object = N'tblWebReferral', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblWebReferral', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblWebReferral]', @del_cmd = N'CALL [sp_MSdel_dbotblWebReferral]', @upd_cmd = N'SCALL [sp_MSupd_dbotblWebReferral]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblWebReferralForm', @source_owner = N'dbo', @source_object = N'tblWebReferralForm', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblWebReferralForm', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblWebReferralForm]', @del_cmd = N'CALL [sp_MSdel_dbotblWebReferralForm]', @upd_cmd = N'SCALL [sp_MSupd_dbotblWebReferralForm]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblWebReferralFormProblem', @source_owner = N'dbo', @source_object = N'tblWebReferralFormProblem', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblWebReferralFormProblem', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblWebReferralFormProblem]', @del_cmd = N'CALL [sp_MSdel_dbotblWebReferralFormProblem]', @upd_cmd = N'SCALL [sp_MSupd_dbotblWebReferralFormProblem]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblWebReferralFormRule', @source_owner = N'dbo', @source_object = N'tblWebReferralFormRule', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblWebReferralFormRule', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblWebReferralFormRule]', @del_cmd = N'CALL [sp_MSdel_dbotblWebReferralFormRule]', @upd_cmd = N'SCALL [sp_MSupd_dbotblWebReferralFormRule]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblWebReferralFormSpecialty', @source_owner = N'dbo', @source_object = N'tblWebReferralFormSpecialty', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblWebReferralFormSpecialty', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblWebReferralFormSpecialty]', @del_cmd = N'CALL [sp_MSdel_dbotblWebReferralFormSpecialty]', @upd_cmd = N'SCALL [sp_MSupd_dbotblWebReferralFormSpecialty]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblWebUser', @source_owner = N'dbo', @source_object = N'tblWebUser', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblWebUser', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblWebUser]', @del_cmd = N'CALL [sp_MSdel_dbotblWebUser]', @upd_cmd = N'SCALL [sp_MSupd_dbotblWebUser]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblWebUserAccount', @source_owner = N'dbo', @source_object = N'tblWebUserAccount', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblWebUserAccount', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblWebUserAccount]', @del_cmd = N'CALL [sp_MSdel_dbotblWebUserAccount]', @upd_cmd = N'SCALL [sp_MSupd_dbotblWebUserAccount]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblWebUserChangeRequest', @source_owner = N'dbo', @source_object = N'tblWebUserChangeRequest', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblWebUserChangeRequest', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblWebUserChangeRequest]', @del_cmd = N'CALL [sp_MSdel_dbotblWebUserChangeRequest]', @upd_cmd = N'SCALL [sp_MSupd_dbotblWebUserChangeRequest]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblWebUserStatus', @source_owner = N'dbo', @source_object = N'tblWebUserStatus', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'tblWebUserStatus', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblWebUserStatus]', @del_cmd = N'CALL [sp_MSdel_dbotblWebUserStatus]', @upd_cmd = N'SCALL [sp_MSupd_dbotblWebUserStatus]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblWorkstation', @source_owner = N'dbo', @source_object = N'tblWorkstation', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblWorkstation', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblWorkstation]', @del_cmd = N'CALL [sp_MSdel_dbotblWorkstation]', @upd_cmd = N'SCALL [sp_MSupd_dbotblWorkstation]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'tblZipCode', @source_owner = N'dbo', @source_object = N'tblZipCode', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'tblZipCode', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbotblZipCode]', @del_cmd = N'CALL [sp_MSdel_dbotblZipCode]', @upd_cmd = N'SCALL [sp_MSupd_dbotblZipCode]'
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vw_EDIFileAttachments', @source_owner = N'dbo', @source_object = N'vw_EDIFileAttachments', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vw_EDIFileAttachments', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vw_WebCaseSummary', @source_owner = N'dbo', @source_object = N'vw_WebCaseSummary', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vw_WebCaseSummary', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vw_WebCaseSummaryExt', @source_owner = N'dbo', @source_object = N'vw_WebCaseSummaryExt', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vw_WebCaseSummaryExt', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vw_WebCoverLetterInfo', @source_owner = N'dbo', @source_object = N'vw_WebCoverLetterInfo', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vw_WebCoverLetterInfo', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vw30DaySchedule', @source_owner = N'dbo', @source_object = N'vw30DaySchedule', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vw30DaySchedule', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwAbetonCompanyFees', @source_owner = N'dbo', @source_object = N'vwAbetonCompanyFees', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwAbetonCompanyFees', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwAbetonProviderFees', @source_owner = N'dbo', @source_object = N'vwAbetonProviderFees', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwAbetonProviderFees', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwAcctDocuments', @source_owner = N'dbo', @source_object = N'vwAcctDocuments', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwAcctDocuments', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwacctexception', @source_owner = N'dbo', @source_object = N'vwacctexception', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwacctexception', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwAcctingParam', @source_owner = N'dbo', @source_object = N'vwAcctingParam', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwAcctingParam', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwAcctingSummary', @source_owner = N'dbo', @source_object = N'vwAcctingSummary', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwAcctingSummary', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwAcctMonitorDetail', @source_owner = N'dbo', @source_object = N'vwAcctMonitorDetail', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwAcctMonitorDetail', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwAcctRegisterTax', @source_owner = N'dbo', @source_object = N'vwAcctRegisterTax', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwAcctRegisterTax', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwApptHoldRpt', @source_owner = N'dbo', @source_object = N'vwApptHoldRpt', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwApptHoldRpt', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwApptLog', @source_owner = N'dbo', @source_object = N'vwApptLog', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwApptLog', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwApptLogByAppt', @source_owner = N'dbo', @source_object = N'vwApptLogByAppt', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwApptLogByAppt', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwApptLogByApptDocs', @source_owner = N'dbo', @source_object = N'vwApptLogByApptDocs', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwApptLogByApptDocs', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwApptLogDocs', @source_owner = N'dbo', @source_object = N'vwApptLogDocs', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwApptLogDocs', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwApptsByMth', @source_owner = N'dbo', @source_object = N'vwApptsByMth', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwApptsByMth', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwAssocCases', @source_owner = N'dbo', @source_object = N'vwAssocCases', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwAssocCases', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwCancelAppt', @source_owner = N'dbo', @source_object = N'vwCancelAppt', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwCancelAppt', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwCase', @source_owner = N'dbo', @source_object = N'vwCase', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwCase', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwCaseAppt', @source_owner = N'dbo', @source_object = N'vwCaseAppt', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwCaseAppt', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwCaseCC', @source_owner = N'dbo', @source_object = N'vwCaseCC', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwCaseCC', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwCaseDocMailEntities', @source_owner = N'dbo', @source_object = N'vwCaseDocMailEntities', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwCaseDocMailEntities', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwCaseDocuments', @source_owner = N'dbo', @source_object = N'vwCaseDocuments', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwCaseDocuments', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwCaseHistoryFollowUp', @source_owner = N'dbo', @source_object = N'vwCaseHistoryFollowUp', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwCaseHistoryFollowUp', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwcaseissue', @source_owner = N'dbo', @source_object = N'vwcaseissue', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwcaseissue', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwCaseMonitorDetail', @source_owner = N'dbo', @source_object = N'vwCaseMonitorDetail', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwCaseMonitorDetail', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwcaseopenservices', @source_owner = N'dbo', @source_object = N'vwcaseopenservices', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwcaseopenservices', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwCaseOtherContacts', @source_owner = N'dbo', @source_object = N'vwCaseOtherContacts', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwCaseOtherContacts', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwcaseOtherParty', @source_owner = N'dbo', @source_object = N'vwcaseOtherParty', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwcaseOtherParty', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwCasePanel', @source_owner = N'dbo', @source_object = N'vwCasePanel', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwCasePanel', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwCaseProblem', @source_owner = N'dbo', @source_object = N'vwCaseProblem', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwCaseProblem', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwCaseReExam', @source_owner = N'dbo', @source_object = N'vwCaseReExam', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwCaseReExam', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwCaseReports', @source_owner = N'dbo', @source_object = N'vwCaseReports', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwCaseReports', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwcaseservices', @source_owner = N'dbo', @source_object = N'vwcaseservices', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwcaseservices', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwCaseSummary', @source_owner = N'dbo', @source_object = N'vwCaseSummary', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwCaseSummary', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwCaseSummaryWithSecurity', @source_owner = N'dbo', @source_object = N'vwCaseSummaryWithSecurity', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwCaseSummaryWithSecurity', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwCaseTrans', @source_owner = N'dbo', @source_object = N'vwCaseTrans', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwCaseTrans', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwCCExport', @source_owner = N'dbo', @source_object = N'vwCCExport', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwCCExport', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwCCs', @source_owner = N'dbo', @source_object = N'vwCCs', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwCCs', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwCertifiedMailCases', @source_owner = N'dbo', @source_object = N'vwCertifiedMailCases', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwCertifiedMailCases', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwClaimNbrCheck', @source_owner = N'dbo', @source_object = N'vwClaimNbrCheck', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwClaimNbrCheck', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwclient', @source_owner = N'dbo', @source_object = N'vwclient', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwclient', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwClientDefaults', @source_owner = N'dbo', @source_object = N'vwClientDefaults', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwClientDefaults', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwClientExport', @source_owner = N'dbo', @source_object = N'vwClientExport', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwClientExport', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwClientExportColumns', @source_owner = N'dbo', @source_object = N'vwClientExportColumns', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwClientExportColumns', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwClientWebAcct', @source_owner = N'dbo', @source_object = N'vwClientWebAcct', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwClientWebAcct', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwConfirmationResultsReport', @source_owner = N'dbo', @source_object = N'vwConfirmationResultsReport', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwConfirmationResultsReport', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwDoctorDocument', @source_owner = N'dbo', @source_object = N'vwDoctorDocument', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwDoctorDocument', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwDoctorExport', @source_owner = N'dbo', @source_object = N'vwDoctorExport', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwDoctorExport', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwDoctorExportColumns', @source_owner = N'dbo', @source_object = N'vwDoctorExportColumns', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwDoctorExportColumns', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwDoctorFeeSchedule', @source_owner = N'dbo', @source_object = N'vwDoctorFeeSchedule', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwDoctorFeeSchedule', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwDoctorKeyword', @source_owner = N'dbo', @source_object = N'vwDoctorKeyword', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwDoctorKeyword', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwDoctorSchedule', @source_owner = N'dbo', @source_object = N'vwDoctorSchedule', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwDoctorSchedule', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwDoctorScheduleSummary', @source_owner = N'dbo', @source_object = N'vwDoctorScheduleSummary', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwDoctorScheduleSummary', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwDoctorSearchResult', @source_owner = N'dbo', @source_object = N'vwDoctorSearchResult', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwDoctorSearchResult', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwDocument', @source_owner = N'dbo', @source_object = N'vwDocument', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwDocument', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwDocumentAccting', @source_owner = N'dbo', @source_object = N'vwDocumentAccting', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwDocumentAccting', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwDPSCases', @source_owner = N'dbo', @source_object = N'vwDPSCases', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwDPSCases', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwdrschedule', @source_owner = N'dbo', @source_object = N'vwdrschedule', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwdrschedule', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwEDIExportSummary', @source_owner = N'dbo', @source_object = N'vwEDIExportSummary', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwEDIExportSummary', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwExamineeCases', @source_owner = N'dbo', @source_object = N'vwExamineeCases', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwExamineeCases', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwExamineeRecordHistory', @source_owner = N'dbo', @source_object = N'vwExamineeRecordHistory', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwExamineeRecordHistory', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwExceptionDefinitionListing', @source_owner = N'dbo', @source_object = N'vwExceptionDefinitionListing', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwExceptionDefinitionListing', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwExportSummary', @source_owner = N'dbo', @source_object = N'vwExportSummary', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwExportSummary', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwFeeDetail', @source_owner = N'dbo', @source_object = N'vwFeeDetail', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwFeeDetail', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwFeeDetailAbeton', @source_owner = N'dbo', @source_object = N'vwFeeDetailAbeton', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwFeeDetailAbeton', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwfees', @source_owner = N'dbo', @source_object = N'vwfees', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwfees', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwFeeScheduleRpt', @source_owner = N'dbo', @source_object = N'vwFeeScheduleRpt', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwFeeScheduleRpt', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwFileManagerAttachedDocument', @source_owner = N'dbo', @source_object = N'vwFileManagerAttachedDocument', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwFileManagerAttachedDocument', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwIMOLateCancel', @source_owner = N'dbo', @source_object = N'vwIMOLateCancel', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwIMOLateCancel', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwInvoiceAttachmentGuidance', @source_owner = N'dbo', @source_object = N'vwInvoiceAttachmentGuidance', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwInvoiceAttachmentGuidance', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwInvoiceDetailsView', @source_owner = N'dbo', @source_object = N'vwInvoiceDetailsView', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwInvoiceDetailsView', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwInvoiceView', @source_owner = N'dbo', @source_object = N'vwInvoiceView', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwInvoiceView', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwLibertyExport', @source_owner = N'dbo', @source_object = N'vwLibertyExport', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwLibertyExport', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwMatrixClientExport', @source_owner = N'dbo', @source_object = N'vwMatrixClientExport', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwMatrixClientExport', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwMatrixTDExport', @source_owner = N'dbo', @source_object = N'vwMatrixTDExport', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwMatrixTDExport', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwNotaryApproval', @source_owner = N'dbo', @source_object = N'vwNotaryApproval', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwNotaryApproval', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwopendrschedule', @source_owner = N'dbo', @source_object = N'vwopendrschedule', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwopendrschedule', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwPatientCCs', @source_owner = N'dbo', @source_object = N'vwPatientCCs', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwPatientCCs', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwPDFCaseData', @source_owner = N'dbo', @source_object = N'vwPDFCaseData', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwPDFCaseData', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwPDFDoctorData', @source_owner = N'dbo', @source_object = N'vwPDFDoctorData', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwPDFDoctorData', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwPDFInvData', @source_owner = N'dbo', @source_object = N'vwPDFInvData', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwPDFInvData', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwPDFInvDetData', @source_owner = N'dbo', @source_object = N'vwPDFInvDetData', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwPDFInvDetData', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwPDFLocationData', @source_owner = N'dbo', @source_object = N'vwPDFLocationData', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwPDFLocationData', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwPDFOverride', @source_owner = N'dbo', @source_object = N'vwPDFOverride', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwPDFOverride', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwPDFStaticData', @source_owner = N'dbo', @source_object = N'vwPDFStaticData', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwPDFStaticData', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwprofit', @source_owner = N'dbo', @source_object = N'vwprofit', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwprofit', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwProfitDocs', @source_owner = N'dbo', @source_object = N'vwProfitDocs', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwProfitDocs', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwQuoteApproval', @source_owner = N'dbo', @source_object = N'vwQuoteApproval', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwQuoteApproval', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwRecordsToInvoice', @source_owner = N'dbo', @source_object = N'vwRecordsToInvoice', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwRecordsToInvoice', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwReferralbyMonthAppt', @source_owner = N'dbo', @source_object = N'vwReferralbyMonthAppt', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwReferralbyMonthAppt', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwReferralbyMonthApptDocs', @source_owner = N'dbo', @source_object = N'vwReferralbyMonthApptDocs', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwReferralbyMonthApptDocs', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwReferralbyMonthDateReceived', @source_owner = N'dbo', @source_object = N'vwReferralbyMonthDateReceived', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwReferralbyMonthDateReceived', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwReferralbyMonthDateReceivedDocs', @source_owner = N'dbo', @source_object = N'vwReferralbyMonthDateReceivedDocs', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwReferralbyMonthDateReceivedDocs', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwRegister', @source_owner = N'dbo', @source_object = N'vwRegister', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwRegister', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwRegisterTotal', @source_owner = N'dbo', @source_object = N'vwRegisterTotal', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwRegisterTotal', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwReportTATRpt', @source_owner = N'dbo', @source_object = N'vwReportTATRpt', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwReportTATRpt', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwReportTATRptDocs', @source_owner = N'dbo', @source_object = N'vwReportTATRptDocs', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwReportTATRptDocs', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwRptCancelDetail', @source_owner = N'dbo', @source_object = N'vwRptCancelDetail', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwRptCancelDetail', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwRptCancelDetailDocs', @source_owner = N'dbo', @source_object = N'vwRptCancelDetailDocs', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwRptCancelDetailDocs', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwRptDaySheet', @source_owner = N'dbo', @source_object = N'vwRptDaySheet', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwRptDaySheet', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwRptDoctorScheduleDoctor', @source_owner = N'dbo', @source_object = N'vwRptDoctorScheduleDoctor', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwRptDoctorScheduleDoctor', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwRptDoctorScheduleLocation', @source_owner = N'dbo', @source_object = N'vwRptDoctorScheduleLocation', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwRptDoctorScheduleLocation', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwRptDoctorScheduleLocationDoctor', @source_owner = N'dbo', @source_object = N'vwRptDoctorScheduleLocationDoctor', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwRptDoctorScheduleLocationDoctor', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwRptMEIDoctorSchedulebyDoctor', @source_owner = N'dbo', @source_object = N'vwRptMEIDoctorSchedulebyDoctor', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwRptMEIDoctorSchedulebyDoctor', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwRptMEIDoctorSchedulebyLocation', @source_owner = N'dbo', @source_object = N'vwRptMEIDoctorSchedulebyLocation', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwRptMEIDoctorSchedulebyLocation', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwRptMEINotification', @source_owner = N'dbo', @source_object = N'vwRptMEINotification', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwRptMEINotification', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwRptNoShowDetail', @source_owner = N'dbo', @source_object = N'vwRptNoShowDetail', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwRptNoShowDetail', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwRptNoShowDetailDocs', @source_owner = N'dbo', @source_object = N'vwRptNoShowDetailDocs', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwRptNoShowDetailDocs', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwRptOutstandingAuthorizations', @source_owner = N'dbo', @source_object = N'vwRptOutstandingAuthorizations', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwRptOutstandingAuthorizations', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwRptOutstandingRecords', @source_owner = N'dbo', @source_object = N'vwRptOutstandingRecords', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwRptOutstandingRecords', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwRptProgressiveClosedCaseSummary', @source_owner = N'dbo', @source_object = N'vwRptProgressiveClosedCaseSummary', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwRptProgressiveClosedCaseSummary', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwRptProgressiveIMESummary', @source_owner = N'dbo', @source_object = N'vwRptProgressiveIMESummary', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwRptProgressiveIMESummary', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwRptProgressivePeerBills', @source_owner = N'dbo', @source_object = N'vwRptProgressivePeerBills', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwRptProgressivePeerBills', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwRptProgressivePeerSummary', @source_owner = N'dbo', @source_object = N'vwRptProgressivePeerSummary', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwRptProgressivePeerSummary', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwRptProgressiveReExam', @source_owner = N'dbo', @source_object = N'vwRptProgressiveReExam', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwRptProgressiveReExam', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwRptProgressiveReferral', @source_owner = N'dbo', @source_object = N'vwRptProgressiveReferral', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwRptProgressiveReferral', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwRptProgressiveRptWebLog', @source_owner = N'dbo', @source_object = N'vwRptProgressiveRptWebLog', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwRptProgressiveRptWebLog', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwRptProgressiveUpcomingAppt', @source_owner = N'dbo', @source_object = N'vwRptProgressiveUpcomingAppt', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwRptProgressiveUpcomingAppt', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwScheduleViewer', @source_owner = N'dbo', @source_object = N'vwScheduleViewer', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwScheduleViewer', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwServiceWorkflow', @source_owner = N'dbo', @source_object = N'vwServiceWorkflow', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwServiceWorkflow', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwServiceWorkflowQueue', @source_owner = N'dbo', @source_object = N'vwServiceWorkflowQueue', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwServiceWorkflowQueue', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwServiceWorkflowQueueDocument', @source_owner = N'dbo', @source_object = N'vwServiceWorkflowQueueDocument', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwServiceWorkflowQueueDocument', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwSLURequirementDetails_Verizon', @source_owner = N'dbo', @source_object = N'vwSLURequirementDetails_Verizon', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwSLURequirementDetails_Verizon', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwspecialservices', @source_owner = N'dbo', @source_object = N'vwspecialservices', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwspecialservices', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwStatusAppt', @source_owner = N'dbo', @source_object = N'vwStatusAppt', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwStatusAppt', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwStatusNew', @source_owner = N'dbo', @source_object = N'vwStatusNew', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwStatusNew', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwTranscriptionTracker', @source_owner = N'dbo', @source_object = N'vwTranscriptionTracker', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwTranscriptionTracker', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwUpdateLastStatus', @source_owner = N'dbo', @source_object = N'vwUpdateLastStatus', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwUpdateLastStatus', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwUserSecurity', @source_owner = N'dbo', @source_object = N'vwUserSecurity', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwUserSecurity', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwVoucherSelect', @source_owner = N'dbo', @source_object = N'vwVoucherSelect', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwVoucherSelect', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'vwWALI', @source_owner = N'dbo', @source_object = N'vwWALI', @type = N'view schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'vwWALI', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'web_GetCaseDocumentPath', @source_owner = N'dbo', @source_object = N'web_GetCaseDocumentPath', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'web_GetCaseDocumentPath', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'web_GetCaseDocumentPathExisting', @source_owner = N'dbo', @source_object = N'web_GetCaseDocumentPathExisting', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'web_GetCaseDocumentPathExisting', @destination_owner = N'dbo', @status = 16
GO
use [IMECentricEW]
exec sp_addarticle @publication = N'IMECentricEW', @article = N'web_GetTransJobDocumentPath', @source_owner = N'dbo', @source_object = N'web_GetTransJobDocumentPath', @type = N'proc schema only', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x0000000008000001, @destination_table = N'web_GetTransJobDocumentPath', @destination_owner = N'dbo', @status = 16
GO

-- Adding the transactional subscriptions
use [IMECentricEW]
exec sp_addsubscription @publication = N'IMECentricEW', @subscriber = N'PRODBETLSQL01', @destination_db = N'IMECentricEW', @subscription_type = N'Push', @sync_type = N'automatic', @article = N'all', @update_mode = N'read only', @subscriber_type = 0
exec sp_addpushsubscription_agent @publication = N'IMECentricEW', @subscriber = N'PRODBETLSQL01', @subscriber_db = N'IMECentricEW', @job_login = N'DOMAIN\SQL_IMEC_Replication', @job_password = N'$qLiM3cR3p', @subscriber_security_mode = 1, @frequency_type = 64, @frequency_interval = 1, @frequency_relative_interval = 1, @frequency_recurrence_factor = 0, @frequency_subday = 4, @frequency_subday_interval = 5, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 0, @active_end_date = 0, @dts_package_location = N'Distributor'
GO

