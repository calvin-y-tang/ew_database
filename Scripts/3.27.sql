PRINT N'Altering [dbo].[tblTempData]...';


GO
ALTER TABLE [dbo].[tblTempData]
    ADD [IntValue2] INT NULL;


GO
PRINT N'Creating [dbo].[tblDoctorMargin]...';


GO
CREATE TABLE [dbo].[tblDoctorMargin] (
    [PrimaryKey]      INT            IDENTITY (1, 1) NOT NULL,
    [DoctorCode]      INT            NOT NULL,
    [ParentCompanyID] INT            NOT NULL,
    [EWBusLineID]     INT            NOT NULL,
    [EWServiceTypeID] INT            NOT NULL,
    [SpecialtyCode]   INT            NULL,
    [CaseCount]       INT            NOT NULL,
    [TotalInvoiceAmt] MONEY          NOT NULL,
    [TotalVoucherAmt] MONEY          NOT NULL,
    [Margin]          NUMERIC (8, 2) NULL,
    [DateLastEdited]  DATETIME       NOT NULL,
    CONSTRAINT [PK_DoctorMargin] PRIMARY KEY CLUSTERED ([PrimaryKey] ASC)
);


GO
PRINT N'Creating [dbo].[tblDoctorMargin].[IX_tblDoctorMargin_DoctorCode]...';


GO
CREATE NONCLUSTERED INDEX [IX_tblDoctorMargin_DoctorCode]
    ON [dbo].[tblDoctorMargin]([DoctorCode] ASC);


GO
PRINT N'Creating [dbo].[tblFilePattern]...';


GO
CREATE TABLE [dbo].[tblFilePattern] (
    [FilePatternID]   INT           IDENTITY (1, 1) NOT NULL,
    [FilePatternDesc] VARCHAR (50)  NOT NULL,
    [FilePattern]     VARCHAR (255) NOT NULL,
    [CaseDocTypeID]   INT           NULL,
    [DocumentDescrip] VARCHAR (255) NULL,
    CONSTRAINT [PK_tblFilePattern] PRIMARY KEY CLUSTERED ([FilePatternID] ASC)
);


GO
PRINT N'Creating [dbo].[tblFolderFilePattern]...';


GO
CREATE TABLE [dbo].[tblFolderFilePattern] (
    [FolderID]      INT          NOT NULL,
    [FilePatternID] INT          NOT NULL,
    [DateAdded]     DATETIME     NULL,
    [UserIDAdded]   VARCHAR (15) NULL,
    CONSTRAINT [PK_tblFolderFilePattern] PRIMARY KEY CLUSTERED ([FolderID] ASC, [FilePatternID] ASC)
);


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
	INNER JOIN tblDoctorSchedule ON tblCasePanel.SchedCode = tblDoctorSchedule.SchedCode
	INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
	INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
	INNER JOIN tblEWServiceType ON tblServices.EWServiceTypeID = tblEWServiceType.EWServiceTypeID
	INNER JOIN tblPublishOnWeb ON tblCase.CaseNbr = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCase' AND tblPublishOnWeb.UserCode = @DoctorCode
	AND tblEWServiceType.EWServiceTypeID in (1,7)
	AND tblCase.ApptTime >= @StartDate AND tblCase.ApptTime <= @EndDate
	AND tblCase.Status <> 9
	GROUP BY FORMAT (apptTime, 'MM/dd/yyyy hh:mm tt', 'en-US'), CaseNbr, DATEADD (minute, duration, apptTime), tblDoctorSchedule.Duration, tblEWServiceType.Name, tblExaminee.LastName + ', ' + FirstName

	ORDER BY ApptDate, Service

	SET @Err = @@Error

	RETURN @Err
END
GO
PRINT N'Altering [dbo].[proc_DoctorSchedulePortalCalendarMonth]...';


GO
ALTER PROCEDURE [proc_DoctorSchedulePortalCalendarMonth]  

@StartDate smalldatetime,
@EndDate smalldatetime,
@DoctorCode int

AS
BEGIN

	SET NOCOUNT ON
	DECLARE @Err int

	SELECT ApptDate, Service, Sum(CaseCount) CaseCount FROM
	(
	SELECT CONVERT(VARCHAR, apptTime, 101) ApptDate, tblEWServiceType.Name Service, COUNT(casenbr) CaseCount FROM tblCase 
	INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
	INNER JOIN tblEWServiceType ON tblServices.EWServiceTypeID = tblEWServiceType.EWServiceTypeID
	INNER JOIN tblPublishOnWeb ON tblCase.CaseNbr = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCase' AND tblPublishOnWeb.UserCode = @DoctorCode
	AND tblEWServiceType.EWServiceTypeID in (1,7)
	AND tblCase.ApptTime >= @StartDate AND tblCase.ApptTime <= @EndDate
	AND tblCase.Status <> 9
	AND tblCase.DoctorCode = @DoctorCode
	GROUP BY CONVERT(VARCHAR, apptTime, 101), tblEWServiceType.Name

	UNION ALL

	SELECT CONVERT(VARCHAR, apptTime, 101) ApptDate, tblEWServiceType.Name Service, COUNT(casenbr) CaseCount FROM tblCasePanel 
	INNER JOIN tblCase ON tblCasePanel.PanelNbr = tblCase.PanelNbr
	INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
	INNER JOIN tblEWServiceType ON tblServices.EWServiceTypeID = tblEWServiceType.EWServiceTypeID
	INNER JOIN tblPublishOnWeb ON tblCase.CaseNbr = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCase' AND tblPublishOnWeb.UserCode = @DoctorCode
	AND tblEWServiceType.EWServiceTypeID in (1,7)
	AND tblCase.ApptTime >= @StartDate AND tblCase.ApptTime <= @EndDate
	AND tblCase.Status <> 9
	AND tblCasePanel.DoctorCode = @DoctorCode
	GROUP BY CONVERT(VARCHAR, apptTime, 101), tblEWServiceType.Name
	)
	as sq group by sq.ApptDate, sq.Service, sq.CaseCount
	
	ORDER BY ApptDate, Service

	SET @Err = @@Error

	RETURN @Err
END
GO






-- Issue 7036 - Add a new trigger
INSERT INTO tblExceptionList VALUES 
('Appointment Cancel with Special Services', 'Active', GETDATE(), 'Admin', GETDATE(), 'Admin')
GO


-- Issue 7036 - Add a new generic exception definition
INSERT INTO tblExceptionDefinition 
values ('Cancel Appointment With Special Services', 'CS', Null, 29, -1, -1, -1, Null, 1, 0, 0, 0, 0, 
'Please cancel or reschedule the Special Services associated with this canceled appointment.', 0, 0,
 Null, Null, Null, Null, Null, 'Active', GETDATE(), 'Admin', GETDATE(), 'Admin', 0, 1) 
GO



UPDATE tblServices SET IsReExam=1 WHERE ServiceCode=3290
--UPDATE tblServices SET ReExamServiceCode=?
GO

INSERT INTO tblSetting (Name, Value) VALUES
(   'RememberSearchDrLocOffices', -- Name - varchar(30)
    ';26;28;'  -- Value - varchar(30)
)
GO


UPDATE tblControl SET DBVersion='3.27'
GO
