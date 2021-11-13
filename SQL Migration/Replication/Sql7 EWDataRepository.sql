-- Enabling the replication database
use master
exec sp_replicationdboption @dbname = N'EWDataRepository', @optname = N'publish', @value = N'true'
GO

exec [EWDataRepository].sys.sp_addlogreader_agent @job_login = N'domain\sql_imec_replication', @job_password = N'$qLiM3cR3p', @publisher_security_mode = 1
GO
-- Adding the transactional publication
use [EWDataRepository]
exec sp_addpublication @publication = N'EWDataRepository', @description = N'Transactional publication of database ''EWDataRepository'' from Publisher ''SqlServer7\EW_IME_CENTRIC''.', @sync_method = N'concurrent', @retention = 0, @allow_push = N'true', @allow_pull = N'true', @allow_anonymous = N'true', @enabled_for_internet = N'false', @snapshot_in_defaultfolder = N'true', @compress_snapshot = N'false', @ftp_port = 21, @ftp_login = N'anonymous', @allow_subscription_copy = N'false', @add_to_active_directory = N'false', @repl_freq = N'continuous', @status = N'active', @independent_agent = N'true', @immediate_sync = N'true', @allow_sync_tran = N'false', @autogen_sync_procs = N'false', @allow_queued_tran = N'false', @allow_dts = N'false', @replicate_ddl = 1, @allow_initialize_from_backup = N'false', @enabled_for_p2p = N'false', @enabled_for_het_sub = N'false'
GO


exec sp_addpublication_snapshot @publication = N'EWDataRepository', @frequency_type = 1, @frequency_interval = 0, @frequency_relative_interval = 0, @frequency_recurrence_factor = 0, @frequency_subday = 0, @frequency_subday_interval = 0, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 0, @active_end_date = 0, @job_login = N'domain\sql_imec_replication', @job_password = N'$qLiM3cR3p', @publisher_security_mode = 1
GO

exec sp_grant_publication_access @publication = N'EWDataRepository', @login = N'sa'
GO
exec sp_grant_publication_access @publication = N'EWDataRepository', @login = N'NT SERVICE\SQLWriter'
GO
exec sp_grant_publication_access @publication = N'EWDataRepository', @login = N'NT SERVICE\Winmgmt'
GO
exec sp_grant_publication_access @publication = N'EWDataRepository', @login = N'NT Service\MSSQL$EW_IME_CENTRIC'
GO
exec sp_grant_publication_access @publication = N'EWDataRepository', @login = N'NT SERVICE\SQLAgent$EW_IME_CENTRIC'
GO
exec sp_grant_publication_access @publication = N'EWDataRepository', @login = N'sys-admin'
GO
exec sp_grant_publication_access @publication = N'EWDataRepository', @login = N'imeCentric'
GO
exec sp_grant_publication_access @publication = N'EWDataRepository', @login = N'DOMAIN\commvault.sqlservice'
GO
exec sp_grant_publication_access @publication = N'EWDataRepository', @login = N'DOMAIN\SQLSentry'
GO
exec sp_grant_publication_access @publication = N'EWDataRepository', @login = N'EW\ISEWIS-DL'
GO
exec sp_grant_publication_access @publication = N'EWDataRepository', @login = N'DOMAIN\EWIntegrationServer'
GO
exec sp_grant_publication_access @publication = N'EWDataRepository', @login = N'EW\ISSQLAdmin-DL'
GO
exec sp_grant_publication_access @publication = N'EWDataRepository', @login = N'distributor_admin'
GO
exec sp_grant_publication_access @publication = N'EWDataRepository', @login = N'DOMAIN\SQL_IMEC_Replication'
GO

-- Adding the transactional articles
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'AcctAdjustment', @source_owner = N'dbo', @source_object = N'AcctAdjustment', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'AcctAdjustment', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboAcctAdjustment]', @del_cmd = N'CALL [sp_MSdel_dboAcctAdjustment]', @upd_cmd = N'SCALL [sp_MSupd_dboAcctAdjustment]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'AcctDetail', @source_owner = N'dbo', @source_object = N'AcctDetail', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'AcctDetail', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboAcctDetail]', @del_cmd = N'CALL [sp_MSdel_dboAcctDetail]', @upd_cmd = N'SCALL [sp_MSupd_dboAcctDetail]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'AcctEDIStatus', @source_owner = N'dbo', @source_object = N'AcctEDIStatus', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'AcctEDIStatus', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboAcctEDIStatus]', @del_cmd = N'CALL [sp_MSdel_dboAcctEDIStatus]', @upd_cmd = N'SCALL [sp_MSupd_dboAcctEDIStatus]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'AcctHeader', @source_owner = N'dbo', @source_object = N'AcctHeader', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'AcctHeader', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboAcctHeader]', @del_cmd = N'CALL [sp_MSdel_dboAcctHeader]', @upd_cmd = N'SCALL [sp_MSupd_dboAcctHeader]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'AcctManualPayment', @source_owner = N'dbo', @source_object = N'AcctManualPayment', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'AcctManualPayment', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboAcctManualPayment]', @del_cmd = N'CALL [sp_MSdel_dboAcctManualPayment]', @upd_cmd = N'SCALL [sp_MSupd_dboAcctManualPayment]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'Client', @source_owner = N'dbo', @source_object = N'Client', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'Client', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboClient]', @del_cmd = N'CALL [sp_MSdel_dboClient]', @upd_cmd = N'SCALL [sp_MSupd_dboClient]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'Company', @source_owner = N'dbo', @source_object = N'Company', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'Company', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboCompany]', @del_cmd = N'CALL [sp_MSdel_dboCompany]', @upd_cmd = N'SCALL [sp_MSupd_dboCompany]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'Doctor', @source_owner = N'dbo', @source_object = N'Doctor', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'Doctor', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboDoctor]', @del_cmd = N'CALL [sp_MSdel_dboDoctor]', @upd_cmd = N'SCALL [sp_MSupd_dboDoctor]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'EWBusLine', @source_owner = N'dbo', @source_object = N'EWBusLine', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'EWBusLine', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboEWBusLine]', @del_cmd = N'CALL [sp_MSdel_dboEWBusLine]', @upd_cmd = N'SCALL [sp_MSupd_dboEWBusLine]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'EWCompanyType', @source_owner = N'dbo', @source_object = N'EWCompanyType', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'EWCompanyType', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboEWCompanyType]', @del_cmd = N'CALL [sp_MSdel_dboEWCompanyType]', @upd_cmd = N'SCALL [sp_MSupd_dboEWCompanyType]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'EWDRFlashMapping', @source_owner = N'dbo', @source_object = N'EWDRFlashMapping', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'EWDRFlashMapping', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboEWDRFlashMapping]', @del_cmd = N'CALL [sp_MSdel_dboEWDRFlashMapping]', @upd_cmd = N'SCALL [sp_MSupd_dboEWDRFlashMapping]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'EWFacility', @source_owner = N'dbo', @source_object = N'EWFacility', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'EWFacility', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboEWFacility]', @del_cmd = N'CALL [sp_MSdel_dboEWFacility]', @upd_cmd = N'SCALL [sp_MSupd_dboEWFacility]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'EWFacilityGroup', @source_owner = N'dbo', @source_object = N'EWFacilityGroup', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'EWFacilityGroup', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboEWFacilityGroup]', @del_cmd = N'CALL [sp_MSdel_dboEWFacilityGroup]', @upd_cmd = N'SCALL [sp_MSupd_dboEWFacilityGroup]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'EWFacilityGroupCategory', @source_owner = N'dbo', @source_object = N'EWFacilityGroupCategory', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'EWFacilityGroupCategory', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboEWFacilityGroupCategory]', @del_cmd = N'CALL [sp_MSdel_dboEWFacilityGroupCategory]', @upd_cmd = N'SCALL [sp_MSupd_dboEWFacilityGroupCategory]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'EWFacilityGroupDetail', @source_owner = N'dbo', @source_object = N'EWFacilityGroupDetail', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'EWFacilityGroupDetail', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboEWFacilityGroupDetail]', @del_cmd = N'CALL [sp_MSdel_dboEWFacilityGroupDetail]', @upd_cmd = N'SCALL [sp_MSupd_dboEWFacilityGroupDetail]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'EWFacilityGroupSummary', @source_owner = N'dbo', @source_object = N'EWFacilityGroupSummary', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'EWFacilityGroupSummary', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboEWFacilityGroupSummary]', @del_cmd = N'CALL [sp_MSdel_dboEWFacilityGroupSummary]', @upd_cmd = N'SCALL [sp_MSupd_dboEWFacilityGroupSummary]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'EWFeeZone', @source_owner = N'dbo', @source_object = N'EWFeeZone', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'EWFeeZone', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboEWFeeZone]', @del_cmd = N'CALL [sp_MSdel_dboEWFeeZone]', @upd_cmd = N'SCALL [sp_MSupd_dboEWFeeZone]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'EWFlashCategory', @source_owner = N'dbo', @source_object = N'EWFlashCategory', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'EWFlashCategory', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboEWFlashCategory]', @del_cmd = N'CALL [sp_MSdel_dboEWFlashCategory]', @upd_cmd = N'SCALL [sp_MSupd_dboEWFlashCategory]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'EWGLAcct', @source_owner = N'dbo', @source_object = N'EWGLAcct', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'EWGLAcct', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboEWGLAcct]', @del_cmd = N'CALL [sp_MSdel_dboEWGLAcct]', @upd_cmd = N'SCALL [sp_MSupd_dboEWGLAcct]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'EWGLAcctCategory', @source_owner = N'dbo', @source_object = N'EWGLAcctCategory', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'EWGLAcctCategory', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboEWGLAcctCategory]', @del_cmd = N'CALL [sp_MSdel_dboEWGLAcctCategory]', @upd_cmd = N'SCALL [sp_MSupd_dboEWGLAcctCategory]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'EWLocation', @source_owner = N'dbo', @source_object = N'EWLocation', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'EWLocation', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboEWLocation]', @del_cmd = N'CALL [sp_MSdel_dboEWLocation]', @upd_cmd = N'SCALL [sp_MSupd_dboEWLocation]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'EWParentCompany', @source_owner = N'dbo', @source_object = N'EWParentCompany', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'EWParentCompany', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboEWParentCompany]', @del_cmd = N'CALL [sp_MSdel_dboEWParentCompany]', @upd_cmd = N'SCALL [sp_MSupd_dboEWParentCompany]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'EWServiceType', @source_owner = N'dbo', @source_object = N'EWServiceType', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'EWServiceType', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboEWServiceType]', @del_cmd = N'CALL [sp_MSdel_dboEWServiceType]', @upd_cmd = N'SCALL [sp_MSupd_dboEWServiceType]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'Source', @source_owner = N'dbo', @source_object = N'Source', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'none', @destination_table = N'Source', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboSource]', @del_cmd = N'CALL [sp_MSdel_dboSource]', @upd_cmd = N'SCALL [sp_MSupd_dboSource]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'sysdiagrams', @source_owner = N'dbo', @source_object = N'sysdiagrams', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'sysdiagrams', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dbosysdiagrams]', @del_cmd = N'CALL [sp_MSdel_dbosysdiagrams]', @upd_cmd = N'SCALL [sp_MSupd_dbosysdiagrams]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'TempVendorVoucher', @source_owner = N'dbo', @source_object = N'TempVendorVoucher', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'TempVendorVoucher', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboTempVendorVoucher]', @del_cmd = N'CALL [sp_MSdel_dboTempVendorVoucher]', @upd_cmd = N'SCALL [sp_MSupd_dboTempVendorVoucher]'
GO
use [EWDataRepository]
exec sp_addarticle @publication = N'EWDataRepository', @article = N'VendorCheckRequest', @source_owner = N'dbo', @source_object = N'VendorCheckRequest', @type = N'logbased', @description = N'', @creation_script = N'', @pre_creation_cmd = N'drop', @schema_option = 0x00000000080350DF, @identityrangemanagementoption = N'manual', @destination_table = N'VendorCheckRequest', @destination_owner = N'dbo', @status = 24, @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboVendorCheckRequest]', @del_cmd = N'CALL [sp_MSdel_dboVendorCheckRequest]', @upd_cmd = N'SCALL [sp_MSupd_dboVendorCheckRequest]'
GO

-- Adding the transactional subscriptions
use [EWDataRepository]
exec sp_addsubscription @publication = N'EWDataRepository', @subscriber = N'PRODBETLSQL01', @destination_db = N'EWDataRepository', @subscription_type = N'Push', @sync_type = N'automatic', @article = N'all', @update_mode = N'read only', @subscriber_type = 0
exec sp_addpushsubscription_agent @publication = N'EWDataRepository', @subscriber = N'PRODBETLSQL01', @subscriber_db = N'EWDataRepository', @job_login = N'domain\sql_imec_replication', @job_password = N'$qLiM3cR3p', @subscriber_security_mode = 1, @frequency_type = 64, @frequency_interval = 1, @frequency_relative_interval = 1, @frequency_recurrence_factor = 0, @frequency_subday = 4, @frequency_subday_interval = 5, @active_start_time_of_day = 0, @active_end_time_of_day = 235959, @active_start_date = 0, @active_end_date = 0, @dts_package_location = N'Distributor'
GO

