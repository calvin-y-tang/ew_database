PRINT N'Dropping [dbo].[tblCase].[IX_tblCase_DateAddedOfficeCode]...';


GO
DROP INDEX [IX_tblCase_DateAddedOfficeCode]
    ON [dbo].[tblCase];


GO
PRINT N'Dropping [dbo].[tblCase].[IX_tblCase_DateReceivedEWReferralTypeStatus]...';


GO
DROP INDEX [IX_tblCase_DateReceivedEWReferralTypeStatus]
    ON [dbo].[tblCase];



GO
PRINT N'Dropping [dbo].[tblCase].[IX_tblCase_DateReceivedOfficeCode]...';


GO
DROP INDEX [IX_tblCase_DateReceivedOfficeCode]
    ON [dbo].[tblCase];


GO
PRINT N'Dropping [dbo].[tblCase].[IX_tblCase_OfficeCodeStatusSchedulerCode]...';


GO
DROP INDEX [IX_tblCase_OfficeCodeStatusSchedulerCode]
    ON [dbo].[tblCase];


GO
PRINT N'Dropping [dbo].[tblZipCode].[IX_tblZipCode_sZip]...';


GO
DROP INDEX [IX_tblZipCode_sZip]
    ON [dbo].[tblZipCode];
GO
PRINT N'Creating [dbo].[tblAcctMargin]...';


GO
CREATE TABLE [dbo].[tblAcctMargin] (
    [PrimaryKey]      INT         IDENTITY (1, 1) NOT NULL,
    [DocumentDate]    DATETIME    NOT NULL,
    [DocumentType]    VARCHAR (2) NOT NULL,
    [EWFacilityID]    INT         NOT NULL,
    [ParentCompanyID] INT         NOT NULL,
    [EWBusLineID]     INT         NOT NULL,
    [EWServiceTypeID] INT         NOT NULL,
    [AmountUS]        MONEY       NOT NULL,
    [CaseCount]       INT         NOT NULL,
    CONSTRAINT [PK_tblAcctMargin] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


GO
PRINT N'Creating [dbo].[tblAcctMargin].[IX_tblAcctMargin_DocumentDateDocumentTypeEWFacilityIDParentCompanyIDEWBusLineIDEWServiceID]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblAcctMargin_DocumentDateDocumentTypeEWFacilityIDParentCompanyIDEWBusLineIDEWServiceID]
    ON [dbo].[tblAcctMargin]([DocumentDate] ASC, [DocumentType] ASC, [EWFacilityID] ASC, [ParentCompanyID] ASC, [EWBusLineID] ASC, [EWServiceTypeID] ASC)
    INCLUDE([AmountUS], [CaseCount]);




GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_DateAddedOfficeCodeStatus]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_DateAddedOfficeCodeStatus]
    ON [dbo].[tblCase]([DateAdded] ASC, [OfficeCode] ASC, [Status] ASC);


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_OfficeCodeStatus]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_OfficeCodeStatus]
    ON [dbo].[tblCase]([OfficeCode] ASC, [Status] ASC)
    INCLUDE([DoctorLocation], [ClientCode], [MarketerCode], [SchedulerCode], [Priority], [CaseType], [ServiceCode], [DoctorCode], [QARep]);


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_OfficeCodeStatusDateReceived]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_OfficeCodeStatusDateReceived]
    ON [dbo].[tblCase]([OfficeCode] ASC, [Status] ASC, [DateReceived] ASC)
    INCLUDE([CaseNbr], [ChartNbr], [ClientCode], [MarketerCode], [CaseType], [ApptTime], [ServiceCode], [DoctorCode], [Jurisdiction], [ForecastDate], [EWReferralType], [InputSourceID], [ExtCaseNbr]);


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_SchedCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_SchedCode]
    ON [dbo].[tblCase]([SchedCode] ASC)
    INCLUDE([PanelNbr], [ExtCaseNbr], [ChartNbr], [OfficeCode], [ClientCode], [CaseType], [ServiceCode], [ClaimNbr]);


GO
PRINT N'Creating [dbo].[tblCaseOtherParty].[IX_tblCaseOtherParty_StatusDueDate]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCaseOtherParty_StatusDueDate]
    ON [dbo].[tblCaseOtherParty]([Status] ASC, [DueDate] ASC)
    INCLUDE([CaseNbr], [OPCode]);


GO
PRINT N'Creating [dbo].[tblCasePanel].[IX_tblCasePanel_SchedCodePanelNbr]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCasePanel_SchedCodePanelNbr]
    ON [dbo].[tblCasePanel]([SchedCode] ASC, [PanelNbr] ASC);


GO
PRINT N'Creating [dbo].[tblClient].[IX_tblClient_ClientCodeCompanyCodeLastNameFirstName]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblClient_ClientCodeCompanyCodeLastNameFirstName]
    ON [dbo].[tblClient]([ClientCode] ASC, [CompanyCode] ASC, [LastName] ASC, [FirstName] ASC);


GO
PRINT N'Creating [dbo].[tblCompany].[IX_tblCompany_CompanyCodeIntNameExtName]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCompany_CompanyCodeIntNameExtName]
    ON [dbo].[tblCompany]([CompanyCode] ASC, [IntName] ASC, [ExtName] ASC);


GO
PRINT N'Creating [dbo].[tblExaminee].[IX_tblExaminee_ChartNbrLastNameFirstName]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblExaminee_ChartNbrLastNameFirstName]
    ON [dbo].[tblExaminee]([ChartNbr] ASC, [LastName] ASC, [FirstName] ASC);


GO
PRINT N'Creating [dbo].[tblZipCode].[IX_tblZipCode_sZipsCountyNamesState]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblZipCode_sZipsCountyNamesState]
    ON [dbo].[tblZipCode]([sZip] ASC, [sCountyName] ASC, [sState] ASC);


GO
PRINT N'Altering [dbo].[vwCaseMonitorDetail]...';


GO
ALTER VIEW vwCaseMonitorDetail
AS
    SELECT  C.Status AS StatusCode,
            IIF(C.Priority <> 'Normal', 1, 0) AS Rush ,
            IIF(ISNULL(C.Priority, 'Normal') = 'Normal', 1, 0) AS Normal ,
            C.MarketerCode ,
            C.DoctorLocation ,
            C.DoctorCode ,
            C.CompanyCode ,
            C.OfficeCode ,
            C.SchedulerCode ,
            C.QARep ,
            C.ServiceCode ,
            C.CaseType
    FROM    tblCase AS C
    WHERE   C.Status NOT IN (8, 9, -100)
GO
PRINT N'Altering [dbo].[vwCaseOpenServices]...';


GO
ALTER VIEW vwCaseOpenServices
AS
    SELECT  tblCase.CaseNbr ,
            tblCaseOtherParty.DueDate ,
            tblCaseOtherParty.Status ,
            tblCase.OfficeCode ,
            tblCase.DoctorLocation ,
            tblCase.MarketerCode ,
            tblCase.DoctorCode ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS examineename ,
            tblCaseOtherParty.UserIDResponsible ,
            tblCase.ApptDate ,
            tblServices.ShortDesc AS service ,
            tblServices.ServiceCode ,
            OP.CompanyName ,
            OP.OPSubType ,
            tblCase.SchedulerCode ,
            tblCompany.CompanyCode ,
            tblCase.QARep ,
            tblCaseOtherParty.OPCode ,
            tblCase.PanelNbr ,
            tblCase.DoctorName ,
            tblCase.CaseType , 
			tblCase.ExtCaseNbr 
    FROM    tblCaseOtherParty
            INNER JOIN tblCase ON tblCaseOtherParty.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblDoctor OP ON tblCaseOtherParty.OPCode = OP.DoctorCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
    WHERE   ( tblCaseOtherParty.Status = 'Open' );
GO
PRINT N'Altering [dbo].[vwScheduleViewer]...';


GO
ALTER VIEW vwScheduleViewer
AS
    SELECT tblDoctorSchedule.SchedCode ,
			tblDoctorSchedule.LocationCode ,
            tblDoctorSchedule.date,
            tblDoctorSchedule.StartTime, 
            tblDoctorSchedule.Description ,
            tblDoctorSchedule.Status ,
            tblDoctorSchedule.DoctorCode ,            
            tblCase.CaseNbr , 
			tblCase.ExtCaseNbr , 
            tblCompany.ExtName AS Company ,
            tblExaminee.FirstName + ' ' + tblExaminee.LastName AS ExamineeName ,
            tblLocation.Location,
            tblEWFacility.LegalName AS CompanyName ,
            ISNULL(tblDoctor.FirstName, '') + ' ' + ISNULL(tblDoctor.LastName,
                                                           '') + ', '
            + ISNULL(tblDoctor.Credentials, '') AS DoctorName ,
            tblCase.ClaimNbr ,
            tblClient.FirstName + ' ' + tblClient.LastName AS ClientName ,
            tblCaseType.Description AS CaseTypeDesc , 
            tblServices.Description AS Servicedesc ,
            tblCase.PanelNbr ,
            tblCase.OfficeCode,			
            CASE WHEN tblCase.CaseNbr IS NULL
                 THEN tblDoctorSchedule.CaseNbr1desc
                 ELSE NULL
            END AS ScheduleDescription ,
            tblServices.ShortDesc ,
            tblDoctorSchedule.Duration ,
            tblCompany.IntName AS CompanyIntName
    FROM    tblDoctorSchedule 
				INNER JOIN tblDoctor ON tblDoctorSchedule.DoctorCode = tblDoctor.DoctorCode	
				INNER JOIN tblLocation ON tblDoctorSchedule.LocationCode = tblLocation.LocationCode
				INNER JOIN tblDoctorOffice ON tblDoctor.DoctorCode = tblDoctorOffice.DoctorCode
				INNER JOIN tblLocationOffice ON tblLocationOffice.OfficeCode = tblDoctorOffice.OfficeCode AND tblLocationOffice.LocationCode = tblLocation.LocationCode
				LEFT OUTER JOIN tblCase
					INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
					INNER JOIN tblCompany ON tblClient.CompanyCode = tblCompany.CompanyCode
					INNER JOIN tblOffice ON tblCase.OfficeCode = tblOffice.OfficeCode
					INNER JOIN tblEWFacility ON tblOffice.EWFacilityID = tblEWFacility.EWFacilityID
					INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode 
					INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
					INNER JOIN tblCaseType ON tblCase.CaseType = tblCaseType.Code		
					LEFT OUTER JOIN tblLanguage ON tblLanguage.LanguageID = tblcase.LanguageID
					LEFT OUTER JOIN tblCasePanel ON tblCasePanel.PanelNbr = tblCase.PanelNbr
				ON tblDoctorSchedule.SchedCode = ISNULL(tblCasePanel.SchedCode, tblCase.SchedCode)
GO
PRINT N'Altering [dbo].[vwStatusNew]...';


GO
ALTER VIEW vwStatusNew
AS
    SELECT DISTINCT
            tblCase.casenbr
           ,tblExaminee.lastname + ', ' + tblExaminee.firstname AS examineename
           ,CASE WHEN tblcase.panelnbr IS NULL
                 THEN tbldoctor.lastname + ', '
                      + ISNULL(tbldoctor.firstname, ' ')
                 ELSE tblcase.doctorname
            END AS doctorname
           ,tblClient.lastname + ', ' + tblClient.firstname AS clientname
           ,tblCase.MarketerCode AS MarketerName
           ,tblCompany.intname AS CompanyName
           ,tblCase.priority
           ,tblCase.ApptDate
           ,tblCase.Status
           ,tblCase.DateAdded
           ,tblCase.DoctorCode
           ,tblCase.MarketerCode
           ,tblQueues.StatusDesc
           ,tblServices.shortdesc AS Service
           ,tblCase.doctorlocation
           ,tblClient.companycode
           ,tblCase.servicecode
           ,tblCase.QARep
           ,tblCase.schedulercode
           ,tblCase.officecode
           ,tblCase.PanelNbr
           ,'ViewCase' AS FunctionCode
           ,tblCase.casetype
		   ,tblCase.ExtCaseNbr 
    FROM    tblCase
            INNER JOIN tblClient ON tblClient.clientcode = tblCase.clientcode
            INNER JOIN tblCompany ON tblCompany.companycode = tblClient.companycode
            INNER JOIN tblServices ON tblServices.servicecode = tblCase.servicecode
            LEFT OUTER JOIN tblDoctor ON tblCase.doctorcode = tblDoctor.doctorcode
            LEFT OUTER JOIN tblExaminee ON tblCase.chartnbr = tblExaminee.chartnbr
            LEFT OUTER JOIN tblUser AS Marketer ON Marketer.UserID = tblCase.marketercode
            LEFT OUTER JOIN tblQueues ON tblQueues.statuscode = tblCase.status
GO
PRINT N'Altering [dbo].[vwWALI]...';


GO
ALTER VIEW vwWALI
AS
    SELECT  tblDoctorSchedule.SchedCode,
			tblDoctorSchedule.DoctorCode,
			tblDoctorSchedule.date,
			tblCase.CaseNbr,
			tblCaseType.EWBusLineID
	FROM    tblDoctorSchedule 
				LEFT OUTER JOIN tblCase
					INNER JOIN tblCaseType ON tblCase.CaseType = tblCaseType.Code	
					LEFT OUTER JOIN tblCasePanel ON tblCasePanel.PanelNbr = tblCase.PanelNbr
				ON tblDoctorSchedule.SchedCode = ISNULL(tblCasePanel.SchedCode, tblCase.SchedCode)
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
			AND (tblLocation.Status = 'Active')

SET @Err = @@Error
RETURN @Err
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Altering [dbo].[spCompanyCases]...';


GO
ALTER PROCEDURE spCompanyCases
    @CompanyCode AS INTEGER
AS
    SELECT
        tblCase.CaseNbr,
        tblCase.ExtCaseNbr,
        tblExaminee.LastName+', '+tblExaminee.FirstName AS ExamineeName,
        tblCase.ApptDate,
        tblCaseType.Description,
        tblCase.ClientCode,
        tblClient.LastName+', '+tblClient.FirstName AS ClientName,
        tblClient.CompanyCode,
        tblCompany.IntName,
        tblLocation.Location,
        tblQueues.StatusDesc,
        tblCase.DoctorName,
        tblOffice.ShortDesc AS OfficeName
    FROM
        tblCase
    INNER JOIN tblExaminee ON tblCase.ChartNbr=tblExaminee.ChartNbr
    INNER JOIN tblClient ON tblCase.ClientCode=tblClient.ClientCode
    INNER JOIN tblCompany ON tblCase.CompanyCode=tblCompany.CompanyCode
    INNER JOIN tblQueues ON tblCase.Status=tblQueues.StatusCode
    LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation=tblLocation.LocationCode
    LEFT OUTER JOIN tblCaseType ON tblCase.CaseType=tblCaseType.Code
    LEFT OUTER JOIN tblOffice ON tblCase.OfficeCode=tblOffice.OfficeCode
    WHERE
        tblCompany.CompanyCode=@CompanyCode
    ORDER BY
        tblCase.ApptDate DESC
GO
PRINT N'Creating [dbo].[proc_GetMostUsedOffice]...';


GO
CREATE PROCEDURE [proc_GetMostUsedOffice]

@UserType char(2),
@UserCode int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	DECLARE @sqlString nvarchar(2000)

	IF (@UserType = 'CL')
	BEGIN
		SET @sqlstring = 'select top 1 officecode, count(OfficeCode) OfficeCount from tblcase where tblCase.ClientCode = ' + CAST(@usercode AS varchar(20)) + ' group by OfficeCode order by OfficeCount desc'
	END

	ELSE IF (@UserType = 'TR')
	BEGIN
		SET @sqlstring = 'select top 1 officecode, count(OfficeCode) OfficeCount from tblcase where tblCase.TransCode = ' + CAST(@usercode AS varchar(20)) + ' group by OfficeCode order by OfficeCount desc'
	END

	ELSE IF (@UserType = 'DR')
	BEGIN
		SET @sqlstring = 'select top 1 officecode, count(OfficeCode) OfficeCount from tblcase where tblCase.DoctorCode = ' + CAST(@usercode AS varchar(20)) + ' group by OfficeCode order by OfficeCount desc'
	END

	ELSE IF (@UserType = 'AT')
	BEGIN
		SET @sqlstring = 'select top 1 officecode, count(OfficeCode) OfficeCount from tblcase where (tblCase.DefenseAttorneyCode = ' + CAST(@usercode AS varchar(20)) + ' OR tblCase.PlaintiffAttorneyCode = ' + CAST(@usercode AS varchar(20)) + ' OR tblCase.DefParaLegal = ' + CAST(@usercode AS varchar(20)) + ') group by OfficeCode order by OfficeCount desc'
	END

	Execute SP_ExecuteSQL  @sqlString

	SET @Err = @@Error

	RETURN @Err
END
GO



PRINT N'Dropping [dbo].[tblCase].[IX_tblCase_OfficeCodeStatus]...';


GO
DROP INDEX [IX_tblCase_OfficeCodeStatus]
    ON [dbo].[tblCase];


GO
PRINT N'Creating [dbo].[tblCase].[IX_tblCase_OfficeCodeStatus]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblCase_OfficeCodeStatus]
    ON [dbo].[tblCase]([OfficeCode] ASC, [Status] ASC)
    INCLUDE([DoctorLocation], [ClientCode], [MarketerCode], [SchedulerCode], [Priority], [CaseType], [ServiceCode], [DoctorCode], [QARep], [ChartNbr], [CompanyCode]);


GO
PRINT N'Altering [dbo].[vwCaseOpenServices]...';


GO
ALTER VIEW vwCaseOpenServices
AS
    SELECT  tblCase.CaseNbr ,
            tblCaseOtherParty.DueDate ,
            tblCaseOtherParty.Status ,
            tblCase.OfficeCode ,
            tblCase.DoctorLocation ,
            tblCase.MarketerCode ,
            tblCase.DoctorCode ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS examineename ,
            tblCaseOtherParty.UserIDResponsible ,
            tblCase.ApptDate ,
            tblServices.ShortDesc AS service ,
            tblServices.ServiceCode ,
            OP.CompanyName ,
            OP.OPSubType ,
            tblCase.SchedulerCode ,
            tblCase.CompanyCode ,
            tblCase.QARep ,
            tblCaseOtherParty.OPCode ,
            tblCase.PanelNbr ,
            tblCase.DoctorName ,
            tblCase.CaseType , 
			tblCase.ExtCaseNbr 
    FROM    tblCaseOtherParty
            INNER JOIN tblCase ON tblCaseOtherParty.CaseNbr = tblCase.CaseNbr
            INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblDoctor OP ON tblCaseOtherParty.OPCode = OP.DoctorCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
    WHERE   ( tblCaseOtherParty.Status = 'Open' );
GO

UPDATE tblControl SET DBVersion='2.96'
GO
