PRINT N'Creating [dbo].[tblIssueQuestion]...';


GO
CREATE TABLE [dbo].[tblIssueQuestion] (
    [IssueQuestionID] INT            IDENTITY (1, 1) NOT NULL,
    [IssueCode]       INT            NOT NULL,
    [QuestionText]    VARCHAR (1600) NOT NULL,
    [DateAdded]       DATETIME       NULL,
    [UserIDAdded]     VARCHAR (15)   NULL,
    [DateEdited]      DATETIME       NULL,
    [UserIDEdited]    VARCHAR (15)   NULL,
    CONSTRAINT [PK_tblIssueQuestion] PRIMARY KEY CLUSTERED ([IssueQuestionID] ASC)
);


GO
PRINT N'Creating [dbo].[tblQuestionRule]...';


GO
CREATE TABLE [dbo].[tblQuestionRule] (
    [QuestionRuleID]  INT          IDENTITY (1, 1) NOT NULL,
    [ProcessOrder]    INT          NOT NULL,
    [CaseType]        INT          NULL,
    [Jurisdiction]    VARCHAR (2)  NULL,
    [ParentCompanyID] INT          NULL,
    [CompanyCode]     INT          NULL,
    [ServiceCode]     INT          NULL,
    [QuestionSetID]   INT          NOT NULL,
    [ShowQuestions]   BIT          NULL,
    [DateAdded]       DATETIME     NOT NULL,
    [UserIDAdded]     VARCHAR (15) NOT NULL,
    [DateEdited]      DATETIME     NULL,
    [UserIDEdited]    VARCHAR (15) NULL,
    [OfficeCode]      INT          NOT NULL,
    CONSTRAINT [PK_tblQuestionRule] PRIMARY KEY CLUSTERED ([QuestionRuleID] ASC)
);


GO
PRINT N'Creating [dbo].[tblQuestionSet]...';


GO
CREATE TABLE [dbo].[tblQuestionSet] (
    [QuestionSetID] INT           IDENTITY (1, 1) NOT NULL,
    [Name]          VARCHAR (100) NOT NULL,
    [DateAdded]     DATETIME      NOT NULL,
    [UserIDAdded]   VARCHAR (15)  NOT NULL,
    [DateEdited]    DATETIME      NULL,
    [UserIDEdited]  VARCHAR (15)  NULL,
    CONSTRAINT [PK_tblQuestionSet] PRIMARY KEY CLUSTERED ([QuestionSetID] ASC)
);


GO
PRINT N'Creating [dbo].[tblQuestionSetDetail]...';


GO
CREATE TABLE [dbo].[tblQuestionSetDetail] (
    [QuestionSetDetailID] INT          IDENTITY (1, 1) NOT NULL,
    [QuestionSetID]       INT          NOT NULL,
    [IssueQuestionID]     INT          NOT NULL,
    [DisplayOrder]        INT          NOT NULL,
    [DateAdded]           DATETIME     NOT NULL,
    [UserIDAdded]         VARCHAR (15) NOT NULL,
    [DateEdited]          DATETIME     NULL,
    [UserIDEdited]        VARCHAR (15) NULL,
    CONSTRAINT [PK_tblQuestionSetDetail] PRIMARY KEY CLUSTERED ([QuestionSetDetailID] ASC)
);


GO
PRINT N'Altering [dbo].[tblCase]...';


GO
ALTER TABLE [dbo].[tblCase]
    ADD [CanceledByID]                   INT           NULL,
        [CanceledReason]                 VARCHAR (300) NULL,
        [CanceledByUserID]               VARCHAR (15)  NULL;


GO
PRINT N'Altering [dbo].[tblEWParentCompany]...';


GO
ALTER TABLE [dbo].[tblEWParentCompany]
    ADD [RequireFeeZoneNYFL] BIT NULL;


GO
PRINT N'Altering [dbo].[tblEWParentCompany]...';


GO
ALTER TABLE [dbo].[tblEWParentCompany]
    ADD [Param] VARCHAR (1024) NULL;


GO





PRINT N'Altering [dbo].[proc_CaseType_LoadComboByOfficeCode]...';


GO
ALTER PROCEDURE [proc_CaseType_LoadComboByOfficeCode]

@OfficeCode nvarchar(100)

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	DECLARE @strSQL nvarchar(800)

	SET @StrSQL = N'SELECT DISTINCT tblCaseType.Code, tblCaseType.Description FROM tblCaseType ' +
	'INNER JOIN tblCaseTypeOffice on tblCaseType.code = tblCaseTypeOffice.CaseType ' +
	'WHERE tblCaseType.PublishOnWeb = 1 ' +
	'AND tblCaseTypeOffice.OfficeCode IN (' + @OfficeCode + ') ORDER BY tblCaseType.Description'

	BEGIN
	  EXEC SP_EXECUTESQL @StrSQL
	END

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_DoctorSchedulePortalCalendarDays]...';


GO
ALTER PROCEDURE [proc_DoctorSchedulePortalCalendarDays]

@StartDate smalldatetime,
@EndDate smalldatetime,
@DoctorCode int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT FORMAT (apptTime, 'MM/dd/yyyy hh:mm tt', 'en-US') ApptDate, CaseNbr, DATEADD (minute, duration, apptTime) ApptDateEnd, tblDoctorSchedule.Duration, tblEWServiceType.Name Service, tblExaminee.LastName + ', ' + FirstName ExamineeName, COUNT(casenbr) CaseCount FROM tblCase
	INNER JOIN tblDoctorSchedule ON tblCase.SchedCode = tblDoctorSchedule.SchedCode 
	INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
	INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
	INNER JOIN tblEWServiceType ON tblServices.EWServiceTypeID = tblEWServiceType.EWServiceTypeID
	INNER JOIN tblPublishOnWeb ON tblCase.CaseNbr = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCase' AND tblPublishOnWeb.UserCode = @DoctorCode
	AND tblEWServiceType.EWServiceTypeID in (1,7)
	AND tblCase.ApptTime >= @StartDate AND tblCase.ApptTime <= @EndDate
	AND tblCase.Status <> 9
	AND tblCase.DoctorCode = @DoctorCode
	GROUP BY FORMAT (apptTime, 'MM/dd/yyyy hh:mm tt', 'en-US'), CaseNbr, DATEADD (minute, duration, apptTime), tblDoctorSchedule.Duration, tblEWServiceType.Name, tblExaminee.LastName + ', ' + FirstName

	UNION

	SELECT FORMAT (apptTime, 'MM/dd/yyyy hh:mm tt', 'en-US') ApptDate, CaseNbr, DATEADD (minute, duration, apptTime) ApptDateEnd, tblDoctorSchedule.Duration, tblEWServiceType.Name Service, tblExaminee.LastName + ', ' + FirstName ExamineeName, COUNT(casenbr) CaseCount FROM tblCasePanel 
	INNER JOIN tblCase ON tblCasePanel.PanelNbr = tblCase.PanelNbr
	INNER JOIN tblDoctorSchedule ON tblCase.SchedCode = tblDoctorSchedule.SchedCode
	INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
	INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
	INNER JOIN tblEWServiceType ON tblServices.EWServiceTypeID = tblEWServiceType.EWServiceTypeID
	INNER JOIN tblPublishOnWeb ON tblCase.CaseNbr = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCase' AND tblPublishOnWeb.UserCode = @DoctorCode
	AND tblEWServiceType.EWServiceTypeID in (1,7)
	AND tblCase.ApptTime >= @StartDate AND tblCase.ApptTime <= @EndDate
	AND tblCase.Status <> 9
	AND tblCase.DoctorCode = @DoctorCode
	GROUP BY FORMAT (apptTime, 'MM/dd/yyyy hh:mm tt', 'en-US'), CaseNbr, DATEADD (minute, duration, apptTime), tblDoctorSchedule.Duration, tblEWServiceType.Name, tblExaminee.LastName + ', ' + FirstName

	ORDER BY ApptDate, Service

	SET @Err = @@Error

	RETURN @Err
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
                        + 'WHERE tblDoctorDocuments.EWDrDocTypeID = 2 AND tblDoctorDocuments.SpecialtyCode in (' + @Specialties + ') ) '
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









-- ALTER TABLE EWParentCompany ALTER COLUMN RequireFeeZoneNYFL BIT NOT NULL
-- GO
UPDATE tblEWParentCompany SET RequireFeeZoneNYFL = 0
GO


-- Version defaults for Issue 6666 for Office
UPDATE tblOffice SET IssueVersion = 1


-- Issue 6613 Script to put "Confirmation" on all manually confirmed appointments case history records
update tblCaseHistory 
set Type  = 'Confirmation'
where Eventdesc = 'Appt Manually Confirmed'  and
(type is null or type = '') and 
DateAdded > '2017-03-01' 
GO



INSERT INTO tblUserFunction (FunctionCode, FunctionDesc) VALUES ('QuestionMaintenanceEdit', 'Question Maintenance - Add/Edit/Delete')
GO
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc) VALUES ('QuestionRuleSetup', 'Question Rule Setup')
GO
INSERT INTO tblUserFunction (FunctionCode, FunctionDesc) VALUES ('QuestionSetEdit', 'Question Set - Add/Edit/Delete')
GO





UPDATE tblControl SET DBVersion='3.23'
GO