
IF (SELECT OBJECT_ID('tempdb..#tmpErrors')) IS NOT NULL DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
BEGIN TRANSACTION
GO
PRINT N'Altering [dbo].[tblCase]...';


GO
ALTER TABLE [dbo].[tblCase]
    ADD [DoctorBlockTimeSlotID] INT NULL;


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[tblCaseApptPanel]...';


GO
ALTER TABLE [dbo].[tblCaseApptPanel]
    ADD [DoctorBlockTimeSlotID] INT NULL;


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[tblClient]...';


GO
ALTER TABLE [dbo].[tblClient] ALTER COLUMN [EmployeeNumber] VARCHAR (255) NULL;


GO
ALTER TABLE [dbo].[tblClient]
    ADD [InputSourceID] INT NULL;


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[tblDoctorBlockTimeSlot]...';


GO
ALTER TABLE [dbo].[tblDoctorBlockTimeSlot] ALTER COLUMN [HoldDescription] VARCHAR (70) NULL;


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[tblWebReferral]...';


GO
ALTER TABLE [dbo].[tblWebReferral]
    ADD [DoctorBlockTimeSlotID] INT NULL;


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[tblWebUser]...';


GO
ALTER TABLE [dbo].[tblWebUser]
    ADD [InputSourceID] INT NULL;


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Creating [dbo].[tblAutoProvisionLog]...';


GO
CREATE TABLE [dbo].[tblAutoProvisionLog] (
    [APLogID]            INT            IDENTITY (1, 1) NOT NULL,
    [EntityType]         CHAR (2)       NOT NULL,
    [EntityID]           INT            NULL,
    [WebUserID]          INT            NULL,
    [APType]             CHAR (8)       NOT NULL,
    [Result]             VARCHAR (32)   NULL,
    [Details]            VARCHAR (4096) NULL,
    [Param1Name]         VARCHAR (32)   NULL,
    [Param1Value]        VARCHAR (255)  NULL,
    [Param2Name]         VARCHAR (32)   NULL,
    [Param2Value]        VARCHAR (255)  NULL,
    [Param3Name]         VARCHAR (32)   NULL,
    [Param3Value]        VARCHAR (255)  NULL,
    [Param4Name]         VARCHAR (32)   NULL,
    [Param4Value]        VARCHAR (255)  NULL,
    [Param5Name]         VARCHAR (32)   NULL,
    [Param5Value]        VARCHAR (255)  NULL,
    [DateAdded]          DATETIME       NOT NULL,
    [UserIDAdded]        VARCHAR (20)   NOT NULL,
    [DateAcknowledged]   DATETIME       NULL,
    [UserIDAcknowledged] VARCHAR (20)   NULL,
    PRIMARY KEY CLUSTERED ([APLogID] ASC)
);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Creating [dbo].[tblSSOProfile]...';


GO
CREATE TABLE [dbo].[tblSSOProfile] (
    [Id]                       INT            IDENTITY (1, 1) NOT NULL,
    [EntityType]               CHAR (2)       NOT NULL,
    [EntityID]                 INT            NOT NULL,
    [SSOEntityID]              VARCHAR (255)  NULL,
    [SSOType]                  INT            NULL,
    [AuthType]                 INT            NULL,
    [IdentityProviderName]     VARCHAR (128)  NULL,
    [SAMLURL]                  VARCHAR (255)  NULL,
    [UserIDAdded]              VARCHAR (20)   NOT NULL,
    [DateAdded]                DATETIME       NOT NULL,
    [UserIDEdited]             VARCHAR (20)   NOT NULL,
    [DateEdited]               DATETIME       NOT NULL,
    [MatchType]                INT            NOT NULL,
    [Active]                   BIT            NOT NULL,
    [AllowAutoProvision]       BIT            NOT NULL,
    [AutoProvisionCompanyCode] INT            NULL,
    [AutoProvisionEmail]       VARCHAR (2048) NULL,
    [WebCompanyID]             INT            NULL,
    [DefaultEWTimeZoneID]      INT            NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[vwWALI]...';


GO
ALTER VIEW vwWALI
AS
SELECT  CA.CaseApptID,
		ISNULL(CA.DoctorCode, CAP.DoctorCode) AS DoctorCode,
		dbo.fnDateValue(CA.ApptTime) AS ApptDate,
		CA.CaseNbr,
		CT.EWBusLineID,
		C.ServiceCode
FROM    tblCaseAppt AS CA 
INNER JOIN tblCase AS C ON C.CaseNbr = CA.CaseNbr
INNER JOIN tblCaseType AS CT ON C.CaseType = CT.Code
INNER JOIN tblCodes ON Category = 'WALI CAC' AND SubCategory = 'ServiceCode' AND Value=CAST(C.ServiceCode AS VARCHAR)
LEFT OUTER JOIN tblCaseApptPanel AS CAP ON CAP.CaseApptID = CA.CaseApptID
WHERE CT.EWBusLineID=3
AND CA.ApptStatusID=10
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Creating [dbo].[vwAutoProvisions]...';


GO
CREATE VIEW vwAutoProvisions
AS 
	SELECT 
			tblAutoProvisionLog.*, 
			tblCompany.CompanyCode AS CompanyCode,
			tblClientOffice.OfficeCode,
			tblCompany.ParentCompanyID AS ParentCompanyID,
			tblCompany.IntName
	  FROM tblAutoProvisionLog
			LEFT OUTER JOIN tblClient ON tblClient.ClientCode = tblAutoProvisionLog.EntityID
			LEFT OUTER JOIN tblClientOffice ON tblClientOffice.ClientCode = tblAutoProvisionLog.EntityID
			LEFT OUTER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
			LEFT OUTER JOIN tblEWParentCompany ON tblEWParentCompany.ParentCompanyID = tblCompany.ParentCompanyID
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Creating [dbo].[vwDrSchedGetBlockTimeAppts]...';


GO
CREATE VIEW [dbo].[vwDrSchedGetBlockTimeAppts]
	AS 
		SELECT
			-- tblDoctorBlockTimeSlot details
			TimeSlot.*,
			-- other miscellaneous IDs that are helpful to have
			c.CaseNbr AS ApptSlotCaseNbr, 
			c.ChartNbr,
			c.ClientCode, 
			c.ServiceCode, 
			c.CaseType, 
			co.CompanyCode, 
			-- details that are used in UI
			ex.LastName + ', ' + ex.Firstname as ExamineeName, 
			co.intname as CompanyName,
			ct.shortdesc as CaseTypeShortDesc,
			serv.ShortDesc as ServiceShortDesc 
		FROM 
			tblDoctorBlockTimeSlot AS TimeSlot
				LEFT OUTER JOIN tblCaseAppt AS ca ON ca.CaseApptID = TimeSlot.CaseApptID
				LEFT OUTER JOIN tblCaseApptRequest AS car ON car.CaseApptRequestID = TimeSlot.CaseApptRequestID
				LEFT OUTER JOIN tblCase AS c ON c.CaseNbr = IIF(ca.CaseNbr IS NULL, car.CaseNbr, ca.CaseNbr)
				LEFT OUTER JOIN tblExaminee AS ex ON ex.ChartNbr = c.Chartnbr
				LEFT OUTER JOIN tblServices AS serv ON serv.ServiceCode = c.ServiceCode
				LEFT OUTER JOIN tblCaseType AS ct ON ct.Code = c.CaseType
				LEFT OUTER JOIN tblclient AS cl ON cl.ClientCode = c.ClientCode
				LEFT OUTER JOIN tblCompany AS co ON co.CompanyCode = cl.CompanyCode
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Creating [dbo].[vwDrSchedGetNonBlockTimeAppt]...';


GO
CREATE VIEW [dbo].[vwDrSchedGetNonBlockTimeAppt]
	AS 
		SELECT 
			ca.CaseApptID,
			ca.CaseNbr,
			ca.ApptStatusID,
			ca.DoctorCode, 
			ca.LocationCode, 
			ca.ApptTime,
			ca.Duration,
			-- IDs that are useful to have at hand
			c.CaseNbr AS ApptSlotCaseNbr,
			c.ChartNbr,
			cl.ClientCode,
			c.ServiceCode,
			c.CaseType,
			co.CompanyCode,
			-- details used in UI
			ex.LastName + ', ' + ex.FirstName AS ExamineeName,
			co.IntName AS CompanyName,
			ct.ShortDesc AS CaseTypeShortDesc,
			serv.ShortDesc AS ServiceShortDesc
		FROM
			tblCaseAppt AS ca
				INNER JOIN tblCase AS c ON c.CaseNbr = ca.CaseNbr
				INNER JOIN tblExaminee AS ex ON ex.ChartNbr = c.Chartnbr
				INNER JOIN tblServices AS serv ON serv.ServiceCode = c.ServiceCode
				INNER JOIN tblCaseType AS ct ON ct.Code = c.CaseType
				INNER JOIN tblclient AS cl ON cl.ClientCode = c.ClientCode
				INNER JOIN tblCompany AS co ON co.CompanyCode = cl.CompanyCode
		WHERE 
			ca.DoctorBlockTimeSlotID IS NULL
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[proc_Doctor_GetDaySheetData]...';


GO

ALTER proc [dbo].[proc_Doctor_GetDaySheetData]
	@fromDate datetime,
	@toDate datetime,
	@office int,
	@casetype int, 
	@doctor int,
	@location int,
	@alloffices int,
	@usenewdata int,
	@userid varchar(15)
as
begin
	

	if @alloffices is null or @alloffices < 0
	begin
		set @alloffices = -1;
	end

	if @usenewdata is null or @usenewdata <= 0
	begin
		set @usenewdata = -1;
	end

	if @userid is null 
	begin
		set @userid = '';
	end

	if object_id('tempdb..#daysheetdata') is not null drop table #daysheetdata;   

	if object_id('tempdb..#daysheetdatanew') is not null drop table #daysheetdatanew;   


	select 
		distinct LocationCode, LocationOffice, DoctorOffice 
		into #daysheetdatanew 
	from (
		select 
			ca.CaseApptID as SchedCode,
			ca.DoctorCode ,            
			ca.LocationCode ,
			c.CaseNbr, 
			c.ExtCaseNbr, 
			c.OfficeCode,
			lo.OfficeCode as LocationOffice,
			dro.OfficeCode as DoctorOffice

		from tblcaseappt as ca with (nolock)
			inner join tblcase as c  with (nolock)on ca.caseapptid = c.caseapptid			
			left join tblcaseapptpanel as cap  with (nolock)on cap.caseapptid = c.caseapptid
			inner join tbldoctor as dr  with (nolock)on dr.doctorcode = isnull(ca.doctorcode, cap.doctorcode)
			inner join tbllocation as l  with (nolock)on ca.locationcode = l.locationcode
			inner join tbldoctoroffice as dro  with (nolock)on dr.doctorcode = dro.doctorcode
			inner join tbllocationoffice as lo  with (nolock)on lo.officecode = dro.officecode and lo.locationcode = l.locationcode			
			inner join tblapptstatus as aps  with (nolock)on aps.apptstatusid = ca.apptstatusid and ca.apptstatusid = 10

		where
			(cast(ca.ApptTime as date) >= @fromDate and cast(ca.ApptTime as date) <= @toDate)	
			and aps.Name = 'Scheduled'
			and (c.CaseType = (COALESCE(NULLIF(@casetype, '-1'), c.CaseType)) or c.CaseType is null)
			and ca.DoctorCode = (COALESCE(NULLIF(@doctor, '-1'), ca.DoctorCode))
			and ca.LocationCode = (COALESCE(NULLIF(@location, '-1'), ca.LocationCode))
	) x
	;

	select 
		x.*, 
		isnull(cpc.OfficeCode, c.OfficeCode) as OfficeCode, 
		isnull(cpc.CaseNbr, c.CaseNbr) as CaseNbr, 
		isnull(cpc.ExtCaseNbr, c.ExtCaseNbr) as ExtCaseNbr
		
		into #daysheetdata
	from (

		select 

			tblDoctorSchedule.SchedCode,		
			tblDoctorSchedule.DoctorCode,
			tblDoctorSchedule.LocationCode,		
			tblLocation.Location,
			(rtrim(tblLocation.Addr1 + ' ' + isnull(tblLocation.Addr2, '')) +  ', ' + tblLocation.City + ' ' + tblLocation.State + ' ' + tblLocation.Zip) as DoctorAddress,				
			tblDoctorSchedule.date as ApptDate,
			tblDoctorSchedule.StartTime as ApptDateTime,
			stuff(replace(right(convert(varchar(19), tblDoctorSchedule.StartTime, 0), 7), ' ', '0'), 6, 0, ' ') as ApptTime,		
			ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName, '') + ', ' + ISNULL(tblDoctor.Credentials, '') as DoctorName,		
			(case when ltrim(rtrim(tblDoctor.EmailAddr)) <> '' then ltrim(rtrim(tblDoctor.EmailAddr)) else null end) as DoctorEmail,		
			tblLocation.Phone as LocationPhone,
			tblLocation.Fax as LocationFax,
			tblLocation.ContactLast,
			tblLocation.ContactFirst,
			tblLocation.ExtName as LocationExtName,
			tblLocationOffice.OfficeCode as LocationOffice, 
			tblDoctorOffice.OfficeCode as DoctorOffice,
			tblDoctorSchedule.CaseNbr1,
			tblDoctorSchedule.CaseNbr2,
			tblDoctorSchedule.CaseNbr3,
			tblDoctorSchedule.CaseNbr4,
			tblDoctorSchedule.CaseNbr5,
			tblDoctorSchedule.CaseNbr6

		FROM tblDoctorSchedule with (nolock)
			inner join tblDoctor with (nolock) on tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode	
			inner join tblLocation with (nolock) on tblDoctorSchedule.LocationCode = tblLocation.LocationCode 
			inner join tblDoctorOffice with (nolock) on tblDoctor.DoctorCode = tblDoctorOffice.DoctorCode
			inner join tblLocationOffice with (nolock) on tblLocationOffice.OfficeCode = tblDoctorOffice.OfficeCode AND tblLocationOffice.LocationCode = tblLocation.LocationCode	

		WHERE 					
			(tblDoctorSchedule.date >= @fromDate and tblDoctorSchedule.date <= @toDate)			
			and tblDoctorSchedule.Status = 'Scheduled'		
			and tblDoctorSchedule.DoctorCode = (COALESCE(NULLIF(@doctor, '-1'), tblDoctorSchedule.DoctorCode))
			and tblDoctorSchedule.LocationCode = (COALESCE(NULLIF(@location, '-1'), tblDoctorSchedule.LocationCode))

	) x
		left outer join tblCasePanel cp with (nolock) 
			join tblCase cpc with (nolock) on cp.PanelNbr = cpc.PanelNbr
			on cp.SchedCode = x.SchedCode and cpc.CaseNbr in (x.CaseNbr1, x.CaseNbr2, x.CaseNbr3, x.CaseNbr4, x.CaseNbr5, x.CaseNbr6)

		left outer join tblCase c with (nolock) on c.SchedCode = x.SchedCode and c.CaseNbr in (x.CaseNbr1, x.CaseNbr2, x.CaseNbr3, x.CaseNbr4, x.CaseNbr5, x.CaseNbr6)

	;

	with
	ddata as (

		select 
			distinct 
			SchedCode, OfficeCode, DoctorCode, LocationCode, Location, DoctorAddress, CaseNbr, ExtCaseNbr, ApptDate, ApptDateTime, ApptTime,  
			DoctorName, DoctorEmail, LocationPhone, LocationFax, ContactLast, ContactFirst, LocationExtName
		from #daysheetdata
		where 
		(1=1 and 
				--// favorites
				(
					1 = (case when @alloffices = 0 then 1 else 0 end) 
					and	OfficeCode in (select distinct OfficeCode from tblUserOffice where UserID = @userid)
					and LocationOffice in (select distinct OfficeCode from tblUserOffice where UserID = @userid) 
					and DoctorOffice in (select distinct OfficeCode from tblUserOffice where UserID = @userid)
				)

				or

				----// default
				(
					2 = (case when @alloffices = -1 then 2 else 0 end) 
					and	OfficeCode = @office
					and LocationOffice = @office 
					and DoctorOffice = @office
				)

				or
			
				----// all offices
				(
					3 = (case when @alloffices = 1 then 3 else 0 end) 						
				)
		)

	)

	select 
		d.*,
		tblOffice.ShortDesc as OfficeName,
		tblExaminee.FirstName + ' ' + tblExaminee.LastName as Examinee,
		tblCaseType.Description as CaseType,
		tblCaseType.ExternalDesc as CaseTypeShort,
		tblServices.Description as [Service],
		tblServices.ShortDesc as [ServiceShort],
		tblCase.DoctorSpecialty as Specialty,
		(tblServices.ShortDesc + ' / ' + tblCase.DoctorSpecialty) as ServiceSpecialty,		
		(case when tblCase.PhotoRqd is not null and tblCase.PhotoRqd = 1 then convert(bit, 1) else convert(bit, 0) end) as PhotoRequired,
		(case when tblCase.InterpreterRequired = 1 then 'Interpreter' else '' end) as Interpreter,
		(case when tblCase.LanguageID > 0 then tblLanguage.Description else '' end) as [InterpreterLanguage],
		(case when (select top 1 [Type] from tblRecordHistory with (nolock) where [Type] = 'F' and CaseNbr = tblCase.CaseNbr) = 'F' then 'Films' else '' end) as Comments,
		tblEWFacility.Logo as LogoURL
	from ddata d
			inner join tblCase with (nolock) on tblCase.CaseNbr = d.CaseNbr
			inner join tblClient with (nolock) on tblCase.ClientCode = tblClient.ClientCode
			inner join tblCompany with (nolock) on tblClient.CompanyCode = tblCompany.CompanyCode
			inner join tblOffice with (nolock) on tblCase.OfficeCode = tblOffice.OfficeCode
			inner join tblEWFacility with (nolock) on tblOffice.EWFacilityID = tblEWFacility.EWFacilityID
			inner join tblServices with (nolock) on tblCase.ServiceCode = tblServices.ServiceCode 
			inner join tblExaminee with (nolock) on tblCase.ChartNbr = tblExaminee.ChartNbr
			inner join tblCaseType with (nolock) on tblCase.CaseType = tblCaseType.Code		
			left outer join tblLanguage with (nolock) on tblLanguage.LanguageID = tblcase.LanguageID
	;

	if object_id('tempdb..#daysheetdata') is not null drop table #daysheetdata;   

	if object_id('tempdb..#daysheetdatanew') is not null drop table #daysheetdatanew; 


end
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Altering [dbo].[proc_Info_Generic_MgtRpt_QueryData]...';


GO
ALTER PROCEDURE [dbo].[proc_Info_Generic_MgtRpt_QueryData]
	@startDate Date,
	@endDate Date,
	@ewFacilityIdList VarChar(255),
	@companyCodeList VarChar(255)
AS
SET NOCOUNT ON

IF OBJECT_ID('tempdb..##tmp_GenericInvoices') IS NOT NULL DROP TABLE ##tmp_GenericInvoices
print 'Gather main data set ...'


DECLARE @xml XML
DECLARE @xmlCompany XML
DECLARE @delimiter CHAR(1) = ','
SET @xml = CAST('<X>' + REPLACE(@ewFacilityIdList, @delimiter, '</X><X>') + '</X>' AS XML)
SET @xmlCompany = CAST('<X>' + REPLACE(@companyCodeList, @delimiter, '</X><X>') + '</X>' AS XML)

print 'Facility ID List: ' + @ewFacilityIdList;
print 'Company Code List: ' + @companyCodeList;

WITH SLADetailsCTE AS
	(SELECT se.Descrip + IIF(LEN(sla.Explanation) > 0, ' - ' + sla.Explanation, '') as SLAReason, sla.CaseNbr 
	   FROM tblCaseSLARuleDetail as sla 
			 LEFT OUTER JOIN tblSLAException as se on sla.SLAExceptionID = se.SLAExceptionID 
			 INNER JOIN tblCase as c on sla.CaseNbr = c.CaseNbr 
			 INNER JOIN tblAcctHeader as ah on c.CaseNbr = ah.CaseNbr 
			 INNER JOIN tblClient as cli on cli.ClientCode = ah.ClientCode 
			 INNER JOIN tblCompany as com on com.CompanyCode = cli.CompanyCode 
	 WHERE ((LEN(se.Descrip) > 0) OR (LEN(sla.Explanation) > 0)) 
  		  AND (AH.DocumentType = 'IN' 
		  AND AH.DocumentStatus = 'Final' 
		  AND AH.DocumentDate >= @startDate and AH.DocumentDate <= @endDate) 
	 GROUP BY (se.Descrip + IIF(LEN(sla.Explanation) > 0, ' - ' + sla.Explanation, '')), sla.CaseNbr ) 
SELECT
  Inv.EWFacilityID,
  Inv.HeaderID,
  EWF.DBID as DBID,
  EWF.GPFacility + '-' + cast(Inv.DocumentNbr as varchar(15)) as InvoiceNo,
  Inv.DocumentDate as InvoiceDate,
  C.CaseNbr,
  C.ExtCaseNbr,
  isnull(PC.Name, 'Other') as ParentCompany,
  CO.CompanyCode as CompanyID,
  CO.IntName as CompanyInt,
  CO.ExtName as CompanyExt,
  COM.IntName as CaseCompanyInt,
  COM.ExtName as CaseCompanyExt,
  case when isnull(CLI.LastName, '') = '' then isnull(CLI.FirstName, '') else CLI.LastName+', '+isnull(CLI.FirstName, '') end as CaseClient,
  CO.State as CompanyState,
  EWCT.Name as CompanyType,
  CL.ClientCode as ClientID,
  case when isnull(CL.LastName, '') = '' then isnull(CL.FirstName, '') else CL.LastName+', '+isnull(CL.FirstName, '') end as Client,
  D.DoctorCode as DoctorID, 
  D.Zip as DoctorZip,
  CASE 
  WHEN c.PanelNbr IS NOT NULL THEN c.DoctorName 
  ELSE case when isnull(D.LastName, '') = '' then isnull(D.FirstName, '') else D.LastName+', '+isnull(D.FirstName, '') end
  END as Doctor, 
  C.DoctorReason,
  CT.Description as CaseType,
  BL.Name as BusinessLine,
  ST.Name as ServiceType,
  S.Description as Service,
  Inv.ClaimNbr as ClaimNo,
  C.SInternalCaseNbr as InternalCaseNbr,
  Inv.Examinee as Examinee,
  CASE ISNULL(C.EmployerID, 0)
    WHEN 0 THEN E.Employer
    ELSE EM.Name
  END AS Employer,
  E.DOB as "Examinee DOB",
  E.SSN as "Examinee SSN",
  O.ShortDesc as Office,
  EL.Location as ExamLocationName,
  EL.Addr1 as ExamLocationAddress1,
  EL.Addr2 as ExamLocationAddress2,
  EL.City as ExamLocationCity,
  EL.State as ExamLocationState,
  EL.Zip as ExamLocationZip,
  cast(case when isnull(M.FirstName, '') = '' then isnull(M.LastName, isnull(C.MarketerCode, '')) else M.FirstName+' '+isnull(M.LastName, '') end as varchar(30)) as Marketer,
  EWF.ShortName as EWFacility,
  EFGS.RegionGroupName as Region,
  EFGS.SubRegionGroupName as SubRegion,
  EFGS.BusUnitGroupName as BusUnit,
  EWF.GPFacility as GPFacility,
  Inv.Finalized as DateFinalized,
  Inv.UserIDFinalized as UserFinalized,
  Inv.BatchNbr as GPBatchNo,
  Inv.ExportDate as GPBatchDate,
  BB.Descrip as BulkBilling,
  DOC.Description as InvoiceDocument,
  APS.Name as ApptStatus,
  CB.ExtName as CanceledBy,
  CA.Reason as CancelReason,
  isnull(Inv.ClientRefNbr, '') as ClientRefNo,
  isnull(CA.SpecialtyCode, C.DoctorSpecialty) as DoctorSpecialty,
  C.DateOfInjury as InjuryDate,
  C.ForecastDate,
  C.Jurisdiction,
  EWIS.Name as InputSource,
  EWIS.Mapping1 as SedgwickSource,
  isnull(CA.DateReceived, C.DateReceived) as DateReceived,
  CA.DateAdded as ApptMadeDate,
  C.OrigApptTime as OrigAppt,
  ISNULL(inv.CaseApptID, c.CaseApptID) as CaseApptID,
  CA.ApptTime as [ApptDate],
  C.RptFinalizedDate,
  C.RptSentDate,
  case S.EWServiceTypeID
    when 2 then C.DateMedsRecd
    when 3 then C.DateMedsRecd
    when 4 then C.DateMedsRecd
    when 5 then C.DateMedsRecd
  end as DateMedsReceived,
  C.OCF25Date,
  c.TATAwaitingScheduling,  
  c.TATEnteredToAcknowledged,
  c.TATEnteredToMRRReceived,
  c.TATEnteredToScheduled,
  c.TATExamToClientNotified,
  c.TATExamToRptReceived,
  c.TATQACompleteToRptSent,
  c.TATReport, 
  c.TATRptReceivedToQAComplete,
  c.TATRptSentToInvoiced,
  c.TATScheduledToExam,
  c.TATServiceLifeCycle, 
  C.DateAdded as CaseDateAdded,
  Inv.CaseDocID,
  case
    when EWReferralType=0 then ''
    when EWReferralType=1 then 'Incoming'
    when EWReferralType=2 then 'Outgoing'
    else 'Unknown'
  end as MigratingClaim,
  isnull(MCFGS.BusUnitGroupName, '') as MigratingClaimBusUnit,
  C.PhotoRqd,
  C.PhotoRcvd,
  isnull(C.TransportationRequired, 0) as TransportationRequired,
  isnull(C.InterpreterRequired, 0) as InterpreterRequired,
  LANG.Description as Language,
  '' as CaseIssues,
  case C.NeedFurtherTreatment when 1 then 'Pos' else 'Neg' end as Outcome,
  case C.IsReExam when 1 then 'Yes' else 'No' end as IsReExam,
  isnull(FZ.Name, '') as FeeZone,
  (select count(tCA.CaseApptID) from tblCaseAppt as tCA where C.CaseNbr = tCA.CaseNbr and tCA.CaseApptID <= CA.CaseApptID and tCA.ApptStatusID <> 50) as ApptCount,
  (select count(tCA.CaseApptID) from tblCaseAppt as tCA where C.CaseNbr = tCA.CaseNbr and tCA.CaseApptID <= CA.CaseApptID and tCA.ApptStatusID = 101) as NSCount,
  cast(Round(Inv.TaxTotal*Inv.ExchangeRate, 2) as Money) as TaxTotal,
  Inv.DocumentTotalUS-cast(Round(Inv.TaxTotal*Inv.ExchangeRate, 2) as Money) as Revenue,
  Inv.DocumentTotalUS as InvoiceTotal,
  isnull(VO.Expense, 0) as Expense,
  VO.VoucherCount as Vouchers,
  VO.VoucherDateMin as VoucherDate1,
  EWF.GPFacility + '-' + cast(VO.VoucherNoMin as varchar(15)) as VoucherNo1,
  VO.VoucherDateMax as VoucherDate2,
  EWF.GPFacility + '-' + cast(VO.VoucherNoMax as varchar(15)) as VoucherNo2,
  (select count(LI.LineNbr) from tblAcctDetail as LI where LI.HeaderID = Inv.HeaderID) as LineItems,
 STUFF((SELECT '; ' + SLAReason FROM SLADetailsCTE
    WHERE SLADetailsCTE.CaseNbr = inv.CaseNbr
    FOR XML path(''), type, root).value('root[1]', 'varchar(max)'), 1, 2, '') as SLAReasons,
  CONVERT(DATETIME, NULL) as ClaimantConfirmationDateTime,
  CONVERT(VARCHAR(32), NULL) as ClaimantConfirmationStatus,
  CONVERT(INT, NULL) as ClaimantCallAttempts,
  CONVERT(DATETIME, NULL) as AttyConfirmationDateTime,
  CONVERT(VARCHAR(32), NULL) as AttyConfirmationStatus,
  CONVERT(INT, NULL) as AttyCallAttempts,  
  CONVERT(MONEY, NULL) AS   FeeDetailExam,
  CONVERT(MONEY, NULL) AS   FeeDetailBillReview,
  CONVERT(MONEY, NULL) AS   FeeDetailPeer,
  CONVERT(MONEY, NULL) AS   FeeDetailAdd,
  CONVERT(MONEY, NULL) AS   FeeDetailLegal,
  CONVERT(MONEY, NULL) AS   FeeDetailProcServ,
  CONVERT(MONEY, NULL) AS   FeeDetailDiag,
  CONVERT(MONEY, NULL) AS   FeeDetailNurseServ,
  CONVERT(MONEY, NULL) AS   FeeDetailPhone,
  CONVERT(MONEY, NULL) AS   FeeDetailMSA,
  CONVERT(MONEY, NULL) AS   FeeDetailClinical,
  CONVERT(MONEY, NULL) AS   FeeDetailTech,
  CONVERT(MONEY, NULL) AS   FeeDetailMedicare,
  CONVERT(MONEY, NULL) AS   FeeDetailOPO,
  CONVERT(MONEY, NULL) AS   FeeDetailRehab,
  CONVERT(MONEY, NULL) AS   FeeDetailAddRev,
  CONVERT(MONEY, NULL) AS   FeeDetailTrans,
  CONVERT(MONEY, NULL) AS   FeeDetailMileage,
  CONVERT(MONEY, NULL) AS   FeeDetailTranslate,
  CONVERT(MONEY, NULL) AS   FeeDetailAdminFee,
  CONVERT(MONEY, NULL) AS   FeeDetailFacFee,
  CONVERT(MONEY, NULL) AS   FeeDetailOther,
  ISNULL(C.InsuringCompany, '') as InsuringCompany,
  ISNULL(C.Priority, 'Normal') AS CasePriority,
  CONVERT(DATE, C.AwaitingScheduling) as DateAwaitingScheduling
INTO ##tmp_GenericInvoices
FROM tblAcctHeader AS Inv
left outer join tblCase as C on Inv.CaseNbr = C.CaseNbr
left outer join tblEmployer as EM on C.EmployerID = EM.EmployerID
left outer join tblClient as CL on Inv.ClientCode = CL.ClientCode		-- invoice client (billing client)
left outer join tblCompany as CO on Inv.CompanyCode = CO.CompanyCode	-- invoice company (billing company)
left outer join tblClient as CLI on C.ClientCode = CLI.ClientCode		-- case client
left outer join tblCompany as COM on CLI.CompanyCode = COM.CompanyCode	-- case company
left outer join tblEWCompanyType as EWCT on CO.EWCompanyTypeID = EWCT.EWCompanyTypeID
left outer join tblDoctor as D on Inv.DrOpCode = D.DoctorCode
left outer join tblExaminee as E on C.ChartNbr = E.ChartNbr
left outer join tblCaseType as CT on C.CaseType = CT.Code
left outer join tblServices as S on C.ServiceCode = S.ServiceCode
left outer join tblEWBusLine as BL on CT.EWBusLineID = BL.EWBusLineID
left outer join tblEWServiceType as ST on S.EWServiceTypeID = ST.EWServiceTypeID
left outer join tblOffice as O on C.OfficeCode = O.OfficeCode
left outer join tblEWFacility as EWF on Inv.EWFacilityID = EWF.EWFacilityID
left outer join tblEWFacilityGroupSummary as EFGS on Inv.EWFacilityID = EFGS.EWFacilityID
left outer join tblEWFacilityGroupSummary as MCFGS on C.EWReferralEWFacilityID = MCFGS.EWFacilityID
left outer join tblDocument as DOC on Inv.DocumentCode = DOC.Document
left outer join tblUser as M on C.MarketerCode = M.UserID
left outer join tblEWParentCompany as PC on CO.ParentCompanyID = PC.ParentCompanyID
left outer join tblEWBulkBilling as BB on CO.BulkBillingID = BB.BulkBillingID
left outer join tblCaseAppt as CA on isnull(Inv.CaseApptID, C.CaseApptID) = CA.CaseApptID
left outer join tblApptStatus as APS on isnull(Inv.ApptStatusID, C.ApptStatusID) = APS.ApptStatusID
left outer join tblCanceledBy as CB on CA.CanceledByID = CB.CanceledByID
left outer join tblEWFeeZone as FZ on isnull(CA.EWFeeZoneID, C.EWFeeZoneID) = FZ.EWFeeZoneID
left outer join tblLanguage as LANG on C.LanguageID = LANG.LanguageID
left outer join tblEWInputSource as EWIS on C.InputSourceID = EWIS.InputSourceID
left outer join tblLocation as EL on CA.LocationCode = EL.LocationCode
left outer join
  (select
     RelatedInvHeaderID, 
     sum(DocumentTotalUS)-sum(cast(Round(TaxTotal*ExchangeRate, 2) as Money)) as Expense,
     count(DocumentNbr) as VoucherCount,
     min(DocumentDate) as VoucherDateMin,  
     min(DocumentNbr) as VoucherNoMin,
     max(DocumentDate) as VoucherDateMax,
     max(DocumentNbr) as VoucherNoMax
   from tblAcctHeader
   where DocumentType='VO' and DocumentStatus='Final' 
         and (DocumentDate >= @startDate and DocumentDate <= @endDate )
   group by RelatedInvHeaderID
  ) as VO on Inv.RelatedInvHeaderID = VO.RelatedInvHeaderID
WHERE (Inv.DocumentType='IN')
      AND (Inv.DocumentStatus='Final')
      AND (Inv.DocumentDate >= @startDate) and (Inv.DocumentDate <= @endDate)
      AND (inv.EWFacilityID in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xml.nodes( 'X' ) AS [T]( [N] )))
      AND (((LEN(ISNULL(@companyCodeList, 0)) > 0 AND CO.ParentCompanyID in (SELECT [N].value( '.', 'varchar(50)' ) AS value FROM @xmlCompany.nodes( 'X' ) AS [T]( [N] ))))
			OR (LEN(ISNULL(@companyCodeList, 0)) = 0 AND CO.ParentCompanyID > 0))

ORDER BY EWF.GPFacility, Inv.DocumentNbr

print 'Data retrieved'

SET NOCOUNT OFF
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO
PRINT N'Creating [dbo].[spDoctorSearchNew]...';


GO
CREATE PROCEDURE [dbo].[spDoctorSearchNew]
(
	@SessionID AS VARCHAR(50) = NULL,

    @StartDate AS DATETIME,
    @PanelExam AS BIT = NULL,

    @DoctorCode AS INT = NULL,
    @ProvTypeCode AS INT = NULL,
	@IncludeInactiveDoctor AS BIT = NULL,
    @Degree AS VARCHAR(50) = NULL,
    @RequirePracticingDoctors AS BIT = NULL,
    @RequireLicencedInExamState AS BIT = NULL,
    @RequireBoardCertified AS BIT = NULL,

    @LocationCode AS INT = NULL,
    @City AS VARCHAR(50) = NULL,
    @State AS VARCHAR(2) = NULL,
    @Vicinity AS VARCHAR(50) = NULL,
    @County AS VARCHAR(50) = NULL,

	@Proximity AS INT = NULL,
	@ProximityZip AS VARCHAR(10) = NULL,

    @KeyWordIDs AS VARCHAR(100) = NULL,
    @Specialties AS VARCHAR(200) = NULL,
    @EWAccreditationID AS INT = NULL,
	@OfficeCode AS INT = NULL,	

	@ClientCode AS INT = NULL,	
	@CompanyCode AS INT = NULL,
	@ParentCompanyID AS INT = NULL,
	@EWBusLineID AS INT = NULL,
	@EWServiceTypeID AS INT = NULL,
	
	@FirstName AS VARCHAR(50) = NULL,
	@LastName AS VARCHAR(50) = NULL
)
AS
BEGIN

    SET NOCOUNT ON;

	DECLARE @strSQL NVARCHAR(max), @strWhere NVARCHAR(max) = ''
	DECLARE @strDrSchCol NVARCHAR(max), @strDrSchFrom NVARCHAR(max) = ''
	DECLARE @lstSpecialties VARCHAR(200)
	DECLARE @lstKeywordIDs VARCHAR(100)
	DECLARE @geoEE GEOGRAPHY
    DECLARE @distanceConv FLOAT
	DECLARE @tmpSessionID VARCHAR(50)
	DECLARE @returnValue INT
	DECLARE @AvgMargin AS DECIMAL(8, 2)
	DECLARE @MaxCaseCount AS DECIMAL(8, 2)

	--Defalt Values
	SET @tmpSessionID = ISNULL(@SessionID, NEWID())

	IF @ParentCompanyID IS NOT NULL
	BEGIN
		IF @RequirePracticingDoctors IS NULL
			(SELECT @RequirePracticingDoctors = RequirePracticingDoctor FROM tblEWParentCompany WHERE ParentCompanyID = @ParentCompanyID)
		IF @RequireBoardCertified IS NULL
			(SELECT @RequireBoardCertified = RequireCertification FROM tblEWParentCompany WHERE ParentCompanyID = @ParentCompanyID)
	END

	--Format delimited list
	SET @lstSpecialties = ';;' + @Specialties
	SET @lstKeywordIDs = ';;' + REPLACE(@KeyWordIDs, ' ', '')

	--Calculate parameter geography data
	IF (@ProximityZip IS NOT NULL)
	BEGIN
		SET @geoEE = geography::STGeomFromText((SELECT TOP 1 'POINT(' + CONVERT(VARCHAR(100),Z.fLongitude) +' '+ CONVERT(VARCHAR(100),Z.fLatitude)+')' FROM tblZipCode AS Z WHERE Z.sZip=@ProximityZip ORDER BY Z.kIndex) ,4326)
		IF (SELECT TOP 1 DistanceUofM FROM tblIMEData)='Miles'
			SET @distanceConv = 1609.344
		ELSE
			SET @distanceConv = 1000
	END

	--Clear data from last search
	DELETE FROM tblDoctorSearchResult WHERE SessionID=@tmpSessionID


	--Set Differrent SQL String for Panel Search
	IF ISNULL(@PanelExam,0) = 1
		BEGIN
			SET @strDrSchCol = ' BTS.DoctorBlockTimeSlotID AS SchedCode,'
			SET @strDrSchFrom = ' INNER JOIN tblDoctorBlockTimeDay AS BTD ON BTD.DoctorCode=DL.DoctorCode AND BTD.LocationCode=DL.LocationCode AND BTD.ScheduleDate>=@_StartDate ' +
								' INNER JOIN tblDoctorBlockTimeSlot AS BTS ON BTS.DoctorBlockTimeDayID = BTD.DoctorBlockTimeDayID AND BTS.DoctorBlockTimeSlotStatusID=10'
		END
	ELSE
		SET @strDrSchCol = '(SELECT TOP 1 SchedCode FROM tblDoctorSchedule AS DS WHERE DS.DoctorCode=DL.DoctorCode AND DS.LocationCode=DL.LocationCode AND DS.date >= dbo.fnDateValue(@_StartDate) AND DS.Status = ''Open'' ORDER BY DS.date) AS SchedCode,'
		SET @strDrSchCol = '(SELECT TOP 1 BTS.DoctorBlockTimeSlotID AS SchedCode FROM tblDoctorBlockTimeDay AS BTD ' +
						   ' INNER JOIN tblDoctorBlockTimeSlot AS BTS ON BTS.DoctorBlockTimeDayID = BTD.DoctorBlockTimeDayID' +
						   ' WHERE BTD.DoctorCode=DL.DoctorCode AND BTD.LocationCode=DL.LocationCode AND BTS.DoctorBlockTimeSlotStatusID=10' +
						   ' AND BTD.ScheduleDate >= dbo.fnDateValue(@_StartDate) ORDER BY BTD.ScheduleDate) AS SchedCode,'
 

--Set main SQL String
SET @strSQL='
INSERT INTO tblDoctorSearchResult
(
    SessionID,
    DoctorCode,
    LocationCode,
    SchedCode,
    Proximity
)
SELECT
	@_tmpSessionID AS SessionID,
	DR.DoctorCode,
    L.LocationCode,
	' + @strDrSchCol + '
	ISNULL(L.GeoData.STDistance(@_geoEE)/@_distanceConv,9999) AS Proximity

FROM 
    tblDoctor AS DR
    INNER JOIN tblDoctorLocation AS DL
        ON DL.DoctorCode = DR.DoctorCode
	INNER JOIN tblLocation AS L
        ON L.LocationCode = DL.LocationCode
' + @strDrSchFrom


--Set WHERE clause string
	SET @strWhere ='WHERE DR.OPType = ''DR'''

	IF ISNULL(@IncludeInactiveDoctor,0)=0
		SET @strWhere = @strWhere + ' AND (DR.Status = ''Active'' AND DL.Status = ''Active'')'
	IF @OfficeCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorOffice WHERE OfficeCode=@_OfficeCode)'

	IF @DoctorCode IS NOT NULL
		 SET @strWhere = @strWhere + ' AND @_DoctorCode = DR.DoctorCode'
	IF @ProvTypeCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND @_ProvTypeCode = DR.ProvTypeCode'
	IF ISNULL(@Degree,'')<>''
		SET @strWhere = @strWhere + ' AND @_Degree = DR.Credentials'

	IF ISNULL(@FirstName,'')<>''
		SET @strWhere = @strWhere + ' AND DR.FirstName LIKE @_FirstName'
	IF ISNULL(@LastName,'')<>''
		SET @strWhere = @strWhere + ' AND DR.LastName LIKE @_LastName'

	IF ISNULL(@RequirePracticingDoctors,0)=1
		SET @strWhere = @strWhere + ' AND DR.PracticingDoctor = 1'
	IF ISNULL(@RequireLicencedInExamState,0)=1
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorDocuments WHERE EWDrDocTypeID = 11 AND State = @_State)'
	IF ISNULL(@RequireBoardCertified,0)=1
	BEGIN
		IF @Specialties IS NOT NULL
			SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorDocuments WHERE EWDrDocTypeID = 2 AND PATINDEX(''%;;''+SpecialtyCode+'';;%'', @_lstSpecialties)>0)'
		ELSE
			SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorDocuments WHERE EWDrDocTypeID = 2)'
	END

	IF @EWAccreditationID IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DoctorCode FROM tblDoctorAccreditation WHERE EWAccreditationID = @_EWAccreditationID)'
	IF @KeyWordIDs IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorKeyWord WHERE PATINDEX(''%;;''+ CONVERT(VARCHAR, KeywordID)+'';;%'', @_lstKeywordIDs)>0)'
	IF @Specialties IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode IN (SELECT DISTINCT DoctorCode FROM tblDoctorSpecialty WHERE PATINDEX(''%;;''+SpecialtyCode+'';;%'', @_lstSpecialties)>0)'

	IF @ParentCompanyID IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''PC'' AND Code=@_ParentCompanyID)'
	IF @CompanyCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''CO'' AND Code=@_CompanyCode)'
	IF @ClientCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND DR.DoctorCode NOT IN (SELECT DISTINCT DoctorCode from tblDrDoNotUse WHERE Type=''CL'' AND Code=@_ClientCode)'

	IF @LocationCode IS NOT NULL
		SET @strWhere = @strWhere + ' AND @_LocationCode = L.LocationCode'
	IF ISNULL(@City,'')<>''
		SET @strWhere = @strWhere + ' AND @_City = L.City'
	IF ISNULL(@State,'')<>''
		SET @strWhere = @strWhere + ' AND @_State = L.State'
	IF ISNULL(@County,'')<>''
		SET @strWhere = @strWhere + ' AND @_County = L.County'
	IF ISNULL(@Vicinity,'')<>''
		SET @strWhere = @strWhere + ' AND @_Vicinity = L.Vicinity'

	IF @Proximity IS NOT NULL
		SET @strWhere = @strWhere + ' AND L.GeoData.STDistance(@_geoEE)/@_distanceConv<=@_Proximity'

	SET @strSQL = @strSQL + @strWhere
	PRINT @strSQL
	EXEC sp_executesql @strSQL,
		  N'@_tmpSessionID VARCHAR(50),
			@_geoEE GEOGRAPHY,
			@_distanceConv FLOAT,
			@_StartDate DATETIME ,
			@_DoctorCode INT ,
			@_LocationCode INT ,
			@_City VARCHAR(50) ,
			@_State VARCHAR(2) ,
			@_Vicinity VARCHAR(50) ,
			@_County VARCHAR(50) ,
			@_Degree VARCHAR(50) ,
			@_lstKeyWordIDs VARCHAR(100) ,
			@_lstSpecialties VARCHAR(200) ,
			@_PanelExam BIT ,
			@_ProvTypeCode INT ,		
			@_EWAccreditationID INT,	
			@_IncludeInactiveDoctor BIT,	
			@_RequirePracticingDoctors BIT,
			@_RequireLicencedInExamState BIT,
			@_RequireBoardCertified BIT,	
			@_OfficeCode INT,			
			@_ParentCompanyID INT,	
			@_CompanyCode INT,		
			@_ClientCode INT,			
			@_Proximity INT,
			@_FirstName VARCHAR(50),
			@_LastName VARCHAR(50)
			',
			@_tmpSessionID = @tmpSessionID,
			@_geoEE = @geoEE,
			@_distanceConv = @distanceConv,
			@_StartDate = @StartDate,
			@_DoctorCode = @DoctorCode,
			@_LocationCode = @LocationCode,
			@_City = @City,
			@_State = @State,
			@_Vicinity = @Vicinity,
			@_County = @County,
			@_Degree = @Degree,
			@_lstKeyWordIDs = @lstKeywordIDs ,
			@_lstSpecialties = @lstSpecialties,
			@_PanelExam = @PanelExam,
			@_ProvTypeCode = @ProvTypeCode,		
			@_EWAccreditationID = @EWAccreditationID,	
			@_IncludeInactiveDoctor = @IncludeInactiveDoctor,
			@_RequirePracticingDoctors = @RequirePracticingDoctors,
			@_RequireLicencedInExamState = @RequireLicencedInExamState,
			@_RequireBoardCertified = @RequireBoardCertified,
			@_OfficeCode = @OfficeCode,
			@_ParentCompanyID = @ParentCompanyID,
			@_CompanyCode = @CompanyCode,
			@_ClientCode = @ClientCode,
			@_Proximity = @Proximity,
			@_FirstName = @FirstName,
			@_LastName = @LastName
	SET @returnValue = @@ROWCOUNT


	--Set Specialty List
	IF @Specialties IS NOT NULL
	BEGIN
	    SET QUOTED_IDENTIFIER OFF
		UPDATE DSR SET DSR.SpecialtyCodes=
		ISNULL((STUFF((
				SELECT ', '+ CAST(DS.SpecialtyCode AS VARCHAR)
				FROM tblDoctorSpecialty DS
				WHERE DS.DoctorCode=DSR.DoctorCode
				FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'varchar(300)'),1,2,'')),'')
		 FROM tblDoctorSearchResult AS DSR
		 WHERE DSR.SessionID=@tmpSessionID
		SET QUOTED_IDENTIFIER ON
	END

	--Get Doctor Margin
	UPDATE DSR SET DSR.CaseCount=stats.CaseCount, DSR.AvgMargin=stats.AvgMargin
	 FROM tblDoctorSearchResult AS DSR
	 INNER JOIN
		(
		 SELECT DM.DoctorCode, AVG(DM.Margin) AS AvgMargin, SUM(DM.CaseCount) AS CaseCount
		 FROM tblDoctorMargin AS DM
		 WHERE (@ParentCompanyID IS NULL OR DM.ParentCompanyID=@ParentCompanyID)
		  AND (@EWBusLineID IS NULL OR DM.EWBusLineID=@EWBusLineID)
		  AND (@EWServiceTypeID IS NULL OR DM.EWServiceTypeID=@EWServiceTypeID)
		  AND (@Specialties IS NULL OR PATINDEX('%;;' + DM.SpecialtyCode + ';;%', @lstSpecialties)>0)
		 GROUP BY DM.DoctorCode
		) AS stats ON stats.DoctorCode = DSR.DoctorCode
	 WHERE DSR.SessionID=@tmpSessionID

	 -- Calculate DisplayScore
	SELECT 
		@AvgMargin = MAX(AvgMargin), 
		@MaxCaseCount = CAST(MAX(CaseCount) AS DECIMAL(8, 2)) 
	FROM tblDoctorSearchResult 
	WHERE SessionID = @tmpSessionID
	GROUP BY SessionID

	UPDATE DSR SET DSR.DisplayScore =
	   IIF(L.InsideDr=1, W.BlockTime, 0) +
	   IIF(@AvgMargin=0, 0, DSR.AvgMargin/@AvgMargin * W.AverageMargin) +
	   IIF(@MaxCaseCount=0, 0, DSR.CaseCount/@MaxCaseCount * W.CaseCount) +
	   (6-ISNULL(DR.SchedulePriority,5))/5.0 * W.SchedulePriority +
	   IIF(DR.ReceiveMedRecsElectronically=1, W.ReceiveMedRecsElectronically, 0)
	FROM tblDoctorSearchResult AS DSR
		INNER JOIN tblDoctorSearchWeightedCriteria AS W ON W.PrimaryKey=1
		INNER JOIN tblDoctor AS DR ON DR.DoctorCode = DSR.DoctorCode
		INNER JOIN tblLocation AS L ON L.LocationCode = DSR.LocationCode
		WHERE DSR.SessionID = @tmpSessionID

	 -- Calculate DoctorRank 
	UPDATE DSR 
		SET DSR.DoctorRank = DR.DoctorRank1
		FROM tblDoctorSearchResult AS DSR
		   INNER JOIN (SELECT PrimaryKey, DENSE_RANK() OVER (ORDER BY DisplayScore DESC, DoctorCode) AS DoctorRank1
		                 FROM tblDoctorSearchResult
					  WHERE SessionID = @tmpSessionID) AS DR ON DR.PrimaryKey = DSR.PrimaryKey
		WHERE DSR.SessionID=@tmpSessionID


	-- Recalculate doctor ranking so that the same doctor has the same ranking
     UPDATE DSR 
           SET DSR.DoctorRank = T1.DoctorRankMin
           FROM tblDoctorSearchResult AS DSR
                     INNER JOIN (SELECT PrimaryKey, DoctorCode, MIN(DoctorRank)OVER(PARTITION BY DoctorCode) AS DoctorRankMin 
                                    FROM tblDoctorSearchResult
                                    WHERE SessionID = @tmpSessionID) AS T1 ON t1.PrimaryKey = DSR.PrimaryKey
           WHERE DSR.SessionID = @tmpSessionID


	-- The ranking created above has gaps in numbering - take gaps out.
	UPDATE DSR 
		SET DSR.DoctorRank = DR.DRk1
		FROM tblDoctorSearchResult AS DSR
		   INNER JOIN (SELECT PrimaryKey, DENSE_RANK() OVER (ORDER BY DoctorRank) AS DRk1 FROM tblDoctorSearchResult
		WHERE SessionID = @tmpSessionID) AS DR ON DR.PrimaryKey = DSR.PrimaryKey


	--If SessionID is given, return the number of rows instead of the actual data
	IF @SessionID IS NOT NULL
		RETURN @returnValue
	ELSE
		SELECT * FROM tblDoctorSearchResult WHERE SessionID=@SessionID
END
GO
IF @@ERROR <> 0
   AND @@TRANCOUNT > 0
    BEGIN
        ROLLBACK;
    END

IF @@TRANCOUNT = 0
    BEGIN
        INSERT  INTO #tmpErrors (Error)
        VALUES                 (1);
        BEGIN TRANSACTION;
    END


GO


IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT N'The transacted portion of the database update succeeded.'
COMMIT TRANSACTION
END
ELSE PRINT N'The transacted portion of the database update failed.'
GO
DROP TABLE #tmpErrors
GO
PRINT N'Update complete.';


GO


-- Workaround.  Had to set InputSource to NUL initially
--Fill values with 1
--Then we will set column to Not Null
--tblClient and tblWebUser
Update tblClient
set InputSourceID = 1
where 1 = 1

GO

Update tblWebUser
set InputSourceID = 1
where 1 = 1

GO


ALTER TABLE
  tblClient
ALTER COLUMN
  InputSourceID
    INT NOT NULL;

GO



ALTER TABLE
  tblWebUser
ALTER COLUMN
  InputSourceID
    INT NOT NULL;

GO

--Issue 11389 - Changes to ext priority code for mi-Support

DELETE FROM tblDPSPriority

SET IDENTITY_INSERT [dbo].[tblDPSPriority] ON
INSERT INTO [dbo].[tblDPSPriority] ([DPSPriorityID], [Name], [ExtPriorityCode], [DueDateMethod], [DueDateHours], [CancelPriority]) VALUES (1, 'Standard (24hr)', 'Medium', 2, 24, NULL)
INSERT INTO [dbo].[tblDPSPriority] ([DPSPriorityID], [Name], [ExtPriorityCode], [DueDateMethod], [DueDateHours], [CancelPriority]) VALUES (2, 'Rush (4hr)', 'Rush', 1, 4, 1)
INSERT INTO [dbo].[tblDPSPriority] ([DPSPriorityID], [Name], [ExtPriorityCode], [DueDateMethod], [DueDateHours], [CancelPriority]) VALUES (3, 'Complex (48hr)', 'Low', 2, 48, NULL)
INSERT INTO [dbo].[tblDPSPriority] ([DPSPriorityID], [Name], [ExtPriorityCode], [DueDateMethod], [DueDateHours], [CancelPriority]) VALUES (4, 'High (12hr)', 'High', 2, 12, NULL)
SET IDENTITY_INSERT [dbo].[tblDPSPriority] OFF

GO

INSERT INTO [dbo].[tblDoctorBlockTimeSlotStatus] ([DoctorBlockTimeSlotStatusID] ,[Name]) VALUES (0, 'Draft')
INSERT INTO [dbo].[tblDoctorBlockTimeSlotStatus] ([DoctorBlockTimeSlotStatusID] ,[Name]) VALUES (10, 'Open')
INSERT INTO [dbo].[tblDoctorBlockTimeSlotStatus] ([DoctorBlockTimeSlotStatusID] ,[Name]) VALUES (21, 'Reserved')
INSERT INTO [dbo].[tblDoctorBlockTimeSlotStatus] ([DoctorBlockTimeSlotStatusID] ,[Name]) VALUES (22, 'Hold')
INSERT INTO [dbo].[tblDoctorBlockTimeSlotStatus] ([DoctorBlockTimeSlotStatusID] ,[Name]) VALUES (30, 'Scheduled')
GO

INSERT INTO tblUserFunction VALUES ('AckNewPortalAcct', 'Acknowledge - New Portal Accts Auto Provision', '2019-12-12')
GO