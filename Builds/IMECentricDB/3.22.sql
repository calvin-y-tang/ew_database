PRINT N'Altering [dbo].[tblOffice]...';


GO
ALTER TABLE [dbo].[tblOffice]
    ADD [IssueVersion]             INT          NULL;


GO
PRINT N'Altering [dbo].[tblCase]...';


GO
ALTER TABLE [dbo].[tblCase]
    ADD [TATEnteredToExam]               INT           NULL,
        [TATAwaitingSchedulingToRptSent] INT           NULL,
        [TATAwaitingSchedulingToExam]    INT           NULL,
		[IssueVersion]                   INT           NULL;

GO
PRINT N'Altering [dbo].[tblCasePeerBill]...';


GO
ALTER TABLE [dbo].[tblCasePeerBill]
    ADD [ProviderZip] VARCHAR (10) NULL;


GO
PRINT N'Altering [dbo].[tblClient]...';


GO
ALTER TABLE [dbo].[tblClient]
    ADD [EmployeeNumber] VARCHAR (20) NULL;


GO
PRINT N'Altering [dbo].[tblNotify]...';


GO
ALTER TABLE [dbo].[tblNotify]
    ADD [TableType] VARCHAR (50) NULL,
        [UserCode]  INT          NULL;


GO
PRINT N'Altering [dbo].[tblNotifyAudience]...';


GO
ALTER TABLE [dbo].[tblNotifyAudience]
    ADD [TableType] VARCHAR (50) NULL;


GO
PRINT N'Altering [dbo].[tblOffice]...';


GO
ALTER TABLE [dbo].[tblOffice]
    ADD [NotificationEmailAddress] VARCHAR (70) NULL;


GO
PRINT N'Creating [dbo].[tblDoctorRecommend]...';


GO
CREATE TABLE [dbo].[tblDoctorRecommend] (
    [DoctorRecID]               INT           IDENTITY (1, 1) NOT NULL,
    [FirstName]                 VARCHAR (50)  NULL,
    [LastName]                  VARCHAR (50)  NULL,
    [Address1]                  VARCHAR (50)  NULL,
    [Address2]                  VARCHAR (50)  NULL,
    [City]                      VARCHAR (50)  NULL,
    [State]                     VARCHAR (50)  NULL,
    [Zip]                       VARCHAR (50)  NULL,
    [Phone]                     VARCHAR (50)  NULL,
    [EmailAddress]              VARCHAR (100) NULL,
    [Specialty]                 VARCHAR (50)  NULL,
    [StateLicensed]             NCHAR (10)    NULL,
    [FeedbackTo]                NCHAR (10)    NULL,
    [Notes]                     VARCHAR (MAX) NULL,
    [NominatedByFullName]       VARCHAR (100) NULL,
    [NominatedByIMECentricCode] INT           NULL,
    [UserTypeAdded]             CHAR (2)      NULL,
    [UserIDAdded]               VARCHAR (50)  NULL,
    [DateAdded]                 DATETIME      NULL,
    [ForwardedToCred]           BIT           NULL,
    [ForwardedToCredEmail]      VARCHAR (100) NULL,
    [ForwardedToCredDate]       DATETIME      NULL,
    CONSTRAINT [PK_tblDoctorRecommend] PRIMARY KEY CLUSTERED ([DoctorRecID] ASC) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];


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

	SELECT FORMAT (apptTime, 'MM/dd/yyyy hh:mm tt', 'en-US') ApptDate, DATEADD (minute, duration, apptTime) ApptDateEnd, tblDoctorSchedule.Duration, tblEWServiceType.Name Service, tblExaminee.LastName + ', ' + FirstName ExamineeName, COUNT(casenbr) CaseCount FROM tblCase
	INNER JOIN tblDoctorSchedule ON tblCase.SchedCode = tblDoctorSchedule.SchedCode 
	INNER JOIN tblExaminee ON tblCase.ChartNbr = tblExaminee.ChartNbr
	INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
	INNER JOIN tblEWServiceType ON tblServices.EWServiceTypeID = tblEWServiceType.EWServiceTypeID
	INNER JOIN tblPublishOnWeb ON tblCase.CaseNbr = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCase' AND tblPublishOnWeb.UserCode = @DoctorCode
	AND tblEWServiceType.EWServiceTypeID in (1,7)
	AND tblCase.ApptTime >= @StartDate AND tblCase.ApptTime <= @EndDate
	AND tblCase.Status <> 9
	AND tblCase.DoctorCode = @DoctorCode
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
	AND tblCase.Status <> 9
	AND tblCase.DoctorCode = @DoctorCode
	GROUP BY FORMAT (apptTime, 'MM/dd/yyyy hh:mm tt', 'en-US'), DATEADD (minute, duration, apptTime), tblDoctorSchedule.Duration, tblEWServiceType.Name, tblExaminee.LastName + ', ' + FirstName

	UNION

	SELECT FORMAT (tblDoctorSchedule.StartTime, 'MM/dd/yyyy hh:mm tt', 'en-US') ApptDate, DATEADD (minute, duration, tblDoctorSchedule.StartTime), tblDoctorSchedule.Duration, 'Reserved' Service, 'None' ExamineeName, 1 CaseCount FROM tblDoctorSchedule
	WHERE tblDoctorSchedule.StartTime >= @StartDate AND tblDoctorSchedule.StartTime <= @EndDate
	AND doctorcode = @DoctorCode AND status = 'Open' 
	GROUP BY FORMAT (tblDoctorSchedule.StartTime, 'MM/dd/yyyy hh:mm tt', 'en-US'),  DATEADD (minute, duration, tblDoctorSchedule.StartTime), tblDoctorSchedule.Duration
	
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

	SELECT CONVERT(VARCHAR, apptTime, 101) ApptDate, tblEWServiceType.Name Service, COUNT(casenbr) CaseCount FROM tblCase 
	INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
	INNER JOIN tblEWServiceType ON tblServices.EWServiceTypeID = tblEWServiceType.EWServiceTypeID
	INNER JOIN tblPublishOnWeb ON tblCase.CaseNbr = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCase' AND tblPublishOnWeb.UserCode = @DoctorCode
	AND tblEWServiceType.EWServiceTypeID in (1,7)
	AND tblCase.ApptTime >= @StartDate AND tblCase.ApptTime <= @EndDate
	AND tblCase.Status <> 9
	AND tblCase.DoctorCode = @DoctorCode
	GROUP BY CONVERT(VARCHAR, apptTime, 101), tblEWServiceType.Name

	UNION

	SELECT CONVERT(VARCHAR, apptTime, 101) ApptDate, tblEWServiceType.Name Service, COUNT(casenbr) CaseCount FROM tblCasePanel 
	INNER JOIN tblCase ON tblCasePanel.PanelNbr = tblCase.PanelNbr
	INNER JOIN tblServices ON tblCase.ServiceCode = tblServices.ServiceCode
	INNER JOIN tblEWServiceType ON tblServices.EWServiceTypeID = tblEWServiceType.EWServiceTypeID
	INNER JOIN tblPublishOnWeb ON tblCase.CaseNbr = tblPublishOnWeb.TableKey AND tblPublishOnWeb.TableType = 'tblCase' AND tblPublishOnWeb.UserCode = @DoctorCode
	AND tblEWServiceType.EWServiceTypeID in (1,7)
	AND tblCase.ApptTime >= @StartDate AND tblCase.ApptTime <= @EndDate
	AND tblCase.Status <> 9
	AND tblCase.DoctorCode = @DoctorCode
	GROUP BY CONVERT(VARCHAR, apptTime, 101), tblEWServiceType.Name

	UNION

	SELECT CONVERT(CHAR(10), tblDoctorSchedule.StartTime, 101) ApptDate, 'Reserved' Service, 1 CaseCount FROM tblDoctorSchedule
	WHERE tblDoctorSchedule.StartTime >= @StartDate AND tblDoctorSchedule.StartTime <= @EndDate
	AND doctorcode = @DoctorCode AND status = 'Open' 
	GROUP BY CONVERT(CHAR(10), tblDoctorSchedule.StartTime, 101)
	
	ORDER BY ApptDate, Service

	SET @Err = @@Error

	RETURN @Err
END
GO







--Reconfigure TAT Calculation Group
--***** Patch existing Case by recalculating all TAT *****
INSERT INTO [dbo].[tblDataField] ([DataFieldID], [TableName], [FieldName], [Descrip]) VALUES (113, 'tblCase', 'TATAwaitingSchedulingToExam', '')
INSERT INTO [dbo].[tblDataField] ([DataFieldID], [TableName], [FieldName], [Descrip]) VALUES (114, 'tblCase', 'TATEnteredToExam', '')
INSERT INTO [dbo].[tblDataField] ([DataFieldID], [TableName], [FieldName], [Descrip]) VALUES (115, 'tblCase', 'TATAwaitingSchedulingToRptSent', '')
GO

INSERT INTO [dbo].[tblTATCalculationMethod] ([TATCalculationMethodID], [StartDateFieldID], [EndDateFieldID], [Unit], [TATDataFieldID], [UseTrend]) VALUES (14, 210, 208, 'Day', 113, 0)
INSERT INTO [dbo].[tblTATCalculationMethod] ([TATCalculationMethodID], [StartDateFieldID], [EndDateFieldID], [Unit], [TATDataFieldID], [UseTrend]) VALUES (15, 201, 208, 'Day', 114, 0)
INSERT INTO [dbo].[tblTATCalculationMethod] ([TATCalculationMethodID], [StartDateFieldID], [EndDateFieldID], [Unit], [TATDataFieldID], [UseTrend]) VALUES (16, 210, 205, 'Day', 115, 0)
GO

INSERT INTO [dbo].[tblTATCalculationGroup] ([TATCalculationGroupID], [Name]) VALUES (4, 'Litigation')
GO

UPDATE [dbo].[tblTATCalculationGroupDetail] SET [DisplayOrder]=7 WHERE [TATCalculationGroupID] = 1 AND [TATCalculationMethodID] = 2
UPDATE [dbo].[tblTATCalculationGroupDetail] SET [DisplayOrder]=8 WHERE [TATCalculationGroupID] = 1 AND [TATCalculationMethodID] = 3
UPDATE [dbo].[tblTATCalculationGroupDetail] SET [DisplayOrder]=9 WHERE [TATCalculationGroupID] = 1 AND [TATCalculationMethodID] = 4
UPDATE [dbo].[tblTATCalculationGroupDetail] SET [DisplayOrder]=12 WHERE [TATCalculationGroupID] = 1 AND [TATCalculationMethodID] = 5
UPDATE [dbo].[tblTATCalculationGroupDetail] SET [DisplayOrder]=4 WHERE [TATCalculationGroupID] = 1 AND [TATCalculationMethodID] = 8
UPDATE [dbo].[tblTATCalculationGroupDetail] SET [DisplayOrder]=11 WHERE [TATCalculationGroupID] = 1 AND [TATCalculationMethodID] = 9
UPDATE [dbo].[tblTATCalculationGroupDetail] SET [DisplayOrder]=6 WHERE [TATCalculationGroupID] = 1 AND [TATCalculationMethodID] = 10
UPDATE [dbo].[tblTATCalculationGroupDetail] SET [DisplayOrder]=5 WHERE [TATCalculationGroupID] = 1 AND [TATCalculationMethodID] = 11
GO

INSERT INTO [dbo].[tblTATCalculationGroupDetail] ([TATCalculationGroupID], [TATCalculationMethodID], [DisplayOrder]) VALUES (1, 14, 3)
INSERT INTO [dbo].[tblTATCalculationGroupDetail] ([TATCalculationGroupID], [TATCalculationMethodID], [DisplayOrder]) VALUES (1, 16, 10)
INSERT INTO [dbo].[tblTATCalculationGroupDetail] ([TATCalculationGroupID], [TATCalculationMethodID], [DisplayOrder]) VALUES (4, 1, 1)
INSERT INTO [dbo].[tblTATCalculationGroupDetail] ([TATCalculationGroupID], [TATCalculationMethodID], [DisplayOrder]) VALUES (4, 2, 3)
INSERT INTO [dbo].[tblTATCalculationGroupDetail] ([TATCalculationGroupID], [TATCalculationMethodID], [DisplayOrder]) VALUES (4, 3, 4)
INSERT INTO [dbo].[tblTATCalculationGroupDetail] ([TATCalculationGroupID], [TATCalculationMethodID], [DisplayOrder]) VALUES (4, 4, 5)
INSERT INTO [dbo].[tblTATCalculationGroupDetail] ([TATCalculationGroupID], [TATCalculationMethodID], [DisplayOrder]) VALUES (4, 5, 7)
INSERT INTO [dbo].[tblTATCalculationGroupDetail] ([TATCalculationGroupID], [TATCalculationMethodID], [DisplayOrder]) VALUES (4, 6, 6)
INSERT INTO [dbo].[tblTATCalculationGroupDetail] ([TATCalculationGroupID], [TATCalculationMethodID], [DisplayOrder]) VALUES (4, 13, 0)
INSERT INTO [dbo].[tblTATCalculationGroupDetail] ([TATCalculationGroupID], [TATCalculationMethodID], [DisplayOrder]) VALUES (4, 15, 2)
GO







UPDATE O SET O.NotificationEmailAddress=I.EmailAddress
 FROM tblOffice AS O
 INNER JOIN tblIMEData AS I ON I.IMECode = O.IMECode
GO







UPDATE tblControl SET DBVersion='3.22'
GO