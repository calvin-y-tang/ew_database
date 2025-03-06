
PRINT N'Dropping [dbo].[DF_tblControl_AllowCompanyCPTOverride]...';


GO
ALTER TABLE [dbo].[tblControl] DROP CONSTRAINT [DF_tblControl_AllowCompanyCPTOverride];


GO
PRINT N'Dropping [dbo].[DF_tblControl_blnUseIMEWorkflow]...';


GO
ALTER TABLE [dbo].[tblControl] DROP CONSTRAINT [DF_tblControl_blnUseIMEWorkflow];


GO
PRINT N'Dropping [dbo].[DF_tblControl_FeeScheduleSetting]...';


GO
ALTER TABLE [dbo].[tblControl] DROP CONSTRAINT [DF_tblControl_FeeScheduleSetting];


GO
PRINT N'Dropping [dbo].[DF_tblIMEData_brqinternalcasenbr]...';


GO
ALTER TABLE [dbo].[tblIMEData] DROP CONSTRAINT [DF_tblIMEData_brqinternalcasenbr];


GO
PRINT N'Dropping [dbo].[DF_tblIMEData_IncludeSubCaseOnMaster]...';


GO
ALTER TABLE [dbo].[tblIMEData] DROP CONSTRAINT [DF_tblIMEData_IncludeSubCaseOnMaster];


GO
PRINT N'Dropping [dbo].[DF_tblIMEData_UseBillingCompany]...';


GO
ALTER TABLE [dbo].[tblIMEData] DROP CONSTRAINT [DF_tblIMEData_UseBillingCompany];


GO
PRINT N'Dropping [dbo].[DF_tblIMEData_UseHCAIInterface]...';


GO
ALTER TABLE [dbo].[tblIMEData] DROP CONSTRAINT [DF_tblIMEData_UseHCAIInterface];


GO
PRINT N'Dropping [dbo].[vwCaseHistoryDesc]...';


GO
DROP VIEW [dbo].[vwCaseHistoryDesc];


GO
PRINT N'Dropping [dbo].[vwcustomdoctorschedule]...';


GO
DROP VIEW [dbo].[vwcustomdoctorschedule];


GO
PRINT N'Dropping [dbo].[vwDaySheetWithOffice]...';


GO
DROP VIEW [dbo].[vwDaySheetWithOffice];


GO
PRINT N'Dropping [dbo].[vwDoctorScheduleBMC]...';


GO
DROP VIEW [dbo].[vwDoctorScheduleBMC];


GO
PRINT N'Dropping [dbo].[vwDoctorSchedulewithOffice]...';


GO
DROP VIEW [dbo].[vwDoctorSchedulewithOffice];


GO
PRINT N'Dropping [dbo].[vwfeeschedulerpt]...';


GO
DROP VIEW [dbo].[vwfeeschedulerpt];


GO
PRINT N'Dropping [dbo].[vwUserOffice]...';


GO
DROP VIEW [dbo].[vwUserOffice];


GO
PRINT N'Dropping [dbo].[proc_tblClientInsert]...';


GO
DROP PROCEDURE [dbo].[proc_tblClientInsert];


GO
PRINT N'Dropping [dbo].[proc_tblClientUpdate]...';


GO
DROP PROCEDURE [dbo].[proc_tblClientUpdate];


GO
PRINT N'Dropping [dbo].[proc_ValidateUserNew]...';


GO
DROP PROCEDURE [dbo].[proc_ValidateUserNew];


GO
PRINT N'Dropping [dbo].[spCaseHistoryDesc]...';


GO
DROP PROCEDURE [dbo].[spCaseHistoryDesc];


GO
PRINT N'Dropping [dbo].[SPExamineeCombo]...';


GO
DROP PROCEDURE [dbo].[SPExamineeCombo];


GO
PRINT N'Altering [dbo].[tblControl]...';


GO
ALTER TABLE [dbo].[tblControl] DROP COLUMN [ActivationKey], COLUMN [AllowCompanyCPTOverride], COLUMN [Authentication], COLUMN [blnUseIMEWorkflow], COLUMN [FeeScheduleSetting], COLUMN [InstallCode], COLUMN [LastWebCutOffDate], COLUMN [LastWebCutOffSuccessDate], COLUMN [LastWebSynchDate], COLUMN [LogToFile], COLUMN [MRUSize], COLUMN [QBPGMVersion], COLUMN [UsePeerBill];


GO
PRINT N'Altering [dbo].[tblIMEData]...';


GO
ALTER TABLE [dbo].[tblIMEData] DROP COLUMN [AccountingSystem], COLUMN [Addr1], COLUMN [Addr2], COLUMN [AllowICD10], COLUMN [ApptDuration], COLUMN [ATSecurityProfileID], COLUMN [blnUseSubCases], COLUMN [BrqInternalCaseNbr], COLUMN [CalcTaxOnVouchers], COLUMN [City], COLUMN [CLSecurityProfileID], COLUMN [CountryID], COLUMN [CreateVouchers], COLUMN [DefAPAcctNbr], COLUMN [DefARAcctNbr], COLUMN [DefaultICDFormat], COLUMN [DirDictationFiles], COLUMN [DirDirections], COLUMN [DirIMECentricHelper], COLUMN [DirRptCoverLetter], COLUMN [DirTemplate], COLUMN [DirVoicePlayer], COLUMN [DirWebQuickReferralFiles], COLUMN [DrDocFolderID], COLUMN [DRSecurityProfileID], COLUMN [EmailCapability], COLUMN [Fax], COLUMN [FaxCapability], COLUMN [FaxCoverPage], COLUMN [FaxServerName], COLUMN [FaxServerType], COLUMN [IMEAccount], COLUMN [IMECreate], COLUMN [IncludeSubCaseOnMaster], COLUMN [InvoiceDate], COLUMN [LabelCapability], COLUMN [Logo], COLUMN [MedsRecdDocument], COLUMN [MultiPortal], COLUMN [NextBatchNbr], COLUMN [NextEDIBatchNbr], COLUMN [NextInvoiceNbr], COLUMN [NextVoucherNbr], COLUMN [OPSecurityProfileID], COLUMN [Phone], COLUMN [QBCustMask], COLUMN [QBVendorMask], COLUMN [RequirePDF], COLUMN [SerialNumber], COLUMN [State], COLUMN [SupportCompany], COLUMN [SupportEmail], COLUMN [TaxCode], COLUMN [TranscriptionCapability], COLUMN [TRSecurityProfileID], COLUMN [UseBillingCompany], COLUMN [UseCustomRptCoverLetterDir], COLUMN [UseHCAIInterface], COLUMN [UseMutipleTreatingPhysicians], COLUMN [Website], COLUMN [WorkHourEnd], COLUMN [WorkHourStart], COLUMN [Zip];


GO
PRINT N'Creating [dbo].[tblFolderOffice]...';


GO
CREATE TABLE [dbo].[tblFolderOffice] (
    [FolderID]    INT          NOT NULL,
    [OfficeCode]  INT          NOT NULL,
    [DateAdded]   DATETIME     NULL,
    [UserIDAdded] VARCHAR (15) NULL,
    CONSTRAINT [PK_tblFolderOffice] PRIMARY KEY CLUSTERED ([FolderID] ASC, [OfficeCode] ASC)
);


GO
PRINT N'Altering [dbo].[fnGetTATMins]...';


GO


--Calculate TAT Elapsed Time in Minutes
ALTER FUNCTION fnGetTATMins
(
 @startDate DATETIME,
 @endDate DATETIME
)
RETURNS INT
AS
BEGIN

--Declare and initialize variables
DECLARE @minStart INT
DECLARE @minEnd INT
DECLARE @days INT


SELECT @minStart = 0
SELECT @minEnd = 0
SELECT @days = 0

--Load system settings
DECLARE @workHourStart INT
DECLARE @workHourEnd INT
SELECT TOP 1 @workHourStart = WorkHourStart, @workHourEnd=WorkHourEnd FROM dbo.tblControl ORDER BY InstallID

--Temp variables used for calculation
DECLARE @hourStart DATETIME
DECLARE @hourEnd DATETIME
DECLARE @tmpDateTime DATETIME

 --Get the working minutes on the start day
 IF dbo.fnIsWorkDay(@startDate) = 1
  BEGIN
   --If the start time of the start date is before working hours start, use working hours start instead
   SELECT @tmpDateTime = DATEADD(hh, @workHourStart, dbo.fnDateValue(@startDate))
   IF @startDate > @tmpDateTime
    SELECT @hourStart = @startDate
   ELSE
    SELECT @hourStart = @tmpDateTime
   
   --if the end date is actually the same date as start AND before the working hours end, then use the end date time,
   --otherwise use the working hours end of the start date portion
   SELECT @tmpDateTime = DATEADD(hh, @workHourEnd, dbo.fnDateValue(@startDate))
   IF @endDate < @tmpDateTime
    SELECT @hourEnd = @endDate
   ELSE
    SELECT @hourEnd = @tmpDateTime

   --in case start and end time are both before working hours start OR both after working hours end
   --hours start can be after hour end, then just ignore and return 0 for minStart
   IF @hourStart < @hourEnd
    SELECT @minStart = DATEDIFF(n, @hourStart, @hourEnd)
  END

    --Only if start and end date are no the same day
    DECLARE @dateToCheck DATETIME
    SELECT @dateToCheck = DateAdd(d, 1, @startDate)
    --loop thru each day in between and see which one is working day
    While @dateToCheck < dbo.fnDateValue(@endDate)
 BEGIN
  If dbo.fnIsWorkDay(@dateToCheck) = 1
   SELECT @days = @days + 1
  SELECT @dateToCheck = DateAdd(d, 1, @dateToCheck)
 END

    --If end date is a working day and is not the same as start date, calculate the working minutes
    If dbo.fnIsWorkDay(@endDate) = 1 And (dbo.fnDateValue(@startDate) < dbo.fnDateValue(@endDate))
    BEGIN
        --Similar logic as minStart, calculate minEnd for end date
        SELECT @tmpDateTime = DateAdd(hh, @workHourStart, dbo.fnDateValue(@endDate))
        If @startDate > @tmpDateTime
            SELECT @hourStart = @startDate
        Else
            SELECT @hourStart = @tmpDateTime

        SELECT @tmpDateTime = DateAdd(hh, @workHourEnd, dbo.fnDateValue(@endDate))
        If @endDate < @tmpDateTime
            SELECT @hourEnd = @endDate
        Else
            SELECT @hourEnd = @tmpDateTime
        If @hourStart < @hourEnd
   SELECT @minEnd = DateDiff(n, @hourStart, @hourEnd)
    END
    
    --Return the total working time in minutes
 RETURN @minStart + (@days * (@workHourEnd - @workHourStart) * 60) + @minEnd
END
GO
PRINT N'Altering [dbo].[fnGetTATString]...';


GO



--Format TAT into formatted string
ALTER FUNCTION fnGetTATString 
(
 @tat INT
)
RETURNS VARCHAR(20)
AS
BEGIN

--Declare and initialize variables
DECLARE @days INT
DECLARE @hours INT
DECLARE @mins INT
DECLARE @workHourPerDay INT
 
 SELECT TOP 1 @workHourPerDay = WorkHourEnd-WorkHourStart FROM tblControl ORDER BY InstallID
            
    SELECT @hours = FLOOR(@tat / 60)
    SELECT @mins = @tat % 60
    SELECT @days = FLOOR(@hours / @workHourPerDay)
    SELECT @hours = @hours % @workHourPerDay
            
    --Only return non zero values
    DECLARE @result VARCHAR(20)
    SELECT @result = ''
    If @days > 0
  SELECT @result = CAST(@days AS VARCHAR) + 'd '
    If @hours > 0
  SELECT @result = @result + CAST(@hours AS VARCHAR) + 'h '
    If @mins > 0
  SELECT @result = @result + CAST(@mins AS VARCHAR) + 'm '
    SELECT @result = RTRIM(@result)
    --If all zero, use "< 1m" rather than empty string
    If @result = ''
  SELECT @result = '< 1m'
    RETURN @result
END
GO
PRINT N'Altering [dbo].[vwclient]...';


GO
ALTER VIEW [dbo].[vwclient]
AS
    SELECT DISTINCT
            tblClient.LastName + ', ' + tblClient.FirstName AS Client ,
            tblCompany.IntName ,
            tblClient.Status ,
            tblClient.Email ,
            tblClient.LastName ,
            tblClient.FirstName ,
            tblClient.Addr1 ,
            tblClient.Addr2 ,
            tblClient.City ,
            tblClient.State ,
            tblClient.Zip ,
            tblClient.Phone1 ,
            tblClient.Phone1Ext ,
            tblClient.Fax ,
            tblClient.CaseType ,
            tblClient.CompanyCode ,
            tblCompany.ExtName ,
            tblClient.ClientCode ,
            tblEWFacility.LegalName AS CompanyName ,
            tblCase.OfficeCode ,
            tblClient.Prefix
    FROM    tblClient
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblCase ON tblClient.ClientCode = tblCase.ClientCode
            INNER JOIN tblOffice ON tblCase.OfficeCode = tblOffice.OfficeCode
            INNER JOIN tblEWFacility ON tblOffice.EWFacilityID = tblEWFacility.EWFacilityID;
GO
PRINT N'Altering [dbo].[vwDoctorSchedule]...';


GO
ALTER VIEW vwDoctorSchedule
AS
    SELECT  tblDoctorSchedule.LocationCode ,
            tblDoctorSchedule.date ,
            tblDoctorSchedule.StartTime ,
            tblDoctorSchedule.Description ,
            tblDoctorSchedule.Status ,
            tblDoctorSchedule.DoctorCode ,
            tblDoctorSchedule.SchedCode ,
            tblCase.CaseNbr ,
            tblCompany.ExtName AS Company ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS ExamineeName ,
            tblLocation.Location ,
            tblEWFacility.LegalName AS CompanyName ,
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName,
                                                           '') + ', '
            + ISNULL(tblDoctor.Credentials, '') AS DoctorName ,
            tblCase.ClaimNbr ,
            tblClient.FirstName + ' ' + tblClient.LastName AS ClientName ,
            tblCaseType.Description AS Casetypedesc ,
            tblServices.Description AS Servicedesc ,
            CAST(tblCase.SpecialInstructions AS VARCHAR(1000)) AS specialinstructions ,
            tblCase.WCBNbr ,
            tblLocation.Phone AS DoctorPhone ,
            tblLocation.Fax AS DoctorFax ,
            tblCase.PhotoRqd ,
            tblClient.Phone1 AS ClientPhone ,
            tblCase.DoctorName AS Paneldesc ,
            tblCase.PanelNbr ,
            NULL AS Panelnote ,
            tblCase.OfficeCode ,
            CASE WHEN tblCase.CaseNbr IS NULL
                 THEN tblDoctorSchedule.CaseNbr1desc
                 ELSE NULL
            END AS ScheduleDescription ,
            tblServices.ShortDesc ,
            tblEWFacility.Fax ,
            CASE WHEN tblCase.InterpreterRequired = 1 THEN 'Interpreter'
                 ELSE ''
            END AS Interpreter ,
            tblDoctorSchedule.Duration ,
            tblCompany.IntName AS CompanyIntName ,
            CASE WHEN ( SELECT TOP 1
                                Type
                        FROM    tblRecordHistory
                        WHERE   Type = 'F'
                                AND CaseNbr = tblCase.CaseNbr
                      ) = 'F' THEN 'Films'
                 ELSE ''
            END AS films
    FROM    tblCase
            INNER JOIN tblClient ON tblClient.ClientCode = tblCase.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblDoctorSchedule ON tblDoctorSchedule.SchedCode = tblCase.SchedCode
            INNER JOIN tblDoctor ON tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode 
			INNER JOIN tblLocation ON tblLocation.LocationCode = tblDoctorSchedule.LocationCode
            INNER JOIN tblCaseType ON tblCaseType.Code = tblCase.CaseType
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblOffice ON tblOffice.OfficeCode = tblCase.OfficeCode
            INNER JOIN tblEWFacility ON tblEWFacility.EWFacilityID = tblOffice.EWFacilityID
    WHERE   ( tblDoctorSchedule.Status = 'open' )
            OR ( tblDoctorSchedule.Status = 'Hold' )
            OR ( ( tblDoctorSchedule.Status = 'Scheduled' )
                 AND ( tblCase.SchedCode IS NOT NULL )
               )
    UNION
    SELECT  tblDoctorSchedule.LocationCode ,
            tblDoctorSchedule.date ,
            tblDoctorSchedule.StartTime ,
            tblDoctorSchedule.Description ,
            tblDoctorSchedule.Status ,
            tblDoctorSchedule.DoctorCode ,
            tblDoctorSchedule.SchedCode ,
            tblCase.CaseNbr ,
            tblCompany.ExtName AS Company ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS ExamineeName ,
            tblLocation.Location ,
            tblEWFacility.LegalName AS CompanyName ,
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName,
                                                           '') + ', '
            + ISNULL(tblDoctor.Credentials, '') AS DoctorName ,
            tblCase.ClaimNbr ,
            tblClient.FirstName + ' ' + tblClient.LastName AS ClientName ,
            tblCaseType.Description AS Casetypedesc ,
            tblServices.Description AS Servicedesc ,
            CAST(tblCase.SpecialInstructions AS VARCHAR(1000)) AS specialinstructions ,
            tblCase.WCBNbr ,
            tblLocation.Phone AS DoctorPhone ,
            tblLocation.Fax AS DoctorFax ,
            tblCase.PhotoRqd ,
            tblClient.Phone1 AS ClientPhone ,
            tblCase.DoctorName AS Paneldesc ,
            tblCase.PanelNbr ,
            CAST(tblCasePanel.PanelNote AS VARCHAR(50)) AS Panelnote ,
            tblCase.OfficeCode ,
            CASE WHEN tblCase.CaseNbr IS NULL
                 THEN tblDoctorSchedule.CaseNbr1desc
                 ELSE NULL
            END AS ScheduleDescription ,
            tblServices.ShortDesc ,
            tblEWFacility.Fax ,
            CASE WHEN tblCase.InterpreterRequired = 1 THEN 'Interpreter'
                 ELSE ''
            END AS Interpreter ,
            tblDoctorSchedule.Duration ,
            tblCompany.IntName AS CompanyIntName ,
            CASE WHEN ( SELECT TOP 1
                                Type
                        FROM    tblRecordHistory
                        WHERE   Type = 'F'
                                AND CaseNbr = tblCase.CaseNbr
                      ) = 'F' THEN 'Films'
                 ELSE ''
            END AS films
    FROM    tblCase
            INNER JOIN tblClient ON tblClient.ClientCode = tblCase.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblCasePanel ON tblCase.PanelNbr = tblCasePanel.PanelNbr
            INNER JOIN tblDoctorSchedule ON tblCasePanel.SchedCode = tblDoctorSchedule.SchedCode
            INNER JOIN tblDoctor ON tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode 
			INNER JOIN tblLocation ON tblLocation.LocationCode = tblDoctorSchedule.LocationCode
            INNER JOIN tblCaseType ON tblCaseType.Code = tblCase.CaseType
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblOffice ON tblOffice.OfficeCode = tblCase.OfficeCode
            INNER JOIN tblEWFacility ON tblEWFacility.EWFacilityID = tblOffice.EWFacilityID
    WHERE   ( ( tblDoctorSchedule.Status = 'open' )
              OR ( tblDoctorSchedule.Status = 'Scheduled' )
              OR ( tblDoctorSchedule.Status = 'Hold' )
            )
            AND tblCase.PanelNbr IS NOT NULL;
GO
PRINT N'Altering [dbo].[vwDoctorScheduleMEI]...';


GO
ALTER VIEW vwDoctorScheduleMEI
AS
    SELECT  tblDoctorSchedule.date ,
            tblDoctorSchedule.StartTime ,
            tblDoctorSchedule.Status ,
            tblDoctorSchedule.DoctorCode ,
            tblDoctorSchedule.SchedCode ,
            tblCase.CaseNbr ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS examineename ,
            tblLocation.Location ,
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName,
                                                           '') + ', '
            + ISNULL(tblDoctor.Credentials, '') AS doctorname ,
            tblLocation.Phone AS doctorphone ,
            tblLocation.Fax AS doctorfax ,
            tblCase.PanelNbr ,
            tblDoctorOffice.OfficeCode ,
            CASE WHEN tblCase.InterpreterRequired = 1 THEN 'Interpreter'
                 ELSE ''
            END AS Interpreter ,
            tblExaminee.Sex ,
            tblLocation.Addr1 ,
            tblLocation.Addr2 ,
            tblLocation.City ,
            tblLocation.State ,
            tblLocation.Zip ,
            tblEWFacility.LegalName AS CompanyName ,
            tblLocation.LocationCode ,
            tblServices.ShortDesc
    FROM    tblLocation
            INNER JOIN tblDoctorSchedule
            INNER JOIN tblDoctor ON tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode ON tblLocation.LocationCode = tblDoctorSchedule.LocationCode
            LEFT OUTER JOIN tblCaseType
            INNER JOIN tblClient
            INNER JOIN tblCase ON tblClient.ClientCode = tblCase.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr ON tblCaseType.Code = tblCase.CaseType
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode ON tblDoctorSchedule.SchedCode = tblCase.SchedCode
            LEFT OUTER JOIN tblEWFacility
            INNER JOIN tblOffice
            INNER JOIN tblDoctorOffice ON tblOffice.OfficeCode = tblDoctorOffice.OfficeCode ON tblEWFacility.EWFacilityID = tblOffice.EWFacilityID ON tblDoctorSchedule.DoctorCode = tblDoctorOffice.DoctorCode
    WHERE   ( tblDoctorSchedule.Status = 'open' )
            OR ( tblDoctorSchedule.Status = 'Hold' )
            OR ( tblDoctorSchedule.Status = 'scheduled' )
            AND ( tblCase.SchedCode IS NOT NULL );
GO
PRINT N'Altering [dbo].[vw_WebCaseSummary]...';


GO
ALTER VIEW vw_WebCaseSummary

AS

SELECT     
	--case     
	tblCase.casenbr,
	tblCase.chartnbr,
	tblCase.doctorlocation,
	tblCase.clientcode,
	tblCase.Appttime,
	tblCase.dateofinjury,
	REPLACE(REPLACE(REPLACE(CAST(tblCase.notes AS VARCHAR(2000)),CHAR(10),' '),CHAR(13),' '),CHAR(9),' ') notes,
	tblCase.DoctorName,
	tblCase.ClaimNbrExt,
	tblCase.ApptDate,
	tblCase.claimnbr,
	tblCase.jurisdiction,
	tblCase.WCBNbr,
	tblCase.specialinstructions,
	tblCase.HearingDate,
	tblCase.requesteddoc,
	tblCase.sreqspecialty,
	tblCase.schedulenotes,
	tblCase.AttorneyNote,
	tblCase.BillingNote,
	
	--examinee
	tblExaminee.lastname,
	tblExaminee.firstname,
	tblExaminee.addr1,
	tblExaminee.addr2,
	tblExaminee.city,
	tblExaminee.state,
	tblExaminee.zip,
	tblExaminee.phone1,
	tblExaminee.phone2,
	tblExaminee.SSN,
	tblExaminee.sex,
	tblExaminee.DOB,
	tblExaminee.note,
	tblExaminee.county,
	tblExaminee.prefix,
	tblExaminee.fax,
	tblExaminee.email,
	tblExaminee.insured,
	tblExaminee.employer,
	tblExaminee.treatingphysician,
	tblExaminee.InsuredAddr1,
	tblExaminee.InsuredCity,
	tblExaminee.InsuredState,
	tblExaminee.InsuredZip,
	tblExaminee.InsuredSex,
	tblExaminee.InsuredRelationship,
	tblExaminee.InsuredPhone,
	tblExaminee.InsuredPhoneExt,
	tblExaminee.InsuredFax,
	tblExaminee.InsuredEmail,
	tblExaminee.ExamineeStatus,
	tblExaminee.TreatingPhysicianAddr1,
	tblExaminee.TreatingPhysicianCity,
	tblExaminee.TreatingPhysicianState,
	tblExaminee.TreatingPhysicianZip,
	tblExaminee.TreatingPhysicianPhone,
	tblExaminee.TreatingPhysicianPhoneExt,
	tblExaminee.TreatingPhysicianFax,
	tblExaminee.TreatingPhysicianEmail,
	tblExaminee.EmployerAddr1,
	tblExaminee.EmployerCity,
	tblExaminee.EmployerState,
	tblExaminee.EmployerZip,
	tblExaminee.EmployerPhone,
	tblExaminee.EmployerPhoneExt,
	tblExaminee.EmployerFax,
	tblExaminee.EmployerEmail,
	tblExaminee.Country,
	tblExaminee.policynumber,
	tblExaminee.EmployerContactFirstName,
	tblExaminee.EmployerContactLastName,
	tblExaminee.TreatingPhysicianLicenseNbr,
	tblExaminee.TreatingPhysicianTaxID,

	--case type
	tblCaseType.code,
	tblCaseType.description,
	tblCaseType.instructionfilename,
	tblCaseType.WebID,
	tblCaseType.ShortDesc,

	--services
	tblServices.description AS servicedescription,
	tblServices.DaysToCommitDate,
	tblServices.CalcFrom,
	tblServices.ServiceType,

	--office
	tblOffice.description AS officedesc,

	--client
	tblClient.companycode,
	tblClient.clientnbrold,
	tblClient.lastname AS clientlname,
	tblClient.firstname AS clientfname,

	--defense attorney
	cc1.cccode,
	cc1.lastname AS defattlastname,
	cc1.firstname AS defattfirstname,
	cc1.company AS defattcompany,
	cc1.address1 AS defattadd1,
	cc1.address2 AS defattadd2,
	cc1.city AS defattcity,
	cc1.state AS defattstate,
	cc1.zip AS defattzip,
	cc1.phone AS defattphone,
	cc1.phoneextension AS defattphonext,
	cc1.fax AS defattfax,
	cc1.email AS defattemail,
	cc1.prefix AS defattprefix,

	--plaintiff attorney
	cc2.lastname AS plaintattlastname,
	cc2.firstname AS plaintattfirstname,
	cc2.company AS plaintattcompany,
	cc2.address1 AS plaintattadd1,
	cc2.address2 AS plaintattadd2,
	cc2.city AS plaintattcity,
	cc2.state AS plaintattstate,
	cc2.zip AS plaintattzip,
	cc2.phone AS plaintattphone,
	cc2.phoneextension AS plaintattphonext,
	cc2.fax AS plaintattfax,
	cc2.email AS plaintattemail,
	cc2.prefix AS plaintattprefix

FROM tblCase 
	INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr 
	LEFT OUTER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code 
	LEFT OUTER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode 
	LEFT OUTER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode 
	LEFT OUTER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode 
	LEFT OUTER JOIN tblCCAddress AS cc1 ON tblCase.defenseattorneycode = cc1.cccode 
	LEFT OUTER JOIN tblCCAddress AS cc2 ON tblCase.plaintiffattorneycode = cc2.cccode
GO
PRINT N'Altering [dbo].[vw_WebCaseSummaryExt]...';


GO
ALTER VIEW vw_WebCaseSummaryExt

AS

SELECT     
	--case     
	tblCase.casenbr,
	tblCase.chartnbr,
	tblCase.doctorlocation,
	tblCase.clientcode,
	tblCase.Appttime,
	tblCase.dateofinjury,
	REPLACE(REPLACE(REPLACE(CAST(tblCase.notes AS VARCHAR(2000)),CHAR(10),' '),CHAR(13),' '),CHAR(9),' ') notes,
	tblCase.DoctorName,
	tblCase.ClaimNbrExt,
	tblCase.ApptDate,
	tblCase.claimnbr,
	tblCase.jurisdiction,
	tblCase.WCBNbr,
	tblCase.specialinstructions,
	tblCase.HearingDate,
	tblCase.requesteddoc,
	tblCase.sreqspecialty,
	tblCase.schedulenotes,
	tblCase.TransportationRequired,
	tblCase.InterpreterRequired,
	tblCase.LanguageID,
	tblCase.AttorneyNote,
	tblCase.BillingNote,
	
	--examinee
	tblExaminee.lastname,
	tblExaminee.firstname,
	tblExaminee.addr1,
	tblExaminee.addr2,
	tblExaminee.city,
	tblExaminee.state,
	tblExaminee.zip,
	tblExaminee.phone1,
	tblExaminee.phone2,
	tblExaminee.SSN,
	tblExaminee.sex,
	tblExaminee.DOB,
	tblExaminee.note,
	tblExaminee.county,
	tblExaminee.prefix,
	tblExaminee.fax,
	tblExaminee.email,
	tblExaminee.insured,
	tblExaminee.employer,
	tblExaminee.treatingphysician,
	tblExaminee.InsuredAddr1,
	tblExaminee.InsuredCity,
	tblExaminee.InsuredState,
	tblExaminee.InsuredZip,
	tblExaminee.InsuredSex,
	tblExaminee.InsuredRelationship,
	tblExaminee.InsuredPhone,
	tblExaminee.InsuredPhoneExt,
	tblExaminee.InsuredFax,
	tblExaminee.InsuredEmail,
	tblExaminee.ExamineeStatus,
	tblExaminee.TreatingPhysicianAddr1,
	tblExaminee.TreatingPhysicianCity,
	tblExaminee.TreatingPhysicianState,
	tblExaminee.TreatingPhysicianZip,
	tblExaminee.TreatingPhysicianPhone,
	tblExaminee.TreatingPhysicianPhoneExt,
	tblExaminee.TreatingPhysicianFax,
	tblExaminee.TreatingPhysicianEmail,
	tblExaminee.TreatingPhysicianDiagnosis,
	tblExaminee.EmployerAddr1,
	tblExaminee.EmployerCity,
	tblExaminee.EmployerState,
	tblExaminee.EmployerZip,
	tblExaminee.EmployerPhone,
	tblExaminee.EmployerPhoneExt,
	tblExaminee.EmployerFax,
	tblExaminee.EmployerEmail,
	tblExaminee.Country,
	tblExaminee.policynumber,
	tblExaminee.EmployerContactFirstName,
	tblExaminee.EmployerContactLastName,
	tblExaminee.TreatingPhysicianLicenseNbr,
	tblExaminee.TreatingPhysicianTaxID,
	tblExaminee.note AS StateDirected,

	--case type
	tblCaseType.code,
	tblCaseType.description,
	tblCaseType.instructionfilename,
	tblCaseType.WebID,
	tblCaseType.ShortDesc,

	--services
	tblServices.description AS servicedescription,
	tblServices.DaysToCommitDate,
	tblServices.CalcFrom,
	tblServices.ServiceType,

	--office
	tblOffice.description AS officedesc,

	--client
	tblClient.companycode,
	tblClient.clientnbrold,
	tblClient.lastname AS clientlname,
	tblClient.firstname AS clientfname,
	tblClient.phone1 AS ClientPhone,
	tblClient.email AS ClientEmail,
	tblClient.fax AS ClientFax,
	tblClient.notes AS ClientOffice,

	--defense attorney
	cc1.cccode,
	cc1.lastname AS defattlastname,
	cc1.firstname AS defattfirstname,
	cc1.company AS defattcompany,
	cc1.address1 AS defattadd1,
	cc1.address2 AS defattadd2,
	cc1.city AS defattcity,
	cc1.state AS defattstate,
	cc1.zip AS defattzip,
	cc1.phone AS defattphone,
	cc1.phoneextension AS defattphonext,
	cc1.fax AS defattfax,
	cc1.email AS defattemail,
	cc1.prefix AS defattprefix,

	--plaintiff attorney
	cc2.lastname AS plaintattlastname,
	cc2.firstname AS plaintattfirstname,
	cc2.company AS plaintattcompany,
	cc2.address1 AS plaintattadd1,
	cc2.address2 AS plaintattadd2,
	cc2.city AS plaintattcity,
	cc2.state AS plaintattstate,
	cc2.zip AS plaintattzip,
	cc2.phone AS plaintattphone,
	cc2.phoneextension AS plaintattphonext,
	cc2.fax AS plaintattfax,
	cc2.email AS plaintattemail,
	cc2.prefix AS plaintattprefix,

	--company
	tblCompany.extname AS InsCompanyName,
	tblCompany.addr1 AS InsCompanyAddress1,
	tblCompany.addr2 AS InsCompanyAddress2,
	tblCompany.city AS InsCompanyCity,
	tblCompany.state AS InsCompanyState,
	tblCompany.zip AS InsCompanyZip,

	--case manager
	tblRelatedParty.firstname AS CaseManagerFirstName,
	tblRelatedParty.lastname AS CaseManagerLastName,
	tblRelatedParty.address1 AS CaseManagerAddress1,
	tblRelatedParty.address2 AS CaseManagerAddress2,
	tblRelatedParty.city AS CaseManagerCity,
	tblRelatedParty.state AS CaseManagerState,
	tblRelatedParty.zip as CaseManagerZip,
	tblRelatedParty.companyname AS CaseManagerOffice,
	tblRelatedParty.phone as CaseManagerPhone,
	tblRelatedParty.fax as CaseManagerFax,
	tblRelatedParty.email as CaseManagerEmail,

	--language
	tblLanguage.Description as LanguageDescription

FROM tblCase 
	INNER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
	INNER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
	INNER JOIN tblCompany ON tblClient.companycode = tblCompany.companycode 
	LEFT OUTER  JOIN tblLanguage ON tblCase.LanguageID = tblLanguage.LanguageID
	LEFT OUTER JOIN tblCaseRelatedParty ON tblCase.casenbr = tblCaseRelatedParty.casenbr
	LEFT OUTER JOIN tblRelatedParty ON tblCaseRelatedParty.RPCode = tblRelatedParty.RPCode
	LEFT OUTER JOIN tblCaseType ON tblCase.casetype = tblCaseType.code 
	LEFT OUTER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode 
	LEFT OUTER JOIN tblOffice ON tblCase.officecode = tblOffice.officecode 
	LEFT OUTER JOIN tblCCAddress AS cc1 ON tblCase.defenseattorneycode = cc1.cccode 
	LEFT OUTER JOIN tblCCAddress AS cc2 ON tblCase.plaintiffattorneycode = cc2.cccode
GO
PRINT N'Altering [dbo].[vwCCs]...';


GO
ALTER VIEW vwCCs
AS
    SELECT  ccCode ,
            COALESCE(Company, LastName + ', ' + FirstName, LastName, FirstName) AS CompanyOrderDisplayName ,
            COALESCE(LastName + ', ' + FirstName, LastName, FirstName) AS Contact ,
            COALESCE(LastName + ', ' + FirstName, LastName, FirstName, Company) AS ContactOrderDisplayName ,
            Company ,
            City ,
            State ,
            Status
    FROM    tblCCAddress
GO
PRINT N'Altering [dbo].[vwClientDefaults]...';


GO
ALTER VIEW vwClientDefaults
AS
    SELECT  CL.marketercode AS ClientMarketer ,
            COM.IntName ,
			ISNULL(COM.EWCompanyID, 0) AS EWCompanyID, 
            CL.ReportPhone ,
            CL.Priority ,
            CL.ClientCode ,
            CL.fax ,
            CL.email ,
            CL.phone1 ,
            CL.documentemail AS EmailClient ,
            CL.documentfax AS FaxClient ,
            CL.documentmail AS MailClient ,
            ISNULL(CL.casetype, COM.CaseType) AS CaseType ,
            CL.feeschedule ,
            COM.credithold ,
            COM.preinvoice ,
            CL.billaddr1 ,
            CL.billaddr2 ,
            CL.billcity ,
            CL.billstate ,
            CL.billzip ,
            CL.billattn ,
            CL.ARKey ,
            CL.addr1 ,
            CL.addr2 ,
            CL.city ,
            CL.state ,
            CL.zip ,
            CL.firstname + ' ' + CL.lastname AS clientname ,
            CL.prefix AS clientprefix ,
            CL.suffix AS clientsuffix ,
            CL.lastname ,
            CL.firstname ,
            CL.billfax ,
            CL.QARep ,
            ISNULL(CL.photoRqd, COM.photoRqd) AS photoRqd ,
            CL.CertifiedMail ,
            CL.PublishOnWeb ,
            CL.UseNotificationOverrides ,
            CL.CSR1 ,
            CL.CSR2 ,
            CL.AutoReschedule ,
            CLO.OfficeCode AS DefOfficeCode ,
            ISNULL(CL.marketercode, COM.marketercode) AS marketer ,
            COM.Jurisdiction ,
			CL.CreateCvrLtr|COM.CreateCvrLtr As CreateCvrLtr
    FROM    tblClient AS CL
            INNER JOIN tblCompany AS COM ON CL.companycode = COM.companycode
			LEFT OUTER JOIN tblClientOffice AS CLO ON CLO.ClientCode = CL.ClientCode AND CLO.IsDefault=1
GO
PRINT N'Altering [dbo].[vwExceptionDefinitionListing]...';


GO
ALTER VIEW vwExceptionDefinitionListing
AS
    SELECT  tblExceptionDefinition.Description ,
            tblExceptionDefinition.Entity ,
            tblExceptionList.Description AS ExceptionDesc ,
            ISNULL(tblCaseType.Description, 'All') AS CaseType ,
            ISNULL(tblServices.Description, 'All') AS Service ,
            ISNULL(tblQueues.StatusDesc, 'All') AS Status ,
            tblExceptionDefinition.StatusCodeValue ,
            tblExceptionDefinition.DisplayMessage ,
            tblExceptionDefinition.RequireComment ,
            tblExceptionDefinition.EmailMessage ,
            tblExceptionDefinition.GenerateDocument ,
            tblExceptionDefinition.Message ,
            tblExceptionDefinition.EditEmail ,
            tblExceptionDefinition.EmailScheduler ,
            tblExceptionDefinition.EmailQA ,
            tblExceptionDefinition.EmailOther ,
            tblExceptionDefinition.EmailSubject ,
            tblExceptionDefinition.EmailText ,
            tblExceptionDefinition.Document1 ,
            tblExceptionDefinition.Document2 ,
            tblExceptionDefinition.Status AS Active ,
            tblExceptionDefinition.DateAdded ,
            tblExceptionDefinition.UserIDAdded ,
            tblExceptionDefinition.DateEdited ,
            tblExceptionDefinition.UserIDEdited ,
            '' AS EntityDescription ,
			ExceptionDefID ,
			AllOffice
    FROM    tblExceptionDefinition
            INNER JOIN tblExceptionList ON tblExceptionDefinition.ExceptionID = tblExceptionList.ExceptionID
            LEFT OUTER JOIN tblQueues ON tblExceptionDefinition.StatusCode = tblQueues.StatusCode
            LEFT OUTER JOIN tblServices ON tblExceptionDefinition.ServiceCode = tblServices.ServiceCode
            LEFT OUTER JOIN tblCaseType ON tblExceptionDefinition.CaseTypeCode = tblCaseType.Code
GO
PRINT N'Altering [dbo].[vwLibertyExport]...';


GO
ALTER VIEW vwLibertyExport
AS
    SELECT  tblCase.DateReceived ,
            tblCase.ClaimNbr ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS ExamineeName ,
            tblClient.LastName + '. ' + tblClient.FirstName AS ClientName ,
            tblCase.Jurisdiction ,
            tblAcctHeader.ApptDate ,
            tblDoctor.LastName + ', ' + tblDoctor.FirstName AS Doctorname ,
            tblSpecialty.Description AS Specialty ,
            tblAcctHeader.DocumentTotal AS Charge ,
            tblAcctHeader.DocumentNbr ,
            tblAcctHeader.DocumentType ,
            tblCompany.ExtName AS Company ,
            tblCase.SInternalCaseNbr AS InternalCaseNbr ,
            ( SELECT TOP ( 1 )
                        CPTCode
              FROM      tblAcctDetail
              WHERE     ( HeaderID = tblAcctHeader.HeaderID )
              ORDER BY  LineNbr
            ) AS CPTCode ,
            ( SELECT TOP ( 1 )
                        Modifier
              FROM      tblAcctDetail AS TblAcctDetail_1
              WHERE     ( HeaderID = tblAcctHeader.HeaderID )
              ORDER BY  LineNbr
            ) AS CPTModifier ,
            ( SELECT TOP ( 1 )
                        EventDate
              FROM      tblCaseHistory
              WHERE     ( CaseNbr = tblCase.CaseNbr )
              ORDER BY  EventDate DESC
            ) AS DateFinalized ,
            tblAcctHeader.DocumentDate ,
            tblAcctHeader.DocumentStatus ,
            tblAcctHeader.CaseNbr ,
            tblCase.ServiceCode ,
            tblServices.Description AS Service ,
            tblCaseType.ShortDesc AS CaseType ,
            tblClient.USDVarchar2 AS Market ,
            tblCase.USDVarChar1 AS RequestedAs ,
            tblCase.USDInt1 AS ReferralNbr ,
            tblEWFacility.LegalName AS EWFacilityLegalName,
            tblEWFacility.Address AS EWFacilityAddress,
            tblEWFacility.City AS EWFacilityCity,
            tblEWFacility.State AS EWFacilityState,
            tblEWFacility.Zip AS EWFacilityZip,
            tblCase.OfficeCode
    FROM    tblCase
            INNER JOIN tblAcctHeader ON tblCase.CaseNbr = tblAcctHeader.CaseNbr
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblCaseType ON tblCase.CaseType = tblCaseType.Code
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblEWFacility ON tblEWFacility.EWFacilityID = tblAcctHeader.EWFacilityID
            LEFT OUTER JOIN tblSpecialty ON tblCase.DoctorSpecialty = tblSpecialty.SpecialtyCode
            LEFT OUTER JOIN tblDoctor ON tblAcctHeader.DrOpCode = tblDoctor.DoctorCode
    WHERE   ( tblAcctHeader.DocumentType = 'IN' )
            AND ( tblAcctHeader.DocumentStatus = 'Final' )
GO
PRINT N'Creating [dbo].[vwTranscriptionTracker]...';


GO
 CREATE VIEW vwTranscriptionTracker
 AS
    SELECT  CT.TranscriptionJobID ,
			CT.TranscriptionStatusCode ,
            CT.CaseNbr ,
            CASE WHEN C.CaseNbr IS NULL THEN 0
                 ELSE 1
            END AS CaseSelected ,
            DATEDIFF(DAY, C.LastStatusChg, GETDATE()) AS IQ ,
            C.ApptDate ,
            C.ApptTime ,
            C.Priority ,
			IsNull(P.Rank, 100) AS PriorityRank ,
            EE.LastName + ', ' + EE.FirstName AS ExamineeName ,
            CASE WHEN C.PanelNbr IS NULL
                 THEN D.LastName + ', ' + ISNULL(D.FirstName, ' ')
                 ELSE C.DoctorName
            END AS DoctorName ,
            L.Location ,
            COM.IntName AS CompanyName ,
            S.ShortDesc AS Service ,
            CASE WHEN CT.TransCode = -1 THEN '<Job Request>'
                 ELSE T.TransCompany
            END AS TransGroup ,
            Q.ShortDesc AS CaseStatus ,
            TS.Descrip AS TransStatus ,
            C.OfficeCode ,
            T.TransCode ,
			T.Workflow ,
            CT.DateAdded ,
            CT.DateCompleted ,
			CT.LastStatusChg ,
            TD.Name AS TransDept ,
			CT.EWTransDeptID
    FROM    tblTranscriptionJob CT
            INNER JOIN tblTranscriptionStatus TS ON CT.TranscriptionStatusCode = TS.TranscriptionStatusCode
            LEFT OUTER JOIN tblTranscription T ON T.TransCode = CT.TransCode
            LEFT OUTER JOIN tblCase C ON CT.CaseNbr = C.CaseNbr
            LEFT OUTER JOIN tblExaminee EE ON C.ChartNbr = EE.ChartNbr
            LEFT OUTER JOIN tblQueues Q ON C.Status = Q.StatusCode
            LEFT OUTER JOIN tblServices S ON C.ServiceCode = S.ServiceCode
            LEFT OUTER JOIN tblClient CL ON C.ClientCode = CL.ClientCode
            LEFT OUTER JOIN tblCompany COM ON COM.CompanyCode = CL.CompanyCode
            LEFT OUTER JOIN tblDoctor D ON C.DoctorCode = D.DoctorCode
            LEFT OUTER JOIN tblLocation L ON C.DoctorLocation = L.LocationCode
            LEFT OUTER JOIN tblPriority P ON C.Priority = P.PriorityCode
            LEFT OUTER JOIN tblEWTransDept TD ON CT.EWTransDeptID = TD.EWTransDeptID
GO
PRINT N'Altering [dbo].[proc_GetNewBatchNbr]...';


GO


ALTER PROCEDURE proc_GetNewBatchNbr
(
  @BatchType VARCHAR(2),
  @UserIDAdded VARCHAR(20),
  @BatchNbr INT OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON
    DECLARE @error INT

    DECLARE @installID INT
	DECLARE @offsetHours INT

	SELECT TOP 1 @offsetHours = OffsetHours FROM tblControl ORDER BY InstallID

    BEGIN TRAN
		SELECT TOP 1 @BatchNbr = NextBatchNbr, @installID = InstallID
		 FROM tblControl (UPDLOCK)
		 ORDER BY InstallID
        SET @error = @@ERROR
        IF @error <> 0 
            GOTO Done

		UPDATE tblControl SET NextBatchNbr=@BatchNbr+1
		 WHERE InstallID=@installID
        SET @error = @@ERROR
        IF @error <> 0 
            GOTO Done

		INSERT INTO tblbatch (BatchNbr, Type, DateAdded, UserIDAdded) VALUES
		(
			@BatchNbr,
			@BatchType,
			DATEADD(hh, @offsetHours, GETDATE()),
			@UserIDAdded
		)
        SET @error = @@ERROR
        IF @error <> 0 
            GOTO Done

		--Commit transaction
	COMMIT TRAN
 
        Done:
        IF @error <> 0 
            SET @BatchNbr = NULL
        IF @BatchNbr IS NULL 
            ROLLBACK TRAN

        SET NOCOUNT OFF
        RETURN @error
END
GO
PRINT N'Altering [dbo].[proc_IMEData_LoadByPrimaryKey]...';


GO
ALTER PROCEDURE [proc_IMEData_LoadByPrimaryKey]
(
	@ImeCode int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT top 1 * from tblIMEData
		WHERE ImeCode = @ImeCode

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_GetProviderSearch]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO
ALTER PROCEDURE [proc_GetProviderSearch]

AS

SET NOCOUNT OFF
DECLARE @Err int


	SELECT DISTINCT 
		tblLocation.locationcode,
		tbldoctor.lastname, 
		tblDoctor.firstname, 
		tbldoctor.credentials, 
		tblSpecialty.description specialty,
		tblSpecialty.specialtycode,
		tblLocation.zip, 
		tblLocation.city,
		tblLocation.location, 
		tblLocation.state, 
		tbldoctor.prepaid, 
		tblLocation.county,
		tblLocation.phone,
		tblDoctor.ProvTypeCode,
		tblDoctorKeyword.keywordID,
		tblDoctor.doctorcode, 
		'' as Proximity,
		ISNULL(lastname, '') + ', ' + ISNULL(firstname, '') + ' ' + ISNULL(credentials, '') AS doctorname 
		FROM tblDoctor
		LEFT JOIN tblDoctorSpecialty ON tblDoctor.doctorcode = tblDoctorSpecialty.doctorcode
		LEFT JOIN tblSpecialty ON tblDoctorSpecialty.specialtycode = tblSpecialty.specialtycode
		LEFT JOIN tbldoctordocuments ON tblDoctor.doctorcode = tbldoctordocuments.doctorcode AND tbldoctordocuments.publishonweb = 1
		LEFT JOIN tblDoctorKeyWord ON tblDoctor.doctorcode = tblDoctorKeyWord.doctorcode
		LEFT JOIN tblDoctorLocation ON tblDoctor.doctorcode = tblDoctorLocation.doctorcode AND tblDoctorLocation.publishonweb = 1
		LEFT JOIN tblLocation ON tblDoctorLocation.locationcode = tblLocation.locationcode
		WHERE (tblDoctor.status = 'Active') AND (OPType = 'DR') AND (tblDoctor.publishonweb = 1) AND (tblLocation.locationcode is not null)

SET @Err = @@Error
RETURN @Err
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Altering [dbo].[spExamineeCases]...';


GO
ALTER PROC spExamineeCases
    (
      @ChartNbr INTEGER
    )
AS 
    SELECT  *
    FROM    ( SELECT    tblCase.CaseNbr ,
                        DATEADD(dd, 0, DATEDIFF(dd, 0, tblCaseAppt.ApptTime)) AS ApptDate ,
                        tblCase.ChartNbr ,
                        tblClient.lastname + ', ' + tblClient.firstname AS ClientName ,
                        tblLocation.Location ,
                        CASE WHEN tblCaseAppt.CaseApptID = tblCase.CaseApptID
                                  OR ROW_NUMBER() OVER ( PARTITION BY tblCase.CaseNbr ORDER BY tblCaseAppt.CaseApptID DESC ) = 1
                             THEN tblQueues.StatusDesc
                             ELSE ''
                        END AS StatusDesc ,
                        ISNULL(ApptSpec.Description,
                               ISNULL(CaseSpec.Description,
                                      ReqSpec.Description)) AS SpecialtyDesc ,
                        ReqSpec.Description ,
                        tblServices.ShortDesc ,
                        tblCase.MasterSubCase ,
                        ISNULL(tblCase.mastercasenbr, tblCase.casenbr) AS MasterCaseNbr ,
                        tblDoctor.FirstName + ' ' + tblDoctor.LastName AS DoctorName ,
                        tbloffice.shortdesc AS Office ,
                        tblApptStatus.Name AS Result ,
                        tblCaseAppt.CaseApptID
              FROM      tblCase
                        INNER JOIN tblQueues ON tblCase.status = tblQueues.statuscode
                        INNER JOIN tblServices ON tblCase.servicecode = tblServices.servicecode
                        INNER JOIN tbloffice ON tbloffice.officecode = tblcase.officecode
                        LEFT OUTER JOIN tblCaseAppt ON tblCase.CaseNbr = tblCaseAppt.CaseNbr
                        LEFT OUTER JOIN tblApptStatus ON tblCaseAppt.ApptStatusID = tblApptStatus.ApptStatusID
                        LEFT OUTER JOIN tblSpecialty AS ReqSpec ON tblCase.sreqspecialty = ReqSpec.specialtycode
                        LEFT OUTER JOIN tblSpecialty AS CaseSpec ON tblCase.DoctorSpecialty = CaseSpec.specialtycode
                        LEFT OUTER JOIN tblSpecialty AS ApptSpec ON ApptSpec.specialtycode = tblCaseAppt.SpecialtyCode
                        LEFT OUTER JOIN tblDoctor ON ISNULL(tblCaseAppt.DoctorCode,
                                                            tblCase.DoctorCode) = tblDoctor.doctorcode
                        LEFT OUTER JOIN tblLocation ON tblCaseAppt.LocationCode = tblLocation.locationcode
                        LEFT OUTER JOIN tblClient ON tblCase.clientcode = tblClient.clientcode
              WHERE     ( tblCase.chartnbr = @ChartNbr )
            ) AS eeCases
    ORDER BY eeCases.MasterCaseNbr DESC ,
            eeCases.MasterSubCase ,
            eeCases.ApptDate DESC ,
            eeCases.CaseApptID DESC
GO
PRINT N'Altering [dbo].[spRptFlashReport]...';


GO
ALTER PROCEDURE [dbo].[spRptFlashReport]
@Month int,
@Year int,
@sReport varchar (20) ,
@EWFacilityID int , 
@OfficeCode int 
AS 
if @sReport = 'CurrentBilled'
begin
set nocount on

create table #lineItems
(DocumentType varchar(2),
 DocumentNbr int not null,
 LineNbr int,
 Description varchar(100),
 ReportCategory varchar(25),
 Revenue money not null,
 Expense money not null,
 ExtendedAmount money not null)

insert into #lineItems
select  tblAcctHeader.DocumentType,
        tblAcctHeader.DocumentNbr,
        tblAcctDetail.LineNbr,
        '',
        ISNULL(tblEWFlashCategory.Category, 'Other') as ReportCategory,
        case when tblacctheader.documenttype = 'IN'
             then isnull(tblacctdetail.extendedamount, 0)
             else 0
        end as Revenue,
        case when tblacctheader.documenttype = 'VO'
             then isnull(tblacctdetail.extendedamount, 0)
             else 0
        end as Expense,
        isnull(tblacctdetail.ExtendedAmount, 0) as ExtendedAmount
from    tblAcctHeader
        inner join tblAcctDetail on tblAcctHeader.HeaderID = tblAcctDetail.HeaderID
        left outer join tblCase on tblAcctHeader.casenbr = tblCase.casenbr
        left outer join tblFRCategory on tblCase.casetype = tblFRCategory.CaseType
                                         and TblAcctDetail.prodcode = tblFRCategory.ProductCode
        left outer JOIN tblEWFlashCategory ON tblFRCategory.EWFlashCategoryID = tblEWFlashCategory.EWFlashCategoryID
where   ( tblAcctHeader.documentstatus = 'Final' )
        and ( tblAcctHeader.EWFacilityID = @EWFacilityID
              or @EWFacilityID = -1
            )
        and month(tblAcctHeader.DocumentDate) = @month
        and year(tblAcctHeader.DocumentDate) = @year 
		and dbo.tblCase.OfficeCode = @OfficeCode  

select ReportCategory, sum(FRUnits)as sumDocuments, sum(revenue) as SumRevenue, sum(expense) as SumExpense , sum(amount) as SumMargin from 
(
select
  ReportCategory,
  case
    when (select count(*) from #lineItems as counter
   where counter.DocumentType=#lineItems.DocumentType
   and counter.DocumentNbr=#lineItems.DocumentNbr
   and counter.ReportCategory=#lineItems.ReportCategory
   and counter.LineNbr<=#lineItems.LineNbr) = 1 then
      case  
        when DocumentType = 'IN' then
          case when ExtendedAmount < 0 then -1 else 1 end
        else 0
      end
    else 0 
  end as FRUnits,
  Revenue, Expense,
  case
    when DocumentType = 'IN' then ExtendedAmount
    else -ExtendedAmount
  end as Amount
from #lineItems
) as lines
group by ReportCategory
order by ReportCategory

drop table #lineItems

end

if @sReport = 'CurrentScheduled'
begin
SELECT  ReportCategory,
        COUNT(casenbr) AS SumDocuments
FROM    ( SELECT    dbo.tblCase.casenbr AS casenbr,
     ISNULL(tblEWFlashCategory.Category, 'Other') as ReportCategory
          FROM      dbo.tblCase
                    INNER JOIN tblClient ON dbo.tblClient.clientcode = dbo.tblCase.clientcode
                    INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
                    INNER JOIN dbo.tblOffice ON tblcase.officecode = tblOffice.officecode
                    INNER JOIN dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
                    INNER JOIN dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode
                    LEFT OUTER JOIN dbo.tblproduct ON dbo.tblproduct.description = dbo.tblServices.description
                    LEFT OUTER JOIN dbo.tblFRCategory ON dbo.tblFRCategory.ProductCode = dbo.tblproduct.prodcode
                                                         AND dbo.tblFRCategory.CaseType = dbo.tblCase.casetype
                    LEFT OUTER JOIN dbo.tblEWFlashCategory ON dbo.tblFRCategory.EWFlashCategoryID=dbo.tblEWFlashCategory.EWFlashCategoryID
          WHERE     ( tblOffice.EWFacilityID = @EWFacilityID
                      OR @EWFacilityID = -1
                    )
                    AND dbo.tblcase.status <> 8
                    AND dbo.tblcase.status <> 9
                    AND ( dbo.TblCase.invoiceamt = 0
                          OR dbo.tblcase.invoiceamt IS NULL
                        )
                    AND MONTH(dbo.tblcase.ForecastDate) = @month
                    AND YEAR(dbo.tblcase.ForecastDate) = @year 
					AND dbo.tblCase.OfficeCode = @OfficeCode 
        ) AS a
GROUP BY ReportCategory

end

if @sReport = 'FutureScheduled'
begin
if @month = 12 begin
 select @month = 1
 select @year = @year + 1
end
else
begin
 select @month = @month + 1
end

SELECT  ReportCategory,
        COUNT(casenbr) AS SumDocuments
FROM    ( SELECT    dbo.tblCase.casenbr AS casenbr,
                    ISNULL(tblEWFlashCategory.Category, 'Other') as ReportCategory
          FROM      dbo.tblCase
                    INNER JOIN tblClient ON dbo.tblClient.clientcode = dbo.tblCase.clientcode
                    INNER JOIN dbo.tblCompany ON dbo.tblClient.companycode = dbo.tblCompany.companycode
                    INNER JOIN dbo.tblOffice ON tblcase.officecode = tblOffice.officecode
                    INNER JOIN dbo.tblCaseType ON dbo.tblCase.casetype = dbo.tblCaseType.code
                    INNER JOIN dbo.tblServices ON dbo.tblCase.servicecode = dbo.tblServices.servicecode
                    LEFT OUTER JOIN dbo.tblproduct ON dbo.tblproduct.description = dbo.tblServices.description
                    LEFT OUTER JOIN dbo.tblFRCategory ON dbo.tblFRCategory.ProductCode = dbo.tblproduct.prodcode
                                                         AND dbo.tblFRCategory.CaseType = dbo.tblCase.casetype
                    LEFT OUTER JOIN dbo.tblEWFlashCategory ON dbo.tblFRCategory.EWFlashCategoryID=dbo.tblEWFlashCategory.EWFlashCategoryID
          WHERE     ( tblOffice.EWFacilityID = @EWFacilityID
                      OR @EWFacilityID = -1
                    )
                    AND dbo.tblcase.status <> 8
                    AND dbo.tblcase.status <> 9
                    AND ( dbo.TblCase.invoiceamt = 0
                          OR dbo.tblcase.invoiceamt IS NULL
                        )
                    AND MONTH(dbo.tblcase.ForecastDate) = @month
                    AND YEAR(dbo.tblcase.ForecastDate) = @year
					and dbo.tblOffice.OfficeCode  = @OfficeCode 
        ) AS a
GROUP BY ReportCategory

end
GO
PRINT N'Creating [dbo].[proc_Client_GetDefaultOffice]...';


GO
CREATE PROCEDURE [proc_Client_GetDefaultOffice]
(
	@clientcode int
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT OfficeCode FROM tblClientOffice WHERE ClientCode = @clientcode AND IsDefault = 1

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Creating [dbo].[proc_Control_LoadByPrimaryKey]...';


GO
CREATE PROCEDURE [proc_Control_LoadByPrimaryKey]
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	SELECT top 1 * from tblControl


	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Update complete.';


GO

UPDATE tblControl SET DBVersion='2.76'
GO
