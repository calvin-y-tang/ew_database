-- -----------------------------------------------------------
--	Scripts in here are ONLY applied to IMECentricMaster
-- -----------------------------------------------------------
USE [IMECentricMaster]  -- DO NOT REMOVE
GO

-- Sprint 146

-- IMEC-14832 Update emails sent for ERP errors.
UPDATE ISExtIntegration WHERE [Type] = 'ERP'
SET NotifyEmail = "doug.troy@examworks.com;william.cecil@examworks.com;EWISLogs@examworks.com";

-- // =============================================================================================
-- // IMEC-14796 Allstar Report EWIS process
-- // Author: Sam Chiang
-- // =============================================================================================

merge into IMECentricMaster.dbo.ISSchedule as tar
using (
	select 'MSN Allstar Rpt IME' as [Name], 'XSFTP' as [Task], 'm' as [Type], 30 as [Interval], '0111110' as [WeekDays], '1900-01-01 08:00:00' as [Time], '2025-02-08 07:15:00' as [StartDate], '2025-02-08 07:15:00' as [RunTimeStart], 31 as GroupNo, 1 as SeqNo
) as src 
	on tar.[Name] = src.[Name] and tar.[Task] = src.[Task]
when not matched by target then
	insert ([Name], [Task], [Type], [Interval], [WeekDays], [Time], [StartDate], [RunTimeStart], [GroupNo], [SeqNo])
	values (src.[Name], src.[Task], src.[Type], src.[Interval], src.[WeekDays], src.[Time], src.[StartDate], src.[RunTimeStart], src.[GroupNo], src.[SeqNo])
;

merge into IMECentricMaster.dbo.ISSchedule as tar
using (
	select 'MSN Allstar Rpt PR' as [Name], 'XSFTP' as [Task], 'm' as [Type], 30 as [Interval], '0111110' as [WeekDays], '1900-01-01 08:00:00' as [Time], '2025-02-08 07:15:00' as [StartDate], '2025-02-08 07:15:00' as [RunTimeStart], 31 as GroupNo, 2 as SeqNo
) as src 
	on tar.[Name] = src.[Name] and tar.[Task] = src.[Task]
when not matched by target then
	insert ([Name], [Task], [Type], [Interval], [WeekDays], [Time], [StartDate], [RunTimeStart], [GroupNo], [SeqNo])
	values (src.[Name], src.[Task], src.[Type], src.[Interval], src.[WeekDays], src.[Time], src.[StartDate], src.[RunTimeStart], src.[GroupNo], src.[SeqNo])
;

merge into IMECentricMaster.dbo.ISSchedule as tar
using (
	select 'MSN Allstar Rpt REF' as [Name], 'XSFTP' as [Task], 'm' as [Type], 30 as [Interval], '0111110' as [WeekDays], '1900-01-01 08:00:00' as [Time], '2025-02-08 07:15:00' as [StartDate], '2025-02-08 07:15:00' as [RunTimeStart], 31 as GroupNo, 3 as SeqNo
) as src 
	on tar.[Name] = src.[Name] and tar.[Task] = src.[Task]
when not matched by target then
	insert ([Name], [Task], [Type], [Interval], [WeekDays], [Time], [StartDate], [RunTimeStart], [GroupNo], [SeqNo])
	values (src.[Name], src.[Task], src.[Type], src.[Interval], src.[WeekDays], src.[Time], src.[StartDate], src.[RunTimeStart], src.[GroupNo], src.[SeqNo])
;

merge into IMECentricMaster.dbo.ISSchedule as tar
using (
	select 'MSN Allstar Rpt IME_ADD' as [Name], 'XSFTP' as [Task], 'm' as [Type], 30 as [Interval], '0111110' as [WeekDays], '1900-01-01 08:00:00' as [Time], '2025-02-08 07:15:00' as [StartDate], '2025-02-08 07:15:00' as [RunTimeStart], 31 as GroupNo, 4 as SeqNo
) as src 
	on tar.[Name] = src.[Name] and tar.[Task] = src.[Task]
when not matched by target then
	insert ([Name], [Task], [Type], [Interval], [WeekDays], [Time], [StartDate], [RunTimeStart], [GroupNo], [SeqNo])
	values (src.[Name], src.[Task], src.[Type], src.[Interval], src.[WeekDays], src.[Time], src.[StartDate], src.[RunTimeStart], src.[GroupNo], src.[SeqNo])
;

merge into IMECentricMaster.dbo.ISSchedule as tar
using (
	select 'MSN Allstar Rpt PR_ADD' as [Name], 'XSFTP' as [Task], 'm' as [Type], 30 as [Interval], '0111110' as [WeekDays], '1900-01-01 08:00:00' as [Time], '2025-02-08 07:15:00' as [StartDate], '2025-02-08 07:15:00' as [RunTimeStart], 31 as GroupNo, 5 as SeqNo
) as src 
	on tar.[Name] = src.[Name] and tar.[Task] = src.[Task]
when not matched by target then
	insert ([Name], [Task], [Type], [Interval], [WeekDays], [Time], [StartDate], [RunTimeStart], [GroupNo], [SeqNo])
	values (src.[Name], src.[Task], src.[Type], src.[Interval], src.[WeekDays], src.[Time], src.[StartDate], src.[RunTimeStart], src.[GroupNo], src.[SeqNo])
;

-- // set params: Prod
update IMECentricMaster.dbo.ISSchedule
	set		
		param = concat(
		'Host=files.allstarmanagementny.com',
		';Port=44222',
		';Username=MedSourceN',
		';Password=RVbX?ECyu3a6',
		';Direction=Download',
		';SrcPath="/MedSourceN/' + (
			case 
			when [Name] like '% IME' then 'imes'
			when [Name] like '% PR' then 'peer_reviews'
			when [Name] like '% REF' then 'pr_references'
			when [Name] like '% IME_ADD' then 'ime_addendums'
			when [Name] like '% PR_ADD' then 'pr_addendums'
			else '' end
		)  + '/"',
		';DstPath="\\imecdocs5.ew.domain.local\ISIntegrations\External\AllstarReports\"',
		';Filename=*.*',
		';DeleteAfterCopy=False',
		';ExistingFileHandle=Overwrite',
		';AllOrNone=False',
		''
		)
	where 
		[Name] like 'MSN Allstar Rpt%' 
		and GroupNo = 31 
		and Task = 'XSFTP'
;

-- // =============================================================================================
-- // IMEC-14795 Black Car Fund EWIS process
-- // Author: Sam Chiang
-- // =============================================================================================

-- // create new record in ISSchedule for: Black Car Fund
merge into IMECentricMaster.dbo.ISSchedule as tar
using (
	select 'BCF Report Export' as [Name], 'XBlackCarFundReportExport' as [Task], 'D' as [Type], 1 as [Interval], '0111110' as [WeekDays], '1900-01-01 08:00:00' as [Time], '2025-02-08 08:00:00' as [StartDate], '2025-02-08 08:00:00' as [RunTimeStart]
) as src 
	on tar.[Name] = src.[Name] and tar.[Task] = src.[Task]
when not matched by target then
	insert ([Name], [Task], [Type], [Interval], [WeekDays], [Time], [StartDate], [RunTimeStart])
	values (src.[Name],src.[Task],src.[Type],src.[Interval],src.[WeekDays],src.[Time],src.[StartDate],src.[RunTimeStart])
;


-- // create new record in ISExtIntegration for: Black Car Fund
merge into IMECentricMaster.dbo.ISExtIntegration as tar
using (
	select 1110 as ExtIntegrationID, 'BCF Report Export' as [Name], 'XBlackCarFundReportExport' as [Type], convert(bit,1) as Active, '' as NotifyEmail, '' as [Param]
) as src 
	on tar.ExtIntegrationID = src.ExtIntegrationID and tar.[Type] = src.[Type]
when not matched by target then
	insert (ExtIntegrationID, [Name], [Type], Active, NotifyEmail, [Param])
	values (src.ExtIntegrationID, src.[Name], src.[Type], src.Active, src.NotifyEmail, src.[Param])
;


-- // set params: Prod
update IMECentricMaster.dbo.ISExtIntegration
	set
		NotifyEmail = 'sam.chiang@examworks.com',
		param = concat(
		'DBID=31',  -- // prod
		';NotificationEmail=sam.chiang@examworks.com',
		';NotificationEmailSubject=EWIS: Black Car Fund - Daily',
		';SQLFile=E:\EWIntegrationServer\SQLScripts\BCF_GetReportCases.sql',
		';SFTPUseSSHFile=true',
		';SFTPFolder=/imes',
		';SFTPHost=rmaprdsftp3.dxc-ins.com',
		';SFTPUser=RSKSFTP3029',
		';SFTPPwd=E:\EWIntegrationServer\SQLScripts\BCF_RSKSFTP3029_OpenSshKey',
		';SFTPPort=22',						
		''
		)
	where ExtIntegrationID = 1110 -- // prod
;


-- // =============================================================================================
-- // IMEC-14797 PMA Report Export EWIS process
-- // Author: Sam Chiang
-- // =============================================================================================

-- // create new record in ISSchedule for: PMA
merge into IMECentricMaster.dbo.ISSchedule as tar
using (
	select 'PMA Report Export' as [Name], 'XPMAReportExport' as [Task], 'D' as [Type], 1 as [Interval], '0111110' as [WeekDays], '1900-01-01 08:00:00' as [Time], '2025-02-08 23:00:00' as [StartDate], '2025-02-08 23:00:00' as [RunTimeStart]
) as src 
	on tar.[Name] = src.[Name] and tar.[Task] = src.[Task]
when not matched by target then
	insert ([Name], [Task], [Type], [Interval], [WeekDays], [Time], [StartDate], [RunTimeStart])
	values (src.[Name],src.[Task],src.[Type],src.[Interval],src.[WeekDays],src.[Time],src.[StartDate],src.[RunTimeStart])
;


-- // create new record in ISExtIntegration for: PMA
merge into IMECentricMaster.dbo.ISExtIntegration as tar
using (
	select 1111 as ExtIntegrationID, 'PMA Report Export' as [Name], 'XPMAReportExport' as [Type], convert(bit,1) as Active, '' as NotifyEmail, '' as [Param]
) as src 
	on tar.ExtIntegrationID = src.ExtIntegrationID and tar.[Type] = src.[Type]
when not matched by target then
	insert (ExtIntegrationID, [Name], [Type], Active, NotifyEmail, [Param])
	values (src.ExtIntegrationID, src.[Name], src.[Type], src.Active, src.NotifyEmail, src.[Param])
;


-- // set params: Prod
update IMECentricMaster.dbo.ISExtIntegration
	set
		NotifyEmail = 'sam.chiang@examworks.com',
		param = concat(
		'DBID=31',  -- // prod
		';NotificationEmail=sam.chiang@examworks.com',
		';NotificationEmailSubject=EWIS: PMA Report Export - Daily',
		';SQLFile=E:\EWIntegrationServer\SQLScripts\PMA_GetReportCases.sql',
		';SFTPFolder=/data_efs/sftp/techsource/pma/responses',
		';SFTPHost=34.193.147.58',
		';SFTPUser=root',		
		';SFTPPwd="=tzN*kfG%79Q2jd"',		
		';SFTPPort=22',			
		';WriteXMLDataToCaseHistory=true',
		''
		)
	where ExtIntegrationID = 1111 -- // prod
;


-- // =============================================================================================
-- // IMEC-14798 PMA Eligibility Intake EWIS process
-- // Author: Sam Chiang
-- // =============================================================================================

-- // create new record in ISSchedule for: PMA
merge into IMECentricMaster.dbo.ISSchedule as tar
using (
	select 'PMA Eligibility Intake' as [Name], 'XPMAEligibilityIntake' as [Task], 'D' as [Type], 1 as [Interval], '0111110' as [WeekDays], '1900-01-01 08:00:00' as [Time], '2025-02-08 23:00:00' as [StartDate], '2025-02-08 23:00:00' as [RunTimeStart]
) as src 
	on tar.[Name] = src.[Name] and tar.[Task] = src.[Task]
when not matched by target then
	insert ([Name], [Task], [Type], [Interval], [WeekDays], [Time], [StartDate], [RunTimeStart])
	values (src.[Name],src.[Task],src.[Type],src.[Interval],src.[WeekDays],src.[Time],src.[StartDate],src.[RunTimeStart])
;


-- // create new record in ISExtIntegration for: PMA
merge into IMECentricMaster.dbo.ISExtIntegration as tar
using (
	select 1112 as ExtIntegrationID, 'PMA Eligibility Intake' as [Name], 'XPMAEligibilityIntake' as [Type], convert(bit,1) as Active, '' as NotifyEmail, '' as [Param]
) as src 
	on tar.ExtIntegrationID = src.ExtIntegrationID and tar.[Type] = src.[Type]
when not matched by target then
	insert (ExtIntegrationID, [Name], [Type], Active, NotifyEmail, [Param])
	values (src.ExtIntegrationID, src.[Name], src.[Type], src.Active, src.NotifyEmail, src.[Param])
;


-- // set params: Prod  
update IMECentricMaster.dbo.ISExtIntegration
	set
		NotifyEmail = 'sam.chiang@examworks.com',
		param = concat(
		'DBID=31',  
		';NotificationEmail=sam.chiang@examworks.com',
		';NotificationEmailSubject=EWIS: PMA Eligibility Intake - Daily',
		';SFTPFolder=/data_efs/sftp/techsource/pma/eligibility',
		';SFTPHost=34.193.147.58',
		';SFTPUser=root',		
		';SFTPPwd="=tzN*kfG%79Q2jd"',		
		';SFTPPort=22',
		';RemoveRemoteFiles=false',
		';SQLFile=E:\EWIntegrationServer\SQLScripts\PMA_EligibilityFindCases.sql',
		''
		)
	where ExtIntegrationID = 1112 
;
