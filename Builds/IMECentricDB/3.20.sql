PRINT N'Altering [dbo].[tblCaseAppt]...';


GO
ALTER TABLE [dbo].[tblCaseAppt]
    ADD [ApptAttendance] VARCHAR (300) NULL;


GO
PRINT N'Altering [dbo].[tblEWParentCompany]...';


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO
ALTER TABLE [dbo].[tblEWParentCompany]
    ADD [RequirePracticingDoctor] BIT NULL,
        [RequireStateLicence]     BIT NULL,
        [RequireCertification]    BIT NULL;


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Altering [dbo].[tblWebUser]...';


GO
ALTER TABLE [dbo].[tblWebUser]
    ADD [PortalVersion]    INT      NULL,
        [EWTimeZoneID]     INT      NULL,
        [QuietTimeEnabled] BIT      NULL,
        [QuietTimeStart]   DATETIME NULL,
        [QuietTimeEnd]     DATETIME NULL;


GO
PRINT N'Creating [dbo].[tblNotify]...';


GO
CREATE TABLE [dbo].[tblNotify] (
    [NotifyID]       INT          IDENTITY (1, 1) NOT NULL,
    [UserID]         INT          NOT NULL,
    [UserType]       VARCHAR (2)  NULL,
    [NotifyEventID]  INT          NOT NULL,
    [NotifyMethodID] INT          NOT NULL,
    [CaseNbr]        INT          NULL,
    [ActionType]     VARCHAR (20) NULL,
    [ActionKey]      INT          NULL,
    [DateDelivered]  DATETIME     NULL,
    [DateAdded]      DATETIME     NULL,
    [UserIDAdded]    VARCHAR (15) NULL,
    CONSTRAINT [PK_tblNotify] PRIMARY KEY CLUSTERED ([NotifyID] ASC)
);


GO
PRINT N'Creating [dbo].[tblNotifyAudience]...';


GO
CREATE TABLE [dbo].[tblNotifyAudience] (
    [NotifyAudienceID]       INT          IDENTITY (1, 1) NOT NULL,
    [NotifyEventID]          INT          NOT NULL,
    [NotifyMethodID]         INT          NOT NULL,
    [UserType]               VARCHAR (2)  NULL,
    [ActionType]             VARCHAR (20) NULL,
    [DateAdded]              DATETIME     NULL,
    [UserIDAdded]            VARCHAR (15) NULL,
    [DateEdited]             DATETIME     NULL,
    [UserIDEdited]           VARCHAR (15) NULL,
    [DefaultPreferenceValue] BIT          NOT NULL,
    CONSTRAINT [PK_tblNotifyAudience] PRIMARY KEY CLUSTERED ([NotifyAudienceID] ASC)
);


GO
PRINT N'Creating [dbo].[tblNotifyAudience].[IX_U_tblNotifyAudience_UserTypeNotifyEventIDNotifyMethodID]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblNotifyAudience_UserTypeNotifyEventIDNotifyMethodID]
    ON [dbo].[tblNotifyAudience]([UserType] ASC, [NotifyEventID] ASC, [NotifyMethodID] ASC);


GO
PRINT N'Creating [dbo].[tblNotifyDetail]...';


GO
CREATE TABLE [dbo].[tblNotifyDetail] (
    [NotifyID] INT           NOT NULL,
    [Details]  VARCHAR (MAX) NULL,
    CONSTRAINT [PK_tblNotifyDetail] PRIMARY KEY CLUSTERED ([NotifyID] ASC)
);


GO
PRINT N'Creating [dbo].[tblNotifyEvent]...';


GO
CREATE TABLE [dbo].[tblNotifyEvent] (
    [NotifyEventID] INT          IDENTITY (1, 1) NOT NULL,
    [Description]   VARCHAR (70) NULL,
    [Active]        BIT          NOT NULL,
    [DateAdded]     DATETIME     NULL,
    [UserIDAdded]   VARCHAR (15) NULL,
    [DateEdited]    DATETIME     NULL,
    [UserIDEdited]  VARCHAR (15) NULL,
    [DisplayOrder]  INT          NOT NULL,
    CONSTRAINT [PK_tblNotifyEvent] PRIMARY KEY CLUSTERED ([NotifyEventID] ASC)
);


GO
PRINT N'Creating [dbo].[tblNotifyMethod]...';


GO
CREATE TABLE [dbo].[tblNotifyMethod] (
    [NotifyMethodID] INT          NOT NULL,
    [Name]           VARCHAR (20) NULL,
    CONSTRAINT [PK_tblNotifyMethod] PRIMARY KEY CLUSTERED ([NotifyMethodID] ASC)
);


GO
PRINT N'Creating [dbo].[tblNotifyPreference]...';


GO
CREATE TABLE [dbo].[tblNotifyPreference] (
    [NotifyPreferenceID] INT          IDENTITY (1, 1) NOT NULL,
    [WebUserID]          INT          NOT NULL,
    [NotifyEventID]      INT          NOT NULL,
    [NotifyMethodID]     INT          NOT NULL,
    [DateEdited]         DATETIME     NULL,
    [UserIDEdited]       VARCHAR (15) NULL,
    [PreferenceValue]    BIT          NOT NULL,
    CONSTRAINT [PK_tblNotifyPreference] PRIMARY KEY CLUSTERED ([NotifyPreferenceID] ASC)
);


GO
PRINT N'Creating [dbo].[tblOfficeContact]...';


GO
CREATE TABLE [dbo].[tblOfficeContact] (
    [OfficeContactCode] INT          IDENTITY (1, 1) NOT NULL,
    [OfficeCode]        INT          NOT NULL,
    [EWBusLineID]       INT          NULL,
    [Department]        INT          NULL,
    [Email]             VARCHAR (70) NOT NULL,
    [Phone]             VARCHAR (15) NOT NULL,
    [DateAdded]         DATETIME     NULL,
    [DateEdited]        DATETIME     NULL,
    [UserIDAdded]       VARCHAR (30) NULL,
    [UserIDEdited]      VARCHAR (30) NULL,
    [Priority]          INT          NOT NULL,
    CONSTRAINT [PK_tblOfficeContact] PRIMARY KEY CLUSTERED ([OfficeContactCode] ASC)
);


GO
PRINT N'Creating [dbo].[tblOfficeContact].[IX_U_tblOfficeContact_OfficeCodeDepartmentLineOfBusiness]...';


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_U_tblOfficeContact_OfficeCodeDepartmentLineOfBusiness]
    ON [dbo].[tblOfficeContact]([OfficeCode] ASC, [Department] ASC, [EWBusLineID] ASC);


GO
PRINT N'Creating [dbo].[tblWebUserChangeRequest]...';


GO
CREATE TABLE [dbo].[tblWebUserChangeRequest] (
    [WebUserChgReqID]       INT           IDENTITY (1, 1) NOT NULL,
    [UserType]              CHAR (2)      NULL,
    [IMECentricCode]        INT           NULL,
    [FirstName]             VARCHAR (50)  NULL,
    [LastName]              VARCHAR (50)  NULL,
    [MiddleInitial]         CHAR (1)      NULL,
    [Address1]              VARCHAR (50)  NULL,
    [Address2]              VARCHAR (50)  NULL,
    [City]                  VARCHAR (50)  NULL,
    [State]                 CHAR (2)      NULL,
    [Zip]                   VARCHAR (10)  NULL,
    [Phone]                 VARCHAR (15)  NULL,
    [Fax]                   VARCHAR (15)  NULL,
    [Mobile]                VARCHAR (15)  NULL,
    [OfficePhone]           VARCHAR (15)  NULL,
    [EmailAddress]          VARCHAR (150) NULL,
    [BankInfoAccountType]   VARCHAR (30)  NULL,
    [BankInfoRoutingNumber] VARCHAR (30)  NULL,
    [BankInfoAccountNumber] VARCHAR (30)  NULL,
    [EmailSent]             BIT           NULL,
    [EmailSentEmailAddress] VARCHAR (150) NULL,
    [EmailSentDate]         SMALLDATETIME NULL,
    [DateAdded]             SMALLDATETIME NULL,
    [UserIDAdded]           VARCHAR (15)  NULL,
    [DateEdited]            SMALLDATETIME NULL,
    [UserIDEdited]          VARCHAR (15)  NULL,
    CONSTRAINT [PK_tblWebUserChangeRequest] PRIMARY KEY CLUSTERED ([WebUserChgReqID] ASC) ON [PRIMARY]
) ON [PRIMARY];


GO
PRINT N'Creating [dbo].[DF_tblNotifyAudience_DefaultValue]...';


GO
ALTER TABLE [dbo].[tblNotifyAudience]
    ADD CONSTRAINT [DF_tblNotifyAudience_DefaultValue] DEFAULT ((0)) FOR [DefaultPreferenceValue];


GO
PRINT N'Creating [dbo].[DF_tblNotifyEvent_Active]...';


GO
ALTER TABLE [dbo].[tblNotifyEvent]
    ADD CONSTRAINT [DF_tblNotifyEvent_Active] DEFAULT ((1)) FOR [Active];


GO
PRINT N'Creating [dbo].[DF_tblOfficeContact_Priority]...';


GO
ALTER TABLE [dbo].[tblOfficeContact]
    ADD CONSTRAINT [DF_tblOfficeContact_Priority] DEFAULT ((0)) FOR [Priority];


GO









----Applied Above----




PRINT N'Altering [dbo].[vwStatusAppt]...';


GO
ALTER VIEW vwStatusAppt
AS
    SELECT  tblCase.CaseNbr ,
            tblExaminee.LastName + ', ' + tblExaminee.FirstName AS examineename ,
            tblClient.LastName + ', ' + tblClient.FirstName AS clientname ,
            tblUser.LastName + ', ' + tblUser.FirstName AS schedulername ,
            tblCompany.IntName AS companyname ,
            tblCase.Priority ,
            tblCase.ApptDate ,
            tblCase.Status ,
            tblCase.DateAdded ,
            tblCase.ClaimNbr ,
            tblCase.DoctorLocation ,
            tblCase.ApptTime ,
            tblCase.ShowNoShow ,
            tblCase.TransCode ,
            tblCase.RptStatus ,
            tblLocation.Location ,
            tblCase.DateEdited ,
            tblCase.UserIDEdited ,
            tblCase.ApptSelect ,
            tblClient.Email AS clientemail ,
            tblClient.Fax AS clientfax ,
            tblCase.MarketerCode ,
            tblCase.RequestedDoc ,
            tblCase.InvoiceDate ,
            tblCase.InvoiceAmt ,
            tblCase.DateDrChart ,
            tblCase.DrChartSelect ,
            tblCase.InQASelect ,
            tblCase.InTransSelect ,
            tblCase.BilledSelect ,
            tblCase.AwaitTransSelect ,
            tblCase.ChartPrepSelect ,
            tblCase.ApptRptsSelect ,
            tblCase.TransReceived ,
            tblTranscription.TransCompany ,
            tblServices.ShortDesc AS service ,
            tblCase.DoctorCode ,
            tblClient.CompanyCode ,
            tblCase.OfficeCode ,
            tblCase.SchedulerCode ,
            tblCase.QARep ,
            DATEDIFF(DAY, tblCase.LastStatusChg, GETDATE()) AS IQ ,
            tblCase.LastStatusChg ,
            CASE WHEN tblCase.PanelNbr IS NULL
                 THEN tblDoctor.LastName + ', ' + ISNULL(tblDoctor.FirstName,
                                                         ' ')
                 ELSE tblCase.DoctorName
            END AS doctorname ,
            tblCase.PanelNbr ,
            tblQueues.FunctionCode ,
            tblCase.ServiceCode ,
            tblCase.CaseType , 
			tblCase.ExtCaseNbr, 
			ISNULL(BillCompany.ParentCompanyID, tblCompany.ParentCompanyID) AS ParentCompanyID,
			ISNULL(tblCaseAppt.ApptAttendance, '') as ApptAttendance
    FROM    tblCase
            INNER JOIN tblClient ON tblCase.ClientCode = tblClient.ClientCode
            INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
            INNER JOIN tblQueues ON tblCase.Status = tblQueues.StatusCode
			LEFT OUTER JOIN tblCaseAppt ON tblCase.CaseApptID = tblCaseAppt.CaseApptID
            LEFT OUTER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
            LEFT OUTER JOIN tblCompany ON tblCompany.CompanyCode = tblClient.CompanyCode
			LEFT OUTER JOIN tblClient AS BillClient ON BillClient.ClientCode = tblCase.BillClientCode
			LEFT OUTER JOIN tblCompany AS BillCompany ON BillCompany.CompanyCode = BillClient.CompanyCode
            LEFT OUTER JOIN tblTranscription ON tblCase.TransCode = tblTranscription.TransCode
            LEFT OUTER JOIN tblLocation ON tblCase.DoctorLocation = tblLocation.LocationCode
            LEFT OUTER JOIN tblDoctor ON tblCase.DoctorCode = tblDoctor.DoctorCode
            LEFT OUTER JOIN tblUser ON tblCase.SchedulerCode = tblUser.UserID
                                       AND tblUser.UserType = 'SC'
GO
PRINT N'Altering [dbo].[proc_EDIDetermination]...';


GO
ALTER PROCEDURE [dbo].[proc_EDIDetermination]
(
@CaseNbr INT,
@ChangeProcessEDI BIT OUTPUT 
)
AS
DECLARE @Jurisdiction VARCHAR(2)
DECLARE @ParentCompany INT
BEGIN
	SET @ParentCompany = ( SELECT ParentCompanyID FROM tblCase AS c
		INNER JOIN tblCompany as co on c.CompanyCode = co.CompanyCode
		WHERE c.CaseNbr = @CaseNbr)
	IF(@ParentCompany = 87)
		BEGIN
			SET @ChangeProcessEDI = (SELECT TOP 1 Count(OfficeCode) AS SkipEDI FROM tblCase
							WHERE CaseNbr = @CaseNbr AND OfficeCode In (14))
		END
	ELSE
		BEGIN
			SET @ChangeProcessEDI = 0
		END

    RETURN @ChangeProcessEDI
END
GO
PRINT N'Altering [dbo].[spAvailableDoctors]...';


GO
ALTER PROCEDURE [dbo].[spAvailableDoctors]
    @startdate AS DATETIME ,
    @doctorcode AS INTEGER ,
    @locationcode AS INTEGER ,
    @city AS VARCHAR(50) ,
    @state AS VARCHAR(2) ,
    @vicinity AS VARCHAR(50) ,
    @county AS VARCHAR(50) ,
    @degree AS VARCHAR(50) ,
    @KeyWordIDs AS VARCHAR(100) ,
    @Specialties AS VARCHAR(200) ,
    @PanelExam AS BIT ,
    @ProvTypeCode AS INTEGER ,
    @EWAccreditationID AS INTEGER, 
	@IncludeInactiveDoctor AS BIT,
    @RequirePracticingDoctors AS BIT,
    @RequireLicencedInExamState AS BIT,
    @RequireBoardCertified AS BIT

AS 
    DECLARE @sColumns VARCHAR(2000)
    DECLARE @sFrom VARCHAR(2000)
    DECLARE @sWhere VARCHAR(2000)
    DECLARE @sGroupBy VARCHAR(2000)
    DECLARE @sHaving VARCHAR(2000)
    DECLARE @sSqlString NVARCHAR(4000)
    DECLARE @sOrderBy VARCHAR(1000)


    SET @sColumns = 'dbo.tblDoctor.lastname + '', '' + isnull(dbo.tblDoctor.firstname,'''') AS doctorname, dbo.tblDoctor.status, '
        + 'dbo.tblDoctorLocation.schedulethru, dbo.tblLocation.location, MIN(dbo.tblDoctorSchedule.date) AS firstavail, dbo.tblLocation.city, dbo.tblLocation.state, '
        + 'dbo.tblLocation.Phone, dbo.tblLocation.insidedr, dbo.tblDoctor.doctorcode, dbo.tblDoctor.schedulepriority, dbo.tblDoctorLocation.locationcode, '
        + 'dbo.tblDoctor.prepaid, dbo.tblLocation.vicinity, dbo.tblLocation.county, dbo.tblLocation.zip, dbo.tblDoctor.credentials AS degree, '
        + 'CASE WHEN MIN(dbo.tblDoctorSchedule.date) is null then 1 else 0 end AS sortorder, dbo.tbllocation.locationcode, dbo.tbldoctor.provtypecode, dbo.tbldoctor.optype  ' 
    SET @sFrom = 'FROM         dbo.tblLocation INNER JOIN '
        + 'dbo.tblDoctorLocation ON dbo.tblLocation.locationcode = dbo.tblDoctorLocation.locationcode LEFT OUTER JOIN '
        + 'dbo.tblDoctorSchedule ON dbo.tblLocation.locationcode = dbo.tblDoctorSchedule.locationcode AND '
        + 'dbo.tblDoctorLocation.doctorcode = dbo.tblDoctorSchedule.doctorcode LEFT OUTER JOIN '
        + 'dbo.tblDoctor ON dbo.tblDoctorLocation.doctorcode = dbo.tblDoctor.doctorcode ' 

    SET @sWhere = ''
	
    SET @sGroupBy = 'GROUP BY ALL dbo.tblDoctor.status, dbo.tblDoctorLocation.schedulethru, dbo.tblLocation.location, dbo.tblLocation.city, dbo.tblLocation.state, '
        + 'dbo.tblLocation.Phone, dbo.tblLocation.insidedr, dbo.tblDoctor.doctorcode, dbo.tblDoctor.schedulepriority, dbo.tblDoctorLocation.locationcode, '
        + 'dbo.tblLocation.vicinity, dbo.tblDoctor.prepaid, dbo.tblDoctor.lastname + '', '' + ISNULL(dbo.tblDoctor.firstname, ''''), dbo.tblLocation.county, '
        + 'dbo.tblLocation.zip, dbo.tblDoctor.credentials, dbo.tblDoctorLocation.status,CASE WHEN (dbo.tblDoctorSchedule.date) is null then 1 else 0 end,dbo.tbllocation.locationcode,dbo.tbldoctor.provtypecode, dbo.tbldoctor.optype ' 

	-- Issue  5501 - JAP - allow for inclusion of inactive Doctors
	IF @IncludeInactiveDoctor IS NULL OR @IncludeInactiveDoctor = 0
	BEGIN
		-- Normal use which only includes active doctors
		SET @sHaving = 'HAVING (dbo.tblDoctor.status = ''Active'') AND '
			+ '(dbo.tblDoctorLocation.status = ''Active'') AND dbo.tbldoctor.OPType = ''DR'' '
	END
	ELSE
	BEGIN
		-- Need to include active and inactive doctors
		SET @sHaving = 'HAVING dbo.tbldoctor.OPType = ''DR'' '
	END

	SET @sOrderBy = ''

	--Use different where and having clause for panel exam
    IF @PanelExam IS NULL 
        BEGIN
            SET @sColumns = @sColumns
                + ', MIN(dbo.tblDoctorSchedule.starttime) AS starttime ' 

            SET @sWhere = 'WHERE ( (dbo.tblDoctorSchedule.date >= '''
                + CONVERT(VARCHAR, @startdate, 101)
                + ''' AND dbo.tblDoctorSchedule.status = ''Open'') OR '
                + '(dbo.tblDoctorSchedule.date IS NULL AND dbo.tblDoctorSchedule.status IS NULL)) '  

            SET @sOrderBy = 'ORDER BY dbo.tblDoctor.schedulepriority,CASE WHEN MIN(dbo.tblDoctorSchedule.date) is null then 1 else 0 end, MIN(dbo.tblDoctorSchedule.date), dbo.tblDoctor.lastname + '', '' + ISNULL(dbo.tblDoctor.firstname, '''') '
        END
    ELSE 
        BEGIN
            SET @sColumns = @sColumns
                + ', dbo.tblDoctorSchedule.starttime AS starttime, dbo.tbldoctorschedule.status, '
                + '(select count(*) from tbldoctorschedule a where a.locationcode = tbllocation.locationcode and '
                + 'a.starttime = tbldoctorschedule.starttime AND a.status = ''Open'') as apptcount '
            SET @sGroupBy = @sGroupBy
                + ', dbo.tblDoctorSchedule.starttime, dbo.tblDoctorSchedule.status '
            SET @sWhere = ' '  
            SET @sHaving = @sHaving
                + ' AND (dbo.tbldoctorschedule.starttime >= '''
                + CONVERT(VARCHAR, @startdate, 101)
                + ''' AND dbo.tblDoctorSchedule.status = ''Open'')  '
                + ' and (select count(*) from tbldoctorschedule a where a.locationcode = tbllocation.locationcode and '
                + ' a.starttime = tbldoctorschedule.starttime AND a.status = ''Open'') > 1 '
            SET @sOrderBy = 'ORDER BY dbo.tblDoctorSchedule.starttime, dbo.tbllocation.location, dbo.tblDoctor.lastname + '', '' + ISNULL(dbo.tblDoctor.firstname, ''''), dbo.tblSpecialty.description '
        END


	-- if specialties exist, add the appropriate statements to the select clause
    IF @Specialties IS NOT NULL 
        BEGIN
            SET @specialties = REPLACE(@Specialties, '*', '''')
            SET @sColumns = @sColumns
                + ', dbo.tblDoctorSpecialty.specialtycode, dbo.tblSpecialty.description '
            SET @sFrom = @sFrom
                + ' INNER JOIN dbo.tblDoctorSpecialty ON dbo.tblDoctorLocation.doctorcode = dbo.tblDoctorSpecialty.doctorcode INNER JOIN '
                + ' dbo.tblSpecialty ON dbo.tblDoctorSpecialty.specialtycode = dbo.tblSpecialty.specialtycode '
            SET @sGroupBy = @sGroupBy
                + ',dbo.tblDoctorSpecialty.specialtycode, dbo.tblSpecialty.description '
            SET @sHaving = @sHaving
                + ' AND (dbo.tblDoctorSpecialty.specialtycode in ('
                + @Specialties + ') ) '

        END
	-- if keywords exist, add the appropriate statements to the select clause
    IF @KeyWordIDs IS NOT NULL 
        BEGIN
            SET @sColumns = @sColumns
                + ', dbo.tblDoctorKeyWord.keywordID, dbo.tblKeyWord.keyword '
            SET @sFrom = @sFrom
                + 'INNER JOIN dbo.tblDoctorKeyWord ON dbo.tblDoctorLocation.doctorcode = dbo.tblDoctorKeyWord.doctorcode INNER JOIN '
                + 'dbo.tblKeyWord ON dbo.tblDoctorKeyWord.keywordID = dbo.tblKeyWord.keywordID '
            SET @sGroupBy = @sGroupBy
                + ',dbo.tblDoctorKeyWord.keywordID, dbo.tblKeyWord.keyword '
            SET @sHaving = @sHaving
                + ' AND (dbo.tblDoctorKeyWord.KeyWordID in (' + @KeywordIDs
                + ') ) '
        END




	--Filter data if parameter is supplied
    IF @doctorcode IS NOT NULL 
        BEGIN
            SET @sHaving = @sHaving + ' AND ' + '(dbo.tbldoctor.doctorcode = '
                + CAST(@doctorcode AS VARCHAR(10)) + ') ' 
        END

    IF @locationcode IS NOT NULL 
        BEGIN
            SET @sHaving = @sHaving + ' AND '
                + '(dbo.tbldoctorlocation.locationcode = '
                + CAST(@locationcode AS VARCHAR(10)) + ') ' 
        END
    IF @city IS NOT NULL 
        BEGIN
            SET @sHaving = @sHaving + ' AND ' + '(dbo.tbllocation.city = '''
                + @city + ''') ' 
        END
    IF @state IS NOT NULL 
        BEGIN
            SET @sHaving = @sHaving + ' AND ' + '(dbo.tbllocation.state = '''
                + @state + ''') ' 
        END

    IF @vicinity IS NOT NULL 
        BEGIN
            SET @sHaving = @sHaving + ' AND '
                + '(dbo.tbllocation.vicinity = ''' + @vicinity + ''') ' 
        END

    IF @county IS NOT NULL 
        BEGIN
            SET @sHaving = @sHaving + ' AND ' + '(dbo.tbllocation.county = '''
                + @county + ''') ' 
        END

    IF @degree IS NOT NULL 
        BEGIN

            SET @sHaving = @sHaving + ' AND '
                + '(dbo.tbldoctor.credentials = ''' + @degree + ''') ' 
        END

    IF @ProvtypeCode IS NOT NULL 
        BEGIN
            SET @sHaving = @sHaving + ' AND '
                + '(dbo.tbldoctor.provtypecode = '
                + CAST(@ProvTypeCode AS VARCHAR(10)) + ') ' 
        END

	--Check for Accreditation        
    IF @EWAccreditationID IS NOT NULL 
        BEGIN
            SET @sHaving = @sHaving + ' AND '
                + 'tblDoctor.DoctorCode in (SELECT DoctorCode FROM tblDoctorAccreditation WHERE EWAccreditationID='
                + CAST(@EWAccreditationID AS VARCHAR) + ')'
        END

    IF @RequirePracticingDoctors = 1
        BEGIN
            SET @sGroupBy = @sGroupBy
                + ', dbo.tblDoctor.PracticingDoctor '

            SET @sHaving = @sHaving + ' AND '
                + 'dbo.tblDoctor.PracticingDoctor = 1 '
        END

	--Check for Licenced in Exam State
    IF @RequireLicencedInExamState = 1
        BEGIN
	    IF @State IS NOT NULL
                BEGIN
                    SET @sHaving = @sHaving + ' AND '
                        + 'tblDoctor.DoctorCode IN (SELECT Distinct tblDoctor.DoctorCode FROM tblDoctor INNER JOIN tblDoctorDocuments ON tblDoctor.DoctorCode = tblDoctorDocuments.DoctorCode '
                        + 'WHERE tblDoctorDocuments.EWDrDocTypeID = 11 AND dbo.tbllocation.state = ''' + @State + ''') '
                END
	END

	--Check for Board Certified //Can have more than one certification.  If there is a specialty in the search then I have to match the specialty
    IF @RequireBoardCertified = 1
        BEGIN
	    IF @Specialties IS NOT NULL
                BEGIN
                    SET @sHaving = @sHaving + ' AND '
                        + 'tblDoctor.DoctorCode IN (SELECT Distinct tblDoctor.DoctorCode FROM tblDoctor INNER JOIN tblDoctorDocuments ON tblDoctor.DoctorCode = tblDoctorDocuments.DoctorCode '
                        + 'WHERE tblDoctorDocuments.EWDrDocTypeID = 2 AND tblDoctorDocuments.SpecialtyCode = ' + @Specialties + ') '
		END
		ELSE
		BEGIN
                    SET @sHaving = @sHaving + ' AND '
                        + 'tblDoctor.DoctorCode IN (SELECT Distinct tblDoctor.DoctorCode FROM tblDoctor LEFT OUTER JOIN tblDoctorDocuments ON tblDoctor.DoctorCode = tblDoctorDocuments .DoctorCode '
                        + 'WHERE tblDoctorDocuments.EWDrDocTypeID = 2)'
		END
	END


-- build sql statement
    SET @sSqlString = 'SELECT DISTINCT TOP 100 PERCENT ' + @scolumns + ' '
        + @sFrom + ' ' + @swhere + ' ' + @sGroupby + ' ' + @sHaving + ' '
        + @sOrderby

   --print '@scolumns = ' + @scolumns
   --print '@sfrom = ' + @sfrom
   --print '@swhere = ' + @swhere
   --print '@sgroupby = ' + @sgroupby
   --print '@shaving = ' + @shaving
   --print '@sorderby = ' + @sorderby
   --print 'sqlstring = ' +  @ssqlstring

-- execute sql statement
    EXEC Sp_executesql @sSqlString
GO
PRINT N'Creating [dbo].[proc_DoctorSchedulePortalCalendarDays]...';


GO
CREATE PROCEDURE [proc_DoctorSchedulePortalCalendarDays]

@StartDate smalldatetime,
@EndDate smalldatetime,
@DoctorCode int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT FORMAT (apptTime, 'MM/dd/yyyy hh:mm tt', 'en-US') ApptDate, DATEADD (minute, duration, apptTime) ApptDateEnd, tblDoctorSchedule.Duration, tblEWServiceType.Name Service, tblExaminee.LastName + ', ' + FirstName ExamineeName, COUNT(casenbr) CaseCount FROM tblCase
	INNER JOIN tblDoctorSchedule ON tblCase.SchedCode = tblDoctorSchedule.SchedCode 
	INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
	INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
	INNER JOIN tblEWServiceType ON tblServices.EWServiceTypeID = tblEWServiceType.EWServiceTypeID
	INNER JOIN tblPublishOnWeb ON tblCase.CaseNbr = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCase' AND tblPublishOnWeb.UserCode = @DoctorCode
	AND tblEWServiceType.EWServiceTypeID in (1,7)
	AND tblCase.ApptTime >= @StartDate AND tblCase.ApptTime <= @EndDate
	GROUP BY FORMAT (apptTime, 'MM/dd/yyyy hh:mm tt', 'en-US'), DATEADD (minute, duration, apptTime), tblDoctorSchedule.Duration, tblEWServiceType.Name, tblExaminee.LastName + ', ' + FirstName

	UNION

	SELECT FORMAT (apptTime, 'MM/dd/yyyy hh:mm tt', 'en-US') ApptDate, DATEADD (minute, duration, apptTime) ApptDateEnd, tblDoctorSchedule.Duration, tblEWServiceType.Name Service, tblExaminee.LastName + ', ' + FirstName ExamineeName, COUNT(casenbr) CaseCount FROM tblCasePanel 
	INNER JOIN tblCase ON tblCasePanel.PanelNbr = tblCase.PanelNbr
	INNER JOIN tblDoctorSchedule ON tblCase.SchedCode = tblDoctorSchedule.SchedCode
	INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
	INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
	INNER JOIN tblEWServiceType ON tblServices.EWServiceTypeID = tblEWServiceType.EWServiceTypeID
	INNER JOIN tblPublishOnWeb ON tblCase.CaseNbr = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCase' AND tblPublishOnWeb.UserCode = @DoctorCode
	AND tblEWServiceType.EWServiceTypeID in (1,7)
	AND tblCase.ApptTime >= @StartDate AND tblCase.ApptTime <= @EndDate
	GROUP BY FORMAT (apptTime, 'MM/dd/yyyy hh:mm tt', 'en-US'), DATEADD (minute, duration, apptTime), tblDoctorSchedule.Duration, tblEWServiceType.Name, tblExaminee.LastName + ', ' + FirstName

	UNION

	SELECT FORMAT (tblDoctorSchedule.StartTime, 'MM/dd/yyyy hh:mm tt', 'en-US') ApptDate, DATEADD (minute, duration, tblDoctorSchedule.StartTime), tblDoctorSchedule.Duration, 'Reserved' Service, 'None' ExamineeName, 1 CaseCount FROM tblDoctorSchedule
	WHERE tblDoctorSchedule.StartTime >= @StartDate AND tblDoctorSchedule.StartTime <= @EndDate
	AND doctorcode = 34791 AND status = 'Open' 
	GROUP BY FORMAT (tblDoctorSchedule.StartTime, 'MM/dd/yyyy hh:mm tt', 'en-US'),  DATEADD (minute, duration, tblDoctorSchedule.StartTime), tblDoctorSchedule.Duration
	
	ORDER BY ApptDate, Service

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Creating [dbo].[proc_DoctorSchedulePortalCalendarMonth]...';


GO
CREATE PROCEDURE [proc_DoctorSchedulePortalCalendarMonth]

@StartDate smalldatetime,
@EndDate smalldatetime,
@DoctorCode int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT CONVERT(VARCHAR, apptTime, 101) ApptDate, tblEWServiceType.Name Service, COUNT(casenbr) CaseCount FROM tblCase 
	INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
	INNER JOIN tblEWServiceType ON tblServices.EWServiceTypeID = tblEWServiceType.EWServiceTypeID
	INNER JOIN tblPublishOnWeb ON tblCase.CaseNbr = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCase' AND tblPublishOnWeb.UserCode = @DoctorCode
	AND tblEWServiceType.EWServiceTypeID in (1,7)
	AND tblCase.ApptTime >= @StartDate AND tblCase.ApptTime <= @EndDate
	GROUP BY CONVERT(VARCHAR, apptTime, 101), tblEWServiceType.Name

	UNION

	SELECT CONVERT(VARCHAR, apptTime, 101) ApptDate, tblEWServiceType.Name Service, COUNT(casenbr) CaseCount FROM tblCasePanel 
	INNER JOIN tblCase ON tblCasePanel.PanelNbr = tblCase.PanelNbr
	INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
	INNER JOIN tblEWServiceType ON tblServices.EWServiceTypeID = tblEWServiceType.EWServiceTypeID
	INNER JOIN tblPublishOnWeb ON tblCase.CaseNbr = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCase' AND tblPublishOnWeb.UserCode = @DoctorCode
	AND tblEWServiceType.EWServiceTypeID in (1,7)
	AND tblCase.ApptTime >= @StartDate AND tblCase.ApptTime <= @EndDate
	GROUP BY CONVERT(VARCHAR, apptTime, 101), tblEWServiceType.Name

	UNION

	SELECT CONVERT(CHAR(10), tblDoctorSchedule.StartTime, 101) ApptDate, 'Reserved' Service, 1 CaseCount FROM tblDoctorSchedule
	WHERE tblDoctorSchedule.StartTime >= @StartDate AND tblDoctorSchedule.StartTime <= @EndDate
	AND doctorcode = 34791 AND status = 'Open' 
	GROUP BY CONVERT(CHAR(10), tblDoctorSchedule.StartTime, 101)
	
	ORDER BY ApptDate, Service

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Creating [dbo].[proc_GetOfficeInfoByUserCode]...';


GO
CREATE PROCEDURE proc_GetOfficeInfoByUserCode

@UserCode int,
@UserType char(2)

AS
 
IF @UserType = 'DR'
	BEGIN
		select * from tblEWFacility where EWFacilityID = 
		(select top 1 tblOffice.EWFacilityID from tblCase 
		inner join tblOffice on tblCase.OfficeCode = tblOffice.OfficeCode
		where doctorcode = @UserCode
		group by tblOffice.EWFacilityID
		order by count(casenbr) desc)
	END
ELSE IF @UserType = 'CL'
	BEGIN
		select * from tblEWFacility where EWFacilityID = 
		(select top 1 tblOffice.EWFacilityID from tblCase 
		inner join tblOffice on tblCase.OfficeCode = tblOffice.OfficeCode
		where clientcode = @UserCode
		group by tblOffice.EWFacilityID
		order by count(casenbr) desc)
	END
GO
PRINT N'Creating [dbo].[proc_IsGBArchClaim]...';


GO
CREATE PROCEDURE [proc_IsGBArchClaim]
(
	@PPSClaimNumber varchar(75),
	@IsArchClaim bit output
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Err int

	DECLARE @CarrierNum char(6)

	SET @CarrierNum = (SELECT CarrierNumber FROM vwGBClaimRecords WHERE ppsClaimNumber = @PPSClaimNumber)

	IF @CarrierNum IN ('105000', '105001', '105002', '105003') 
		SET @IsArchClaim = 1
	ELSE
		SET @IsArchClaim = 0

	SET @Err = @@Error

	RETURN @Err
END
GO





INSERT INTO tblSetting VALUES ('UseNewPortalV2', 'False')
GO

Insert into tblSetting values ('UseARCHClaimInfo', 'True')
GO

UPDATE tblWebUser SET PortalVersion = 1
GO


INSERT INTO tblUserFunction VALUES ('WebOfficeContactsAddEdit','Web - Office Contacts Add/Edit', GETDATE())
GO

INSERT INTO tblUserFunction VALUES ('WebUserChangePortalVersion','Web - User Change Portal Version', GETDATE())
GO

INSERT INTO tblUserFunction
VALUES ('PCMaintRestrict', 'Parent Company - Restricted Modify', GETDATE())
GO 

INSERT INTO tblUserFunction
VALUES ('PCMaintLocal', 'Parent Company - Modify Local Details', GETDATE())
GO 

INSERT INTO tblUserFunction
VALUES ('ParentCompanySetOpts', 'Parent Company - Set Search Options', GETDATE())
GO 

INSERT INTO tblUserFunction
VALUES ('ParentCompanyAddEditDNU', 'Parent Company - Add/Edit DrDoNotUse', GETDATE())
GO 





UPDATE tblControl SET DBVersion='3.20'
GO